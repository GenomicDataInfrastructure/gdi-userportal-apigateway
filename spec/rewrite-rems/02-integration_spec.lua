-- SPDX-FileCopyrightText: 2024 PNED G.I.E.
--
-- SPDX-License-Identifier: Apache-2.0

local helpers = require "spec.helpers"

local PLUGIN_NAME = "rewrite-rems"

for _, strategy in helpers.all_strategies() do if strategy ~= "cassandra" then
  describe(PLUGIN_NAME .. ": (access) [#" .. strategy .. "]", function()
    local client

    lazy_setup(function()

      local bp = helpers.get_db_utils(strategy == "off" and "postgres" or strategy, nil, { PLUGIN_NAME })

      -- Inject a test route. No need to create a service, there is a default
      -- service which will echo the request.
      local route1 = bp.routes:insert({
        hosts = { "test1.com" },
      })
      -- add the plugin to test to the route we created
      bp.plugins:insert {
        name = PLUGIN_NAME,
        route = { id = route1.id },
        config = {},
      }

      -- start kong
      assert(helpers.start_kong({
        -- set the strategy
        database   = strategy,
        -- use the custom test template to create a local mock server
        nginx_conf = "spec/fixtures/custom_nginx.template",
        -- make sure our plugin gets loaded
        plugins = "bundled," .. PLUGIN_NAME,
        -- write & load declarative config, only if 'strategy=off'
        declarative_config = strategy == "off" and helpers.make_yaml_file() or nil,
      }))
    end)

    lazy_teardown(function()
      helpers.stop_kong(nil, true)
    end)

    before_each(function()
      client = helpers.proxy_client()
    end)

    after_each(function()
      if client then client:close() end
    end)

    -- TODO find a way to add a mock that echoes request as response
    --describe("response", function()
    --  it("parses a JSON response", function()
    --    local res = client:post("/post", {
    --      headers = {
    --        host = "test1.com",
    --        ["Content-Type"] = "application/json"
    --      },
    --      body = '[["^ ","~:application/workflow",["^ ","~:workflow/id",1,"~:workflow/type","~:workflow/default"],"~:application/external-id","2023/8","~:application/first-submitted","~t2023-11-30T00:02:05.964Z"]]'
    --    })
    --    assert.res_status(200, res)
    --  end)
    --end)
  end)

end end
