-- Load some default values for our rectangle.
function love.load()
	WIDTH = 1280
	HEIGHT = 720
	love.window.setMode(WIDTH,HEIGHT)
	
    g_back = love.graphics.newImage( "gfx/back.png" )
	g_top = love.graphics.newImage( "gfx/eye_top.png" )
	g_bottom = love.graphics.newImage( "gfx/eye_bottom.png" )
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)

end
 
-- Draw a coloured rectangle.
function love.draw()
	love.graphics.setColor(255,255,255)
    love.graphics.draw(g_back,0,0)
	
	local mouseX, mouseY = love.mouse.getPosition()
	local bottomX, bottomY = drawLid(g_bottom,mouseX,mouseY,1.0,false)
	local topX, topY = drawLid(g_top,mouseX,mouseY,1.0,true)
	
	-- Draw bars to cover rest of background
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,WIDTH,topY)
	love.graphics.rectangle("fill",0,0,topX,HEIGHT)
	love.graphics.rectangle("fill",topX+g_top:getWidth(),0,WIDTH-topX+g_top:getWidth(),HEIGHT)
	love.graphics.rectangle("fill",0,(bottomY+g_bottom:getHeight()),WIDTH,HEIGHT - (bottomY+g_bottom:getHeight()))
	
end

function drawLid(gfx, mouseX, mouseY, open, isTop)
	yOffset = 250 * open
	if isTop then yOffset = yOffset * -1 end
	lidX = mouseX - gfx:getWidth() / 2
	lidY = (mouseY - gfx:getHeight() / 2) + yOffset
	love.graphics.draw(gfx,lidX,lidY)
	return lidX, lidY
end