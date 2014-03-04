--[[
Name: Bazooka_ShowUpdates
Author(s): Ternobeus
Description: Bazooka_ShowUpdates adds highlighting of icon/text updates to Bazooka
License: Public Domain
]]

local NotifyShow = "1"
local NotifyScrollDown = "2"
local NotifyScrollUp = "3"

local Plugin = Bazooka.Plugin

local Old_Bazooka_attributeChanged = Bazooka.attributeChanged
function Bazooka:attributeChanged(event, name, attr, value, dataobj)

    local plugin = self.plugins[name]

    if plugin then

        if (plugin.db.showText and attr=="text")
        or (plugin.db.showIcon and attr=="icon")
        or (plugin.db.showValue and attr=="value") 
        or (plugin.db.showTitle and attr=="title") then

            if plugin.db.showupdates == NotifyShow or plugin.db.showupdates == NotifyScrollUp or plugin.db.showupdates == NotifyScrollDown then

                Bazooka_Notify(plugin)

            end

        end 

    end 

    return Old_Bazooka_attributeChanged(self, event, name, attr, value, dataobj)

end

local Old_Plugin_addOptions = Plugin.addOptions
function Plugin:addOptions()

    Old_Plugin_addOptions(self)

    self.opts.args.showupdates = {
        type = 'select',
        name = "Notify when changed",
        desc = "Highlight whenever the icon/text changes, and optionally scroll and fade the old value",
        values = { [""] = "Do nothing", [NotifyShow] = "Show new value", [NotifyScrollUp] = "Scroll old value up", [NotifyScrollDown] = "Scroll old value down" },
        order = 510,
        disabled = "isDisabled",
    }

end

function Bazooka_Notify_Animator(frame)

    local self = frame.bzkPlugin
    local elapsed = GetTime() - self.notifystart
    
    if self.db.showupdates == NotifyScrollUp then

        self.notifyframe:ClearAllPoints()
        self.notifyframe:SetPoint( "TOPLEFT", self.frame, "TOPLEFT", 0, ceil( elapsed * 20 ) )

    elseif self.db.showupdates == NotifyScrollDown then

        self.notifyframe:ClearAllPoints()
        self.notifyframe:SetPoint( "TOPLEFT", self.frame, "TOPLEFT", 0, -ceil( elapsed * 20 ) )

    end

    if self.notifyinhibit == 1 then
        
        if elapsed > 2 then

            self.notifyframe:SetAlpha(0)
            self.notifyicon:SetAlpha(0)
            self.notifytext:SetAlpha(0)
        
            self.notifyinhibit = 0
        
        elseif elapsed > 1 then
        
            self.notifyframe:SetAlpha( 2 - elapsed )
            self.notifyicon:SetAlpha( 2 - elapsed )
            self.notifytext:SetAlpha( 2 - elapsed )
        
        end

    end

    if elapsed > 3 then

        self.frame:SetAlpha(1)
        if self.icon then
            self.icon:SetAlpha(self.bar.frame:GetAlpha())
        end
        if self.text then
            self.text:SetAlpha(self.bar.frame:GetAlpha())
        end

        self.notifyinhibit = 0
        self.notifyframe:SetScript("OnUpdate", nul)
        self.notifyframe:Hide()
        
    end

end


function Bazooka_Notify(self)

    -- make the actual plugin visible

    if not self.frame then
        return
    end

    
    self.frame:SetAlpha(1.0)
    if self.icon then
        self.icon:SetAlpha(1.0)
    end
    if self.text then
        self.text:SetAlpha(1.0)
    end


    if not self.notifyinhibit then
        self.notifyinhibit = 0
    end 


    -- don't create more notifications if one is already shown for this plugin

    if self.notifyinhibit == 1 then
        return
    end
    
    
    -- create frame if we haven't already
    if not self.notifyframe then
        self.notifyframe = CreateFrame("Button", "BazookaPluginNotify_" .. self.name, UIParent)
        self.notifyframe.bzkPlugin = self
        self.notifyframe:SetFrameStrata("BACKGROUND")
    end

    -- create icon if we haven't already
    if not self.notifyicon then
        self.notifyicon = self.frame:CreateTexture("BazookaPluginnotifyicon_" .. self.name, "ARTWORK")
    end

    -- create text if we haven't already
    if not self.notifytext then
        self.notifytext = self.frame:CreateFontString("BazookaPluginnotifytext_" .. self.name, "ARTWORK", "GameFontNormal")
        self.notifytext:SetWordWrap(false)
        self.notifytext:SetJustifyH('LEFT');
    end
    
    -- update icon to match what is currently shown for the real plugin
    if self.icon then
        if self.icon:IsShown() then
            self.notifyicon:ClearAllPoints()
            local iconSize = self.icon:GetWidth()
            self.notifyicon:SetWidth(iconSize)
            self.notifyicon:SetHeight(iconSize)
            self.notifyicon:SetPoint("LEFT", self.notifyframe, "LEFT", 0, 0)
            self.notifyicon:SetTexture( self.icon:GetTexture() )
            self.notifyicon:SetTexCoord( self.icon:GetTexCoord() )
            self.notifyicon:Show()
            self.notifyicon:SetAlpha(1.0)
        else
            self.notifyicon:Hide()
        end
    else
        self.notifyicon:Hide()
    end
    
    -- update text to match what is currently shown for the real plugin
    if self.text then
        if self.text:IsShown() then
            if self.text:GetLeft() and self.frame:GetLeft() then
                self.notifytext:SetPoint("LEFT", self.notifyframe, "LEFT", (self.text:GetLeft() - self.frame:GetLeft()), 0)
            end 
            self.notifytext:SetWidth( self.text:GetWidth() )
            self.notifytext:SetHeight( self.text:GetHeight() )
            self.notifytext:SetFont( self.text:GetFont() )
            self.notifytext:SetText( self.text:GetText() )
            self.notifytext:SetTextColor( self.text:GetTextColor() )
            self.notifytext:Show()
            self.notifytext:SetAlpha(1.0)
        else
            self.notifytext:Hide()
        end
    else
        self.notifytext:Hide()
    end

    -- move the notification itself to the same location/size as the real plugin
    self.notifyframe:SetParent(UIParent)
    self.notifyframe:ClearAllPoints()
    self.notifyframe:SetPoint( "TOPLEFT", self.frame, "TOPLEFT", 0, 0 )
    self.notifyframe:SetWidth( self.frame:GetWidth() )
    self.notifyframe:SetHeight( self.frame:GetHeight() )
    self.notifyframe:SetAlpha(1.0)

    -- set some timer stuff and show the plugin
    self.notifystart = GetTime()
    self.notifyinhibit = 1
    self.notifyframe:Show()
    
    -- link to the update notification to animate etc
    self.notifyframe:SetScript("OnUpdate", Bazooka_Notify_Animator)

end



