-- Mining program v1 --
-- Eric Lacker --

-- Variables --

IgnoredItem = {"minecraft:stone", "minecraft:cobblestone", "minecraft:gravel",
"minecraft:dirt", "minecraft:water", "minecraft:red_mushroom", "minecraft:sand",
"minecraft:netherrack", "Botania:stone", "Botania:mushroom", "chisel:limestone",
"chisel:andesite", "chisel:diorite", "chisel:granite", "chisel:marble",
"BiomesOPlenty:flowers", "BiomesOPlenty:flowers2"}

-- short list, so this is a concise way of checking. Info doesn't
-- have to be burn time.
Consumable = {}
Consumable["minecraft:coal"] = 1600
Consumable["druidcraft:fiery_glass"] = 2400

local distanceTraveled = 0
local fuel = turtle.getFuelLevel()
local firstUsed = 2
local lastUsed = 4

-- Functions --

function KeepItem(name)
    for _, item in ipairs(IgnoredItem)
    do
        if name == item then
            print("Keeping ", name)
            return false
        end
        print("Not Keeping ", name)
    end
    return true
end

function DigForward()
    -- check if Lava, if so grab and refuel --
    if turtle.detect() then
        turtle.dig()
    end
    turtle.forward()
    if turtle.getItemCount(4) > 0 then
        MakeSpace()
    end
    distanceTraveled = distanceTraveled + 1
end

function DumpTrash()
    for slot = firstUsed, lastUsed
    do
        table = pcall(turtle.getItemDetail(slot))
        if table then
            turtle.select(slot)
            turtle.dropDown()
        end
    end
end

function MakeSpace()
    --- check if can place chest ---
    turtle.digDown()
    turtle.select(1)
    turtle.placeDown()
    for slot = firstUsed, lastUsed
    do
        table = pcall(turtle.getItemDetail(slot))
        print("Make Space Status ", status)
        if table then
            if Consumable[name] then
                turtle.select(slot)
                turtle.refuel(table.count)
                fuel = turtle.getFuelLevel()
            end
            if KeepItem(table.name) then
                turtle.select(slot)
                turtle.dropDown()
            end
        end
    end
    turtle.select(1)
    turtle.digDown()
    turtle.suck()

    DumpTrash()
end

function GoHome()
    turtle.turnLeft()
    turtle.turnLeft()
    if turtle.detectUp() then
        turtle.digUp()
    end
    turtle.up()
    for i = 1, distanceTraveled
    do
        turtle.forward()
    end
    turtle.down()
    print("Needs Refueling.")
    turtle.turnLeft()
    turtle.turnLeft()
end

function Run()
    while fuel > distanceTraveled
    do
        DigForward()
        fuel = turtle.getFuelLevel()
    end
    GoHome()
end

Run()

