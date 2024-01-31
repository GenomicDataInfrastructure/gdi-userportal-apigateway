-- SPDX-FileCopyrightText: 2024 PNED G.I.E.
--
-- SPDX-License-Identifier: Apache-2.0

local body_transformer = require "kong.plugins.rewrite-rems.body_transformer"
local transform_json_body = body_transformer.transform_json_body
local cjson = require("cjson.safe").new()
local cjson_decode = cjson.decode
local pcall = pcall

local plugin = {
  PRIORITY = 800,
  VERSION = "0.0.0",
}

function plugin:header_filter(conf)
  kong.response.clear_header("Content-Length")
end

function plugin:body_filter(conf)
  local status = kong.response.get_status()
  if status ~= 200 then
    return
  end
  
  local body = kong.response.get_raw_body()
  local _, json = pcall(cjson_decode, body)
  if json then
    local transformed_body, err = transform_json_body(json)
    if not err then
      kong.response.set_raw_body(transformed_body)
    else
      kong.log.warn("body transform failed: " .. err)
    end
  end
end

return plugin