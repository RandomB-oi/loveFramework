local module = {}

function module.IndexToGrid(i, w)
    local y = math.floor((i-1)/w)
    local x = i - y*w
    
    return x,y+1
end

function module.GridToIndex(x,y, w)
    return (y-1)*w+x
end

function module.GetRowCount(count, width)
    return math.ceil(count/width)
end

function module.GetAspectRatio(count, width)
    local rowCount = module.GetRowCount(count, width)
    return width/rowCount
end

return module