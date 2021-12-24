//
//  Rack.swift
//  Mahjong2017
//
//  Created by Ray Meyer on 2/10/18.
//  Copyright © 2018 Ray. All rights reserved.
//

import Foundation

class Rack: Hand {
    
    func validate() -> String {
        var validation = ""
        if tiles.count > 0 {
            let map = TileIdMap(rack: self)
            map.log()
            for count in map.map {
                if count == 1 {
                    validation = "Singles"
                    break
                }
                else if count == 2 {
                    validation = "Pairs"
                    break
                }
            }
            if validation != "" {
                validation += " cannot be exposed until declaring MahJong. Search online reference for American MahJong rules. Return tiles to your hand to continue.\n If you are exposing jokers - Jokers replace the tile to the left, so place jokers to the right in each set of numbers, dragons, flowers and wind tiles. This is not a Mahjong rule it just helps our app reliably identify jokers."
            }
        }
        return validation
    }
    
    func markJoker(joker: Tile, index: Int) {
        if (tiles.count > 0) && (index >= tiles.count) {
            joker.setJokerFields(lastNonJoker())
        } else if (index > 0) && (index < tiles.count) {
            joker.setJokerFields(tiles[index-1])
        } else if (index == 0) {
            joker.setJokerFields(firstNonJoker())
        }
    }
    
    func lastNonJoker() -> Tile {
        var foundTile: Tile = Tile()
        for tile in tiles {
            if tile.isJoker() == false {
                foundTile = tile
            }
        }
        return foundTile
    }

    func firstNonJoker() -> Tile {
        var foundTile: Tile = Tile()
        for tile in tiles {
            if tile.isJoker() == false {
                foundTile = tile
                break
            }
        }
        return foundTile
    }
    
    func replaceJokers(_ hand: Hand) {
        for _ in 1...14 {
            var index = 0
            for tile in tiles {
                if tile.isJoker() {
                    let t = hand.getTile(tile.jokerSuit, number: tile.jokerNumber)
                    if t != nil {
                        tiles.remove(at: index)
                        tiles.insert(t!, at: index)
                        hand.tiles.append(tile)
                        break
                    }
                }
                index += 1
            }
        }
    }
    
    func replaceJoker(_ tile: Tile) -> Bool {
        var found = false
        for (index, t) in tiles.enumerated() {
            if t.isJoker() && (t.jokerId == tile.id) {
                tiles.remove(at: index)
                tiles.insert(tile, at: index)
                found = true
                break
            }
        }
        return found
    }
    
    func rackAll(_ hand: Hand) {
        hand.sort()
        for tile in hand.tiles {
            tiles.append(tile)
        }
    }
}
