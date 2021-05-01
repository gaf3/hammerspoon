sizes = {1/4, 1/3, 1/2, 2/3, 3/4, 1}
spaces = {4, 3, 2, 3, 4, 1}
spots = {4, 3, 2, 2, 2, 1}

function find()

    local found = {}

    found.win = hs.window.focusedWindow()
    found.frame = found.win:frame()
    found.screen = found.win:screen()
    found.max = found.screen:frame()

    for size = 1, #sizes do
        if not found.w and found.frame.w <= sizes[size] * found.max.w then
            found.w = size
        end
        if not found.h and found.frame.h <= sizes[size] * found.max.h then
            found.h = size
        end
    end

    found.col = math.max(0, math.min(spots[found.w] - 1, math.floor((found.frame.x + 1 - found.max.x) / (found.max.w / spaces[found.w]))))
    found.row = math.max(0, math.min(spots[found.h] - 1, math.floor((found.frame.y + 1 - found.max.y) / (found.max.h / spaces[found.h]))))

    return found

end

function change(horiz, vert)

    local found = find()

    if (horiz == -1 and found.col == 0) or  (horiz == 1 and found.col == spots[found.w] - 1) then
        found.w = found.w > 1 and found.w - 1 or #sizes
        if found.col > 0 or horiz == 1 then
            found.col = spots[found.w] - 1
        end
    else
        found.col = found.col + horiz
    end

    if (vert == -1 and found.row == 0) or  (vert == 1 and found.row == spots[found.h] - 1) then
        found.h = found.h > 1 and found.h - 1 or #sizes
        if found.row > 0 or vert == 1 then
            found.row = spots[found.h] - 1
        end
    else
        found.row = found.row + vert
    end

    found.frame.x = found.max.x + (found.col * found.max.w / spaces[found.w])
    found.frame.y = found.max.y + (found.row * found.max.h / spaces[found.h])  

    found.frame.w = found.max.w * sizes[found.w]
    found.frame.h = found.max.h * sizes[found.h]

    found.win:setFrame(found.frame)

end

hs.hotkey.bind({"cmd", "alt"}, "Left", function()                                                              
    change(-1, 0)
end)
  
hs.hotkey.bind({"cmd", "alt"}, "Right", function()                                                              
    change(1, 0)
end)

hs.hotkey.bind({"cmd", "alt"}, "Up", function()                                                              
    change(0, -1)
end)
  
hs.hotkey.bind({"cmd", "alt"}, "Down", function()                                                              
    change(0, 1)
end)

hs.hotkey.bind({"alt", "ctrl"}, "Left", function()
    local app = hs.window.focusedWindow()
    app:moveOneScreenWest(app:screen())
end)

hs.hotkey.bind({"alt", "ctrl"}, "Right", function()
    local app = hs.window.focusedWindow()
    app:moveOneScreenEast(app:screen())
end)


hs.hotkey.bind({"cmd", "alt", "ctrl"}, "R", function()
    hs.reload()
end)

hs.alert.show("Config loaded")