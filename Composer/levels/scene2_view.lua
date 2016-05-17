-- Generated by Level Director X v1.0.0 on Wed Jul 29 09:35:24 2015 --
require("lib.LD_HelperX")
local M = {}
-----------------------------------
function M:loadAssets()
-----------------------------------
	local assets = {}
	assets.spriteSheetData = {}
	return assets
end -- loadAssets 

------------------------------------------
function M:createLevel(LD_Helper_Instance)
------------------------------------------
	local instance = LD_Helper_Instance
	local objProps = {}
	local level = {}
    local obj = nil
	if (application.LevelDirectorSettings.viewGroup == nil) then
		level.view = display.newGroup() 
	else
		level.view = application.LevelDirectorSettings.viewGroup
	end
	level.view.anchorChildren =false 
	display.setDefault( 'background',  130 / 255, 130 / 255, 130 / 255, 255 / 255)
	display.setDefault( "anchorX", 0.5 )
	display.setDefault( "anchorY", 0.5 )	
	display.setDrawMode("wireframe",false)
	level.name = 'scene2_view' 
	-- Load Assets
	level.assets = self:loadAssets()
	-- Physics properties
	physics.setGravity(0,9.8) 
	physics.setDrawMode('normal')
	physics.setPositionIterations(8)	
	physics.setVelocityIterations(3)	
	level.parallaxEnabled = false
	-- Layers --
	level.layers = {} 
	---- main ------------------------------------------------------------------------------------
	level.layers['main'] = {} 
	level.layers['main'].view = display.newGroup() 
	level.layers['main'].name = 'main' 
	if (level.parallaxEnabled) then
		level.layers['main'].speed = {x = 0, y = 0}
		level.layers['main'].repeated = false
		level.layers['main'].cullingMethod = 0
	else
		level.layers['main'].cullingMethod = 0 
	end
	level.layers['main'].objects = {} 
	objProps = 
	{
		name 	= 'btnBack', 
		objType = 'LDButton',
		class = '',
		width	= 384,
		height	= 128,
		x		= 320,
		y		= 288,
		xScale		= 1 * 1,
		yScale		= 1 * 1,
		assetName	= '',
		textProps	= {text = 'Back', font = 'Arial',size = 32, embossed = false,embossHighlightColorR = 0 / 255,embossHighlightColorG = 0 / 255,embossHighlightColorB = 0 / 255, embossHighlightColorA = 0 / 255,embossShadowColorR = 0 / 255,embossShadowColorG = 0 / 255,embossShadowColorB = 0 / 255, embossShadowColorA = 0 / 255},
		styleProps	= {radius = 192, cornerRadius = 0,strokeWidth = 1, strokeColorR = 255 / 255,strokeColorG = 255 / 255,strokeColorB = 255 / 255, strokeColorA = 255 / 255, fillColorR = 170 / 255, fillColorG = 0 / 255, fillColorB = 0 / 255, fillColorA = 255 / 255},
		fillProps = {fillType = 0, fillAssetName = '', fillFrame = 0 },
		gradientProps = {direction = 0, fillColorR = 170 / 255,fillColorG = 0 / 255,fillColorB = 0 / 255, fillColorA = 255 / 255},
		btnProps = {textColorR = 255 / 255,textColorG = 255 / 255,textColorB = 255 / 255, textColorA = 255 / 255,fillType = 0, fillAssetName = '', fillFrame = 0,styleProps	= {cornerRadius = 0,strokeWidth = 1, strokeColorR = 255 / 255,strokeColorG = 255 / 255,strokeColorB = 255 / 255, strokeColorA = 255 / 255, fillColorR = 170 / 255, fillColorG = 0 / 255, fillColorB = 0 / 255, fillColorA = 255 / 255}},
		}
	obj = instance:createObject(level.layers['main'],objProps, level.assets) 
	objProps = 
	{
		name 	= 'text_2', 
		objType = 'LDText',
		class = '',
		width	= 186,
		height	= 58,
		x		= 224,
		y		= 96,
		xScale		= 1 * 1,
		yScale		= 1 * 1,
		rotation	= 0,
		enableDrag	= false, 
		anchorX = 0,
		anchorY = 0,
		alpha = 1,
		isVisible = true,
		blendMode = 'normal',
		assetName	= '',
		textProps	= {text = 'Scene 2', font = 'Arial',size = 42, embossed = false,embossHighlightColorR = 255 / 255,embossHighlightColorG = 255 / 255,embossHighlightColorB = 255 / 255, embossHighlightColorA = 255 / 255,embossShadowColorR = 255 / 255,embossShadowColorG = 255 / 255,embossShadowColorB = 255 / 255, embossShadowColorA = 255 / 255},
		styleProps	= {radius = 93, cornerRadius = 0,strokeWidth = 1, strokeColorR = 255 / 255,strokeColorG = 255 / 255,strokeColorB = 255 / 255, strokeColorA = 255 / 255, fillColorR = 0 / 255, fillColorG = 0 / 255, fillColorB = 0 / 255, fillColorA = 0 / 255},
		fillProps = {fillType = 0, fillAssetName = '', fillFrame = 0 },
		gradientProps = {direction = 0, fillColorR = 0 / 255,fillColorG = 0 / 255,fillColorB = 0 / 255, fillColorA = 0 / 255},
		}
	obj = instance:createObject(level.layers['main'],objProps, level.assets) 
	instance:insertLayer(level,level.layers['main'])
	---- hud ------------------------------------------------------------------------------------
	level.layers['hud'] = {} 
	level.layers['hud'].view = display.newGroup() 
	level.layers['hud'].name = 'hud' 
	if (level.parallaxEnabled) then
		level.layers['hud'].speed = {x = 0, y = 0}
		level.layers['hud'].repeated = false
		level.layers['hud'].cullingMethod = 0
	else
		level.layers['hud'].cullingMethod = 0 
	end
	level.layers['hud'].objects = {} 
	objProps = 
	{
		name 	= 'text_1', 
		objType = 'LDText',
		class = '',
		width	= 552,
		height	= 38,
		x		= 10,
		y		= 928,
		xScale		= 1 * 1,
		yScale		= 1 * 1,
		rotation	= 0,
		enableDrag	= false, 
		anchorX = 0,
		anchorY = 0,
		alpha = 1,
		isVisible = true,
		blendMode = 'normal',
		assetName	= '',
		textProps	= {text = 'Level Director X - Composer Example', font = 'Arial Black',size = 24, embossed = false,embossHighlightColorR = 255 / 255,embossHighlightColorG = 255 / 255,embossHighlightColorB = 255 / 255, embossHighlightColorA = 255 / 255,embossShadowColorR = 255 / 255,embossShadowColorG = 255 / 255,embossShadowColorB = 255 / 255, embossShadowColorA = 255 / 255},
		styleProps	= {radius = 276, cornerRadius = 0,strokeWidth = 1, strokeColorR = 255 / 255,strokeColorG = 255 / 255,strokeColorB = 255 / 255, strokeColorA = 255 / 255, fillColorR = 0 / 255, fillColorG = 0 / 255, fillColorB = 0 / 255, fillColorA = 0 / 255},
		fillProps = {fillType = 0, fillAssetName = '', fillFrame = 0 },
		gradientProps = {direction = 0, fillColorR = 0 / 255,fillColorG = 0 / 255,fillColorB = 0 / 255, fillColorA = 0 / 255},
		}
	obj = instance:createObject(level.layers['hud'],objProps, level.assets) 
	instance:insertLayer(level,level.layers['hud'])
	--level.ldVersion = 1.0.0	-- Level Director Version
	-- Parallax (after layers)
	level.canvasWidth = 640
	level.canvasHeight = 960
	if level.parallaxEnabled then
		level.parallaxInfinite = false
		level.parallaxDamping = 1
		instance:createParallax(level)
	end
	return level
end -- createLevel
return M

