-- Mining program v1 --
-- Eric Lacker --

-- Variables --

IgnoredItem = {"minecraft:stone", "minecraft:cobblestone", "minecraft:gravel",
"minecraft:dirt", "minecraft:water", "minecraft:red_mushroom", "minecraft:sand",
"minecraft:netherrack", "Botania:stone", "Botania:mushroom", "minecraft:limestone",
"minecraft:andesite", "minecraft:diorite", "minecraft:granite", "minecraft:marble",
"BiomesOPlenty:flowers", "BiomesOPlenty:flowers2"}

-- short list, so this is a concise way of checking. Info doesn't
-- have to be burn time.
Consumable = {}
Consumable["minecraft:coal"] = 1600
Consumable["druidcraft:fiery_glass"] = 2400

local distanceTraveled = 0
local fuel = turtle.getFuelLevel()
local firstUsed = 2
local lastUsed = 16

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

function RefuelWithLava(direction)
    if turtle.getFuelLevel() < turtle.getFuelLimit() then
        turtle.select(2)
        if direction == "front" then
            turtle.place()
        elseif direction == "up" then
            turtle.placeUp()
        end
        turtle.refuel()
        return true
    end
    return false
end

function DumpTrash()
    turtle.down()
    turtle.digDown()
    turtle.up()

    for slot = firstUsed, lastUsed
    do
        table = turtle.getItemDetail(slot)
        if table then
            turtle.select(slot)
            turtle.dropDown()
        end
    end
    turtle.select(firstUsed)
end

function MakeSpace()
    if turtle.getItemCount(13) > 0 then
        --- check if can place chest ---
        turtle.digDown()
        turtle.select(1)
        turtle.placeDown()
        for slot = firstUsed, lastUsed
        do
            table = turtle.getItemDetail(slot)
            print("Make Space Status: ", table, slot)
            if table then
                if Consumable[table.name] then
                    turtle.select(slot)
                    turtle.refuel(table.count)
                    print("Refueled: ", fuel, " -> ", turtle.getFuelLevel())
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
end

function DigPillar()
    -- maybe condense --
    if turtle.detect() then
        _, data = turtle.inspectUp()
        if data.name == "minecraft:lava" then
            RefuelWithLava("front")
        else
            turtle.dig()
            MakeSpace()
        end
        turtle.forward()
    else
        turtle.forward()
    end
    if turtle.detectUp() then
        _, data = turtle.inspectUp()
        if data.name == "minecraft:lava" then
            RefuelWithLava("up")
        else
            turtle.digUp()
            MakeSpace()
        end
    end
    if turtle.detectDown() then
        _, data = turtle.inspectDown()
        if data.name == "minecraft:lava" then
            RefuelWithLava("down")
        else
            turtle.digDown()
            MakeSpace()
        end
    end
end

function Advance()
    -- Dig a 3x3x2 section --
    DigPillar()
    turtle.turnRight()
    DigPillar()
    DigPillar()
    turtle.turnLeft()
    DigPillar()
    turtle.turnLeft()
    DigPillar()
    DigPillar()
    turtle.turnRight()

    distanceTraveled = distanceTraveled + 2
end

function GoHome()
    turtle.turnLeft()
    turtle.turnLeft()
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
    while fuel > (distanceTraveled - 2)
    do
        Advance()
        fuel = turtle.getFuelLevel()
    end
    GoHome()
end

Run()

