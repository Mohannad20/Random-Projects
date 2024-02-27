--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

keyCollision = false

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- generate a key and lock in random positions
    local lockPosition = math.random(1, width)
    local keyPosition = math.random(1, width)
    -- i choose the first
    local keyColor = 1

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        -- and also the player is always droped into solid ground
        if math.random(7) == 1 and x ~= 1 and lockPosition ~= x and keyPosition ~= x then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- spawn a key
            if x == keyPosition then
                table.insert(objects,
                    GameObject {
                        texture = 'keys_locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight + 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = keyColor,
                        collidable = true,
                        consumable = true,
                        solid = false,

                        onConsume = function(player, object)
                            gSounds['pickup']:play()
                            keyCollision = true
                            player.score = player.score + 400
                        end
                    }
                )
            end

            -- spawn a lock
            if x == lockPosition then
                table.insert(objects,
                    GameObject {
                        texture = 'keys_locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = keyColor + 4,
                        collidable = true,
                        solid = true,
                        hit = false,

                        onCollide = function(obj)

                            if not obj.hit then

                                if keyCollision then
                                    gSounds['pickup']:play()
                                    obj.hit = true

                                    -- remove lock when we collide with it
                                    local k = 1
                                    while objects[k] and not (objects[k].texture == 'keys_locks' and objects[k].frame == keyColor + 4) do
                                        k = k + 1
                                    end
                                    table.remove(objects, k)
                                    

                                    -- spawn flagposts at the end of the level
                                    local flagposts = GameObject {
                                        texture = 'flagpost',
                                        x = (width - 1)* TILE_SIZE,
                                        y = (height - 7) * TILE_SIZE,
                                        width = 16,
                                        height = 48,
                                        frame = 5,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,
                
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 400

                                            gStateMachine:change('play', {score = player.score, lastLevelWidth = width})
                                        end
                                    }

                                    -- spawn flags the same as flagpost
                                    local flags = GameObject {
                                        texture = 'flags',
                                        x = (width - 1)* TILE_SIZE ,
                                        y = (height - 7) * TILE_SIZE,
                                        width = 16,
                                        height = 16,
                                        frame = 7,
                                        collidable = true,
                                        consumable = true,
                                        solid = false,
                
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 400

                                            gStateMachine:change('play', {score = player.score, lastLevelWidth = width})
                                        end
                                    }

                                   
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, flagposts)
                                    table.insert(objects, flags)
                                end
                            end
                            
                            gSounds['empty-block']:play()
                        end
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end