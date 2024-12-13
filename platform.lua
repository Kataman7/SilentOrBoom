function map_position(x, y)
    x = flr(x / 8)
    y = flr(y / 8)
    return { x = x, y = y }
end