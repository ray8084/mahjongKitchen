//
//  Hand.swift
//  Mahjong2017
//
//  Created by Ray on 8/11/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import Foundation
import GameKit

class Hand {
    var name: String
    var tiles: [Tile] = []
    var rack: Rack?
    let tileMatches = TileMatches()
    var filterOutYears = false
    var filterOut2468 = false
    var filterOutLikeNumbers = false
    var filterOutAdditionHands = false
    var filterOutQuints = false
    var filterOutRuns = false
    var filterOut13579 = false
    var filterOutWinds = false
    var filterOut369 = false
    var filterOutPairs = false
    var filterOutConcealed = false
    var message = ""
    var testJokerExchange = true
    // var winBot = false
    var letterPatternLocked: LetterPattern?

    // --------------------------------------------------------------
    //  copy
    
    func copy(_ copy: Hand) {
        name = copy.name
        tiles = []
        for tile in copy.tiles {
            tiles.append(Tile(tile))
        }
        if copy.rack == nil {
            rack = nil
        } else {
            rack = Rack("")
            rack!.copy(copy.rack!)
        }
        //tileMatches = TileMatches()
        filterOutYears = copy.filterOutYears
        filterOut2468 = copy.filterOut2468
        filterOutLikeNumbers = copy.filterOutLikeNumbers
        filterOutAdditionHands = copy.filterOutAdditionHands
        filterOutQuints = copy.filterOutQuints
        filterOutRuns = copy.filterOutRuns
        filterOut13579 = copy.filterOut13579
        filterOutWinds = copy.filterOutWinds
        filterOut369 = copy.filterOut369
        filterOutPairs = copy.filterOutPairs
        filterOutConcealed = copy.filterOutConcealed
        message = copy.message
        testJokerExchange = copy.testJokerExchange
        // winBot = copy.winBot
        if copy.letterPatternLocked == nil {
            letterPatternLocked = nil
        } else {
            letterPatternLocked = copy.letterPatternLocked
        }
    }
    
    
    // --------------------------------------------------------------
    //  init
    
    init(_ name: String) {
        self.name = name
    }
  
    
    // --------------------------------------------------------------
    //  counts
    
    func getHighestMatch() -> TileMatchItem {
        if tileMatches.list[0].matchCount == 0 {
            tileMatches.countMatches(hand: self, rack: rack!)
            tileMatches.sort()
        }
        return tileMatches.list[0]
    }
    
    func resetHighestMatch() {
        tileMatches.countMatches(hand: self, rack: rack!)
        tileMatches.sort()
    }
    
    func jokerCount() -> Int {
        var count = 0
        for t in tiles {
            if t.isJoker() {
                count += 1
            }
        }
        return count
    }
    
    func declareMahjong() -> Bool {
        let matchCount = getHighestMatch().matchCount       // we had it
        let totalTiles = tiles.count + rack!.tiles.count    // do we still have it
        if matchCount == 14 && totalTiles != 14 {
            print("declareMahjong todo")                    // we had mahjong and we lost it somehow
        }
        let declare = (matchCount == 14) && (totalTiles == 14)     // matchcount can be old so double check it
        if declare {
            rack!.message = "\(name) declared Mahjong"
        }
        return declare
    }
    
    func onCall() -> Bool {
        let matchCount = getHighestMatch().matchCount
        return matchCount == 13
    }
    
    func countMatches() {
        tileMatches.countMatches(hand: self, rack: rack!)
    }
    
    
    // --------------------------------------------------------------
    //  charleston
    
    func getCharlestonSet(maj: Maj, rack: Rack, count: Int) -> Hand {
        let set = Hand("")
        var tries = 0
        while set.tiles.count < count {
            let discard = getDiscard(maj: maj, rack: rack, withFlowers: false)
            var found = false
            for tile in set.tiles {
                // try to avoid passing pairs
                if tile.isEqual(discard) {
                    found = true
                    break
                }
                // try to avoid passing multiple winds
                if tile.isWind() && discard.isWind() {
                    found = true
                    break
                }
            }
            if found == true {
                // put it back
                tiles.append(discard)
            } else {
                // use it
                set.tiles.append(discard)
            }
            tries += 1
            if tries == tiles.count {
                break
            }
        }
        // couldnt find a good set, ok to pass pairs now
        while set.tiles.count < count {
            set.tiles.append(getDiscard(maj: maj, rack: rack, withFlowers: false))
        }
        return set
    }
    

    // --------------------------------------------------------------
    //  discard
    
    func getDiscard(maj: Maj, rack: Rack, withFlowers: Bool) -> Tile {
        maj.previousHandName = maj.lastHandName
        maj.lastHandName = name
        return getBestDiscard(maj: maj, rack: rack, withFlowers: withFlowers)
    }
    
    func getRandomDiscard(withFlowers: Bool) -> Tile {
        var index = 0
        for tile in tiles {
            if !tile.isJoker() || (tile.isFlower() && withFlowers) {
                break
            }
            index += 1
        }
        var tile: Tile!
        if index < tiles.count {
            tile = tiles.remove(at: index)
        } else {
            tile = tiles.remove(at: tiles.count-1)
        }
        return tile
    }
    
    func getBestDiscard(maj: Maj, rack: Rack, withFlowers: Bool) -> Tile {
        tileMatches.countMatches(hand: self, rack: rack)
        tileMatches.sort()
        let tileMatchItem = getBestBotHand()
        let matchCount = tileMatchItem.matchCount
        shuffle(withSeed: maj.shuffleWithSeed, seedString: maj.shuffleSeed)
        var tile = tiles[0]
        var found = false
        for index in 0...tiles.count-1 {
            if maj.isWinBotEnabled() {
                tile = tiles.remove(at: 0)
                tileMatches.countMatchesForItem(hand: self, tiles: tiles + rack.tiles, tileMatchItem: tileMatchItem, jokerCount: jokerCount() + rack.jokerCount())
            } else {
                tile = tiles.remove(at: index)
                tileMatches.countMatchesForItem(hand: self, tiles: tiles, tileMatchItem: tileMatchItem, jokerCount: jokerCount() + rack.jokerCount())
            }

            if tileMatchItem.matchCount == matchCount {
                if (tile.isJoker() == false) || (tile.isFlower() && withFlowers) {
                    found = true
                    break
                }
            }
            tiles.append(tile)
        }
        return found ? tile : getRandomDiscard(withFlowers: withFlowers)
    }
    
    func getBestBotHand() -> TileMatchItem {
        var bestBotHand = tileMatches.list[0]
        for item in tileMatches.list {
            bestBotHand = item
            if item.concealed == false  {
                break
            }
        }
        return bestBotHand
    }
    
    func shuffle(withSeed: Bool, seedString: String) {
        if withSeed {
            shuffleWithSeed(seedString)
        } else {
            shuffleRandom()
        }
    }
    
    func shuffleRandom() {
        if tiles.count > 0 {
            let range: UInt32 = UInt32(tiles.count)
            for _ in 1...10 {
                let tile1 = tiles.remove(at: Int(arc4random_uniform(range)))
                tiles.insert(tile1, at: 0)
                let index = abs(GKRandomSource.sharedRandom().nextInt() % tiles.count)
                let tile2 = tiles.remove(at: index)
                tiles.insert(tile2, at: 0)
            }
        } else {
            print("no tiles to shuffle")
        }
    }
    
    func shuffleWithSeed(_ seedString: String) {
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
    
    
    // --------------------------------------------------------------
    //  drawing from the wall
    
    func draw(_ maj: Maj) {
        tiles.append(maj.wall.tiles.remove(at: 0))
    }
        
    
    // --------------------------------------------------------------
    //  sorting
    
    func sort() {
        tiles.sort(by: { $0.sortId < $1.sortId })
    }
    
    func sortNumbers() {
        tiles.sort(by: { $0.sortNumbers < $1.sortNumbers })
    }

    func getSortedTiles() -> Hand {
        let sortedTiles = Hand("")
        for tile in tiles {
            let newTile = Tile(named: tile.name, num: tile.number, suit: tile.suit, id: tile.id, sortId: tile.sortId, sortNum: tile.sortNumbers)
            sortedTiles.tiles.append(newTile)
        }
        sortedTiles.sort()
        return sortedTiles
    }

    func finalSortEastRack(_ maj: Maj) {
        tileMatches.countMatchesForEastNoFilters(maj)
        tileMatches.sort()
        let best = tileMatches.list[0].tileIds
        rack!.tiles = finalSort(maj, hand: rack!, best: best)
    }
    
    func finalSort(_ mah: Maj, hand: Hand, best: [Int]) -> [Tile] {
        var oldTiles: [Tile] = hand.tiles
        var newTiles: [Tile] = []
        for tileId in best {
            var found = false
            for (index, tile) in oldTiles.enumerated() {
                if tile.id == tileId {
                    newTiles.append(tile)
                    oldTiles.remove(at: index)
                    found = true
                    break
                }
            }
            if found == false {
                for (index, tile) in oldTiles.enumerated() {
                    if tile.isJoker() {
                        newTiles.append(tile)
                        oldTiles.remove(at: index)
                        found = true
                        break
                    }
                }
            }
        }
        return newTiles
    }
    
    
    
    // --------------------------------------------------------------
    //  tile methods
    
    func getTile(_ suit: String,  number: Int) -> Tile? {
        var index = 0
        for tile in tiles {
            if tile.isEqual(suit, number: number) {
                return tiles.remove(at: index)
            }
            index += 1
        }
        return nil
    }
    
    func removeTile(_ tile: Tile) {
        for (index, t) in tiles.enumerated() {
            if tile.id == t.id {
                tiles.remove(at: index)
                break
            }
        }
    }
    
    func getTile(id: Int) -> Tile? {
        var tile: Tile?
        for (index, t) in tiles.enumerated() {
            if id == t.id {
                tile = tiles.remove(at: index)
                break
            }
        }
        return tile
    }
   
    func addJoker() {
        tiles.append(Tile(named: "joker", num: 11, suit: "jkr", id: 36, sortId: 55, sortNum: 55))
    }
    
    func printTiles() {
        var s = ""
        for tile in tiles {
            s += String(tile.id) + ", "
        }
        s += "Count:\(tiles.count) Jokers:\(jokerCount())"
        print(s)
    }
    
    
    // --------------------------------------------------------------
    //  rack methods - todo move to rack object

    func rackTiles(rack: Rack, tileId: Int, count: Int) {
        for _ in 1...count {
            for (index, tile) in tiles.enumerated() {
                if tile.id == tileId {
                    let tile = tiles.remove(at:index)
                    let newTile = Tile(tile)
                    rack.tiles.append( newTile )
                    break
                }
            }
            //print("rackTiles count \(count):\(i)" )
        }
    }
    
    func rackAllTiles() {
        for tile in tiles {
            rack!.tiles.append(tile)
        }
        rack!.sort()
        tiles.removeAll()
    }
        
    func rackJokers(rack: Rack, id: Int, suit: String, number: Int, count: Int) {
        for _ in 1...count {
            for (index, tile) in tiles.enumerated() {
                if tile.isJoker() {
                    let joker = tiles.remove(at:index)
                    joker.jokerId = id
                    joker.jokerSuit = suit
                    joker.jokerNumber = number
                    rack.tiles.append(joker)
                    break
                }
            }
            //print("rackJokers count \(count):\(i)" )
        }
    }
    
    func getRackCount() -> Int {
        var count = 0
        if rack != nil {
            count = rack!.tiles.count
        }
        return count
    }
    
    func removeFromRack(_ index: Int) -> Tile {
        return (rack?.tiles.remove(at: index))!
    }
    
    func addToRack(_ tile: Tile, index: Int) {
        if index >= getRackCount() {
            rack?.tiles.append(tile)
        } else {
            rack?.tiles.insert(tile, at: index)
        }
    }
    
        
    // --------------------------------------------------------------
    //  filters
    
    func isFilteredOut(tileMatchItem: TileMatchItem) -> Bool {
        var filterOut = false
        if filterOutConcealed && tileMatchItem.concealed {
            filterOut = true
        }
        let rackCount = rack?.tiles.count
        if (rackCount! > 0) && (rackCount! < 14) && tileMatchItem.concealed {
            filterOut = true
        }
        if filterOutQuints && (tileMatchItem.family == Family.quints){
            filterOut = true
        }
        if filterOutPairs && (tileMatchItem.family == Family.pairs){
            filterOut = true
        }
        if filterOutYears && (tileMatchItem.family == Family.year){
            filterOut = true
        }
        if filterOutWinds && (tileMatchItem.family == Family.winds){
            filterOut = true
        }
        if filterOut2468 && (tileMatchItem.family == Family.f2468){
            filterOut = true
        }
        if filterOutLikeNumbers && (tileMatchItem.family == Family.likeNumbers){
            filterOut = true
        }
        if filterOutAdditionHands && (tileMatchItem.family == Family.addition){
            filterOut = true
        }
        if filterOutRuns && (tileMatchItem.family == Family.run){
            filterOut = true
        }
        if filterOut13579 && (tileMatchItem.family == Family.f13579){
            filterOut = true
        }
        if filterOut369 && (tileMatchItem.family == Family.f369){
            filterOut = true
        }
        //if tileMatchItem.rackFilter {
        //    filterOut = true
        //}
        return filterOut
    }
    
    
    // --------------------------------------------------------------
    //  calling

    func skipPattern(patternId: Int) -> Bool {
        return (patternId == 0) || (patternId == 2) || (patternId == 3) || (patternId == 4) // todo fix 2022 joker calls
    }
    
    func call(maj: Maj, rack: Rack) -> Bool{
        // print("Call \(name)")
        if maj.discardTile != nil {
            if maj.discardTile.isJoker() == false {
                let tileMatchItem = getHighestMatch()
                if skipPattern(patternId: tileMatchItem.letterPatternId) == false {
                    let matchMap = tileMatchItem.map
                    let matchId = maj.discardTile.id
                    let tilename = maj.discardTile.getDisplayName()
                    let handMap = TileIdMap(tiles: tiles)
                    let rackMap = TileIdMap(rack: rack)
                    let matchCount = matchMap.map[matchId]
                    let handCount = handMap.map[matchId]
                    let rackCount = rackMap.map[matchId]
                    let jokers = jokerCount()
                    maj.discardCalled = false
                    if rackCount != 0 {
                    }
                    else if (matchCount == 4) && (handCount == 3) {
                        maj.discardCalled = call(maj: maj, rack: rack, matchId: matchId, matchCount: matchCount, handCount: handCount)
                    }
                    else if (matchCount == 4) && (handCount == 2) && (jokers >= 1) {
                        maj.discardCalled = callWithJoker(maj: maj, rack: rack, matchId: matchId, matchCount: matchCount, handCount: handCount)
                    }
                    else if (matchCount == 4) && (handCount == 1) && (jokers >= 2) {
                        maj.discardCalled = callWith2Jokers(maj: maj, rack: rack, matchId: matchId, matchCount: matchCount, handCount: handCount)
                    }
                    else if (matchCount == 3) && (handCount == 2) {
                        maj.discardCalled = call(maj: maj, rack: rack, matchId: matchId, matchCount: matchCount, handCount: handCount)
                    }
                    else if (matchCount == 3) && (handCount == 1) && (jokers > 0) {
                        maj.discardCalled = callWithJoker(maj: maj, rack: rack, matchId: matchId, matchCount: matchCount, handCount: handCount)
                    } else if (matchCount == 2) && (handCount == 1){
                        maj.discardCalled = callPair(maj: maj, rack: rack, matchId: matchId, matchCount: matchCount, handCount: handCount)
                    } else {
                        // print("Pass \(name) id \(matchId) map \(matchCount) hand \(handCount) jokers \(jokers)" )
                    }
                    
                    if maj.discardCalled {
                        // print("Call \(name) id \(matchId) map \(matchCount) hand \(handCount) jokers \(jokers) letterPatternIndex \(tileMatchItem.letterPatternId)" )
                        maj.clearMessages()
                        if maj.isWinBotEnabled() && maj.botWon() {
                            rack.message = "\(name) declared Mahjong"
                            print(rack.message)
                        } else {
                            rack.message = "\(name) called \(tilename)"
                            if maj.previousHandName == maj.south.rack?.name {
                                maj.south.rack?.message = "\(maj.south.rack?.name ?? "") discarded \(tilename)"
                            } else if maj.previousHandName == maj.west.rack?.name {
                                maj.west.rack?.message = "\(maj.west.rack?.name ?? "") discarded \(tilename)"
                            } else if maj.previousHandName == maj.north.rack?.name {
                                maj.north.rack?.message = "\(maj.north.rack?.name ?? "") discarded \(tilename)"
                            }
                        }
                    }
                }
            }
        }
        return maj.discardCalled
    }
    
    private func call(maj: Maj, rack: Rack, matchId: Int, matchCount: Int, handCount: Int) -> Bool {
        var called = false
        if matchCount - handCount == 1 {
            if matchCount + rack.tiles.count < 14 {
                tileMatches.stopSorting = true
                rackTiles(rack: rack, tileId: matchId, count: handCount)
                rack.tiles.append(Tile(maj.discardTile))
                maj.discardTile = getDiscard(maj: maj, rack: rack, withFlowers: true)
                called = true
            } else if maj.isWinBotEnabled() {
                // print("\(name) call for mahjong")
                rack.tiles.append(Tile(maj.discardTile))
                rackAllTiles()
                countMatches()
                called = true
            }
        }
        return called
    }
    
    private func callWithJoker(maj: Maj, rack: Rack, matchId: Int, matchCount: Int, handCount: Int) -> Bool {
        var called = false
        if (matchCount - handCount == 2) && (jokerCount() >= 1) && ((maj.wall.tiles.count < 90) || testJokerExchange) {
            if matchCount + rack.tiles.count < 14 {
                tileMatches.stopSorting = true
                rackTiles(rack: rack, tileId: matchId, count: handCount)
                rackJokers(rack: rack, id: maj.discardTile.id, suit: maj.discardTile.suit, number: maj.discardTile.number, count: 1)
                rack.tiles.append(Tile(maj.discardTile))
                maj.discardTile = getDiscard(maj: maj, rack: rack, withFlowers: true)
                called = true
            } else if maj.isWinBotEnabled() {
                // print("\(name) call for mahjong")
                rack.tiles.append(Tile(maj.discardTile))
                rackAllTiles()
                countMatches()
                called = true
            }
        }
        return called
    }
    
    private func callWith2Jokers(maj: Maj, rack: Rack, matchId: Int, matchCount: Int, handCount: Int) -> Bool {
        var called = false
        if (matchCount - handCount == 3) && (jokerCount() >= 2) && (((maj.wall.tiles.count > 20) && (maj.wall.tiles.count < 40)) || testJokerExchange) {
            if matchCount + rack.tiles.count < 14 {
                tileMatches.stopSorting = true
                rackTiles(rack: rack, tileId: matchId, count: handCount)
                rackJokers(rack: rack, id: maj.discardTile.id, suit: maj.discardTile.suit, number: maj.discardTile.number, count: 2)
                rack.tiles.append(Tile(maj.discardTile))
                maj.discardTile = getDiscard(maj: maj, rack: rack, withFlowers: true)
                called = true
            } else if maj.isWinBotEnabled() {
                // print("\(name) call for mahjong")
                rack.tiles.append(Tile(maj.discardTile))
                rackAllTiles()
                countMatches()
                called = true
            }
        }
        return called
    }
    
    private func callPair(maj: Maj, rack: Rack, matchId: Int, matchCount: Int, handCount: Int) -> Bool {
        var called = false
        if maj.isWinBotEnabled() && (matchCount + rack.tiles.count == 14) {
            // print("\(name) call for mahjong")
            rack.tiles.append(Tile(maj.discardTile))
            rackAllTiles()
            countMatches()
            called = true
        }
        return called
    }
}
