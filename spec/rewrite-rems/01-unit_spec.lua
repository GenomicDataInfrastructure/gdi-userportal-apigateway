-- SPDX-FileCopyrightText: 2024 PNED G.I.E.
--
-- SPDX-License-Identifier: Apache-2.0

describe("body_transformer.transform_json_body", function()
  it("parse serialised REMS input into json object", function()
    local cjson = require "cjson"
    local cjson_decode = cjson.decode
    local ipairs = ipairs

    local body_transformer = require "kong.plugins.rewrite-rems.body_transformer"
    local transform_json_body = body_transformer.transform_json_body
    local input_json = '[["^ ","~:application/workflow",["^ ","~:workflow/id",1,"~:workflow/type","~:workflow/default"],"~:application/external-id","2023/8","~:application/first-submitted","~t2023-11-30T00:02:05.964Z"]]'
    local decoded_input_json = cjson_decode(input_json)
    local output_json = transform_json_body(decoded_input_json)
    local decoded_output_json = cjson_decode(output_json)

    assert.is_truthy(#decoded_output_json)

    local expected_keys = {
      ["application/workflow"] = true,
      ["application/external-id"] = true,
      ["application/first-submitted"] = true
    }

    for _, key in ipairs(decoded_output_json[1]) do
      assert.is_truthy(expected_keys[key])
    end
  end)
end)
