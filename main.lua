-- Load some default values for our rectangle.
function love.load()
	WIDTH = 1280
	HEIGHT = 720
	lookX = WIDTH/2
	lookY = HEIGHT/2
	handX = WIDTH
	handY = HEIGHT
	mouseX = lookX
	mouseY = lookY

	love.window.setMode(WIDTH,HEIGHT)
	
    g_back = love.graphics.newImage( "gfx/back.png" )
	g_top = love.graphics.newImage( "gfx/eye_top.png" )
	g_bottom = love.graphics.newImage( "gfx/eye_bottom.png" )
	g_hand = love.graphics.newImage( "gfx/hand.png" )
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)

	mouseX, mouseY = love.mouse.getPosition()

	lookX, lookY = getNextPositionTowards(mouseX, mouseY, lookX, lookY, 0.05)
	handX, handY = getNextPositionTowards(mouseX+getRandomOffset(50), mouseY+getRandomOffset(50), handX, handY, 0.02)
end
 
-- Draw a coloured rectangle.
function love.draw()
	love.graphics.setColor(255,255,255)
	
	-- Draw background
    love.graphics.draw(g_back,0,0)
	-- Draw hand
	love.graphics.draw(g_hand,handX,handY)
	-- Draw eye-lids 
	local bottomX, bottomY = drawLid(g_bottom,lookX,lookY,1.0,false)
	local topX, topY = drawLid(g_top,lookX,lookY,1.0,true)
	
	-- Draw bars to cover rest of background
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,WIDTH,topY)
	love.graphics.rectangle("fill",0,0,topX,HEIGHT)
	love.graphics.rectangle("fill",topX+g_top:getWidth(),0,WIDTH-topX+g_top:getWidth(),HEIGHT)
	love.graphics.rectangle("fill",0,(bottomY+g_bottom:getHeight()),WIDTH,HEIGHT - (bottomY+g_bottom:getHeight()))
	
	love.graphics.setColor(255,0,0)
	love.graphics.print(lookX .. "," .. lookY,0,0)
	
end

function drawLid(gfx, mouseX, mouseY, open, isTop)
	yOffset = 250 * open
	if isTop then yOffset = yOffset * -1 end
	lidX = mouseX - gfx:getWidth() / 2
	lidY = (mouseY - gfx:getHeight() / 2) + yOffset
	love.graphics.draw(gfx,lidX,lidY)
	return lidX, lidY
end

function getRandomOffset(spread)
	return love.math.random(spread*2)-spread
end

function getNextPositionTowards(targetX, targetY, currentX, currentY, easing)
	dX = targetX - currentX
	dY = targetY - currentY
	d = math.sqrt((dX * dX) + (dY * dY))
	return currentX + (dX * easing), currentY + (dY * easing)

	
end