-- should only be used in **unobfuscated scripts!**
-- will also perform basic runtime validation on script arguments

local assert = assert
local type = type
local getfenv = getfenv
local getgenv = getgenv
local setfenv = setfenv

local env: any = if getgenv then getgenv() else getfenv()

env.LPH_ENCNUM = function(toEncrypt, ...)
    assert(type(toEncrypt) == "number" and #{...} == 0, "LPH_ENCNUM only accepts a single constant double or integer as an argument.")
    return toEncrypt
end
env.LPH_NUMENC = env.LPH_ENCNUM

env.LPH_ENCSTR = function(toEncrypt, ...)
    assert(type(toEncrypt) == "string" and #{...} == 0, "LPH_ENCSTR only accepts a single constant string as an argument.")
    return toEncrypt
end
env.LPH_STRENC = env.LPH_ENCSTR

env.LPH_ENCFUNC = function(toEncrypt, encKey, decKey, ...)
    -- not checking decKey value since this shim is meant to be used without obfuscation/whitelisting
    assert(type(toEncrypt) == "function" and type(encKey) == "string" and #{...} == 0, "LPH_ENCFUNC accepts a constant function, constant string, and string variable as arguments.")
    return toEncrypt
end
env.LPH_FUNCENC = env.LPH_ENCFUNC

env.LPH_JIT = function(f, ...)
    assert(type(f) == "function" and #{...} == 0, "LPH_JIT only accepts a single constant function as an argument.")
    return f
end
env.LPH_JIT_MAX = env.LPH_JIT

env.LPH_NO_VIRTUALIZE = function(f, ...)
    assert(type(f) == "function" and #{...} == 0, "LPH_NO_VIRTUALIZE only accepts a single constant function as an argument.")
    return f
end

env.LPH_NO_UPVALUES = function(f, ...)
    assert(type(setfenv) == "function", "LPH_NO_UPVALUES can only be used on Lua versions with getfenv & setfenv")
    assert(type(f) == "function" and #{...} == 0, "LPH_NO_UPVALUES only accepts a single constant function as an argument.")

    local runtimeEnv = getrenv()
    return setfenv(
        env.LPH_NO_VIRTUALIZE(function(...)
            return (getfenv() :: any).func(...)
        end),
        setmetatable(
            {
                func = f
            },
            {
                __index = runtimeEnv,
                __newindex = runtimeEnv
            }
        )
    )
end

env.LPH_CRASH = function(...)
    assert(#{...} == 0, "LPH_CRASH does not accept any arguments.")
    while true do end
end

return {}