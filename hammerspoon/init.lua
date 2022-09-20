hs.console:clearConsole()

local log = hs.logger.new('config', 'debug')
highlight = require("hs.window.highlight")


stackline = require "stackline"
stackline:init()
hs.loadSpoon("RecursiveBinder")

local singleKey = spoon.RecursiveBinder.singleKey



   


    function yabai(args, completion)
        log:i('yabai ' .. hs.inspect(args))


        local yabai_output = ""
        local yabai_error = ""
        -- Runs in background very fast
        local yabai_task = hs.task.new("/usr/local/bin/yabai",nil, function(task, stdout, stderr)
            print("stdout:"..stdout, "stderr:"..stderr)
            if stdout ~= nil then yabai_output = yabai_output..stdout end
            if stderr ~= nil then yabai_error = yabai_error..stderr end
            return true
        end, args)
        if type(completion) == "function" then
            yabai_task:setCallback(function() completion(yabai_output, yabai_error) end)
        end
        yabai_task:start()
        end

mod1 = 'alt'
mod2 =  'shift'



function yabai_window(...)
    args = {"-m", "window"}

    for _,v in ipairs(...) do
        table.insert(args, v)
    end
    return yabai(args)
end





--focus windows
hs.hotkey.bind(mod1, "h", function()  yabai_window({ "--focus", "west"}) end)
hs.hotkey.bind(mod1, "j", function()  yabai_window({"--focus", "south"}) end)
hs.hotkey.bind(mod1, "k", function()  yabai_window({"--focus", "north"}) end)
hs.hotkey.bind(mod1, "l", function()  yabai_window({"--focus", "east"}) end)
hs.hotkey.bind(mod1, "x", function()  yabai_window({ "--focus", "recent"}) end)

hs.hotkey.bind(mod1, "n", function() hs.execute("next", true) end)
hs.hotkey.bind(mod1, "p", function()  hs.execute("prev", true) end)
hs.hotkey.bind(mod1, "space", function() hs.execute("cycle-layout", true) end)



hs.hotkey.bind(mod1, "f", function()   yabai_window({ "--toggle", "zoom-fullscreen"})end)




function  windowActionKeymap(action)

    action = "--" .. action
    return {
        [ singleKey("h","west")]=function() yabai_window({ action, "west"})  end,
        [singleKey("j","south")] =function() yabai({ action, "south"}) end,
        [singleKey("k", "north")] =function() yabai_window({ action, "north"}) end,
        [singleKey("l", "east")]= function()  yabai_window({ action, "east"})end
    }
end

windowKeymap = {
    [singleKey("w", "warp")] = windowActionKeymap("warp"),
    [singleKey("s", "swap")] = windowActionKeymap("swap"),
    [singleKey("i", "insert")] = windowActionKeymap("insert"),
    [singleKey("k", "stack")] = windowActionKeymap("stack"),

    [singleKey("p", "zoom parent")] = function() yabai_window({ "--toggle", "zoom-parent"}) end,
    [singleKey("f", "full screen")] = function() yabai_window({ "--toggle", "zoom-fullscreen"}) end,
    [singleKey("n", "minimize")] = function() yabai_window({ "--minimize"}) end,
    [singleKey("m", "maximize")] = function()  hs.window.focusedWindow():maximize() end,
    [singleKey("e", "expose")] = function() yabai_window({ "--toggle", "expose"}) end,

}
hs.hotkey.bind(mod1, "w", spoon.RecursiveBinder.recursiveBind(windowKeymap))

