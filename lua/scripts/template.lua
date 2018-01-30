-- template
-- a very basic example


-- specify dsp engine to load:
engine = 'TestSine'

-- init function
init = function(commands, count)
    -- print to command line
    print("template!")
    -- add log message
    norns.log.post("loaded template")
    -- show engine commands available
    print("commands: ")
    for i,v in pairs(commands) do
        print(i, v.fmt)
    end
    -- set engine params
    e.hz(100)
    e.amp(0.125)
    -- start timer
    c:start()
    -- clear grid, if it exists
    if g then 
        g:all(1) 
        g:refresh()
    end 
    -- screen: turn on anti-alias
    s.aa(1)
    s.line_width(1.0) 
end

-- make a variable
t = 0
-- make an array for storing
numbers = {0,0,0,0,0,0,0}
-- make a var, led brightness for grid
level = 5

-- encoder function
enc = function(n, delta)
    numbers[n] = numbers[n] + delta
    -- redraw screen
    redraw()
end

-- key function
key = function(n, z)
    numbers[n+3] = z
    -- redraw screen
    redraw()
end

-- screen redraw function
redraw = function()
    -- clear screen
    s.clear()
    -- set pixel brightness (0-15)
    s.level(15)

    for i=1,6 do
        -- move cursor
	    s.move(0,i*8-1)
        -- draw text
        s.text("> "..numbers[i])
    end 

    -- show timer
    s.move(0,63)
    s.text("> "..t)

    -- draw a line
    s.move(math.random()*64+64,math.random()*64)
    s.line(math.random()*64+64,math.random()*64)
    s.stroke() 

    s.move(63,8)
    s.text_center("hello there")

    s.move(numbers[2],numbers[3])
    s.line(40,numbers[1])
    s.close()
    s.level(3)
    s.fill()

    s.level(15)
    s.arc(32,32,numbers[2],0,numbers[3]*0.1)
    s.stroke()

    s.rect(numbers[2],numbers[3],10,10)
    s.level(numbers[1])
    s.stroke() 
end



-- set up a metro
c = metro[1]
-- count forever
c.count = -1
-- count interval to 1 second
c.time = 1
-- callback function on each count
c.callback = function(stage)
    t = t + 1
    redraw()
end

-- grid key function
gridkey = function(x, y, state)
   if state > 0 then 
      -- turn on led
      g:led(x, y, level)
   else
      -- turn off led
      g:led(x, y, 0)
   end
   -- refresh grid leds
   g:refresh()
end 

-- called on script quit, release memory
cleanup = function()
    numbers = nil
end
