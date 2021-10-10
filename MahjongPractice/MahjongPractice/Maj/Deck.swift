//
//  Deck.swift
//  Mahjong2017
//
//  Created by Ray on 8/10/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import Darwin
import Foundation
import GameKit

class Deck {
    var tiles: [Tile] = []
    
    func copy(_ copy: Deck) {
        tiles = []
        for tile in copy.tiles {
            tiles.append(Tile(tile))
        }
    }
    
    init() {
        loadTiles()
    }
    
    func loadTiles() {
        tiles = []
        for loop in 1...4 {
            for index in 1...9 {
                let sortNum = 7 + (index * 3)
                tiles.append(Tile(named: "\(index)dot", num: index, suit: "dot", id: index, sortId: index+10, sortNum: sortNum))
            }
            for index in 1...9 {
                let sortNum = 8 + (index * 3)
                tiles.append(Tile(named: "\(index)bam", num: index, suit: "bam", id: index+10, sortId: index+20, sortNum: sortNum))
            }
            for index in 1...9 {
                let sortNum = 9 + (index * 3)
                tiles.append(Tile(named: "\(index)crak", num: index, suit: "crak", id: index+20, sortId: index+30, sortNum: sortNum))
            }
            appendJoker()
            appendJoker()
            tiles.append(Tile(named: "red", num: 10, suit: "crak", id: 30, sortId: 43, sortNum: 43))
            tiles.append(Tile(named: "green", num: 10, suit: "bam", id: 20, sortId: 42, sortNum: 42))
            tiles.append(Tile(named: "soap", num: 10, suit: "dot", id: 10, sortId: 41, sortNum: 41))
            tiles.append(Tile(named: "north", num: 1, suit: "wnd", id: 31, sortId: 51, sortNum: 51))
            tiles.append(Tile(named: "south", num: 2, suit: "wnd", id: 32, sortId: 52, sortNum: 52))
            tiles.append(Tile(named: "west", num: 3, suit: "wnd", id: 33, sortId: 53, sortNum: 53))
            tiles.append(Tile(named: "east", num: 4, suit: "wnd", id: 34, sortId: 54, sortNum: 54))
            tiles.append(Tile(named: "f\(loop)", num: 12, suit: "flwr", id: 35, sortId: 1, sortNum: 1))
        }
        tiles.append(Tile(named: "sum", num: 12, suit: "flwr", id: 35, sortId: 2, sortNum: 2))
        tiles.append(Tile(named: "aut", num: 12, suit: "flwr", id: 35, sortId: 3, sortNum: 3))
        tiles.append(Tile(named: "win", num: 12, suit: "flwr", id: 35, sortId: 4, sortNum: 4))
        tiles.append(Tile(named: "spr", num: 12, suit: "flwr", id: 35, sortId: 5, sortNum: 5))
    }
    
    func appendJoker() {
        let joker = Tile(named: "joker", num: 11, suit: "jkr", id: 36, sortId: 55, sortNum: 55)
        joker.jokerFlag = true
        tiles.append(joker)
    }
    
    func shuffle(withSeed: Bool, seedString: String) {
        print("deck.shuffle \(seedString)")
        if withSeed {
            shuffleWithSeed(seedString)
        } else {
            shuffleRandom()
        }
    }

    func shuffleRandom() {
        let range: UInt32 = UInt32(tiles.count)
        for _ in 1...3000 {
            let tile1 = tiles.remove(at: Int(arc4random_uniform(range)))
            tiles.insert(tile1, at: 0)
            let index = abs(GKRandomSource.sharedRandom().nextInt() % 152)
            let tile2 = tiles.remove(at: index)
            tiles.insert(tile2, at: 0)
        }
    }
    
    func shuffleWithSeed(_ seedString: String) {
        loadTiles()
        let range = tiles.count
        let seed = seedString.isEmpty ? "0".data(using: .utf8) : seedString.lowercased().data(using: .utf8)
        let source = GKARC4RandomSource(seed: seed!)
        for _ in 1...3000 {
            let index1 = abs(source.nextInt() % range)
            let tile1 = tiles.remove(at: index1)
            tiles.insert(tile1, at: 0)
            let index = abs(source.nextInt() % range)
            let tile2 = tiles.remove(at: index)
            tiles.insert(tile2, at: 0)
        }
    }
        
    func replace(_ tile: Tile) {
        let range: UInt32 = UInt32(tiles.count)
        tiles.insert(tile, at: Int(arc4random_uniform(range)))
    }
    
    func findTile(id: Int) -> Tile? {
        var foundTile: Tile? = nil
        for (index,tile) in tiles.enumerated() {
            if tile.id == id {
                foundTile = tile
                tiles.remove(at: index)
                break
            }
        }
        return foundTile
    }
    
    func pullTiles(idMap: TileIdMap) -> [Tile] {
        print("pullTiles wallcount \(self.tiles.count)")
        idMap.log()
        var tiles: [Tile] = []
        for (index, count) in idMap.map.enumerated() {
            if count > 0 {
                for _ in 1...count {
                    let tile = findTile(id: index)
                    if tile != nil {
                        tiles.append(tile!)
                    }
                }
            }
        }
        print("pullTiles count \(tiles.count)")
        return tiles
    }
    
    func pullTiles(count: Int) -> [Tile] {
        var tiles: [Tile] = []
        for _ in 1...count {
            tiles.append(self.tiles.remove(at: 0))
        }
        return tiles
    }
    
    func insertRandom(_ tile: Tile) {
        if tiles.count <= 2 {
            tiles.append(tile)
        } else {
            let index = Int.random(in: 0...tiles.count-1)
            tiles.insert(tile, at: index)
        }
    }
 }
