local module = {}

-- Helper: returns the corners of a rotated rectangle
local function getRotatedCorners(center, size, rotation)
    local hw, hh = size.X / 2, size.Y / 2
    local cosR, sinR = math.cos(rotation), math.sin(rotation)

    local corners = {
        Vector.new(-hw, -hh),
        Vector.new(hw, -hh),
        Vector.new(hw, hh),
        Vector.new(-hw, hh)
    }

    for i, corner in ipairs(corners) do
        local rotated = Vector.new(
            corner.X * cosR - corner.Y * sinR,
            corner.X * sinR + corner.Y * cosR
        )
        corners[i] = center + rotated
    end

    return corners
end

-- Helper: projects a set of points onto an axis, returns min and max
local function projectPolygon(corners, axis)
    local min = corners[1]:Dot(axis)
    local max = min
    for i = 2, #corners do
        local proj = corners[i]:Dot(axis)
        if proj < min then min = proj end
        if proj > max then max = proj end
    end
    return min, max
end

local function getAxes(corners)
    return {
        (corners[2] - corners[1]):Normalized(),
        (corners[3] - corners[2]):Normalized()
    }
end

function areRectsColliding(rect1, rect2)
    local axes = {}
    for _, axis in ipairs(getAxes(rect1)) do table.insert(axes, axis) end
    for _, axis in ipairs(getAxes(rect2)) do table.insert(axes, axis) end

    for _, axis in ipairs(axes) do
        local min1, max1 = projectPolygon(rect1, axis)
        local min2, max2 = projectPolygon(rect2, axis)

        if max1 < min2 or max2 < min1 then
            return false -- Separating axis found
        end
    end

    return true -- No separating axis found => collision
end

function AABB(object1, object2)
    local diff = ((object1.RenderPosition + object1.RenderSize/2) - (object2.RenderPosition + object2.RenderSize/2))
    local total = object1.RenderSize + object2.RenderSize

    return math.abs(diff.X) < total.X and math.abs(diff.Y) < total.Y
end

module.getRotatedCorners = getRotatedCorners
module.areRectsColliding = areRectsColliding
module.projectPolygon = projectPolygon
module.AABB = AABB

return module