-- Mining program v1 --

-- Eric Lacker --

--  Orientation (start location = 0,0,0)
local currX = 0
local currY = 0
local currZ = 0
local width = 15

-- Variables --

IgnoredItems = {"minecraft:stone", "minecraft:cobblestone", "minecraft:gravel",
"minecraft:dirt", "minecraft:water", "minecraft:red_mushroom", "minecraft:sand",
"minecraft:netherrack", "Botania:stone", "Botania:mushroom", "chisel:limestone",
"chisel:andesite", "chisel:diorite", "chisel:granite", "chisel:marble",
"BiomesOPlenty:flowers", "BiomesOPlenty:flowers2"}

-- Functions --

function DoKeep(item)
    for name in IgnoredItems
    do
        if name == item then
            return false
        end
    end
    return true
end

