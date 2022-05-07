Theme.Name = "Flandre"
Theme.Description = "Touhou standby screen therme with Flandre Scarlet."

function Theme:Init()
    self.Material = Material( "flan/flanderka" )

    self.BackgroundColor = Vector( CreateClientConVar( "flandre_color", "0.2 0.2 0.2", true, false, " - Background color." ):GetString() ):ToColor()
    cvars.AddChangeCallback("flandre_color", function( name, old, new )
        self:Init()
    end, self.Name)

    self.Size = ScreenScale( CreateClientConVar( "flandre_size", "90", true, false, "Flandre size ( 16 - 265 )", 16, 265 ):GetInt() )
    cvars.AddChangeCallback("flandre_size", function( name, old, new )
        self:Init()
    end, self.Name)

    local w, h = standby_screen.GetResolution()
    self.x = (w - self.Size) / 2
    self.y = (h - self.Size) / 2
end

do

    local surface_DrawTexturedRect = surface.DrawTexturedRect
    local surface_SetDrawColor = surface.SetDrawColor
    local surface_SetMaterial = surface.SetMaterial
    local surface_DrawRect = surface.DrawRect

    local white = Color( 255, 255, 255 )

    function Theme:Paint( w, h )
        surface_SetDrawColor( self.BackgroundColor )
        surface_DrawRect( 0, 0, w, h )

        surface_SetDrawColor( white )
        surface_SetMaterial( self.Material )
        surface_DrawTexturedRect( self.x, self.y, self.Size, self.Size )
    end

end