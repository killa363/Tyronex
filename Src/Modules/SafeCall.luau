local secure_call do
    local LAYERS = 2 -- this is the minimum btw. stack-shape detectors can cook you here cuz a shallow/deep stack will throw nil as the source and just look sus if monitored
    -- additionally, all the layers come from one chunk and share the same one env, so passing a sanity check on this would detect it
    local TEMPLATE do -- fake frames
        local lines: {string} = { -- l = layer/forwarder
            "return function(__renv, __func, ...)",
            "\tsetfenv(0, __renv)", -- pass renv as param cuz we dont want getrenv reachable from the chunk/target's env
            `\tlocal function l{LAYERS}(...) return __func(...) end`,
        }
        for count = LAYERS - 1, 1, -1 do -- builds outward
            lines[#lines + 1] = `\tlocal function l{count}(...) return l{count + 1}(...) end`
        end
        lines[#lines + 1] = "\treturn l1(...)" -- chain kickoff
        lines[#lines + 1] = "end"
        TEMPLATE = table.concat(lines, "\n")
    end
    secure_call = function(func: (...any) -> ...any, mask: Instance, ...: any): ...any -- type __function__ = ( ...any ) -> ...any;
        -- MUSTHAVES: getthreadidentity, getrenv, setfenv, debug.getupvalues, debug.setupvalue, setthreadidentity
        assert(type(func) == "function", `invalid argument #1 to 'secure_call' (function expected, got {typeof(func)})`)
        assert(debug.info(func, "s") ~= "[C]", "invalid argument #1 to 'secure_call' (Luau closure expected, got C closure)") -- workaround in case the executor doesnt have iscclosure/islclosure
        assert(typeof(mask) == "Instance" and mask:IsA("LuaSourceContainer"), `invalid argument #2 to 'secure_call' (LuaSourceContainer expected, got {typeof(mask)})`)
        local level: number = getthreadidentity()
        local renv: {[any]: any} = getrenv()
        local path = mask:GetFullName()
        local ok, env = pcall(getsenv, mask)
        if not ok or type(env) ~= "table" then -- in case its dead
            env = setmetatable({ script = mask }, { __index = renv, __newindex = renv })
        end
        local loader, err = loadstring(TEMPLATE, `={path}`) -- impersonate chunkname-strip (idk if all executors have '=' as prefix but native luau does)
        -- assert(loader, `synthetic sentinel build failed: {err}`)
        setfenv(loader, env) -- inner function inherits this / every frame in the chain shares the env
        local sentinel = (loader :: (...any) -> ...any)()
        local snapshot: {any} = debug.getupvalues(func) -- if they check the owner/source at call time we would be DOOMED
        for index = 1, #snapshot do -- faster than ipairs
            local value = snapshot[index]
            if typeof(value) == "Instance" and value:IsA("LuaSourceContainer") then
                debug.setupvalue(func, index, mask)
            end
        end
        setthreadidentity(2) -- prevent capability probes (e.g., 'settings()')
        local co = coroutine.create(sentinel)
        local args = table.pack(renv, func, ...) -- aligns with sentinel sig
        local response
        while true do -- handler for co states: returned/errored/yielded
            local result = table.pack(coroutine.resume(co, unpack(args, 1, args.n)))
            if not result[1] then -- "ok"/success bool
                err = result[2]
                break
            end
            if coroutine.status(co) == "dead" then -- return results (response) as result[2..n]
                response = table.pack(unpack(result, 2, result.n))
                break
            end
            args = table.pack(coroutine.yield(unpack(result, 2, result.n))) -- yield outside of secure_call and to our caller
        end
        setthreadidentity(level)
        for index = 1, #snapshot do -- faster than ipairs
            debug.setupvalue(func, index, snapshot[index])
        end
        if err then error(err, 2) end -- shows up at the callers level in traceback
        return unpack(response, 1, response.n)
    end
end
return secure_call