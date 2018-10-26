sx, sy = guiGetScreenSize();
rX, rY = sx/1920, sy/1080;

local width, height = 190*rX, 220*rY;

local menuShowing = false;
local playerElement = false;
local playerName = false;
local clickedX, clickedY = false, false;

local r, g, b = unpack(menuColor);

font = dxCreateFont("roboto.ttf", 17);

local buttonSettings = {
    {"Felélesztés", false},
    {"VH teleportálás", false},
    {"Bebörtönzés", false},
    {"Bezárás", false};
};

addEventHandler("onClientRender", getRootElement(), function()
    if menuShowing then
        dxDrawRectangle(clickedX - 10*rX, clickedY - 5*rY, width + 10*rX, height + 10*rY, tocolor(0, 0, 0, 150));
        dxDrawRectangle(clickedX - 5*rX, clickedY, width, height, tocolor(0, 0, 0, 100));
            
        dxDrawText(playerName, clickedX + 90*rX, clickedY + 20*rY, clickedX + 90*rX, clickedY + 20*rY, tocolor(255, 255, 255), 1*rX, font, "center", "center", false, false, false, false, true);
        
        dxDrawRectangle(clickedX + 2.5*rX, clickedY + 40*rY, 175*rX, 2*rY, tocolor(r, g, b, 200));
        
        for i = 1, #buttonSettings do
            dxDrawRectangle(clickedX - 5*rX, clickedY + (42*i + 10)*rY, width, 32*rY, tocolor(0, 0, 0, buttonSettings[i][2] and 100 or 0));
            dxDrawText(buttonSettings[i][1], clickedX + 90*rX, clickedY + (42*i + 25)*rY, clickedX + 90*rX, clickedY + (42*i + 27.5)*rY, tocolor(255, 255, 255), buttonSettings[i][2] and 0.75*rX or 0.68*rX, font, "center", "center", false, false, false, false, true);
            
            if isCursorHover(clickedX - 5*rX, clickedY + (42*i + 10)*rY, width, 32*rY) then
                buttonSettings[i][2] = true;
            else
                buttonSettings[i][2] = false;
            end
        end
    end
end);

addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY, _, _, _, clickedElement)
    if state == "down" then
        if button == "right" then
            if clickedElement and getElementType(clickedElement) == "player" then
                local height = height + 5*rY;
                local absoluteX = absoluteX + 10*rX
                local absoluteY = absoluteY + 5*rY
                clickedX = (absoluteX + width) > sx and (sx - width) or absoluteX;
                clickedY = (absoluteY + height) > sy and (sy - height) or absoluteY;
                playerElement = clickedElement;
                playerName = getPlayerName(clickedElement):gsub("_", " ");
                menuShowing = true;
            end
        else
            if menuShowing and isCursorHover(clickedX - 10*rX, clickedY - 5*rY, width + 10*rX, height + 10*rY) then
                for i = 1, #buttonSettings do
                    if isCursorHover(clickedX - 5*rX, clickedY + (42*i + 10)*rY, width, 32*rY) then
                        buttonFunction(i);
                        menuShowing = false;
                        break;
                    end
                end
            elseif jailPanelShowing then
                selectedEdit = {false, false, false};
                if isCursorHover(panelPos[1] + 187.5*rX, panelPos[2] + 60*rY, 350*rX, 30*rY) then
                    selectedEdit[1] = true;
                elseif isCursorHover(panelPos[1] + 545*rX, panelPos[2] + 325*rY, 120*rX, 30*rY) then
                    selectedEdit[2] = true;
                elseif isCursorHover(panelPos[1] + 30*rX, panelPos[2] + 325*rY, 450*rX, 30*rY) then
                    selectedEdit[3] = true;
                else
                    for i = 1, 4 do
                        if isCursorHover(panelPos[1] + (180*i - tValue)*rX, panelPos[2] + 150*rY, dxGetTextWidth(jailReasons[i][1], 1*rX, font) + 10*rX, 30*rY) then
                            eraseReasons();
                            jailReasons[i][2] = true;
                            break;
                        elseif isCursorHover(panelPos[1] + (180*i - tValue)*rX, panelPos[2] + 200*rY, dxGetTextWidth(jailReasons[i+4][1], 1*rX, font) + 10*rX, 30*rY) then
                            eraseReasons();
                            jailReasons[i+4][2] = true;
                            break;
                        elseif isCursorHover(panelPos[1] + (180*i - tValue)*rX, panelPos[2] + 250*rY, dxGetTextWidth(jailReasons[i+8][1], 1*rX, font) + 10*rX, 30*rY) then
                            eraseReasons();
                            jailReasons[i+8][2] = true;
                            break;
                        end
                    end
                end
            end
        end
    end
end);

function eraseReasons()
    for i = 1, #jailReasons do
        jailReasons[i][2] = false;
    end
end

function buttonFunction(type)
    if type == 1 then
        triggerServerEvent("server->revivePlayer", resourceRoot, localPlayer, playerElement);
    elseif type == 2 then
        triggerServerEvent("server->teleportPlayerToCityHall", resourceRoot, localPlayer, playerElement);
    elseif type == 3 then
        editBox[1] = playerName;
        selectedEdit = {false, false, false};
        jailPanelShowing = not jailPanelShowing;
        guiSetInputEnabled(jailPanelShowing);
    end
end

function isCursorHover(rectX, rectY, rectW, rectH)
    if isCursorShowing() then
        local cursorX, cursorY = getCursorPosition();
        cursorX, cursorY = cursorX * sx, cursorY * sy;
        return (cursorX >= rectX and cursorX <= rectX+rectW) and (cursorY >= rectY and cursorY <= rectY+rectH);
    else
        return false;
    end
end