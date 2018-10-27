local width, height = 750*rX, 420*rY;

panelPos = {(sx/2) - (width/2), (sy/2) - (height/2)};

jailPanelShowing = false;

selectedEdit = {false, false, false};
editBox = {"", "", ""};
local placeHolder = {"Játékos neve", "Időtartam", "Egyéb indok"};
local displayText = {{"", 180}, {"", 180}, {"", 180}};

local r1, g1, b1 = unpack(jailPanelColor);
local r2, g2, b2 = unpack(inputColor);

addEventHandler("onClientRender", getRootElement(), function()
    if jailPanelShowing then
        dxDrawRectangle(panelPos[1] - 5, panelPos[2] - 5, width + 10, height + 10, tocolor(0, 0, 0, 150));
        dxDrawRectangle(panelPos[1], panelPos[2], width, height, tocolor(0, 0, 0, 100));
        
        dxDrawText("Játékos bebörtönzése", panelPos[1] + 370*rX, panelPos[2] + 15*rY, panelPos[1] + 370*rX, panelPos[2] + 15*rY, tocolor(255, 255, 255), 1*rX, font[1], "center", "center", false, false, false, false, true);
            
        dxDrawRectangle(panelPos[1] + 7.5*rX, panelPos[2] + 30*rY, 735*rX, 2, tocolor(r1, g1, b1, 200));
        dxDrawRectangle(panelPos[1] + 7.5*rX, panelPos[2] + 120*rY, 735*rX, 2, tocolor(r1, g1, b1, 200));
        dxDrawRectangle(panelPos[1] + 7.5*rX, panelPos[2] + 310*rY, 735*rX, 2, tocolor(r1, g1, b1, 200));
        dxDrawRectangle(panelPos[1] + 7.5*rX, panelPos[2] + 370*rY, 735*rX, 2, tocolor(r1, g1, b1, 200));
            
        for i = 1, #selectedEdit do
            displayText[i][1] = selectedEdit[i] and editBox[i]..(getTickCount() - tickCount < 500 and "|" or "") or (editBox[i] == "" and placeHolder[i] or editBox[i]);
            displayText[i][2] = (not selectedEdit[i] and editBox[i] == "" and 180 or 255);
        end
            
        dxDrawEditBox(displayText[1][1], selectedEdit[1], panelPos[1] + 187.5*rX, panelPos[2] + 60*rY, 350*rX, 30*rY, displayText[1][2]);
            
        for i = 1, 4 do
            dxDrawEditBox(jailReasons[i][1], jailReasons[i][2], panelPos[1] + (180*i - tValue)*rX, panelPos[2] + 150*rY, dxGetTextWidth(jailReasons[i][1], 1*rX, font[1]) + 10*rX, 30*rY, 255);
        end
            
        for i = 1, 4 do
            dxDrawEditBox(jailReasons[i+4][1], jailReasons[i+4][2], panelPos[1] + (180*i - tValue)*rX, panelPos[2] + 200*rY, dxGetTextWidth(jailReasons[i+4][1], 1*rX, font[1]) + 10*rX, 30*rY, 255);
        end
            
        for i = 1, 4 do
            dxDrawEditBox(jailReasons[i+8][1], jailReasons[i+8][2], panelPos[1] + (180*i - tValue)*rX, panelPos[2] + 250*rY, dxGetTextWidth(jailReasons[i+8][1], 1*rX, font[1]) + 10*rX, 30*rY, 255);
        end
            
        dxDrawEditBox(displayText[3][1], selectedEdit[3], panelPos[1] + 30*rX, panelPos[2] + 325*rY, 450*rX, 30*rY, displayText[3][2]);
            
        dxDrawEditBox(displayText[2][1]..((selectedEdit[2] or editBox[2] ~= "") and (displayText[2][1] ~= placeHolder[2]) and " perc" or ""), selectedEdit[2], panelPos[1] + 545*rX, panelPos[2] + 325*rY, 120*rX, 30*rY, displayText[2][2]);
    end
end);

addEventHandler("onClientCharacter", getRootElement(), function(character)
    if jailPanelShowing then
        if selectedEdit[1] and (string.len(editBox[1]) < 22) then
            editBox[1] = editBox[1]..character;
        elseif selectedEdit[2] and (string.len(editBox[2]) < 3) and type(tonumber(character)) == "number" then
            editBox[2] = editBox[2]..character;
        elseif selectedEdit[3] and (string.len(editBox[3]) < 40) then
            editBox[3] = editBox[3]..character;
        end
    end
end);

addEventHandler("onClientKey", getRootElement(), function(button, press)
    if jailPanelShowing then
        if press then
            if button == "backspace" then
                for i = 1, #selectedEdit do
                    if selectedEdit[i] then
                        editBox[i] = editBox[i]:sub(1, -2);
                        break;
                    end
                end
            elseif button == "delete" then
                for i = 1, #selectedEdit do
                    if selectedEdit[i] then
                        editBox[i] = "";
                        break;
                    end
                end
            end
        end
    end
end);

setTimer(function()
	tickCount = getTickCount()
end, 1000, 0)

function dxDrawEditBox(text, active, x, y, w, h, a)
    dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, isCursorHover(x, y, w, h) and 100 or 0));
    
    dxDrawText(text, x + w/2, y + h/2, x + w/2, y + h/2, tocolor(255, 255, 255, a), 1*rX, font[1], "center", "center", false, false, false, false, true);
    
    dxDrawRectangle(x, y + h, w, 2, tocolor(r2, g2, b2, active and 200 or 0));
end