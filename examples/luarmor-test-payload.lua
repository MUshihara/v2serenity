-- Upload this source to the Luarmor script fb38fdcaac18ad317303fa4cc15421b6.
-- Keep its key requirement enabled (FFA off). Test UI only.
local window = getgenv().__SerenityKeyWindowTest
assert(type(window)=="table" and type(window.CompleteAuthentication)=="function", "Run the Serenity test loader first")
assert(window:CompleteAuthentication(), "Serenity test window is no longer waiting")
