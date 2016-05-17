-----------------------------------------------------------------------------------------
-- Level Director X -Perspective Example
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local perspective = require("lib.perspective")
require("lib.LD_LoaderX")
physics = require ("physics")
physics.start()


local myLevel = {}
local dx = 0
local dy = 0
local btnLeft = nil
local btnRight = nil
local btnUp = nil
local player = nil
local coords = nil 
local isActive = false
local camera = nil
local btnPressed = false
local scoreTxt = nil
local score = 0

local SPEED_X = 90
local SPEED_Y = 180
--also try these instead
--local SPEED_X = 150
--local SPEED_Y = 250

display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "nearest" )


------------------------------------
local function gameLoop()
------------------------------------
	
	scoreTxt.text = string.format("%d", score)

	-- if no buttons pressed then slow player down to a stop.
	local vx,vy = player:getLinearVelocity()
	
	if (not btnPressed) then
		if (vx < 0.1) then
			vx = vx * -0.5
		elseif (vx > 0.1) then
			vx = vx * 0.5
		else
			vx = 0
		end
	else
		vx= dx
	end
	player:setLinearVelocity(vx,vy)

end

------------------------------------
local function upPressed(event)
------------------------------------
	if (isActive) then
		btnPressed = true
		
		local vx,vy = player:getLinearVelocity()
		dx = vx
		dy = -SPEED_Y
		player:setLinearVelocity(vx,dy)
		
	end
end

------------------------------------
local function btnReleased(event)
------------------------------------
	player:setSequence("up")
	player:play()

	btnPressed = false
	
end

------------------------------------
local function leftPressed(event)
------------------------------------
	if (isActive) then
		player:setSequence("left")
		player:play()

		btnPressed = true
		
		dx = -SPEED_X
	end
end

------------------------------------
local function rightPressed(event)
------------------------------------
	if (isActive) then
		player:setSequence("right")
		player:play()

		btnPressed = true
		
		dx = SPEED_X
	end
end

---------------------------------------------------------------------------------
local function realPlayerCollision(self, event )
---------------------------------------------------------------------------------
	-- see if object we collided with has a class (defined in LD)
	local collisionClass = event.other.class
	
	if (string.len(collisionClass) > 0 ) then
		print ('collision ' .. event.phase .. ' with object class',collisionClass,event.other.name)
	end
	
	if ( event.phase == "began" ) then	
		-- if we collided with a star then remove it
		if (collisionClass == 'Star') then
			myLevel:removeLayerObject("FG",event.other.name)
			-- add to score ...
			score = score + 100
		end
	end
end

---------------------------------------------------------------------------------
local function onCollision(self, event )
---------------------------------------------------------------------------------
	-- to avoid collision issues in corona we delay a frame then call the real collision function
	timer.performWithDelay(1, function() return realPlayerCollision( self, event) end )
end

------------------------------------
local function removeLevel(ldxLevel)
------------------------------------
	-- To destroy and cleanup then something like this is required
	camera:cancel()
	Runtime:removeEventListener( "enterFrame", gameLoop )
	ldxLevel:removeLevel()
	camera:destroy()
end 

----------------------------------------
local function initPerspective(ldxLevel)
----------------------------------------
	camera = perspective.createView(#ldxLevel.level.layers)
	
	local l = 1
	local speed = {}
	for i = #ldxLevel.level.layers,1,-1 do
		print (i,l, ldxLevel.level.layers[i].name,ldxLevel.level.layers[i].speed.x,ldxLevel.level.layers[i].speed.y)
		speed[l]={ldxLevel.level.layers[i].speed.x,	ldxLevel.level.layers[i].speed.y}
		camera:add(ldxLevel.level.layers[i].view, l)
		l=l+1
	end	
	camera:setParallax(unpack(speed)) -- Here we set parallax for each layer in descending order
end

-- load level
myLevel= LD_Loader:new()
myLevel:loadLevel("Level01") --replace with your level name here

-- Get local player object from level
player = myLevel:getLayerObject("Player","player").view
-- store player pos
player.tx = player.x
player.ty = player.y

player.collision = onCollision
player:addEventListener('collision', player )


-- local copy of text obj to show score
scoreTxt = myLevel:getLayerObject("Controls","score").view

-- Get local button objects and setup events
btnLeft = myLevel:getLayerObject("Controls","btnLeft")
btnRight = myLevel:getLayerObject("Controls","btnRight")
btnUp = myLevel:getLayerObject("Controls","btnUp")

btnLeft.onPress = leftPressed
btnRight.onPress = rightPressed
btnUp.onPress = upPressed

btnLeft.onRelease = btnReleased
btnRight.onRelease = btnReleased

btnLeft.onCancel = btnReleased
btnRight.onCancel = btnReleased
btnUp.onCancel = btnReleased

--initialise Perspective library with layers from Level Director
initPerspective(myLevel)

camera.damping = 30 -- less is more rigid
camera:setFocus(player) -- Set the focus to the player
camera:track() -- Begin auto-tracking
Runtime:addEventListener( "enterFrame", gameLoop )

isActive =true 

