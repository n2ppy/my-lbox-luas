local byteMap = {}
for i = 0, 255 do byteMap[i] = string.char(i) end




local screenWidth = 128
local screenHeight = 128;





local function clamp(val, min, max)
    if val > max then
        return max;
    elseif val < min then
        return min;
    end

    return val;
end

local function GetDDAPoint(x1, y1, x2, y2, yPos)
    local dx = x2 - x1;
    local dy = y2 - y1;

    local steps = math.abs(dy);

    if math.abs(dx) > math.abs(dy) then
        steps = math.abs(dx);
    end

    local xInc = dx / steps;
    local yInc = dy / steps;

    local x = x1;
    local y = y1;
    for i = 0, steps do
        if y == yPos then
            return x, y;
        end
        x = x + xInc;
        y = y + yInc;
    end
end

local function CreateTexture(id, width, height, data)
    local binaryData = table.concat(data)
    local texture = draw.CreateTextureRGBA(binaryData, width, height)
    return texture
end

local function TestTexture(r, g, b, a, width, height)
    local dataSize = width * height * 4;
    local data, bm = {}, byteMap;
    
    local i = 1;
    while i < dataSize do
        local idx = (i / 4);
        local x, y = idx % width, idx // width;

        data[i] = bm[r];
        data[i + 1] = bm[g];
        data[i + 2] = bm[b];
        data[i + 3] = bm[a];

        i = i + 4;
    end

    return CreateTexture(0, width, height, data);
end

local function ClearBG(r, g, b, a, width, height)
    local dataSize = width * height * 4;
    local data, bm = {}, byteMap;
    
    local i = 1;
    while i < dataSize do
        local idx = (i / 4);
        local x, y = idx % width, idx // width;

        data[i] = bm[r];
        data[i + 1] = bm[g];
        data[i + 2] = bm[b];
        data[i + 3] = bm[a];

        i = i + 4;
    end

    return data;
end

local function PutPixel(x, y, r, g, b, a, data)
    data[((x + (y * screenWidth)) * 4) + 1] = byteMap[r];
    data[((x + (y * screenWidth)) * 4) + 2] = byteMap[g];
    data[((x + (y * screenWidth)) * 4) + 3] = byteMap[b];
    data[((x + (y * screenWidth)) * 4) + 4] = byteMap[a];

    return data;
end

local function DrawLineTexture(x1, y1, x2, y2, r, g, b, a, data)
    local dx = x2 - x1;
    local dy = y2 - y1;

    local steps = math.abs(dy);

    if math.abs(dx) > math.abs(dy) then
        steps = math.abs(dx);
    end

    local xInc = dx / steps;
    local yInc = dy / steps;

    local x = x1;
    local y = y1;
    for i = 0, steps do
        data = PutPixel(x, y, r, g, b, a, data);
        x = x + xInc;
        y = y + yInc;
    end

    return data;
end

local function DrawVLineTexture(x, y, len, r, g, b, a, data)
    for i = 0, len do
        if y + i < screenHeight then
            data = PutPixel(x, y + i, r, g, b, a, data);
        end
    end

    return data;
end

local function DrawHLineTexture(x, y, len, r, g, b, a, data)
    for i = 0, len do
        if x + i < screenWidth then
            data = PutPixel(x + i, y, r, g, b, a, data);
        end
    end

    return data;
end

local function DrawSquareTexture(x1, y1, x2, y2, r, g, b, a, data)
    local yDist = y1 - y2;
    if yDist < 0 then
        yDist = y2 - y1;
    end

    if x1 > x2 then
        local i = 1;
        while i < x1 - x2 do
            if i + x1 < screenWidth then
                data = DrawVLineTexture(x1 + i, y1, yDist, r, g, b, a, data);
                --data = PutPixel(x1 + i, y1, r, g, b, a, data);

                i = i + 1;
            end
        end
    else
        local i = 1;
        while i < x2 - x1 do
            if i + x1 < screenWidth then
                data = DrawVLineTexture(x1 + i, y1, yDist, r, g, b, a, data);
                --data = PutPixel(x1 + i, y1, r, g, b, a, data);

                i = i + 1;
            end
        end
    end

    return data;
end

local function DrawTriangleTexture(xa, ya, xb, yb, xc, yc, r, g, b, a, data)
    -- get total Y length of tri
    local length = 0;
    local longestIDX = 0; -- 0 = ya to yb 1 = yc to yb 2 = yc to ya 3 = yb to ya

    local dists = {
        ya - yb,
        ya - yc,
        yb - ya,
        yb - yc,
        yc - ya,
        yc - yb
    }

    for i, v in pairs(dists) do
        if v > length then
            length = v;
        end
    end

    -- loop through tri
    for i = 0, length do
        local x1, y1 = GetDDAPoint(xa, ya, xb, yb, i);
        local x2, y2 = GetDDAPoint(xa, ya, xc, yc, i);

        if x2 ~= nil and x1 ~= nil and y2 ~= nil and y1 ~= nil then
            if x2 > x1 then
                data = DrawHLineTexture(x1, y1, x2 - x1, r, g, b, a, data);
            else
                data = DrawHLineTexture(x1, y1, x1 - x2, r, g, b, a, data);
            end
        end
    end

    return data;
end

local frame = TestTexture(0, 0, 0, 255, 128, 128);
local frameData = {};
local framecounter = 0.0;

callbacks.Register("Draw", function()
    framecounter = framecounter + globals.FrameTime();
    if framecounter * 1000 >= 100.0 then -- draw every 100 ms (10 fps)
        --frame = TestTexture(255, 255, 255, 255, 128, 128);
        frameData = ClearBG(0, 0, 0, 255, screenWidth, screenHeight);

        --frameData = DrawLineTexture(64, 64, 0, 0, 255, 255, 255, 255, frameData);
        --frameData = DrawSquareTexture(64, 64, 0, 0, 255, 255, 255, 255, frameData);
        --frameData = DrawVLineTexture(0, 0, 64, 255, 255, 255, 255, frameData);
        --frameData = DrawHLineTexture(0, 0, 64, 255, 255, 255, 255, frameData);
        --frameData = DrawTriangleTexture(0, 0, 0, 64, 64, 64, 255, 255, 255, 255, frameData);

        frame = CreateTexture(0, screenWidth, screenHeight, frameData);
        framecounter = 0.0;
    end

    draw.Color(255, 255, 255, 255);
    draw.TexturedRect(frame, 250, 250, 500, 500);
end)

callbacks.Register("Unload", function()
    draw.DeleteTexture(frame);
end)
