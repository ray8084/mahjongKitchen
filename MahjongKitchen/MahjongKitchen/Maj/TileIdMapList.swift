//
//  TileIdMap.swift
//  Mahjong2017
//
//  Created by Ray Meyer on 1/21/18.
//  Copyright © 2018 Ray. All rights reserved.
//
// TileIdMap counts the count for tile ids for a mahjong in a fixed sized list
// For example pattern "11 22 333 444 5555".
// idMap = [0,2,2,3,3,4,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0]
// index mapping
// 0 = reserved for matching count
// 1 = 1 dot
// 2 = 2 dot
// 10 = soap
// 11 = 1 bam
// 12 = 2 bam
// 20 = green dragon
// 21 = 1 crak
// 22 = 2 crak
// 30 = red dragon
// 31 = north
// 32 = south
// 33 = west
// 34 = east
// 35 = flower
// 36 = joker
//
// TileIdMapMap is a list of TileIdMaps for a given pattern
// For example pattern "11 22 333 444 5555".
// ipMapList = ([0, 2,2,3,3,4,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0],  // pattern in dots
//              [0, 0,0,0,0,0,0,0,0,0,0, 2,2,3,3,4,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0],  // pattern in bams
//              [0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 2,2,3,3,4,0,0,0,0,0, 0,0,0,0,0],  // pattern in craks

import Foundation

class TileIdMap {
    var map = [Int](repeating: 0, count: 37)
   
    init(_ idList: [Int]){
        for id in idList {
            map[id] += 1
        }
    }
    
    init(rack: Hand) {
        for tile in rack.tiles {
            if tile.isJoker() {
                map[tile.jokerId] += 1
            } else {
                map[tile.id] += 1
            }
        }
    }
    
    init(tiles: [Tile]) {
        for tile in tiles {
            map[tile.id] += 1
        }
    }
    
    func jokerCount() -> Int {
        return map[36]
    }
    
    func flowerCount() -> Int {
        return map[35]
    }
    
    func log() {
        print(map)
    }
    
    func isFiveSoapHand() -> Bool {
        return map[10] == 5
    }
    
    func isLastSet() -> Bool {
        var setCount = 0
        for tileCount in map {
            if tileCount > 0 {
                setCount += 1
            }
        }
        return setCount == 1
    }
    
    func lastSetId() -> Int {
        var id = 0
        for (index, tileCount) in map.enumerated() {
            if tileCount > 0 {
                id = index
                break
            }
        }
        return id
    }
    
    func singlesAndPairsCount() -> Int {
        var singlesAndPairsCount = 0
        for count in map {
            if count > 0 && count < 3 {
                singlesAndPairsCount += 1
            }
        }
        return singlesAndPairsCount
    }
}

class TileIdMapList {
    var list = [TileIdMap]()
    
    func build(_ tileIdList: TileIdListList) {
        for idList in tileIdList.list {
            let idMap = TileIdMap(idList.ids)
            list.append(idMap)
        }
    }
    
    func buildFromRack(_ rack: Hand) {
        let idMap = TileIdMap(rack: rack)
        list.append(idMap)
    }
}
