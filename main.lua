-- Load some default values for our rectangle.
function love.load()
	WIDTH = 1280
	HEIGHT = 720
	BACK_SCALE = 2
	lookX = WIDTH/2
	lookY = HEIGHT/2
	handX = WIDTH
	handY = HEIGHT
	mouseX = lookX
	mouseY = lookY
	eyeOpen = 1.0
	eyeClosing = true

	love.window.setMode(WIDTH,HEIGHT)
	
    g_back = love.graphics.newImage( "gfx/back.png" )
	g_top = love.graphics.newImage( "gfx/eye_top.png" )
	g_bottom = love.graphics.newImage( "gfx/eye_bottom.png" )
	g_hand = love.graphics.newImage( "gfx/hand.png" )
	
	-- Shader
	myShader = love.graphics.newShader[[
		extern number fact;
		const float kernel[5] = float[](0.2270270270, 0.1945945946, 0.1216216216, 0.0540540541, 0.0162162162);
		vec4 effect(vec4 color, sampler2D tex, vec2 tex_coords, vec2 pos) {
			color = texture2D(tex, tex_coords) * kernel[0];
			for(int i = 1; i < 5; i++) {
				color += texture2D(tex, vec2(tex_coords.x + i * (fact*0.05), tex_coords.y +i* (fact*0.05))) * kernel[i];
				color += texture2D(tex, vec2(tex_coords.x - i * (fact*0.05), tex_coords.y -i* (fact*0.05))) * kernel[i];
			}
			return color;
		}
	]]
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)

	mouseX, mouseY = love.mouse.getPosition()

	lookX, lookY = getNextPositionTowards(mouseX, mouseY, lookX, lookY, 0.05)
	handX, handY = getNextPositionTowards(WIDTH/2+getRandomOffset(50), HEIGHT/2+getRandomOffset(50), handX, handY, 0.02)
	
	if (eyeClosing) then
		eyeOpen = eyeOpen - eyeOpen * 0.003
	else
		eyeOpen = eyeOpen + (1-eyeOpen) * 0.02
	end
	if eyeOpen > 0.9 and eyeClosing == false then 
		eyeOpen = 0.9
		eyeClosing = true
	elseif eyeOpen < 0.3 and eyeClosing then
		eyeOpen = 0.3
		eyeClosing = false
	end
end
 
-- Draw a coloured rectangle.
function love.draw()
	love.graphics.setColor(255,255,255)
	
	myShader:send("fact",eyeOpen)
	love.graphics.setShader(myShader)
	-- Draw background
    love.graphics.draw(g_back,lookX*(BACK_SCALE-1)*-1,lookY*(BACK_SCALE-1)*-1,0,BACK_SCALE,BACK_SCALE)
	-- Draw hand
	love.graphics.draw(g_hand,handX,handY)
	love.graphics.setShader()

	
	-- Draw eye-lids 
	local bottomX, bottomY = drawLid(g_bottom,WIDTH/2,HEIGHT/2,eyeOpen,false)
	local topX, topY = drawLid(g_top,WIDTH/2,HEIGHT/2,eyeOpen,true)
	
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
	return currentX + (dX * easing), currentY + (dY * easing)
	
end