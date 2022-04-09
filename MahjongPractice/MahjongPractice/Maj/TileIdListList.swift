//
//  TileList.swift
//  Mahjong2017
//
//  Created by Ray Meyer on 1/21/18.
//  Copyright © 2018 EightBam. All rights reserved.
//
// TileIds is a list of 14 tile ids for a mahjong
// TileIdList is a list of all of the TileId lists for a given pattern
//
// For example pattern "11 22 333 444 5555"
// TileIdList = ([1,1, 2,2, 3,3,3, 4,4,4, 5,5,5,5], [11,11, 12,12, 13,13,13, 14,14,14, 15,15,15,15], [21,21, 22,22, 23,23,23, 24,24,24, 25,25,25,25])

import Foundation

struct ExtendedIdList {
    var ids = [Int]()
    var singles = Singles.normal
}

class TileIdListList {
    //var list = [[Int]]()          // variable number of lists
    var list = [ExtendedIdList]()
    
    func add(_ item: [Int], singles: Int) {
        list.append(ExtendedIdList(ids: item, singles: singles))
    }
    
    func log() {
        for p in list {
           print(p)
       }
    }
    
    func generateList(text: NSMutableAttributedString, family: Int, mask: String) {
        list.removeAll()
        var s = text.string.replacingOccurrences(of: " ", with: "")
        s = s.replacingOccurrences(of: "(C)", with: "")
        s = s.replacingOccurrences(of: "+", with: "")
        s = s.replacingOccurrences(of: "=", with: "")
        if family == Family.year {
            s = s.replacingOccurrences(of: "0", with: "Z")
        }
        let suiteList = generateSuiteList(mask: mask)
        for suits in suiteList {
            if family == Family.likeNumbers {
                for numberIndex in 0...8 {
                    let item = ExtendedIdList(ids: convertStringToTileIds(string: s, suit: suits, numberIndex: numberIndex) )
                    list.append(item)
                }
            }
            else {
                let item = ExtendedIdList(ids: convertStringToTileIds(string: s, suit: suits, numberIndex: 0))
                list.append(item)
            }
        }
    }
    
    func generateSuiteList(mask: String) -> [[Int]]{
        var suiteList: [[Int]] = []
        var suiteCount = 0
        let m = mask.replacingOccurrences(of: " ", with: "")
        if m.contains("0") {
            suiteCount += 1
        }
        if m.contains("r") {
            suiteCount += 1
        }
        if m.contains("g") {
            suiteCount += 1
        }
        if suiteCount == 1 {
            suiteList.append( maskToSuits(mask: m, s0: 0, s1: 0, s2: 0) )
            suiteList.append( maskToSuits(mask: m, s0: 1, s1: 1, s2: 1) )
            suiteList.append( maskToSuits(mask: m, s0: 2, s1: 2, s2: 2) )
        }
        else {
            suiteList.append( maskToSuits(mask: m, s0: 0, s1: 1, s2: 2) )
            suiteList.append( maskToSuits(mask: m, s0: 0, s1: 2, s2: 1) )
            suiteList.append( maskToSuits(mask: m, s0: 1, s1: 0, s2: 2) )
            suiteList.append( maskToSuits(mask: m, s0: 1, s1: 2, s2: 0) )
            suiteList.append( maskToSuits(mask: m, s0: 2, s1: 0, s2: 1) )
            suiteList.append( maskToSuits(mask: m, s0: 2, s1: 1, s2: 0) )
        }
        return suiteList
    }
    
    func maskToSuits(mask: String, s0: Int, s1: Int, s2: Int) -> [Int] {
        var suits = Array(repeating: s0, count: 14)
        var index = 0
        for char in mask {
            switch(char){
            case "0": suits[index] = s0
            case "g": suits[index] = s1
            case "r": suits[index] = s2
            default: suits[index] = s0
            }
            index += 1
        }
        return suits
    }
    
    func convertStringToTileIds(string: String, suit: [Int], numberIndex: Int) -> [Int] {
        var tileIds: [Int] = []
        var charindex = 0
        for char in string {
            tileIds.append(convertCharToTileId(char: char, suit: suit[charindex], numberIndex: numberIndex))
            charindex += 1
        }
        return tileIds
    }
    
    func convertCharToTileId(char: Character, suit: Int, numberIndex: Int) -> Int {
        var tileId = 0
        switch(char) {
        case "F": tileId = 35
        case "N": tileId = 31
        case "S": tileId = 32
        case "W": tileId = 33
        case "E": tileId = 34
        case "Z": tileId = 10
        case "D": tileId = 10 + (10*suit)
        case "1": tileId = 1 + (10*suit) + numberIndex
        case "2": tileId = 2 + (10*suit) + numberIndex
        case "3": tileId = 3 + (10*suit) + numberIndex
        case "4": tileId = 4 + (10*suit) + numberIndex
        case "5": tileId = 5 + (10*suit) + numberIndex
        case "6": tileId = 6 + (10*suit) + numberIndex
        case "7": tileId = 7 + (10*suit) + numberIndex
        case "8": tileId = 8 + (10*suit) + numberIndex
        case "9": tileId = 9 + (10*suit) + numberIndex
        default: tileId = 0
        }
        return tileId
    }
}
