//
//  Pattern.swift
//  Mahjong2017
//
//  Created by Ray on 10/2/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//
// A letter Pattern from a mahjong score card
// For example pattern "11 222 3333 444 55".
// Contains all expressions of that pattern in a TileIdList

import Foundation

class Family {
    static let year = 0
    static let f2468 = 1
    static let likeNumbers = 2
    static let addition = 3
    static let quints = 4
    static let run = 5
    static let f13579 = 6
    static let winds = 7
    static let f369 = 8
    static let pairs = 9
    static let all = 10
}

class LetterPattern {
    var text = NSMutableAttributedString(string: "")
    var note = NSMutableAttributedString(string: "")
    var wins = 0
    var winsSinceVersion22 = 0
    var losses = 0
    var idList = TileIdListList()
    var idMap = TileIdMapList()
    var matchCount = -1
    var jokerCount = 0
    var id = 0
    var mask = ""
    var family = 0
    var concealed = false
    var filterOut = false
    var points = 0
    var rackFilter = false
    var hide = false
    
    init(text: NSMutableAttributedString, mask: String, note: String, id: Int, family: Int, concealed: Bool, points: Int) {
        self.text = text
        self.note = NSMutableAttributedString(string: note)
        self.id = id
        self.mask = mask
        self.family = family
        self.concealed = concealed
        self.points = points
    }
    
    func getDescription() -> String {
        return text.string + "\n" + note.string
    }
    
    func getFamilyString() -> String {
        switch self.family {
        case Family.year: return "Year"
        case Family.f2468: return "2468"
        case Family.likeNumbers: return "Like Numbers"
        case Family.addition: return "Addition"
        case Family.quints: return "Quints"
        case Family.run: return "Runs"
        case Family.f13579: return "13579"
        case Family.winds: return "Winds"
        case Family.f369: return "369"
        case Family.pairs: return "Singles & Pairs"
        default: return ""
        }
    }
    
    func buildIdMap() {
        if idMap.list.count == 0 {
            idMap.build(idList)
        }
    }
    
    func add(_ item: [Int]) {
        idList.add(item)
    }
    
    func getWins(showLosses: Bool) -> Int {
        var count = winsSinceVersion22
        if showLosses == false {
            count += wins
        }
        return count
    }
    
    func key() -> String {
        return String(id) + ":" + text.string
    }
    
    func lossKey() -> String {
        return String(id) + ":" + text.string + ":L"
    }
    
    func winKeySinceVersion22() -> String {
        return String(id) + ":" + text.string + ":W"
    }
    
    func winPercent() -> String {
        var percent = "0%"
        if winsSinceVersion22 + losses > 0 {
            percent = String(winsSinceVersion22 * 100 / (winsSinceVersion22 + losses)) + "%"
        }
        return percent
    }
    
    func match(_ tiles: [Tile], ignoreFilters: Bool) {
        matchCount = 0
        let filter = filterOut || hide || rackFilter
        if ignoreFilters || (filter == false) {
            buildIdMap()
            if idList.list.count > 0 {
                var jokerCount = 0
                for tile in tiles {
                    if tile.isJoker() {
                        jokerCount += 1
                    }
                }
                for map in idMap.list {
                    let count = countMatches(tiles: tiles, map: map.map, jokerCount: jokerCount)
                    if count > matchCount {
                        matchCount = count
                    }
                }
            }
        }
    }
    
    private func countMatches(tiles: [Tile], map: [Int], jokerCount: Int) -> Int {
        var remainder = map
        for tile in tiles {
            if remainder[tile.id] != 0 {
                remainder[tile.id] -= 1
            }
        }
            
        // check jokers
        var jokerRemainder = jokerCount
        if (jokerRemainder != 0) && (family != Family.pairs) {
            for (index, idCount) in map.enumerated() {
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
        return count
    }

    private func countMatches(_ tiles: [Tile], item: [Int]) -> Int {
        var ids = item
        var count = 0
        for tile in tiles {
            var index = 0
            for id in ids {
                if tile.id == id  {
                    count += 1
                    ids.remove(at: index)
                    break
                }
                index += 1
            }
        }
        return count
    }
    
    func rackFilter(_ rackMap: TileIdMap) {
        buildIdMap()
        rackFilter = false
        var removeCount = 0
        for map in idMap.list {
            for i in 1...35 {
                if map.map[i] == 6 && rackMap.map[i] == 3 {     // 2 sets of 3 flowers
                    continue
                } else if rackMap.map[i] != 0 && rackMap.map[i] != map.map[i] {
                    removeCount += 1
                    break
                }
            }
        }
        // if we remove all the idlists we filter out the pattern
        if removeCount == idMap.list.count {
            rackFilter = true
        } else {
            print("keep \(text.string) from \(rackMap.map) count \(removeCount)" )
        }
    }
    
    func clearRackFilter() {
        rackFilter = false
    }
    
    func generateList() {
        idList.generateList(text: text, family: family, mask: mask)
    }
    
}
