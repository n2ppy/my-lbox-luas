--[[
ideas:
record every 4 ticks
jump ticks
]]--

--[[
TODO:
]]--

-- Load lnxLib library
---@type boolean, lnxLib
local libLoaded, lnxLib = pcall(require, "lnxLib");
assert(libLoaded, "lnxLib not found, please install it!");
assert(lnxLib.GetVersion() <= 0.995, "lnxLib version is too old, please update it!");

-- Import required modules from lnxLib
local WPlayer = lnxLib.TF2.WPlayer;
local Helpers = lnxLib.TF2.Helpers;
local Math = lnxLib.TF2.Math;


--[[ helper functions ]]--
function GetTableLength(t)
    local length = 1;

    for i, v in pairs(t) do
        length = i;
    end

    return i;
end

function ternary ( cond , T , F ) --https://stackoverflow.com/questions/5525817/inline-conditions-in-lua-a-b-yes-no
    if cond then return T else return F end
end

function VecNoVert(vec)
    return Vector3(vec.x, vec.y, 0);
end

local RecordedTicks = {}; -- table filled with tables with tick info: {Position: vec3, Jump: bool}
local EndIndex = 0;

local RecordKey = KEY_R;
local HoldingRecordKey = false;

local PlayKey = KEY_T;
local HoldingPlayKey = false;

local DelayTicks = 4;
local TickCount = 0;

local Recording = false;
local Playing = false;

local PlayTick = 1;

local function onCreateMove(cmd)
    if not HoldingRecordKey and input.IsButtonDown(RecordKey) then
        HoldingRecordKey = true;
        Recording = not Recording;
        if Recording then
            EndIndex = 0;
            RecordedTicks = {};
        end
    elseif not input.IsButtonDown(RecordKey) then
        HoldingRecordKey = false;
    end
    if not HoldingPlayKey and input.IsButtonDown(PlayKey) then
        HoldingPlayKey = true;
        Playing = not Playing;
        if Playing then
            PlayTick = 1;
        end
    elseif not input.IsButtonDown(PlayKey) then
        HoldingPlayKey = false;
    end

    if Recording then
        TickCount = TickCount + 1;

        if TickCount == DelayTicks then
            local pLocal = entities.GetLocalPlayer();
            TickCount = 0;

            EndIndex = EndIndex + 1;
            RecordedTicks[EndIndex] = {
                Position = pLocal:GetAbsOrigin(),
                Jump = ternary((cmd.buttons & IN_JUMP) ~= 0, true, false);
            }
        end
    end

    if Playing then
        local wLocal = WPlayer.GetLocal();
        local pLocal = entities.GetLocalPlayer();

        Helpers.WalkTo(cmd, wLocal, RecordedTicks[PlayTick].Position);

        if vector.Distance(VecNoVert(pLocal:GetAbsOrigin()), VecNoVert(RecordedTicks[PlayTick].Position)) <= 20 then
            if RecordedTicks[PlayTick].Jump then
                cmd:SetButtons(cmd.buttons | IN_JUMP);
            end

            if PlayTick < EndIndex then
                PlayTick = PlayTick + 1;
            else
                Playing = false;
            end
        end
    end
end

local function onDraw()
    if EndIndex ~= 0 then
        for i, v in pairs(RecordedTicks) do
            if i < EndIndex then
                draw.Color(255, 255, 255, 255);

                local screenPos = client.WorldToScreen(RecordedTicks[i].Position);
                local screenPos2 = client.WorldToScreen(RecordedTicks[i + 1].Position);

                draw.Line(screenPos[1], screenPos[2], screenPos2[1], screenPos2[2]);
            end
        end
    end
end

callbacks.Unregister("CreateMove", "MovementRecorderCM");
callbacks.Unregister("Draw", "MovementRecorderDraw");

callbacks.Register("CreateMove", "MovementRecorderCM", onCreateMove);
callbacks.Register("Draw", "MovementRecorderDraw", onDraw);
