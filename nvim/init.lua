require('gvarihendrix')

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

-- require('plugin')
local ingvar = { first_name = "Ingvar", last_name = "Sigurðsson" }
print("Hello " .. dump(ingvar))



