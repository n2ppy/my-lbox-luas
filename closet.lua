local config = {
    EspKey = KEY_R,
    TriggerbotMean = 40,
    TriggerbotSD = 10
}

local count = 0;

callbacks.Unregister("CreateMove", "closetCM")
callbacks.Unregister("Draw", "closetDraw")

callbacks.Register("CreateMove", "closetCM", function(cmd)
    --mean + math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) * stdDev
    count = count + 1;

    if count >= 12 then
        count = 0;
        local delay = config.TriggerbotMean + math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) * config.TriggerbotSD;
        gui.SetValue("Trigger Shoot Delay (ms)", math.ceil(delay));
    end
end)

callbacks.Register("Draw", "closetDraw", function()
    if(input.IsKeyDown(config.EspKey)) then
        gui.SetValue("Players", true);
    else
        gui.SetValue("Players", false);
    end
end)