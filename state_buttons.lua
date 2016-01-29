
    AddonFrame.StateButtons = {
        frame = CreateFrame("Frame", "Y_Buttons", AddonFrame),
        buttonFrame = CreateFrame("Frame", "Y_Buttons_Container", AddonFrame),
        buttons = { },
        size    = 36,
        padding = 6,

        SavePosition = function(self)
            local point, _, rpoint, x, y = self.frame:GetPoint();
            SetCVar("Y_b_frame_point",  point);
            SetCVar("Y_b_frame_rpoint", rpoint);
            SetCVar("Y_b_frame_x",      x);
            SetCVar("Y_b_frame_y",      y);
        end,

        Clear = function(self)
            for i = 1, #self.buttons do
                self.buttons[i]:Hide();
                self.buttons[i] = nil;
            end
        end,

        SetCaption = function(self, text)
            self.statusText:SetText("|cff0000ff"..text.."|r");
        end,

        AddButton = function(self, title, tooltip, icon, bstate, action)
            local button = CreateFrame("CheckButton", "Y_b_action_"..tostring(#self.buttons), self.buttonFrame, "ActionButtonTemplate");
            button:RegisterForClicks("LeftButtonUp", "RightButtonUp");
            button:SetWidth(self.size);
            button:SetHeight(self.size);
            button:SetPoint("TOPLEFT", self.buttonFrame, "TOPLEFT", ((#self.buttons*self.size)+(#self.buttons*self.padding)+4), -3);
            button.icon:SetTexture(icon);
            button.checked = bstate;
            button:SetPushedTexture(nil);
            tinsert(self.buttons, button);

            button:SetScript("OnClick", function(selfb)
                    selfb.checked = not selfb.checked;
                    -- Добавить закрашивание при нажатой/отпущенной кнопке
                    if type(action) == "function" then
                        action(selfb, selfb.checked);
                    end
                end);

            if tooltip then
                button:SetScript("OnEnter", function(self)
                    GameTooltip:SetOwner(self, "ANCHOR_TOP")
                    GameTooltip:AddLine("|cff00ff00" .. tooltip .. "|r")
                    GameTooltip:Show()
                end);
                button:SetScript("OnLeave", function(self)
                    GameTooltip:Hide()
                end);
            end
        end,

        Init = function(self)
            local point, rpoint, x, y =
                GetCVar("Y_b_frame_point"),
                GetCVar("Y_b_frame_rpoint"),
                GetCVar("Y_b_frame_x"),
                GetCVar("Y_b_frame_y");
            if x and y and point and rpoint then
                self.frame:SetPoint(point, UIParent, rpoint, tonumber(x), tonumber(y));
            else
                self.frame:SetPoint("CENTER", UIParent);
            end

            self.frame:SetWidth(170);
            self.frame:SetHeight(AddonFrame.StateButtons.size+5);
            self.frame:SetMovable(true);
            self.frame:SetFrameStrata('HIGH');

            self.frame:Hide();
            self.buttonFrame:Hide();

            self.statusText = AddonFrame.StateButtons.frame:CreateFontString('Y_StatusText');
            self.statusText:SetFont("Fonts\\ARIALN.TTF", 16);
            self.statusText:SetShadowColor(0,0,0, 0.8);
            self.statusText:SetShadowOffset(-1,-1);
            self.statusText:SetPoint("CENTER", AddonFrame.StateButtons.frame);
            self.statusText:SetText("|cff0000ff<empty>|r");

            self.frame.texture = AddonFrame.StateButtons.frame:CreateTexture();
            self.frame.texture:SetAllPoints(AddonFrame.StateButtons.frame);
            self.frame.texture:SetTexture(0,0,0,0.6);

            self.frame:SetScript("OnMouseDown", function(self2, button)
                if not self2.isMoving then
                        self2:StartMoving();
                        self2.isMoving = true;
                    end
                end);

            self.frame:SetScript("OnMouseUp", function(self2, button)
                    if self2.isMoving then
                        self2:StopMovingOrSizing();
                        self2.isMoving = false;
                        self:SavePosition();
                    end
                end);

            self.frame:SetScript("OnHide", function(self2)
                    if self2.isMoving then
                        self2:StopMovingOrSizing();
                        self2.isMoving = false;
                        self:SavePosition();
                    end
                end);
        end,
    };