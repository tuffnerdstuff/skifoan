-- Load some default values for our rectangle.
function love.load()
	
	love.window.setMode(1280,720)
	
    g_back = love.graphics.newImage( "gfx/back.png" )
	g_top = love.graphics.newImage( "gfx/eye_top.png" )
	g_bottom = love.graphics.newImage( "gfx/eye_bottom.png" )
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)

end
 
-- Draw a coloured rectangle.
function love.draw()
    love.graphics.draw(g_back,0,0)
	
	local mouseX, mouseY = love.mouse.getPosition()
	drawLid(g_bottom,mouseX,mouseY,1.0,false)
	drawLid(g_top,mouseX,mouseY,1.0,true)
end

function drawLid(gfx, mouseX, mouseY, open, isTop)
	yOffset = 250 * open
	if isTop then yOffset = yOffset * -1 end
	lidX = mouseX - gfx:getWidth() / 2
	lidY = mouseY - gfx:getHeight() / 2
	love.graphics.draw(gfx,lidX,lidY + yOffset)
end