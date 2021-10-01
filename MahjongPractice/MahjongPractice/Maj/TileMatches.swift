//
//  TilePatterns.swift
//  Mahjong2017
//
//  Created by Ray Meyer on 12/2/17.
//  Copyright © 2017 Ray. All rights reserved.
//

import Foundation

class TileMatches {
    var list = [TileMatchItem]()
    var stopSorting = false
    
    func loadPatterns(_ letterPatterns: [LetterPattern]) {
        list = []
        var letterPatternIndex = 0
        for lp in letterPatterns {
            for tileIds in lp.idList.list {
                list.append(TileMatchItem(tileIds: tileIds, letterPatternIndex: letterPatternIndex, letterPattern: lp))
            }
            letterPatternIndex += 1
        }
    }
    
    func loadOpponentPatterns(_ letterPatterns: [LetterPattern]) {
        var letterPatternIndex = 0
        for lp in letterPatterns {
            if (lp.concealed == false) && (lp.family != Family.pairs) && (lp.family != Family.quints){
                for tileIds in lp.idList.list {
                    list.append(TileMatchItem(tileIds: tileIds, letterPatternIndex: letterPatternIndex, letterPattern: lp))
                }
            }
            letterPatternIndex += 1
        }
    }
    
    func countMatches(hand: Hand, rack: Rack) {
        countMatches(hand: hand, tiles: hand.tiles + rack.tiles, jokerCount: hand.jokerCount() + rack.jokerCount())
    }
    
    private func countMatches(hand: Hand, tiles: [Tile], jokerCount: Int) {
        for tileMatchItem in list {
            countMatchesForItem(hand: hand, tiles: tiles, tileMatchItem: tileMatchItem, jokerCount: jokerCount)
        }
    }
    
    func countMatchesForItem(hand: Hand, tiles: [Tile], tileMatchItem: TileMatchItem, jokerCount: Int) {
        var remainder = tileMatchItem.map.map
        tileMatchItem.matchCount = 0
        if hand.isFilteredOut(tileMatchItem: tileMatchItem ) == false {
            // matching tiles
            for tile in tiles {
                if remainder[tile.id] != 0 {
                    remainder[tile.id] -= 1
                }
            }

            // check jokers
            var jokerRemainder = jokerCount
            if (jokerRemainder != 0) && (tileMatchItem.family != Family.pairs) {
                for (index, idCount) in tileMatchItem.map.map.enumerated() {
                    if (idCount > 2) && (remainder[index] != 0) {
                        if remainder[index] >= jokerRemainder {
                            remainder[index] -= jokerRemainder
                            jokerRemainder = 0
                            break
                        } else {
                            jokerRemainder -= remainder[index]
                            remainder[index] = 0
                        }
                    }
                }
            }
            
            // count remainder
            var count = 14
            for idCount in remainder {
                count -= idCount
            }
            tileMatchItem.matchCount = count
        }
    }

    func countMatchesForItemNoFilters(hand: Hand, tiles: [Tile], tileMatchItem: TileMatchItem, jokerCount: Int) {
        var remainder = tileMatchItem.map.map
        tileMatchItem.matchCount = 0

        // matching tiles
        for tile in tiles {
            if remainder[tile.id] != 0 {
                remainder[tile.id] -= 1
            }
        }

        // check jokers
        var jokerRemainder = jokerCount
        if (jokerRemainder != 0) && (tileMatchItem.family != Family.pairs) {
            for (index, idCount) in tileMatchItem.map.map.enumerated() {
                if (idCount > 2) && (remainder[index] != 0) {
                    if remainder[index] >= jokerRemainder {
                        remainder[index] -= jokerRemainder
                        jokerRemainder = 0
                        break
                    } else {
                        jokerRemainder -= remainder[index]
                        remainder[index] = 0
                    }
                }
            }
        }
        
        // count remainder
        var count = 14
        for idCount in remainder {
            count -= idCount
        }
        tileMatchItem.matchCount = count
    }
    
    func countMatchesForEast(_ maj: Maj) {
        let tiles = maj.east.tiles + maj.rackTiles()
        for tileMatchItem in list {
            if maj.card.isPatternHidden(id: tileMatchItem.letterPatternId) {
                tileMatchItem.matchCount = 0
            } else if tileMatchItem.rackFilter {
                tileMatchItem.matchCount = 0
            } else {
                countMatchesForItem(hand: maj.east, tiles: tiles, tileMatchItem: tileMatchItem, jokerCount: maj.east.jokerCount() + maj.east.rack!.jokerCount())
            }
        }
    }
    
    func countMatchesForEastNoFilters(_ maj: Maj) {
        let tiles = maj.east.tiles + maj.rackTiles()
        for tileMatchItem in list {
            countMatchesForItemNoFilters(hand: maj.east, tiles: tiles, tileMatchItem: tileMatchItem, jokerCount: maj.east.jokerCount() + maj.east.rack!.jokerCount())
        }
    }
    
    func rackFilter(_ rack: Hand) {
        let idMap = TileIdMap(rack: rack)
        for tileMatchItem in list {
            tileMatchItem.rackFilter(idMap)
        }
    }
    
    func clearRackFilter() {
        for tileMatchItem in list {
            tileMatchItem.rackFilter = false
        }
    }
    
    func sort() {
        if stopSorting == false {
            list.sort(by: { $0.matchCount == $1.matchCount ? $0.letterPatternId < $1.letterPatternId :  $0.matchCount > $1.matchCount })
        }
    }
}

class TileMatchItem {
    var tileIds = [Int]()
    var map = TileIdMap([])
    var matchCount = 0
    var letterPatternId = 0
    var concealed = false
    var family = 0
    var rackFilter = false
   
    init(tileIds: [Int], letterPatternIndex: Int, letterPattern: LetterPattern){
        self.tileIds = tileIds
        self.letterPatternId = letterPatternIndex
        self.family = letterPattern.family
        self.concealed = letterPattern.concealed
        self.map = TileIdMap(tileIds)
    }
    
    func rackFilter(_ rackMap: TileIdMap) {
        rackFilter = false
        for i in 1...35 {
            if map.map[i] == 6 && rackMap.map[i] == 3 {     // 2 sets of 3 flowers
                continue
            } else if rackMap.map[i] != 0 && rackMap.map[i] != map.map[i] {
                rackFilter = true
                break
            }
        }
        if rackFilter == false {
            print("keep \(map.map) for rack \(rackMap.map)")
        }
    }
}
