import pygame


#Run with python3
#Use W to export and the number keys 1 through 6 to change what color wall to make 7 goes to the air tool



# pygame setup
pygame.init()
pygame.display.set_caption('raycaster map maker')
screen = pygame.display.set_mode((480, 480))
clock = pygame.time.Clock()
running = True

pygame.font.init()
tahoma = pygame.font.SysFont('Tahoma', 16)

mapWidth = 24
mapHeight = 24

mScreenWidth = 480
mScreenHeight = 480

currentNum = 1

worldMap = [
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ],
    [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
]

def export():
    strings = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    string = "local map = {\n"

    for y in range(0, mapHeight):
        strings[y] = "\t{ "
        for x in range(0, mapWidth):
            if x != mapWidth:
                strings[y] = strings[y] + str(worldMap[y][x]) + ", "
            else:
                strings[y] = strings[y] + str(worldMap[y][x])
        
        if y != mapHeight - 1:
            strings[y] = strings[y] + " },\n"
        else:
            strings[y] = strings[y] + " }\n"

    for s in strings:
        string = string + s

    string = string + "}"

    file = open("output.txt", "w");

    file.write(string)

    file.close()

while running:
    # poll for events
    # pygame.QUIT event means the user clicked X to close your window
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_w:
                export()

    # fill the screen with a color to wipe away anything from last frame
    screen.fill((127, 127, 127, 255))

    # RENDER YOUR GAME HERE
    for y in range(0, mapHeight):
        for x in range(0, mapWidth):
            posX = x * 20
            posY = y * 20

            col = (255, 0, 0, 255)

            if worldMap[y][x] == 0:
                col = (0, 0, 0, 255);
            elif worldMap[y][x] == 1:
                col = (0, 255, 0, 255)
            elif worldMap[y][x] == 2:
                col = (255, 0, 0, 255)
            elif worldMap[y][x] == 3:
                col = (0, 0, 255, 255)
            elif worldMap[y][x] == 4:
                col = (255, 255, 255, 255)
            elif worldMap[y][x] == 5:
                col = (255, 255, 0, 255)
            elif worldMap[y][x] == 6:
                col = (127, 127, 127, 255)

            pygame.draw.rect(screen, col, [posX, posY, posX + 20, posY + 20]);
    
    if pygame.mouse.get_pressed()[0] == True:
        mPos = pygame.mouse.get_pos()

        gridPosX = mPos[0] // 20
        gridPosY = mPos[1] // 20

        worldMap[gridPosY][gridPosX] = currentNum

    if pygame.key.get_pressed()[pygame.K_1]:
        currentNum = 1
    elif pygame.key.get_pressed()[pygame.K_2]:
        currentNum = 2
    elif pygame.key.get_pressed()[pygame.K_3]:
        currentNum = 3
    elif pygame.key.get_pressed()[pygame.K_4]:
        currentNum = 4
    elif pygame.key.get_pressed()[pygame.K_5]:
        currentNum = 5
    elif pygame.key.get_pressed()[pygame.K_6]:
        currentNum = 6
    elif pygame.key.get_pressed()[pygame.K_7]:
        currentNum = 0

    text_surface = tahoma.render("Tool: " + str(currentNum), False, (255, 255, 255, 255));
    screen.blit(text_surface, (0 ,0));

    # flip() the display to put your work on screen
    pygame.display.flip()

    clock.tick(60)  # limits FPS to 60

pygame.quit()
