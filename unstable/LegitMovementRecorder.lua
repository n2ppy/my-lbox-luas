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

local RecordedTicks = {}; -- table filled with tables with tick info: {Position: vec3, ForwardMove: float, SideMove: float, vX: float, vY: float, vZ float, Jump: bool}
local StartPosition = Vector3(0, 0, 0);
local EndIndex = 0;

local RecordKey = KEY_R;
local HoldingRecordKey = false;

local PlayKey = KEY_T;
local HoldingPlayKey = false;

local SaveKey = KEY_P;
local HoldingSaveKey = false;

local DelayTicks = 4;
local TickCount = 0;

local Recording = false;
local Playing = false;
local ReadyToFollow = false;

local PlayTick = 1;

local WorkDir = engine.GetGameDir() .. "\\..\\nullptr\\legitmovementrecordings\\";
local success, full_path1 = filesystem.CreateDirectory([[nullptr]]);
--local WorkDir = "[[nullptr\\legitmovementrecordings";

function FileExists(path)
    local file = io.open(path, "rb")
    if file then file:close() end
    return file ~= nil
end

function SaveToFile(fname)
    --[[
    local file = io.open(path, "wb") -- w write mode and b binary mode
    if not file then return false end
    file:write(content)
    file:close()
    ]]--

    local success, full_path = filesystem.CreateDirectory([[nullptr/legitmovementrecordings]]);

    local file = io.open(full_path .. "\\" .. fname, "w");
    if not file then return 1 end;

    local content = "";    

    for i, v in pairs(RecordedTicks) do
        local line = "{";
        line = line .. string.format("%.2f,%.2f,%.2f|", v.Position.x, v.Position.y, v.Position.z);--tostring(v.Position.x) .. "," .. tostring(v.Position.y) .. "," .. tostring(v.Position.z) .. "}|"; --position

        line = line .. string.format("%.1f,%.1f", v.ForwardMove, v.SideMove);--tostring(v.ForwardMove) .. "|";
        --line = line .. tostring(v.SideMove) .. "|";

        line = line .. string.format("/%.1f,%.1f,%.1f}", v.vX, v.vY, v.vZ);--"/" .. tostring(v.vX) .. "," .. tostring(v.vY) .. "," .. tostring(v.vZ) .. "\\|";

        line = line .. tostring(ternary(v.Jump == true, 1, 0)) .. "?";

        content = content .. line;
    end

    file:write(content);

    file:close();

    return 0;
end

--function LoadFromFile(fname)
    --local success, full_path = filesystem.CreateDirectory([[nullptr/legitmovementrecordings]]);

    --[[local file = io.open(full_path .. "\\" .. fname, "r");
    if not file then return 1 end;

    local content = file:read();

    local lines = {};
    local lastLine = 0;

    local line = "";

    for i = 1, #content do
        local char = content:sub(i, i);

        if char ~= "?" then
            line = line .. char;
        else
            lastLine = lastLine + 1;
            lines[lastLine] = line;

            line = "";
        end
    end

    for i, v in pairs(lines) do
        local pos = Vector3(0, 0, 0);
        local angles = EulerAngles(0, 0, 0);

        local forwardmove = 0.0;
        local sidemove = 0.0;

        local jump = false;

        for i = 1, #v do
            local char = v:sub(i, i);

            if char == "{" then
                local x = tonumber(v:sub(i+1, i+3));
                local y = tonumber(v:sub(i+5, i+7));
                local z = tonumber(v:sub(i+9, i+11));

                pos = Vector3(x, y, z);
            elseif char == "|" then
                forwardmove = tonumber(v:sub(i+))
            end
        end
    end

    file:close();
    return 0;
end]]--

--[[local result = LoadFromFile("test.RTicks");
if result == 1 then
    printc(255, 0, 0, 255, "[-] ERROR: Couldn't open file");
elseif result == 0 then
    printc(255, 255, 255, 255, "[+] Read file and printed")
end]]--

local function OnCreateMove(cmd)
    if not HoldingRecordKey and input.IsButtonDown(RecordKey) then
        HoldingRecordKey = true;
        Recording = not Recording;
        if Recording then
            StartPosition = entities.GetLocalPlayer():GetAbsOrigin();
            EndIndex = 0;
            RecordedTicks = {};
            TickCount = 0;
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

    --[[if not HoldingSaveKey and input.IsButtonDown(SaveKey) then
        HoldingSaveKey = true;
        local saved = SaveToFile("test.RTicks");
        if saved == 1 then
            printc(255, 0, 0, 255, "[-] ERROR: Failed to save to file");
        elseif saved == 2 then
            printc(255, 0, 0, 255, "[-] ERROR: Failed to find or create WorkDir"); 
        end
    elseif not input.IsButtonDown(SaveKey) then
        HoldingSaveKey = false;
    end]]--

    if Recording then
        local pLocal = entities.GetLocalPlayer();

        EndIndex = EndIndex + 1;
        RecordedTicks[EndIndex] = {
            Position = pLocal:GetAbsOrigin();
            ForwardMove = cmd.forwardmove,
            SideMove = cmd.sidemove,
            vX = cmd.viewangles.x,
            vY = cmd.viewangles.y,
            vZ = cmd.viewangles.z,
            Jump = ternary((cmd.buttons & IN_JUMP) ~= 0, true, false)
        }
    end

    if Playing then
        if not ReadyToFollow then
            Helpers.WalkTo(cmd, WPlayer.GetLocal(), StartPosition);

            if vector.Distance(VecNoVert(entities:GetLocalPlayer():GetAbsOrigin()), VecNoVert(StartPosition)) <= 0.5 then
                ReadyToFollow = true;
                TickCount = 0;
            end
        else
            local recorded = RecordedTicks[PlayTick];

            if recorded.Jump then
                cmd:SetButtons(cmd.buttons | IN_JUMP);
            end

            cmd:SetForwardMove(recorded.ForwardMove);
            cmd:SetSideMove(recorded.SideMove);

            --cmd:SetViewAngles(recorded.vX, recorded.vY, recorded.vZ);
            engine.SetViewAngles(EulerAngles(recorded.vX, recorded.vY, recorded.vZ));

            if RecordedTicks[PlayTick + 1] ~= nil then
                PlayTick = PlayTick + 1;
            else
                Playing = false;
            end
        end
    end
end

local function onDraw()
    if EndIndex ~= 0 then
        local TempCount = 0;
        for i, v in pairs(RecordedTicks) do
            TempCount = TempCount + 1;
            if TempCount == 4 then
                TempCount = 0;
                if i < EndIndex then
                    draw.Color(255, 255, 255, 255);

                    local screenPos = client.WorldToScreen(RecordedTicks[i].Position);
                    local screenPos2 = client.WorldToScreen(RecordedTicks[i + 1].Position);

                    if screenPos ~= nil and screenPos2 ~= nil then
                        draw.Line(screenPos[1], screenPos[2], screenPos2[1], screenPos2[2]);
                    end
                end
            end
        end
    end
end

callbacks.Unregister("CreateMove", "LMovementRecorderCM");
callbacks.Unregister("Draw", "LMovementRecorderDraw");

callbacks.Register("CreateMove", "LMovementRecorderCM", OnCreateMove);
callbacks.Register("Draw", "LMovementRecorderDraw", onDraw);
