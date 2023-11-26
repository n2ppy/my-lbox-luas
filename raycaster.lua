--[[

screenshot: https://imgur.com/a/a1aCme9
A simple raycasting engine I made using Lodevs tutorial ( https://lodev.org/cgtutor/raycasting.html )

]]--

--[[

Changelog:
added a keybind to toggle screen visibility

]]--

--[[

Keybinds:
arrows for movement and aiming
HOME to toggle screen visibility

]]--



--local byteMap = {}
--for i = 0, 255 do byteMap[i] = string.char(i) end

function ternary ( cond , T , F ) --https://stackoverflow.com/questions/5525817/inline-conditions-in-lua-a-b-yes-no
    if cond then return T else return F end
end

function DrawLineTexture(texture, x, y, r, g, b, a, length) -- UNFINISHED
    local data, bm = {}, byteMap;

    local w, h = texture:GetActualHeight(), texture:GetActualWidth();

    for i = 0, length do

    end
end

local screenWidth, screenHeight = 320, 240;
local screenPosX, screenPosY = 100, 100;
local mapWidth, mapHeight = 24, 24;

local lboxUI = true;
local holdingUIKey = false;
local holdingLMB = false;
local movingScreen = false;

local screenVisible = true;
local holdingVisibleKey = false;

local initialSPosX, initialSPosY;
local SOffsetX, SOffsetY;

function DrawVLine(x, drawStart, drawEnd, r, g, b, a)
    draw.Color(r, g, b, a);
    draw.Line(int(screenPosX + x), int(screenPosY + drawStart), int(screenPosX + x), int(screenPosY + drawEnd));
end

function tDist(xPos1, yPos1, xPos2, yPos2)
    local dx = xPos1 - xPos2;
    local dy = yPos1 - yPos2;
    return math.floor( math.sqrt( dx * dx + dy * dy ) );
end

function round(val)
    local dist = val - math.floor(val);

    if dist <= 0.4 then
        return math.floor(val);
    else
        return math.ceil(val);
    end
end

function int(val)
    return math.floor(val);
end

local map = { -- 1 = wall 0 = air
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 2, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 2, 0, 2, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 2, 2, 2, 0, 0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
}

local posX, posY = 2.0, 3.0;
local dirX, dirY = -1.0, 0.0;
local planeX, planeY = 0.0, 0.66;

callbacks.Register("Draw", function()
    if screenVisible then
        draw.Color(0, 0, 0, 255);
        draw.FilledRect(screenPosX, screenPosY, screenPosX + screenWidth, screenPosY + screenHeight);

        for x = 0, screenWidth do
            local screenIDX = x * 4;

            local cameraX = 2 * x / screenWidth - 1;

            local rayDirX = dirX + planeX * cameraX;
            local rayDirY = dirY + planeY * cameraX;

            local mapX = int(posX);
            local mapY = int(posY);

            local sideDistX, sideDistY;

            local deltaDistX = ternary(rayDirX == 0, 1e30, math.abs(1 / rayDirX));
            local deltaDistY = ternary(rayDirY == 0, 1e30, math.abs(1 / rayDirY));

            local perpWallDist;

            local stepX;
            local stepY;

            local hit = 0;
            local side;

            if rayDirX < 0 then
                stepX = -1;
                sideDistX = (posX - mapX) * deltaDistX;
            else
                stepX = 1;
                sideDistX = (mapX + 1.0 - posX) * deltaDistX;
            end
            if rayDirY < 0 then
                stepY = -1;
                sideDistY = (posY - mapY) * deltaDistY;
            else
                stepY = 1;
                sideDistY = (mapY + 1.0 - posY) * deltaDistY;
            end
            
            while hit == 0 do
                if sideDistX < sideDistY then
                    sideDistX = sideDistX + deltaDistX;
                    mapX = mapX + stepX;
                    side = 0;
                else
                    sideDistY = sideDistY + deltaDistY;
                    mapY = mapY + stepY;
                    side = 1;
                end

                if map[mapX][mapY] == nil then
                    goto nilcase;
                end

                if map[mapX][mapY] > 0 then
                    hit = 1;
                end

                goto endcase;

                ::nilcase::
                hit = 2;

                ::endcase::
            end

            if hit == 1 then
                if side == 0 then
                    perpWallDist = (sideDistX - deltaDistX);
                else
                    perpWallDist = (sideDistY - deltaDistY);
                end

                local lineHeight = int(screenHeight / perpWallDist);

                --[[ 
                int drawStart = -lineHeight / 2 + h / 2;
                if(drawStart < 0) drawStart = 0;
                int drawEnd = lineHeight / 2 + h / 2;
                if(drawEnd >= h) drawEnd = h - 1;
                ]]--

                local lineStart = -lineHeight / 2 + screenHeight / 2;
                if lineStart < 0 then lineStart = 0 end;
                local lineEnd = lineHeight / 2 + screenHeight / 2;
                if lineEnd >= screenHeight then lineEnd = screenHeight - 1 end;

                local r, g, b, a = 0, 255, 0, 255;

                if map[mapX][mapY] == 2 then
                    r = 255;
                    g = 0;
                    b = 0;
                    a = 255;
                end

                if side == 1 then
                    a = 127;
                end

                a = int(a - ( tDist(posX, posY, mapX, mapY) * 9 ));
                if a < 0 then
                    a = 0;
                end

                DrawVLine(x, lineStart, lineEnd, r, g, b, a);
            end
        end

        --[[
        if(keyDown(SDLK_RIGHT))
        {
        //both camera direction and camera plane must be rotated
        double oldDirX = dirX;
        dirX = dirX * cos(-rotSpeed) - dirY * sin(-rotSpeed);
        dirY = oldDirX * sin(-rotSpeed) + dirY * cos(-rotSpeed);
        double oldPlaneX = planeX;
        planeX = planeX * cos(-rotSpeed) - planeY * sin(-rotSpeed);
        planeY = oldPlaneX * sin(-rotSpeed) + planeY * cos(-rotSpeed);
        }
        //rotate to the left
        if(keyDown(SDLK_LEFT))
        {
        //both camera direction and camera plane must be rotated
        double oldDirX = dirX;
        dirX = dirX * cos(rotSpeed) - dirY * sin(rotSpeed);
        dirY = oldDirX * sin(rotSpeed) + dirY * cos(rotSpeed);
        double oldPlaneX = planeX;
        planeX = planeX * cos(rotSpeed) - planeY * sin(rotSpeed);
        planeY = oldPlaneX * sin(rotSpeed) + planeY * cos(rotSpeed);
        }
        ]]--

        local dt = globals.FrameTime();
        local rotSpeed = dt * 3.0;
        local moveSpeed = dt * 5.0;

        if input.IsButtonDown(KEY_RIGHT) then
            local oldDirX = dirX;
            dirX = dirX * math.cos(-rotSpeed) - dirY * math.sin(-rotSpeed);
            dirY = oldDirX * math.sin(-rotSpeed) + dirY * math.cos(-rotSpeed);
            local oldPlaneX = planeX;
            planeX = planeX * math.cos(-rotSpeed) - planeY * math.sin(-rotSpeed);
            planeY = oldPlaneX * math.sin(-rotSpeed) + planeY * math.cos(-rotSpeed);
        elseif input.IsButtonDown(KEY_LEFT) then
            local oldDirX = dirX;
            dirX = dirX * math.cos(rotSpeed) - dirY * math.sin(rotSpeed);
            dirY = oldDirX * math.sin(rotSpeed) + dirY * math.cos(rotSpeed);
            local oldPlaneX = planeX;
            planeX = planeX * math.cos(rotSpeed) - planeY * math.sin(rotSpeed);
            planeY = oldPlaneX * math.sin(rotSpeed) + planeY * math.cos(rotSpeed);
        end

        if input.IsButtonDown(KEY_UP) then
            if map[int(posX + dirX * moveSpeed)][int(posY)] == 0 then
                posX = posX + dirX * moveSpeed;
            end
            if map[int(posX)][int(posY + dirY * moveSpeed)] == 0 then
                posY = posY + dirY * moveSpeed;
            end
        elseif input.IsButtonDown(KEY_DOWN) then
            if map[int(posX - dirX * moveSpeed)][int(posY)] == 0 then
                posX = posX - dirX * moveSpeed;
            end
            if map[int(posX)][int(posY - dirY * moveSpeed)] == 0 then
                posY = posY - dirY * moveSpeed;
            end
        end

        if lboxUI then
            draw.Color(255, 0, 0, 127);
            draw.FilledRect(screenPosX, screenPosY - 20, screenPosX + screenWidth + 1, screenPosY);

            --[[if input.IsButtonDown(MOUSE_LEFT) then
                local mPos = input.GetMousePos();

                local x = mPos[1];
                local y = mPos[2];

                if x > screenPosX and x < screenPosX + screenWidth and y > screenPosY - 20 and y < screenPosY then
                    screenPosX = x;
                    screenPosY = y;
                end
            end]]--

            if input.IsButtonDown(MOUSE_LEFT) and not holdingLMB then
                holdingLMB = true;

                local mPos = input.GetMousePos();

                --initialSPosX = mPos[1];
                --initialSPosY = mPos[2];

                x = mPos[1];
                y = mPos[2];            

                if x > screenPosX and x < screenPosX + screenWidth and y > screenPosY - 20 and y < screenPosY then
                    SOffsetX = mPos[1] - screenPosX;
                    SOffsetY = mPos[2] - screenPosY;
                    movingScreen = true;
                end

            elseif not input.IsButtonDown(MOUSE_LEFT) then
                holdingLMB = false;
                movingScreen = false;
            end

            if movingScreen then
                local mPos = input.GetMousePos();

                local x = mPos[1];
                local y = mPos[2];

                screenPosX = x - SOffsetX;
                screenPosY = y - SOffsetY;
            end
        end
    end

    if input.IsButtonDown(KEY_INSERT) and not holdingUIKey then
        holdingUIKey = true;
        lboxUI = not lboxUI;
    elseif not input.IsButtonDown(KEY_INSERT) then
        holdingUIKey = false;
    end

    if input.IsButtonDown(KEY_HOME) and not holdingVisibleKey then
        holdingVisibleKey = true;
        screenVisible = not screenVisible;
    elseif not input.IsButtonDown(KEY_HOME) then
        holdingVisibleKey = false;
    end
end)
