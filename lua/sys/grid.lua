--- Grid class
-- @module grid
-- @alias Grid

require 'norns'

---------------------------------
-- Grid device class

local Grid = {}
Grid.__index = Grid

--- constructor
-- @param id : arbitrary numeric identifier
-- @param serial : serial (string)
-- @param name : name (string
-- @param dev : opaque pointer to device (userdata)
function Grid.new(id, serial name, dev)
   local g = setmetatable({}, Grid)
   g.id = id
   g.serial = serial
   g.name = name
   g.dev = dev -- opaque pointer
   g.key = nil -- key event callback
   g.remove = nil -- device unplug callback
   return g
end

--- static callback when any grid device is added
-- user scripts can redefine
-- @param id : arbitrary numeric identifier
-- @param serial : serial (string)
-- @param name : name (string
-- @param dev : opaque pointer to device (userdata)
function Grid.add(id, serial, name, dev)
   print("Grid.add ", id, serial, name, dev)
end

--- static callback when any grid device is removed
-- user scripts can redefine
-- @param id : arbitrary numeric identifier
function Grid.remove(id)
   print("Grid.add ", id, serial, name, dev)
end

--- set state of single LED on this grid device
-- @param x : column index (zero-based)
-- @param y : row index (zero-based)
-- @param val : LED brightness in [0, 15]
function Grid:led(x, y, val)
   grid_set_led(self.dev, x, y, val)
end

--- update any dirty quads on this grid device
function Grid:refresh()
   grid_refresh(self.dev)
end

--- print a description of this grid device
function Grid:print()
   for k,v in pairs(self) do
      print('>> ', k,v)
   end
end

---------------------------------
-- monome device manager

norns.monome = {}

norns.monome.add = function(id, serial, name, dev)
   -- TODO: distinguish between grids and arcs
   -- for now, assume its a grid
   norns.grid.add(id,serial,name,dev)
end


norns.monome.remove = function(id)
   -- TODO: distinguish between grids and arcs
   -- for now, assume its a grid
   norns.grid.remove(id)
end

-- grid devices
norns.grid.add = function(id, serial, name, dev)
   local g = Grid:new(id,serial,name,dev)
   m:print()
   Grid.devices[id] = m
   if Grid.add ~= nil then Grid.add(g) end
end

norns.grid.remove = function(id)
   if Grid.remove ~= nil then Grid.remove(Grid.devices[id]) end
   Grid.devices[id] = nil
end

--- grid key input handler
norns.grid.key = function(id, x, y, val)
   local g = Grid.devices[id]
   if g ~= nil then
      if g.key ~= nil then
	 g.key(g, x, y, val)
      end
   else
      print('>> error: no entry for grid ' .. id)
   end
end

--- print description of all grids
norns.grid.print = function()
   for idx,g in Grid.devices do
	  g:print()
   end
end

return 
