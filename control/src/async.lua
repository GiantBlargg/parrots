--[[
Copyright (c) 2015-2017 Giantblargg

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--

local routines = {}
local listeners = {}

function runAsync (func)
  assert( type(func) == "function" )
  
  table.insert(routines, coroutine.create(func))
end

function addEventListener (event, listener)
  assert( type(event) == "string" )
  assert( type(listener) == "function" )
  
  if not listeners[event] then
    listeners[event] = {}
  end
  
  table.insert(listeners[event], listener)
end

function removeEventListener (event,listener)
  assert( type(event) == "string" )
  assert( type(listener) == "function" )
  
  for key, listen in pairs(listeners[event]) do
    if listen == listener then
      table.remove(listeners[event], key)
      return true
    end
    return false
  end
end

function init(func)
  if func then
    runAsync(func)
  end
  
  local eventData={}
  local filters={}
  local remove={}
  
  while true do 
    for key,r in pairs(routines) do
      if filters[r] == nil or filters[r] == eventData[1] or eventData[1] == "terminate" then
        local ok, param = coroutine.resume( r, unpack(eventData))
        if not ok then
          error(param)
        else
          filters[r] = param
        end
      end
      if coroutine.status(r) == "dead" then
        table.insert(remove,key)
        filters[r]=nil
      end
    end
    
    for key,i in pairs(remove) do
      table.remove(routines,i)
    end
    
    eventData = {os.pullEventRaw()}
    if listeners[eventData[1]] then
      for key, listener in pairs(listeners[eventData[1]]) do
        runAsync(listener)
      end
    end
  end
end