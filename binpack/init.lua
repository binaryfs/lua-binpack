--- Simple 2D bin packing implementation for Lua.
--
-- Packs different-sized rectangles into a rectangular container. This implementation
-- solves the online bin packing problem where rectangles are inserted one at a time
-- in random order.
--
-- @module binpack
-- @author Fabian Staacke
-- @copyright 2019
-- @license https://opensource.org/licenses/MIT

local BASE = (...):gsub("%.init$", "")
local Container = require(BASE .. ".Container")
local Queue = require(BASE .. ".Queue")
local cells = require(BASE .. ".cells")

local binpack = {
  _NAME = "lua-binpack",
  _DESCRIPTION = "Simple 2D bin packing implementation for Lua",
  _VERSION = "1.1.0",
  _URL = "https://github.com/binaryfs/lua-binpack",
  _LICENSE = "MIT License",
  _COPYRIGHT = "Copyright (c) 2019 Fabian Staacke"
}

--- Create a new bin packing container.
--
-- @tparam number width The width of the container
-- @tparam number height The height of the container
-- @tparam[opt=0] number padding The amount of padding inside each container cell (defaults to 0)
-- @tparam[opt="dynamic"] string mode Determines if the container's size is dynamic or static.
--   A dynamically sized container will grow if a rectangle does not fit into it.
--   Pass "static" as the value to create a static-sized container (defaults to "dynamic").
--
-- @treturn binpack.Container
--
-- @raise Invalid value for mode
--
-- @usage
-- local container = binpack.newContainer(256, 256)
-- local staticContainer = binpack.newContainer(32, 32, 0, "static")
function binpack.newContainer(width, height, padding, mode)
  mode = mode or "dynamic"
  if mode ~= "static" and mode ~= "dynamic" then
    error('Value of mode expected to be "static" or "dynamic", got: ' .. tostring(mode))
  end
  return setmetatable({
    _padding = padding or 0,
    _canGrow = canGrow ~= false,
    _hasGrown = false,
    _root = cells.newCell(0, 0, width, height),
    _filledCells = {}
  }, Container)
end

--- Create a new bin packing queue.
--
-- @param[opt] orderFunc An optional order function to sort the enqueued rectangles.
--   The function takes two rectangles as arguments and must return true if the first
--   rectangle should come first in the sorted queue. If no function is specified, the
--   default order function of the Queue class is used.
--
-- @treturn binpack.Queue
--
-- @usage
-- local queue = binpack.newQueue(function(rect1, rect2)
--   return rect1.width > rect2.width
-- end)
function binpack.newQueue(orderFunc)
  return setmetatable({
    _orderFunction = orderFunc or Queue.defaultOrderFunction
  }, Queue)
end

return binpack