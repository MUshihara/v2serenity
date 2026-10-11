-- Serenity v2 key-window test. Production scripts are not loaded.
local url = "https://raw.githubusercontent.com/MUshihara/v2serenity/aa496d3c57e569244674f6abcf0645fd4482ebdb/dist/bootstrap.lua"
local source = game:HttpGet(url .. "?v=" .. tostring(os.time()))
local run, compileError = loadstring(source, "Serenity v2 key-window test")
assert(run, compileError)
return run()
