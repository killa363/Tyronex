local Modules = script:GetDescendants();
local SubModules = {};

for _, module in Modules do
    if (module.ClassName ~= "ModuleScript") then continue end;
    SubModules[module.Name] = require(module)();
end

return SubModules;
