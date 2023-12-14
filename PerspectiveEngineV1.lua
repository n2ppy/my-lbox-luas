--[[

matrix is a 2d array of 4 by 4 size. example:
local matrix = {
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0}
};

]]--

function matrix_multiply(pos, matrix)
    local result = Vector3(0, 0, 0);

    result.x = pos.x * matrix[1][1] + pos.y * matrix[2][1] + pos.z * matrix[3][2] + matrix[4][1];
    result.y = pos.x * matrix[1][2] + pos.y * matrix[2][2] + pos.z * matrix[3][2] + matrix[4][2];
    result.z = pos.x * matrix[1][3] + pos.y * matrix[2][3] + pos.z * matrix[3][3] + matrix[4][3];
    local w = pos.x * matrix[1][4] + pos.y * matrix[2][4] + pos.z * matrix[3][4] + matrix[4][4];

    print(string.format("%.2f %.2f %.2f %.2f\n%.2f %.2f %.2f %.2f\n%.2f %.2f %.2f %.2f\n%.2f %.2f %.2f %.2f\n%.2f", matrix[1][1], matrix[2][1], matrix[3][1], matrix[4][1], matrix[1][2], matrix[2][2], matrix[3][2], matrix[4][2], matrix[1][3], matrix[2][3], matrix[3][3], matrix[4][3], matrix[1][4], matrix[2][4], matrix[3][4], matrix[4][4], w));

    if w ~= 1 then
        result.x = result.x / w;
        result.y = result.y / w;
        result.z = result.z / w;
    end

    return result;
end

--[[function set_projection_matrix(viewangle, near, far)
    local m = {
        {0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0}
    };

    local scale = 1 / math.tan(viewangle * 0.5 * math.pi / 180);
    m[1][1] = scale;
    m[2][2] = scale;
    m[3][3] = -far / (far - near);
    m[4][3] = -far * near / (far - near);
    m[3][4] = -1;
    m[4][4] = 0;

    return m;
end]]--

function nglPerspective(angleOfView, AspectRatio, n, f, b, t, l, r)
    local scale = math.tan(angleOfView * 0.5 * math.pi / 180);
    local rR = AspectRatio * scale;
    local lR = -rR;
    local tR = scale;
    local bR = -tR;

    return rR, lR, tR, bR;
end

function nglFrustum(b, t, l, r, n, f)
    local m = {
        {0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0, 0.0}
    };

    m[1][1] = 2 * n / (r - l);
    m[1][2] = 0.0;
    m[1][3] = 0.0;
    m[1][4] = 0.0;

    m[2][1] = 0.0;
    m[2][2] = 2 * n / (t - b);
    m[2][3] = 0.0;
    m[2][4] = 0.0;

    m[3][1] = (r + l) / (r - l);
    m[3][2] = (t + b) / (t - b);
    m[3][3] = (f + n) / (f - n);
    m[3][4] = 0.0;

    m[4][1] = 0.0;
    m[4][2] = 0.0;
    m[4][3] = -2 * f * n / (f - n);
    m[4][4] = 0.0;

    return m;
end

function round(val)
    local dist = val - math.floor(val);

    if dist <= 0.4 then
        return math.floor(val);
    else
        return math.ceil(val);
    end
end

--[[
Cube:
Vector3(-1.0, -1.0,  1.0),
Vector3(-1.0,  1.0,  1.0),
Vector3(-1.0, -1.0, -1.0),
Vector3(-1.0,  1.0, -1.0),
Vector3( 1.0, -1.0, -1.0),
Vector3( 1.0,  1.0, -1.0),
Vector3( 1.0, -1.0,  1.0),
Vector3( 1.0,  1.0,  1.0),
Vector3( 1.0,  1.0, -1.0),
Vector3(-1.0,  1.0, -1.0),
Vector3( 1.0,  1.0,  1.0),
Vector3(-1.0,  1.0,  1.0),
Vector3( 1.0, -1.0,  1.0),
Vector3(-1.0, -1.0,  1.0),
Vector3( 1.0, -1.0, -1.0),
Vector3(-1.0, -1.0, -1.0)

]]--

numVertices = 16;
local verts = {
    Vector3(-1.0, -1.0,  1.0),
    Vector3(-1.0,  1.0,  1.0),
    Vector3(-1.0, -1.0, -1.0),
    Vector3(-1.0,  1.0, -1.0),
    Vector3( 1.0, -1.0, -1.0),
    Vector3( 1.0,  1.0, -1.0),
    Vector3( 1.0, -1.0,  1.0),
    Vector3( 1.0,  1.0,  1.0),
    Vector3( 1.0,  1.0, -1.0),
    Vector3(-1.0,  1.0, -1.0),
    Vector3( 1.0,  1.0,  1.0),
    Vector3(-1.0,  1.0,  1.0),
    Vector3( 1.0, -1.0,  1.0),
    Vector3(-1.0, -1.0,  1.0),
    Vector3( 1.0, -1.0, -1.0),
    Vector3(-1.0, -1.0, -1.0)
};

local matrix = {
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0}
};
local worldToCamera = {
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0},
    {0.0, 0.0, 0.0, 0.0},
    {0.0, -10.0, -20.0, 0.0}
};

local screenWidth, screenHeight = 320, 240;
local screenPosX, screenPosY = 100, 100;

local angleOfView = 90.0;
local near = 0.1;
local far = 1000.0;
local aspectRatio = screenWidth / screenHeight;
local b, t, l, r;
--  matrix = set_projection_matrix(angleOfView, near, far);

callbacks.Register("Draw", function()
    --[[angleOfView = angleOfView + 1.0;

    if angleOfView > 360.0 then
        angleOfView = 0.0;
    end]]--

    draw.Color(0, 0, 0, 255);
    draw.FilledRect(screenPosX, screenPosY, screenPosX + screenWidth, screenPosY + screenHeight);

    --matrix = set_projection_matrix(angleOfView, near, far);

    b, t, l, r = nglPerspective(angleOfView, aspectRatio, near, far, b, t, l, r);
    matrix = nglFrustum(b, t, l, r, near, far);

    for i = 1, numVertices do
        if i + 1 <= numVertices then
            local vertCamera, projectedVert = Vector3(0, 0, 0), Vector3(0, 0, 0);

            vertCamera = matrix_multiply(verts[i], worldToCamera);
            projectedVert = matrix_multiply(vertCamera, matrix);

            if projectedVert.x < -1 and projectedVert.y < -1 and projectedVert.z < -1 then
                goto continue;
                print("something went wrong");
            end

            local xPos = math.min( screenPosX + (screenWidth - 1), round( ( projectedVert.x + 1 ) * 0.5 * screenWidth ) );
            local yPos = math.min( screenPosY + (screenHeight - 1), round( (1 - ( projectedVert.y + 1) * 0.5) * screenHeight ) );

            --xPos = xPos + screenPosX;
            --yPos = yPos + screenPosY;

            vertCamera = matrix_multiply(verts[i + 1], worldToCamera);
            projectedVert = matrix_multiply(vertCamera, matrix);

            if projectedVert.x < -1 and projectedVert.y < -1 and projectedVert.z < -1 then
                goto continue;
                print("something went wrong");
            end

            local xPos2 = math.min( screenPosX + (screenWidth - 1), round( ( projectedVert.x + 1 ) * 0.5 * screenWidth ) );
            local yPos2 = math.min( screenPosY + (screenHeight - 1), round( (1 - ( projectedVert.y + 1) * 0.5) * screenHeight ) );

            --xPos2 = xPos2 + screenPosX;
            --yPos2 = yPos2 + screenPosY;

            draw.Color(255, 255, 255, 255);
            --draw.FilledRect(xPos, yPos, xPos + 1, yPos + 1);
            draw.Line(xPos, xPos, xPos2, yPos2);

            --print(string.format("%d %d", xPos, yPos));

            ::continue::
        end
    end
end)
