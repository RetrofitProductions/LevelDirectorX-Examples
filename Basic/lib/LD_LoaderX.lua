------------------------------------
-- Level Director X - LD_Loader v1.0
------------------------------------
-- Copyright: 2015 Retrofit Productions

-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

--module(..., package.seeall)
require "config"

require("lib.LD_HelperX")

LD_Loader = {}
LD_Loader_mt =  {__index = LD_Loader}

-------------------------------------------------
function LD_Loader:new(viewGroup)
-------------------------------------------------
	local self = {}
	
	setmetatable(self, LD_Loader_mt )
	
	self.levelsFolder = ''
	self.level = {}
	
	self.LD_Helper = LD_Helper:init(viewGroup)
	
	-- check if there is a folder in the config file for levels
	if (application.LevelDirectorSettings.levelsSubFolder ~= nil) then
		self.levelsFolder = application.LevelDirectorSettings.levelsSubFolder
		self.levelsFolder = self.levelsFolder .. "."
	end

	-- check if there is a folder in the config file for images
	if (application.LevelDirectorSettings.imagesSubFolder ~= nil) then
		self.LD_Helper.imgSubFolder = application.LevelDirectorSettings.imagesSubFolder
		self.LD_Helper.imgSubFolder = self.LD_Helper.imgSubFolder .. "/"
	end
	-- return instance
	return self
	
end -- loadLevel

-------------------------------------------------
function LD_Loader:loadLevel(levelName)
-------------------------------------------------
	-- load the level
	self.LD_Helper.levelName = levelName
	-- load and create level instance
	self.level = require(self.levelsFolder .. levelName):createLevel(self.LD_Helper)
	
	--unload required level module as now stored in 'level'
	package.loaded[self.levelsFolder .. levelName] = nil
    _G[self.levelsFolder .. levelName] = nil	
	
end -- loadLevel

----------------------------------------------------
function LD_Loader:addObject(layerName, obj)
----------------------------------------------------
	-- add a preexisting display object to the level/layer 
	return self.LD_Helper:addObject(self.level.layers[layerName], obj)
end -- addObject

----------------------------------------------------
function LD_Loader:createObject(layerName, objProps)
----------------------------------------------------
	-- create a new LD object
	return self.LD_Helper:createObject(self.level.layers[layerName], objProps,self.level.assets)
end -- createObject

--------------------------------------------------------
function LD_Loader:getLayer(layerName)
--------------------------------------------------------
	-- obtain reference to a LD layer object
	local layer = self.level.layers[layerName]
	
	return layer

end -- getLayer

---------------------------------------------
function LD_Loader:getObject(objectName)
---------------------------------------------
	-- obtain reference to a LD object - searches all layers

	local obj = nil
	for i = 1, (#self.level.layers) do
		for k, v in pairs (self.level.layers[i].objects) do
			if objectName == v.name then
				obj = v
				break
			end
		end
	end
	return obj
end -- getObject

--------------------------------------------------------
function LD_Loader:getLayerObject(layerName,objectName)
--------------------------------------------------------
	-- obtain reference to a LD object on a certain layer
	
	local obj = nil
	for k, v in pairs (self.level.layers[layerName].objects) do
		if objectName == v.name then
			obj = v
			break
		end
	end
	
	return obj

end -- getLayerObject

--------------------------------------------------------
function LD_Loader:setLayerVisible(layerName,isVisible)
--------------------------------------------------------
	-- hide/show a layer
	for k, v in pairs (self.level.layers[layerName].objects) do
		v.view.isVisible = isVisible
	end
	
end -- setLayerVisible

------------------------------------
function LD_Loader:initLevel()
------------------------------------
	-- check for any objects set to follow a path with autostart
	local obj
	for i = 1, (#self.level.layers) do
		--print ("init:" , self.level.layers[i].name)
		for idx, obj in pairs (self.level.layers[i].objects) do
			if (obj.followPathProps) then
				if (obj.followPathProps.path ~= '' and obj.followPathProps.autoStart) then
					local path = self:getObject(obj.followPathProps.path)
					local srcObj = self:getObject(obj.followPathProps.srcObj)
					if (path and srcObj) then
						print (obj.name, path.name, srcObj.name)
						srcObj:followPath(path, obj.followPathProps)
					end
				end
			end
		end
	end
end --initLevel

----------------------------------------------------------
function LD_Loader:objectsWithClass(className)
----------------------------------------------------------
	-- obtain a table of objects that match the class name 
	local objects = {}
	for i = 1, (#self.level.layers) do
		for k, v in pairs (self.level.layers[i].objects) do
			if className == v.class then
				objects[#objects+1] = v
			end
		end
	end
	return objects
end -- objectsWithClass

-----------------------------------------------------------------------------
function LD_Loader:layerObjectsWithClass(layerName, className)
----------------------------------------------------------------------------- 
	-- obtain a table of objects that match the class name on the given layer 
	local layerObjects = {}
	for k, v in pairs (self.level.layers[layerName].objects) do
		if className == v.class then
			layerObjects[#layerObjects+1] = v
  		end
	end
	return layerObjects
end -- layerObjectsWithClass

-------------------------------------------------------------------
function LD_Loader:layerObjects(layerName)
-------------------------------------------------------------------
	-- obtain a table of objects for a given layer 
	local layerObjects = {}
	for k, v in pairs (self.level.layers[layerName].objects) do
		layerObjects[#layerObjects+1] = v
	end
	return layerObjects
end -- layerObjects

-------------------------------------------------------------------
function LD_Loader:getAllObjects()
-------------------------------------------------------------------
	-- obtain a table of all objects 
	local layerObjects = {}
	
	for i = 1, (#self.level.layers) do
		for k, v in pairs (self.level.layers[i].objects) do
			layerObjects[#layerObjects+1] = v
		end
	end
	
	return layerObjects
end -- getAllObjects

-------------------------------------------------------------------
function LD_Loader:removeLayerObject(layerName,objectName)
-------------------------------------------------------------------
	-- remove an object for a given layer and object name 
	for k, v in pairs (self.level.layers[layerName].objects) do
		if objectName == v.name then
			table.remove(self.level.layers[layerName].objects,k)
			v:delete()
			v = nil
			break
		end
	end
end -- removeLayerObject

-------------------------------------------------------------------
function LD_Loader:removeObject(object)
-------------------------------------------------------------------
	-- remove an object from LD 
	self:removeLayerObject(object.layerName, object.name)
end -- removeObject

-------------------------------------------------------------------
function LD_Loader:removeLayerObjectsWithClass(layerName,className)
-------------------------------------------------------------------
	-- remove all objects from a layer for a given class name
	for k, v in pairs (self.level.layers[layerName].objects) do
		if className == v.class then
			table.remove(self.level.layers[layerName].objects,k)
			v:delete()
			v = nil
			--self.level.layers[layerName].objects[k] = nil
		end
	end
end -- removeLayerObjectsWithClass

----------------------------------------------------
function LD_Loader:removeObjectsWithClass(className)
----------------------------------------------------
	-- remove all objects for a given class name
	for i = 1, (#self.level.layers) do
		for k, v in pairs (self.level.layers[i].objects) do
			if className == v.class then
				table.remove(self.level.layers[i].objects,k)
				v:delete()
				v = nil
				--self.level.layers[i].objects[k] = nil
			end
		end
	end
end -- removeObjectsWithClass

--------------------------------------------------------------------
function LD_Loader:addEventListenerToAllObjects(eventName, listener)
--------------------------------------------------------------------
	--must be done before load level
	self.LD_Helper.eventHandlers[eventName] = listener
end -- addEventListenerToAllObjects

-----------------------------------------------------------
function LD_Loader:cullingEngine()
-----------------------------------------------------------
	-- work in progress
	
	local obj = nil
	for i = 1, (#self.level.layers) do
		for k, v in pairs (self.level.layers[i].objects) do
			if objectName == v.name then
				obj = v
				break
			end
		end
	end
	return obj

end -- cullingEngine

---------------------------------------------------------
function LD_Loader:move(dx, dy)
---------------------------------------------------------
	-- Move camera by delta x and y
	-- All layers are moved according to their parallax speeds
	if (self.level.parallaxEnabled == false) then 
		print ("Warning: Parallax not enabled")
	else
		self.level:move(dx, dy)
	end 
end -- move 

-----------------------------------------------------------------
function LD_Loader:moveCamera(x, y)
-----------------------------------------------------------------
	-- Move current camera position to a specifc x and y position 
	self.level:moveCamera(x, y)
end -- moveCamera

-----------------------------------------------------------------
function LD_Loader:getCameraPos()
-----------------------------------------------------------------
	-- return the current camera position in a table of x and Y 
	return self.level:getCameraPos()
end -- getCameraPos

-----------------------------------------------------------------
function LD_Loader:trackEnabled(enabled)
-----------------------------------------------------------------
	-- set if tracking is enabled
	self.level:trackEnabled(enabled)
end -- trackEnabled

-----------------------------------------------------------------
function LD_Loader:setCameraFocus(obj, trackX, trackY)
-----------------------------------------------------------------
	-- set tracking object and tracking axis
	self.level:setCameraFocus(obj, trackX, trackY)
end -- setCameraFocus

----------------------------------------------------------------------------------------
function LD_Loader:slideCameraToPosition(x, y, slideTime, easingType, onCompleteHandler)
----------------------------------------------------------------------------------------
	-- slide camera to specified x,y position using an easing type
	self.level:slideCameraToPosition(x, y, slideTime, easingType, onCompleteHandler)
end

---------------------------------------------------------
function LD_Loader:removeLevel(retainSpriteSheetTextures)
---------------------------------------------------------
	-- remove the main display group
	for i = 1, (#self.level.layers) do
		-- removed objects in layer
		for k2 = #self.level.layers[i].objects, 1, -1 do
			o = self.level.layers[i].objects[k2]
			--print (self.level.layers[i].name,o.name)
			table.remove(self.level.layers[i].objects,k2)
			o:delete()
			o = nil
		end
		
		-- remove layer
		self.level.layers[i].objects = nil
		self.level.layers[i].view:removeSelf()
		self.level.layers[i] = nil
	end
	self.level.layers = nil
	display.remove(self.view)
	
	self.level.assets.spriteSheetData = nil
	self.level.assets = nil
	
	self.LD_Helper:cleanUp(retainSpriteSheetTextures)
	self.level = nil
	self = nil
	
end -- removeLevel

----------------------------
function LD_Loader:cleanUp()
----------------------------
	-- remove all references 
	if (self.level) then
		self.level:removeLevel()
	end
	
	self.LD_Helper = nil
end -- cleanUp

--return LD_Loader
