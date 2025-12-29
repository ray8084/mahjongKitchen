//
//  DiscardTable.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 4/22/18.
//  Copyright © 2018 Ray. All rights reserved.
//
// test

import Foundation

class DiscardTable {
    var jokerCount = 0
    var flowerCount = 0
    var wndCount = [0,0,0,0]
    var dotCount = [0,0,0,0,0,0,0,0,0,0]
    var bamCount = [0,0,0,0,0,0,0,0,0,0]
    var crakCount = [0,0,0,0,0,0,0,0,0,0]
    
    func copy(_ copy: DiscardTable) {
        jokerCount = copy.jokerCount
        flowerCount = copy.flowerCount
        wndCount = copy.wndCount
        dotCount = copy.dotCount
        bamCount = copy.bamCount
        crakCount = copy.crakCount
    }
    
    func resetCounts() {
        for index in 0...dotCount.count-1 {
            dotCount[index] = 0
            bamCount[index] = 0
            crakCount[index] = 0
        }
        for index in 0...wndCount.count-1 {
            wndCount[index] = 0
        }
        jokerCount = 0
        flowerCount = 0
    }
    
    func getCount() -> Int {
        var count = 0
        for index in 0...dotCount.count-1 {
            count += dotCount[index]
            count += bamCount[index]
            count += crakCount[index]
        }
        for index in 0...wndCount.count-1 {
            count += wndCount[index]
        }
        count += jokerCount
        count += flowerCount
        return count
    }
    
    func countTile(_ tile: Tile, increment: Int) {
        switch tile.suit {
        case "dot": dotCount[tile.number - 1] += increment
        case "bam": bamCount[tile.number - 1] += increment
        case "crak": crakCount[tile.number - 1] += increment
        case "wnd": wndCount[tile.number - 1] += increment
        case "jkr": jokerCount += increment
        case "flwr": flowerCount += increment
        default: break
        }

        // print("DiscardTable count \(getCount())")
    }
}
