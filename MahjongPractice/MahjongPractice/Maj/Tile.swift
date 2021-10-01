//
//  Tile.swift
//  Mahjong2017
//
//  Created by Ray on 8/10/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

class Tile {
    var name: String = ""
    var number = 0
    var suit: String = ""
    var jokerSuit = ""
    var jokerNumber = 0
    var jokerId = 0
    var id = 0
    var sortId = 0
    var jokerFlag = false
    
    func copy(_ copy: Tile) {
        name = copy.name
        number = copy.number
        suit = copy.suit
        jokerSuit = copy.jokerSuit
        jokerNumber = copy.jokerNumber
        jokerId = copy.jokerId
        id = copy.id
        sortId = copy.sortId
        jokerFlag = copy.jokerFlag
    }
    
    init() {
    }
    
    init(named: String, num: Int, suit: String, id: Int, sortId: Int) {
        self.name = named
        self.number = num
        self.suit = suit
        self.id = id
        self.sortId = sortId
    }
    
    init(_ tile: Tile) {
        self.name = tile.name
        self.number = tile.number
        self.suit = tile.suit
        self.id = tile.id
        self.sortId = tile.sortId
        self.jokerSuit = tile.jokerSuit
        self.jokerNumber = tile.jokerNumber
        self.jokerId = tile.jokerId
        self.jokerFlag = tile.jokerFlag
    }
    
    func isJoker() -> Bool {
        return jokerFlag || (suit == "jrk") || (number == 11)
    }
    
    func isFlower() -> Bool {
        return suit == "flwr"
    }
    
    func isWind() -> Bool {
        return suit == "wnd"
    }
    
    func isEqual(_ tile: Tile) -> Bool {
        let sameSuit = tile.suit == suit
        let sameNumber = tile.number == number
        return sameSuit && sameNumber
    }
    
    func isEqual(_ suit: String, number: Int) -> Bool {
        let sameSuit = suit == self.suit
        let sameNumber = number == self.number
        return sameSuit && sameNumber
    }
    
    func setJokerSuit(_ suit: String, num: Int, id: Int) {
        if jokerSuit == "" {
            jokerSuit = suit
            jokerNumber = num
            jokerId = id
        }
    }
    
    func setJokerFields(_ tile: Tile) {
        if tile.isJoker() {
            jokerSuit = tile.jokerSuit
            jokerId = tile.jokerId
            jokerNumber = tile.jokerNumber
            // id = tile.id
        } else {
            jokerSuit = tile.suit
            jokerId = tile.id
            jokerNumber = tile.number
            // id = tile.id
        }
    }
    
    func clearJokerSuit() {
        jokerSuit = ""
        jokerNumber = 0
        jokerId = 0
    }
    
    func getImage(maj: Maj) -> String {
        return Tile.getImage(id: id, maj: maj)
    }
    
    static func getImage(id: Int, maj: Maj) -> String {
        var image = Tile.getImage(id)
        if id < 10 && maj.dotTileStyle == TileStyle.largeFont {
            image = Tile.getImageNew(id)
        }
        if id > 10 && id < 20 && maj.bamTileStyle == TileStyle.largeFont {
            image = Tile.getImageNew(id)
        }
        if id > 20 && id < 30 && maj.crakTileStyle == TileStyle.largeFont {
            image = Tile.getImageNew(id)
        }
        if id > 30 && id < 35 && maj.windTileStyle == TileStyle.largeFont {
            image = Tile.getImageNew(id)
        }
        if id == 35 && maj.flowerTileStyle == TileStyle.largeFont {
            image = Tile.getImageNew(id)
        }
        return image
    }
    
    static func getImage(_ id: Int) -> String {
        var image = ""
        switch(id) {
        case 1: image = "1dot.png"
        case 2: image = "2dot.png"
        case 3: image = "3dot.png"
        case 4: image = "4dot.png"
        case 5: image = "5dot.png"
        case 6: image = "6dot.png"
        case 7: image = "7dot.png"
        case 8: image = "8dot.png"
        case 9: image = "9dot.png"
        case 10: image = "soap.png"
        case 11: image = "1bam.png"
        case 12: image = "2bam.png"
        case 13: image = "3bam.png"
        case 14: image = "4bam.png"
        case 15: image = "5bam.png"
        case 16: image = "6bam.png"
        case 17: image = "7bam.png"
        case 18: image = "8bam.png"
        case 19: image = "9bam.png"
        case 20: image = "green.png"
        case 21: image = "1crak.png"
        case 22: image = "2crak.png"
        case 23: image = "3crak.png"
        case 24: image = "4crak.png"
        case 25: image = "5crak.png"
        case 26: image = "6crak.png"
        case 27: image = "7crak.png"
        case 28: image = "8crak.png"
        case 29: image = "9crak.png"
        case 30: image = "red.png"
        case 31: image = "north.png"
        case 32: image = "south.png"
        case 33: image = "west.png"
        case 34: image = "east.png"
        case 35: image = "f1.png"
        case 36: image = "joker.png"
        default: image = ""
        }
        return image
    }
    
    static func getImageNew(_ id: Int) -> String {
        var image = ""
        switch(id) {
        case 1: image = "1dotnew.png"
        case 2: image = "2dotnew.png"
        case 3: image = "3dotnew.png"
        case 4: image = "4dotnew.png"
        case 5: image = "5dotnew.png"
        case 6: image = "6dotnew.png"
        case 7: image = "7dotnew.png"
        case 8: image = "8dotnew.png"
        case 9: image = "9dotnew.png"
        case 10: image = "soap.png"
        case 11: image = "1bamnew.png"
        case 12: image = "2bamnew.png"
        case 13: image = "3bamnew.png"
        case 14: image = "4bamnew.png"
        case 15: image = "5bamnew.png"
        case 16: image = "6bamnew.png"
        case 17: image = "7bamnew.png"
        case 18: image = "8bamnew.png"
        case 19: image = "9bamnew.png"
        case 20: image = "green.png"
        case 21: image = "1craknew.png"
        case 22: image = "2craknew.png"
        case 23: image = "3craknew.png"
        case 24: image = "4craknew.png"
        case 25: image = "5craknew.png"
        case 26: image = "6craknew.png"
        case 27: image = "7craknew.png"
        case 28: image = "8craknew.png"
        case 29: image = "9craknew.png"
        case 30: image = "red.png"
        case 31: image = "northnew.png"
        case 32: image = "southnew.png"
        case 33: image = "westnew.png"
        case 34: image = "eastnew.png"
        case 35: image = "flowernew.png"
        case 36: image = "joker.png"
        default: image = ""
        }
        return image
    }
    
    
    func getDisplayName() -> String {
        return getDisplayNameForId(id: id)
    }
    
    func getDisplayNameForJoker() -> String {
        return getDisplayNameForId(id: jokerId)
    }
    
    private func getDisplayNameForId(id: Int) -> String {
        var  tileName = ""
        switch(id) {
        case 1: tileName = "1 Dot"
        case 2: tileName = "2 Dot"
        case 3: tileName = "3 Dot"
        case 4: tileName = "4 Dot"
        case 5: tileName = "5 Dot"
        case 6: tileName = "6 Dot"
        case 7: tileName = "7 Dot"
        case 8: tileName = "8 Dot"
        case 9: tileName = "9 Dot"
        case 10: tileName = "Soap"
        case 11: tileName = "1 Bam"
        case 12: tileName = "2 Bam"
        case 13: tileName = "3 Bam"
        case 14: tileName = "4 Bam"
        case 15: tileName = "5 Bam"
        case 16: tileName = "6 Bam"
        case 17: tileName = "7 Bam"
        case 18: tileName = "8 Bam"
        case 19: tileName = "9 Bam"
        case 20: tileName = "Green Dragon"
        case 21: tileName = "1 Crak"
        case 22: tileName = "2 Crak"
        case 23: tileName = "3 Crak"
        case 24: tileName = "4 Crak"
        case 25: tileName = "5 Crak"
        case 26: tileName = "6 Crak"
        case 27: tileName = "7 Crak"
        case 28: tileName = "8 Crak"
        case 29: tileName = "9 Crak"
        case 30: tileName = "Red Dragon"
        case 31: tileName = "North Wind"
        case 32: tileName = "South Wind"
        case 33: tileName = "West Wind"
        case 34: tileName = "East Wind"
        case 35: tileName = "Flower"
        case 36: tileName = "Joker"
        default: tileName = ""
        }
        return tileName
    }
    
    
}
