local cjson = require("cjson.safe").new()
local cjson_encode = cjson.encode
local remove_element = table.remove
local match = string.match
local type = type
local ipairs = ipairs

local function transform_json_body(parsed_json)
    local function parse_array(arr)
        local obj = {}
        local key
        remove_element(arr, 1)

        for i, v in ipairs(arr) do
            if i % 2 == 1 then
                key = match(v, "/(.*)$")
            else
                if type(v) == "table" then
                    obj[key] = parse_array(v)
                else
                    obj[key] = v
                end
            end
        end

        return obj
    end

    local result = {}
    for i, v in ipairs(parsed_json) do
        result[i] = parse_array(parsed_json[i])
    end
    return cjson_encode(result)
end


local body_transformer = {}
body_transformer.transform_json_body = transform_json_body

return body_transformer
