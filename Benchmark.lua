local averageFPS = 0.0;
local averageFT = 0.0;

local FPStable = {};
local FTtable = {};

local recording = false;

local holdingStopKey = false;

callbacks.Register("Draw", function()
    if input.IsButtonDown(KEY_F1) then
        recording = true;

        FPStable = {};
        FTtable = {};
    end
    if input.IsButtonDown(KEY_F2) and not holdingStopKey then
        recording = false;
        holdingStopKey = true;

        local count = 0;
        local total = 0;
        for i, v in pairs(FPStable) do
            count = i;
            total = total + v;
        end
        averageFPS = total / count;

        local count = 0;
        local total = 0;
        for i, v in pairs(FTtable) do
            count = i;
            total = total + v;
        end
        averageFT = total / count;

        print(string.format("average fps: %.6f\naverage frametime: %.6f", averageFPS, averageFT));
    elseif not input.IsButtonDown(KEY_F2) then
        holdingStopKey = false;
    end

    if recording then
        local frametime = globals.FrameTime();

        table.insert(FTtable, frametime);
        table.insert(FPStable, 1.0 / frametime);
    end
end);
