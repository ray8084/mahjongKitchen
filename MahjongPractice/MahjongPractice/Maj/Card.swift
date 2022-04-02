//
//  Card.swift
//  Mahjong2017
//
//  Created by Ray on 8/15/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import UIKit

class Card {
    var letterPatterns: [LetterPattern] = []
    let defaults = UserDefaults.standard
    var showLosses = false
    
    init() {
    }
    
    func copy (_ copy: Card) {
        self.showLosses = copy.showLosses
        // ? letterpatterns
    }
    
    func buildIdMaps() {
        for lp in letterPatterns {
            lp.buildIdMap()
        }
    }
    
    func count() -> Int {
        return letterPatterns.count
    }
    
    func text(_ index: Int) -> NSAttributedString {
        if index < letterPatterns.count {
            return letterPatterns[index].text
        } else {
            return NSAttributedString(string: "")
        }
    }
    
    func note(_ index: Int) -> NSAttributedString {
        if index < letterPatterns.count {
            return toBlack( letterPatterns[index].note)
        } else {
            return NSAttributedString(string: "")
        }
    }
    
    func toBlack(_ string: NSMutableAttributedString) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(string: string.mutableString as String)
        let black = [NSAttributedString.Key.foregroundColor: UIColor.black]
        text.addAttributes(black, range: NSRange(location:0, length:text.length))
        return text
    }
    
    func hidePattern(_ index: Int) {
        if index < letterPatterns.count {
            print("hide \(index) \(letterPatterns[index].id) \(letterPatterns[index].text.string)")
            letterPatterns[index].hide = true
        }
    }
    
    func unhideAll() {
        for lp in letterPatterns {
            lp.hide = false
        }
    }
    
    func isPatternHidden(id: Int) -> Bool {
        var hidden = false
        for lp in letterPatterns {
            if lp.id == id {
                hidden = lp.hide
                break
            }
        }
        return hidden
    }

    func add(_ string: String, mask: String, note: String, family: Int, concealed: Bool) -> LetterPattern {
        return add(string, mask: mask, note: note, family: family, concealed: concealed, points: 0)
    }
    
    func add(_ string: String, mask: String, note: String, family: Int, concealed: Bool, points: Int) -> LetterPattern {
        let red = [NSAttributedString.Key.foregroundColor: UIColor.red]
        let green = [NSAttributedString.Key.foregroundColor: UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)  ]
        let m = NSMutableAttributedString(string: string)
        var index = 0
        for char in mask {
            switch char {
            case "g":
                m.addAttributes(green, range: NSRange(location:index,length:1))
                break
            case "r":
                m.addAttributes(red, range: NSRange(location:index,length:1))
                break
            default:
                let black = [NSAttributedString.Key.foregroundColor: UIColor.black]
                m.addAttributes(black, range: NSRange(location:index,length:1))
                break
            }
            index += 1
        }
        
        //print(index)
        //print(m.length)
        
        // Assumes (C) in the concealed string, if this crashes check it
        if concealed {
            for i in index...m.length-1 {
                let black = [NSAttributedString.Key.foregroundColor: UIColor.black]
                m.addAttributes(black, range: NSRange(location:i,length:1))
            }
        }
       
        let p = LetterPattern(text: m, mask: mask, note: note, id: letterPatterns.count, family: family, concealed: concealed, points: points)
        letterPatterns.append(p)
        return p
    }
    
    func match(_ tiles: [Tile], ignoreFilters: Bool) {
        for p in letterPatterns {
            p.match(tiles, ignoreFilters: ignoreFilters)
        }
    }
    
    func rackFilter(_ rack: Hand) {
        let idMap = TileIdMap(rack: rack)
        for lp in letterPatterns {
            lp.rackFilter(idMap)
        }
    }
    
    func clearRackFilter() {
        for lp in letterPatterns {
            lp.clearRackFilter()
        }
    }
    
    func loadSavedValues() {
        for p in letterPatterns {
            p.wins = defaults.integer( forKey: p.key() )
            p.losses = defaults.integer( forKey: p.lossKey() )
            p.winsSinceVersion22 = defaults.integer( forKey: p.winKeySinceVersion22() )
        }
    }
    
    func addWin(_ index: Int) {
        if index < letterPatterns.count {
            let p = letterPatterns[index]
            p.winsSinceVersion22 += 1
            defaults.set(p.winsSinceVersion22, forKey: p.winKeySinceVersion22())
        }
    }
    
    func addLoss(_ letterPattern: LetterPattern) {
        letterPattern.losses += 1
        defaults.set(letterPattern.losses, forKey: letterPattern.lossKey())
    }
    
    func clearStats() {
        for p in letterPatterns {
            defaults.set(0, forKey: p.key())
            defaults.set(0, forKey: p.lossKey())
            defaults.set(0, forKey: p.winKeySinceVersion22())
        }
    }
    
    func winCountText(_ index: Int) -> NSMutableAttributedString {
        var winText = NSMutableAttributedString()
        if index < letterPatterns.count {
            let p = letterPatterns[index]
            if showLosses {
                let wins = p.getWins(showLosses: true)
                if index == 0 {
                    winText = NSMutableAttributedString(string: String(wins) + "-" + String(p.losses) + " Win-Loss")
                } else {
                    winText = NSMutableAttributedString(string: String(wins) + "-" + String(p.losses) )
                }
            } else {
                let wins = p.getWins(showLosses: false)
                if (index == 0) && (wins == 1) {
                    winText = NSMutableAttributedString(string: String(wins) + " Win")
                } else if (index == 0) {
                    winText = NSMutableAttributedString(string: String(wins) + " Wins")
                } else {
                    winText = NSMutableAttributedString(string: String(wins) )
                }
            }
        }
        return toBlack(winText)
    }
    
    func getTotalWins() -> Int {
        var total = 0
        for p in letterPatterns {
            total += p.getWins(showLosses: showLosses)
        }
        return total
    }
    
    func matchCountText(_ index: Int) -> NSAttributedString {
        var matchText = NSMutableAttributedString()
        if index < letterPatterns.count {
            let p = letterPatterns[index]
            if p.matchCount > 0 {
                if index == 0 {
                    matchText = NSMutableAttributedString(string: String(p.matchCount) + " Tiles")
                } else {
                    matchText = NSMutableAttributedString(string: String(p.matchCount))
                }
            }
        }
        return toBlack(matchText)
    }
    
    func winningHand(maj: Maj) -> String {
        var hand = ""
        match((maj.east.rack?.tiles)!, ignoreFilters: true)
        hand = getHand( winningIndex(maj.east.rack!.jokerCount()) )
        match((maj.east.rack?.tiles)!, ignoreFilters: false)
        return hand
    }
    
    func winningHand(hand: Hand) -> String {
        match(hand.rack!.tiles, ignoreFilters: false)
        return getHand( winningIndex(hand.rack!.jokerCount()) )
    }
    
    func getHand(_ index: Int) -> String {
        var hand = ""
        if index < letterPatterns.count {
            hand = letterPatterns[index].text.string
            if letterPatterns[index].note.string != "" {
                hand = hand + " \n " + letterPatterns[index].note.string
            }
        }
        return hand
    }
    
    func getLetterPattern(_ index: Int) -> LetterPattern {
        var letterPattern = letterPatterns[0]
        if index < letterPatterns.count {
            letterPattern = letterPatterns[index]
        }
        return letterPattern
    }
    
    func winningIndex(_ jokerCount: Int) -> Int {
        var index = 0
        var found = false
        for p in letterPatterns {
            if p.matchCount == 14 {
                found = true
                break
            }
            index += 1
        }
        return found ? index : 0xFFFF
    }

    func getClosestPattern(tiles: [Tile]) -> LetterPattern {
        match(tiles, ignoreFilters: true)
        var closet = letterPatterns[0]
        for letterPattern in letterPatterns {
            if letterPattern.matchCount > closet.matchCount {
                closet = letterPattern
            }
        }
        return closet
    }
    
    // --------------------------------------------------------------
    //  stats
    
    func getTotalWins(family: Int) -> String {
        var count = 0
        for lp in letterPatterns {
            if (family == Family.all) || (lp.family == family) {
                count += lp.getWins(showLosses: showLosses)
            }
        }
        return String(count)
    }

    func getTotalWinCount() -> Int {
        var count = 0
        for lp in letterPatterns {
            count += lp.getWins(showLosses: showLosses)
        }
        return count
    }
    
    func getPatternWins(family: Int) -> String {
        var count = 0
        var familyTotal = 0
        for lp in letterPatterns {
            if (family == Family.all) || (lp.family == family) {
                count += lp.getWins(showLosses: showLosses) > 0 ? 1 : 0
                familyTotal += 1
            }
        }
        return String(count) + "/" + String(familyTotal)
    }

    func getPatternWinPercentage(family: Int) -> Double {
        var count = 0.0
        var familyTotal = 0.0
        for lp in letterPatterns {
            if (family == Family.all) || (lp.family == family) {
                count += lp.getWins(showLosses: showLosses) > 0 ? 1 : 0
                familyTotal += 1
            }
        }
        return count/familyTotal
    }
    
    func getPatternWinPercentageString(family: Int) -> String {
        var count = 0.0
        var familyTotal = 0.0
        for lp in letterPatterns {
            if (family == Family.all) || (lp.family == family) {
                count += lp.getWins(showLosses: showLosses) > 0 ? 1 : 0
                familyTotal += 1
            }
        }
        var winPercentage = String("")
        if familyTotal != 0 {
            winPercentage = String(Int(count/familyTotal * 100.0)) + "%"
        }
        return winPercentage;
    }
    
    func getLosses(family: Int) -> String {
        var count = 0
        for lp in letterPatterns {
            if (family == Family.all) || (lp.family == family) {
                count += lp.losses
            }
        }
        return String(count)
    }
    
    func getWinLossPercent(family: Int) -> String {
        var lossCount = 0.0
        var winCount = 0.0
        for lp in letterPatterns {
            if (family == Family.all) || (lp.family == family) {
                lossCount += Double(lp.losses)
                winCount += Double(lp.winsSinceVersion22)
            }
        }
        var winLossPercentage = String("0%")
        if (lossCount + winCount) != 0 {
            winLossPercentage = String(Int(winCount/(lossCount + winCount) * 100.0)) + "%"
        }
        return winLossPercentage;
    }
 
    
    // -----------------------------------------------------------------------------------------
    //
    //  Standard 2468
    //
    // -----------------------------------------------------------------------------------------
    
    func addF2468_32234_1() {
        let p = add("FFF 22 44 666 8888", mask: "000 00 00 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF2468_41234_1() {
        let p = add("FFFF 2 44 666 8888", mask: "0000 0 00 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
        
    func add2468_3434_2() {
        let p = add("222 4444 666 8888", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func add2468_3344_2() {
        let p = add("222 444 6666 8888", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func add2468_4442_1() {
        let p = add("2222 4444 6666 88", mask: "0000 0000 0000 00", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func add2468_3344_3() {
        let p = add("222 444 6666 8888", mask: "ggg ggg rrrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF2468_24224_2() {
        let p = add("FF 2222 44 66 8888", mask: "00 gggg rr rr gggg", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func addFD2468D_2411114_3() {
        let p = add("FF DDDD 2 4 6 8 DDDD", mask: "00 gggg 0 0 0 0 rrrr", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p.add([35,35, 10,10,10,10, 12,14,16,18, 30,30,30,30])
        p.add([35,35, 20,20,20,20, 2,4,6,8, 30,30,30,30])
        p.add([35,35, 10,10,10,10, 22,24,26,28, 20,20,20,20])
    }
    
    func add246822_311333_3() {
        let p = add("222 4 6 888 222 222 (C)", mask: "ggg g g ggg rrr 000", note: "Like Pungs 2,4,6,8 in Other 2 Suits",  family: Family.f2468, concealed: true, points: 25)
        p.add([2,2,2, 4, 6, 8,8,8, 12,12,12, 22,22,22])
        p.add([2,2,2, 4, 6, 8,8,8, 14,14,14, 24,24,24])
        p.add([2,2,2, 4, 6, 8,8,8, 16,16,16, 26,26,26])
        p.add([2,2,2, 4, 6, 8,8,8, 18,18,18, 28,28,28])
        p.add([12,12,12, 14, 16, 18,18,18, 2,2,2, 22,22,22])
        p.add([12,12,12, 14, 16, 18,18,18, 4,4,4, 24,24,24])
        p.add([12,12,12, 14, 16, 18,18,18, 6,6,6, 26,26,26])
        p.add([12,12,12, 14, 16, 18,18,18, 8,8,8, 28,28,28])
        p.add([22,22,22, 24, 26, 28,28,28, 2,2,2, 12,12,12])
        p.add([22,22,22, 24, 26, 28,28,28, 4,4,4, 14,14,14])
        p.add([22,22,22, 24, 26, 28,28,28, 6,6,6, 16,16,16])
        p.add([22,22,22, 24, 26, 28,28,28, 8,8,8, 18,18,18])
    }
    
    func add24468_22334_3() {
        let p = add("22 44 444 666 8888", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
        
    func add24D68_23432_1() {
        let p = add("22 444 DDDD 666 88", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func add2468D_22334_1() {
        let p = add("22 44 666 888 DDDD", mask: "00 00 000 000 0000", note: "Any 1 Suit, Matching Dragon",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
    
    func add24F68_23432_1() {
        let p = add("22 444 FFFF 666 88", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
            
    func add2468_42422_3() {
        let p = add("2222 44 6666 88 88", mask: "0000 00 0000 gg rr", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 30)
        p.add([2,2,2,2, 4,4, 6,6,6,6, 18,18, 28,28])
        p.add([12,12,12,12, 14,14, 16,16,16,16, 8,8, 28,28])
        p.add([22,22,22,22, 24,24, 26,26,26,26, 8,8, 18,18])
    }
    
    func add2468D_22334_3() {
        let p = add("22 44 666 888 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p.generateList()
    }
        
    func add2468D_33332_C() {
        let p = add("222 444 666 888 DD (C)", mask: "000 000 000 000 00", note: "Any 1 Suit",  family: Family.f2468, concealed: true, points: 30)
        p.generateList()
    }
        
    func add24688_32333_C() {
        let p = add("222 44 666 888 888 (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Suits",  family: Family.f2468, concealed: true, points: 30)
        p.add([2,2,2, 4,4, 6,6,6, 18,18,18, 28,28,28])
        p.add([12,12,12, 14,14, 16,16,16, 8,8,8, 28,28,28])
        p.add([22,22,22, 24,24, 26,26,26, 8,8,8, 18,18,18])
    }
    
    func addF2348_23333_C() {
        let p = add("FF 222 444 666 888 (C)", mask: "00 000 000 000 000", note: "",  family: Family.f2468, concealed: true, points: 30)
        p.generateList()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Standard Like Num
    //
    // -----------------------------------------------------------------------------------------
    
    func addLikeF111_2444_3() {
        let p = add("FF 1111 1111 1111", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d,d, b,b,b,b, c,c,c,c])
        }
    }
    
    func addLike1D1D1_22334_C() {
        let p = add("11 DD 111 DDD 1111 (C)", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: true, points: 30)
        p.generateList()
    }
    
    func addLikeF1D1_2444_3() {
        let p = add("FF 1111 DDDD 1111", mask: "00 gggg rrrr 0000", note: "Any Like No.",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, b,b,b,b, 10,10,10,10, c,c,c,c])
            p.add([35,35, d,d,d,d, 20,20,20,20, c,c,c,c])
            p.add([35,35, d,d,d,d, 30,30,30,30, b,b,b,b])
        }
    }
    
    func addLikeF1F1_3434_2() {
        let p = add("FFF 1111 FFF 1111", mask: "000 gggg 000 rrrr", note: "Any Like No.",  family: Family.likeNumbers, concealed: false, points: 30)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35, d,d,d,d, 35,35,35, b,b,b,b])
            p.add([35,35,35, d,d,d,d, 35,35,35, c,c,c,c])
            p.add([35,35,35, b,b,b,b, 35,35,35, c,c,c,c])
        }
    }
    
    func addLikeF1D1D_24242_2() {
        let p = add("FF 1111 DD 1111 DD", mask: "00 gggg gg rrrr rr", note: "Any 2 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d,d, 10,10, b,b,b,b, 20,20])
            p.add([35,35, d,d,d,d, 10,10, c,c,c,c, 30,30])
            p.add([35,35, b,b,b,b, 20,20, c,c,c,c, 30,30])
        }
    }
    
    func addLikeF111_5234_3() {
        let p = add("FFFFF 11 111 1111", mask: "00000 gg rrr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35,35,35, d,d, b,b,b, c,c,c,c])
            p.add([35,35,35,35,35, d,d, c,c,c, b,b,b,b])
            p.add([35,35,35,35,35, b,b, d,d,d, c,c,c,c])
            p.add([35,35,35,35,35, b,b, c,c,c, d,d,d,d])
            p.add([35,35,35,35,35, c,c, d,d,d, b,b,b,b])
            p.add([35,35,35,35,35, c,c, b,b,b, d,d,d,d])
        }
    }
    
    func addLikeF111_4424_3() {
        let p = add("FFFF 1111 11 1111", mask: "0000 gggg rr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35,35, d,d,d,d, b,b, c,c,c,c])
            p.add([35,35,35,35, d,d,d,d, c,c, b,b,b,b])
            p.add([35,35,35,35, b,b,b,b, d,d, c,c,c,c])
        }
    }
    
    func addLike1D1D_3434_2() {
        let p = add("111 DDDD 111 DDDD", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits, Matching Dragons",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d, 10,10,10,10, b,b,b, 20,20,20,20])
            p.add([d,d,d, 10,10,10,10, c,c,c, 30,30,30,30])
            p.add([b,b,b, 20,20,20,20, c,c,c, 30,30,30,30])
        }
    }
    
    func addLikeF1NEWS1_2444_2() {
        let p = add("FF 1111 NEWS 1111", mask: "00 gggg 0000 rrrr", note: "Any 2 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d,d, 31,34,33,32, b,b,b,b])
            p.add([35,35, d,d,d,d, 31,34,33,32, c,c,c,c])
            p.add([35,35, b,b,b,b, 31,34,33,32, c,c,c,c])
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Standard Quints
    //
    // -----------------------------------------------------------------------------------------
    
    func addQ1234_2345_1() {
        let p = add("11 222 3333 44444", mask: "00 000 0000 00000", note: "Any 4 Consec Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1,d+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3,d+3])
            p.add([b,b, b+1,b+1,b+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3,b+3])
            p.add([c,c, c+1,c+1,c+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3,c+3])
        }
    }
    
    func addQ1234_5225_2() {
        let p = add("11111 22 33 44444", mask: "ggggg rr rr ggggg", note: "Any 2 Suits, Any 4 Consec Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d,d, b+1,b+1, b+2,b+2, d+3,d+3,d+3,d+3,d+3])
            p.add([d,d,d,d,d, c+1,c+1, c+2,c+2, d+3,d+3,d+3,d+3,d+3])
            p.add([b,b,b,b,b, d+1,d+1, d+2,d+2, b+3,b+3,b+3,b+3,b+3])
            p.add([b,b,b,b,b, c+1,c+1, c+2,c+2, b+3,b+3,b+3,b+3,b+3])
            p.add([c,c,c,c,c, d+1,d+1, d+2,d+2, c+3,c+3,c+3,c+3,c+3])
            p.add([c,c,c,c,c, b+1,b+1, b+2,b+2, c+3,c+3,c+3,c+3,c+3])
        }
    }
    
    func addQ1212_2525_2() {
        let p = add("11 22222 11 22222", mask: "gg ggggg rr rrrrr", note: "Any 2 Suits, Any 2 Consec Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1,d+1,d+1,d+1, b,b, b+1,b+1,b+1,b+1,b+1])
            p.add([d,d, d+1,d+1,d+1,d+1,d+1, c,c, c+1,c+1,c+1,c+1,c+1])
            p.add([b,b, b+1,b+1,b+1,b+1,b+1, c,c, c+1,c+1,c+1,c+1,c+1])
        }
    }
    
    func addQFN1_455() {
        let p = add("FFFF NNNNN 11111", mask: "0000 00000 ggggg", note: "Any Wind, Any No.",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([35,35,35,35, w,w,w,w,w, d,d,d,d,d])
                p.add([35,35,35,35, w,w,w,w,w, b,b,b,b,b])
                p.add([35,35,35,35, w,w,w,w,w, c,c,c,c,c])
            }
        }
    }
    
    func addQF1N_545() {
        let p = add("FFFFF 1111 NNNNN", mask: "00000 0000 00000", note: "Any Wind, Any No.",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([35,35,35,35,35, d,d,d,d, w,w,w,w,w])
                p.add([35,35,35,35,35, b,b,b,b, w,w,w,w,w])
                p.add([35,35,35,35,35, c,c,c,c, w,w,w,w,w])
            }
        }
    }
    
    func addQ123D_5252_1() {
        let p = add("11111 22 33333 DD", mask: "00000 00 00000 00", note: "Any 3 Consec Nos. Dragons Match",  family: Family.quints, concealed: false, points: 45)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d,d, d+1,d+1, d+2,d+2,d+2,d+2,d+2, 10,10])
            p.add([b,b,b,b,b, b+1,b+1, b+2,b+2,b+2,b+2,b+2, 20,20])
            p.add([c,c,c,c,c, c+1,c+1, c+2,c+2,c+2,c+2,c+2, 30,30])
        }
    }
    
    func addQ1D1_545_3() {
        let p = add("11111 DDDD 11111", mask: "ggggg 0000 rrrrr", note: "Any Like Nos. Opposite Dragon",  family: Family.quints, concealed: false, points: 40)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d,d, 20,20,20,20, c,c,c,c,c])
            p.add([d,d,d,d,d, 30,30,30,30, b,b,b,b,b])
            p.add([b,b,b,b,b, 10,10,10,10, c,c,c,c,c])
        }
    }
    
    func addQND1_545() {
        let p = add("NNNNN DDDD 11111", mask: "00000 gggg rrrrr", note: "Any Wind, Dragon or No.",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([w,w,w,w,w, 10,10,10,10, d,d,d,d,d])
                p.add([w,w,w,w,w, 20,20,20,20, d,d,d,d,d])
                p.add([w,w,w,w,w, 30,30,30,30, d,d,d,d,d])
                p.add([w,w,w,w,w, 10,10,10,10, b,b,b,b,b])
                p.add([w,w,w,w,w, 20,20,20,20, b,b,b,b,b])
                p.add([w,w,w,w,w, 30,30,30,30, b,b,b,b,b])
                p.add([w,w,w,w,w, 10,10,10,10, c,c,c,c,c])
                p.add([w,w,w,w,w, 20,20,20,20, c,c,c,c,c])
                p.add([w,w,w,w,w, 30,30,30,30, c,c,c,c,c])
            }
        }
    }
    
    func addQDN1_545() {
        let p = add("DDDDD NNNN 11111", mask: "00000 0000 00000", note: "Any Dragon, Any Wind, Any No.",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([10,10,10,10,10, w,w,w,w, d,d,d,d,d])
                p.add([20,20,20,20,20, w,w,w,w, d,d,d,d,d])
                p.add([30,30,30,30,30, w,w,w,w, d,d,d,d,d])
                p.add([10,10,10,10,10, w,w,w,w, b,b,b,b,b])
                p.add([20,20,20,20,20, w,w,w,w, b,b,b,b,b])
                p.add([30,30,30,30,30, w,w,w,w, b,b,b,b,b])
                p.add([10,10,10,10,10, w,w,w,w, c,c,c,c,c])
                p.add([20,20,20,20,20, w,w,w,w, c,c,c,c,c])
                p.add([30,30,30,30,30, w,w,w,w, c,c,c,c,c])
            }
        }
    }
    
    func addQ111_545_3() {
        let p = add("11111 1111 11111", mask: "ggggg rrrr 00000", note: "Any Like No.",  family: Family.quints, concealed: false, points: 40)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d,d, b,b,b,b, c,c,c,c,c])
            p.add([d,d,d,d,d, c,c,c,c, b,b,b,b,b])
            p.add([b,b,b,b,b, d,d,d,d, c,c,c,c,c])
        }
    }
    
    func addQF123_2525_1() {
        let p = add("FF 11111 22 33333", mask: "00 00000 00 00000", note: "Any 3 Consec. Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d,d,d, d+1,d+1, d+2,d+2,d+2,d+2,d+2])
            p.add([35,35, b,b,b,b,b, b+1,b+1, b+2,b+2,b+2,b+2,b+2])
            p.add([35,35, c,c,c,c,c, c+1,c+1, c+2,c+2,c+2,c+2,c+2])
        }
    }
    
    func addQF12_455_1() {
        let p = add("FFFF 11111 22222", mask: "0000 00000 00000", note: "Any 1 Suit, Any 2 Consec. Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35,35, d,d,d,d,d, d+1,d+1,d+1,d+1,d+1])
            p.add([35,35,35,35, b,b,b,b,b, b+1,b+1,b+1,b+1,b+1])
            p.add([35,35,35,35, c,c,c,c,c, c+1,c+1,c+1,c+1,c+1])
        }
    }
    
    func addQ12311_455_3() {
        let p = add("1123 11111 11111", mask: "gggg rrrrr 00000", note: "Any Run, Any Pair",  family: Family.quints, concealed: false, points: 40)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d+1,d+2, b,b,b,b,b, c,c,c,c,c])
            p.add([b,b,b+1,b+2, d,d,d,d,d, c,c,c,c,c])
            p.add([c,c,c+1,c+2, d,d,d,d,d, b,b,b,b,b])
            p.add([d,d+1,d+1,d+2, b+1,b+1,b+1,b+1,b+1, c+1,c+1,c+1,c+1,c+1])
            p.add([b,b+1,b+1,b+2, d+1,d+1,d+1,d+1,d+1, c+1,c+1,c+1,c+1,c+1])
            p.add([c,c+1,c+1,c+2, d+1,d+1,d+1,d+1,d+1, b+1,b+1,b+1,b+1,b+1])
            p.add([d,d+1,d+2,d+2, b+2,b+2,b+2,b+2,b+2, c+2,c+2,c+2,c+2,c+2])
            p.add([b,b+1,b+2,b+2, d+2,d+2,d+2,d+2,d+2, c+2,c+2,c+2,c+2,c+2])
            p.add([c,c+1,c+2,c+2, d+2,d+2,d+2,d+2,d+2, b+2,b+2,b+2,b+2,b+2])
        }
    }
    
    func addQ1233_455_3() {
        let p = add("1122 33333 33333", mask: "gggg rrrrr 00000", note: "Any 3 Suits, Any 3 Consec No.",  family: Family.quints, concealed: false, points: 40)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d+1,d+1, b+2,b+2,b+2,b+2,b+2, c+2,c+2,c+2,c+2,c+2])
            p.add([b,b,b+1,b+1, d+2,d+2,d+2,d+2,d+2, c+2,c+2,c+2,c+2,c+2])
            p.add([c,c,c+1,c+1, d+2,d+2,d+2,d+2,d+2, b+2,b+2,b+2,b+2,b+2])
        }
    }
    
    func addQ1234_5225_1() {
        let p = add("11111 22 33 44444", mask: "00000 00 00 00000", note: "Any 4 Consec. Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d,d, d+1,d+1, d+2,d+2, d+3,d+3,d+3,d+3,d+3])
            p.add([b,b,b,b,b, b+1,b+1, b+2,b+2, b+3,b+3,b+3,b+3,b+3])
            p.add([c,c,c,c,c, c+1,c+1, c+2,c+2, c+3,c+3,c+3,c+3,c+3])
        }
    }
    
    func addQ123_545_1() {
        let p = add("11111 2222 33333", mask: "00000 0000 00000", note: "Any 3 Consec, Nos.",  family: Family.quints, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d,d, d+1,d+1,d+1,d+1, d+2,d+2,d+2,d+2,d+2])
            p.add([b,b,b,b,b, b+1,b+1,b+1,b+1, b+2,b+2,b+2,b+2,b+2])
            p.add([c,c,c,c,c, c+1,c+1,c+1,c+1, c+2,c+2,c+2,c+2,c+2])
        }
    }
    
    func addQ123_545_3() {
        let p = add("11111 2222 33333", mask: "ggggg rrrr 00000", note: "Any 3 Consec, Nos.",  family: Family.quints, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d,d, b+1,b+1,b+1,b+1, c+2,c+2,c+2,c+2,c+2])
            p.add([d,d,d,d,d, c+1,c+1,c+1,c+1, b+2,b+2,b+2,b+2,b+2])
            p.add([b,b,b,b,b, d+1,d+1,d+1,d+1, c+2,c+2,c+2,c+2,c+2])
            p.add([b,b,b,b,b, c+1,c+1,c+1,c+1, d+2,d+2,d+2,d+2,d+2])
            p.add([c,c,c,c,c, d+1,d+1,d+1,d+1, b+2,b+2,b+2,b+2,b+2])
            p.add([c,c,c,c,c, b+1,b+1,b+1,b+1, d+2,d+2,d+2,d+2,d+2])
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Standard Runs
    //
    // -----------------------------------------------------------------------------------------
    
    func add12345_23432_1() {
        let p = add("11 222 3333 444 55", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.run, concealed: false, points: 25)
        p.add([1,1, 2,2,2, 3,3,3,3, 4,4,4, 5,5])
        p.add([11,11, 12,12,12, 13,13,13,13, 14,14,14, 15,15])
        p.add([21,21, 22,22,22, 23,23,23,23, 24,24,24, 25,25])
    }
    
    func add56789_23432_1() {
        let p = add("55 666 7777 888 99", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.run, concealed: false, points: 25 )
        p.add([5,5, 6,6,6, 7,7,7,7, 8,8,8, 9,9])
        p.add([15,15, 16,16,16, 17,17,17,17, 18,18,18, 19,19])
        p.add([25,25, 26,26,26, 27,27,27,27, 28,28,28, 29,29])
    }
    
    func add1234_3434_2() {
        let p = add("111 2222 333 4444", mask: "ggg gggg rrr rrrr", note: "Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d, d+1,d+1,d+1,d+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p.add([d,d,d, d+1,d+1,d+1,d+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p.add([b,b,b, b+1,b+1,b+1,b+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p.add([b,b,b, b+1,b+1,b+1,b+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p.add([c,c,c, c+1,c+1,c+1,c+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p.add([c,c,c, c+1,c+1,c+1,c+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3])
        }
    }
    
    func addF123_2444_1() {
        let p = add("FF 1111 2222 3333", mask: "00 0000 0000 0000", note: "Any 1 Suit, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d,d, d+1,d+1,d+1,d+1, d+2,d+2,d+2,d+2])
            p.add([35,35, b,b,b,b, b+1,b+1,b+1,b+1, b+2,b+2,b+2,b+2])
            p.add([35,35, c,c,c,c, c+1,c+1,c+1,c+1, c+2,c+2,c+2,c+2])
        }
    }
    
    func addF123_5234_1() {
        let p = add("FFFFF 11 222 3333", mask: "00000 00 000 0000", note: "Any 1 Suit, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35,35,35, d,d, d+1,d+1,d+1, d+2,d+2,d+2,d+2])
            p.add([35,35,35,35,35, b,b, b+1,b+1,b+1, b+2,b+2,b+2,b+2])
            p.add([35,35,35,35,35, c,c, c+1,c+1,c+1, c+2,c+2,c+2,c+2])
        }
    }
    
    func addF123D_42233_1() {
        let p = add("FFFF 11 22 333 DDD", mask: "0000 00 00 000 000", note: "Any Run, Matching Dragons",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35,35, d,d, d+1,d+1, d+2,d+2,d+2, 10,10,10])
            p.add([35,35,35,35, b,b, b+1,b+1, b+2,b+2,b+2, 20,20,20])
            p.add([35,35,35,35, c,c, c+1,c+1, c+2,c+2,c+2, 30,30,30])
        }
    }
    
    func addF123_2444_3() {
        let p = add("FF 1111 2222 3333", mask: "00 gggg rrrr 0000", note: "Any 3 Suits, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d,d, b+1,b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p.add([35,35, d,d,d,d, c+1,c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p.add([35,35, b,b,b,b, d+1,d+1,d+1,d+1, c+2,c+2,c+2,c+2])
            p.add([35,35, b,b,b,b, c+1,c+1,c+1,c+1, d+2,d+2,d+2,d+2])
            p.add([35,35, c,c,c,c, d+1,d+1,d+1,d+1, b+2,b+2,b+2,b+2])
            p.add([35,35, c,c,c,c, b+1,b+1,b+1,b+1, d+2,d+2,d+2,d+2])
        }
    }
    
    func add12344_22244_3() {
        let p = add("11 22 33 4444 4444", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits, Any Run",  family: Family.run, concealed: false, points: 30)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1, d+2,d+2, b+3,b+3,b+3,b+3, c+3,c+3,c+3,c+3])
            p.add([b,b, b+1,b+1, b+2,b+2, d+3,d+3,d+3,d+3, c+3,c+3,c+3,c+3])
            p.add([c,c, c+1,c+1, c+2,c+2, d+3,d+3,d+3,d+3, b+3,b+3,b+3,b+3])
        }
    }
    
    func addF12D_3443_1() {
        let p = add("FFF 1111 2222 DDD", mask: "000 0000 0000 000", note: "Any 1 Suit",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35, d,d,d,d, d+1,d+1,d+1,d+1, 10,10,10])
            p.add([35,35,35, b,b,b,b, b+1,b+1,b+1,b+1, 20,20,20])
            p.add([35,35,35, c,c,c,c, c+1,c+1,c+1,c+1, 30,30,30])
        }
    }
    
    func addF1F2_3434_2() {
        let p = add("FFF 1111 FFF 2222", mask: "000 gggg 000 rrrr", note: "Any 2 Suits, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35, d,d,d,d, 35,35,35, b+1,b+1,b+1,b+1])
            p.add([35,35,35, d,d,d,d, 35,35,35, c+1,c+1,c+1,c+1])
            p.add([35,35,35, b,b,b,b, 35,35,35, d+1,d+1,d+1,d+1])
            p.add([35,35,35, b,b,b,b, 35,35,35, c+1,c+1,c+1,c+1])
            p.add([35,35,35, c,c,c,c, 35,35,35, d+1,d+1,d+1,d+1])
            p.add([35,35,35, c,c,c,c, 35,35,35, b+1,b+1,b+1,b+1])
        }
    }
    
    func add1234D_12344_1() {
        let p = add("1 22 333 4444 DDDD", mask: "0 00 000 0000 0000", note: "Any 1 Suit, Any Run, Matching Dragons",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d, d+1,d+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3, 10,10,10,10])
            p.add([b, b+1,b+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3, 20,20,20,20])
            p.add([c, c+1,c+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3, 30,30,30,30])
        }
    }
    
    
    func addF12D_2444_1() {
        let p = add("FF 1111 2222 DDDD", mask: "00 0000 0000 0000", note: "Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d,d, d+1,d+1,d+1,d+1, 10,10,10,10])
            p.add([35,35, b,b,b,b, b+1,b+1,b+1,b+1, 20,20,20,20])
            p.add([35,35, c,c,c,c, c+1,c+1,c+1,c+1, 30,30,30,30])
        }
    }
    
    func addF12D_4442_1() {
        let p = add("FFFF 1111 2222 DD", mask: "0000 0000 0000 00", note: "Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35,35, d,d,d,d, d+1,d+1,d+1,d+1, 10,10])
            p.add([35,35,35,35, b,b,b,b, b+1,b+1,b+1,b+1, 20,20])
            p.add([35,35,35,35, c,c,c,c, c+1,c+1,c+1,c+1, 30,30])
        }
    }
    
    func addF1212_42323_2() {
        let p = add("FFFF 11 222 11 222", mask: "0000 gg ggg rr rrr", note: "Any 2 Suits, Any 2 Like Consec Nos",  family: Family.run, concealed: false, points: 30)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,35,35, d,d, d+1,d+1,d+1, b,b, b+1,b+1,b+1])
            p.add([35,35,35,35, d,d, d+1,d+1,d+1, c,c, c+1,c+1,c+1])
            p.add([35,35,35,35, b,b, b+1,b+1,b+1, c,c, c+1,c+1,c+1])
        }
    }
    
    func add12322_32333_C() {
        let p = add("111 22 333 222 222 (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Consec Nos, Pungs Match Pair",  family: Family.run, concealed: true, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d, d+1,d+1, d+2,d+2,d+2, b+1,b+1,b+1, c+1,c+1,c+1])
            p.add([b,b,b, b+1,b+1, b+2,b+2,b+2, d+1,d+1,d+1, c+1,c+1,c+1])
            p.add([c,c,c, c+1,c+1, c+2,c+2,c+2, d+1,d+1,d+1, b+1,b+1,b+1])
        }
    }
    
    func add1234_3344_1() {
        let p = add("111 222 3333 4444", mask: "000 000 0000 0000", note: "Any 1 Suit, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d, d+1,d+1,d+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p.add([b,b,b, b+1,b+1,b+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p.add([c,c,c, c+1,c+1,c+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
        }
    }
 
    func add1234_3344_2() {
        let p = add("111 222 3333 4444", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d, d+1,d+1,d+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p.add([d,d,d, d+1,d+1,d+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p.add([b,b,b, b+1,b+1,b+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p.add([b,b,b, b+1,b+1,b+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p.add([c,c,c, c+1,c+1,c+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p.add([c,c,c, c+1,c+1,c+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
        }
    }
    
    func add12345_22244_3() {
        let p = add("11 22 33 4444 5555", mask: "gg gg gg rrrr 0000", note: "Any 5 Consec Nos",  family: Family.run, concealed: false, points: 30)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1, d+2,d+2, b+3,b+3,b+3,b+3, c+4,c+4,c+4,c+4])
            p.add([d,d, d+1,d+1, d+2,d+2, c+3,c+3,c+3,c+3, b+4,b+4,b+4,b+4])
            p.add([b,b, b+1,b+1, b+2,b+2, d+3,d+3,d+3,d+3, c+4,c+4,c+4,c+4])
            p.add([b,b, b+1,b+1, b+2,b+2, c+3,c+3,c+3,c+3, d+4,d+4,d+4,d+4])
            p.add([c,c, c+1,c+1, c+2,c+2, d+3,d+3,d+3,d+3, b+4,b+4,b+4,b+4])
            p.add([c,c, c+1,c+1, c+2,c+2, b+3,b+3,b+3,b+3, d+4,d+4,d+4,d+4])
        }
    }
    
    func add123D_4343_2() {
        let p = add("1111 222 3333 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            let s = 10
            let g = 20
            let r = 30
            p.add([d,d,d,d, b+1,b+1,b+1, d+2,d+2,d+2,d+2, g,g,g])
            p.add([d,d,d,d, c+1,c+1,c+1, d+2,d+2,d+2,d+2, r,r,r])
            p.add([b,b,b,b, d+1,d+1,d+1, b+2,b+2,b+2,b+2, s,s,s])
            p.add([b,b,b,b, c+1,c+1,c+1, b+2,b+2,b+2,b+2, r,r,r])
            p.add([c,c,c,c, d+1,d+1,d+1, c+2,c+2,c+2,c+2, s,s,s])
            p.add([c,c,c,c, b+1,b+1,b+1, c+2,c+2,c+2,c+2, g,g,g])
        }
    }
    
    func addF1212_23333_C() {
        let p9 = add("FF 111 222 111 222 (C)", mask: "00 ggg ggg rrr rrr", note: "Any 2 Suits, Any Run",  family: Family.run, concealed: true, points: 30)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p9.add([35,35, d,d,d, d+1,d+1,d+1, b,b,b, b+1,b+1,b+1])
            p9.add([35,35, d,d,d, d+1,d+1,d+1, c,c,c, c+1,c+1,c+1])
            p9.add([35,35, b,b,b, b+1,b+1,b+1, c,c,c, c+1,c+1,c+1])
        }
    }
    
    func add12123_22334_3() {
        let p = add("11 22 111 222 3333", mask: "gg gg rrr rrr 0000", note: "Any 3 Consec Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1, b,b,b, b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p.add([d,d, d+1,d+1, c,c,c, c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p.add([b,b, b+1,b+1, d,d,d, d+1,d+1,d+1, c+2,c+2,c+2,c+2])
            p.add([b,b, b+1,b+1, c,c,c, c+1,c+1,c+1, d+2,d+2,d+2,d+2])
            p.add([c,c, c+1,c+1, d,d,d, d+1,d+1,d+1, b+2,b+2,b+2,b+2])
            p.add([c,c, c+1,c+1, b,b,b, b+1,b+1,b+1, d+2,d+2,d+2,d+2])
        }
    }
    
    func add12123_23234_3() {
        let p = add("11 222 11 222 3333", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits, Any 3 Consec Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1,d+1, b,b, b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p.add([d,d, d+1,d+1,d+1, c,c, c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p.add([b,b, b+1,b+1,b+1, c,c, c+1,c+1,c+1, d+2,d+2,d+2,d+2])
        }
    }
    
    func add122123_323323_2_C() {
        let p = add("111 2 333 111 2 333 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits, Any Run",  family: Family.run, concealed: true, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d, d+1, d+2,d+2,d+2, b,b,b, b+1, b+2,b+2,b+2])
            p.add([d,d,d, d+1, d+2,d+2,d+2, c,c,c, c+1, c+2,c+2,c+2])
            p.add([b,b,b, b+1, b+2,b+2,b+2, c,c,c, c+1, c+2,c+2,c+2])
        }
    }
    
    func add1212D_23234_3() {
        let p = add("11 222 11 222 DDDD", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits, Any Run, Opp Dragons",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1,d+1, b,b, b+1,b+1,b+1, 30,30,30,30])
            p.add([d,d, d+1,d+1,d+1, c,c, c+1,c+1,c+1, 20,20,20,20])
            p.add([b,b, b+1,b+1,b+1, c,c, c+1,c+1,c+1, 10,10,10,10])
        }
    }
    
    func add12223_42224_3() {
        let p = add("1111 22 22 22 3333", mask: "gggg rr gg 00 gggg", note: "Any Run, Pairs in the Middle",  family: Family.run, concealed: false, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d, d+1,d+1, b+1,b+1, c+1,c+1, d+2,d+2,d+2,d+2])
            p.add([b,b,b,b, d+1,d+1, b+1,b+1, c+1,c+1, b+2,b+2,b+2,b+2])
            p.add([c,c,c,c, d+1,d+1, b+1,b+1, c+1,c+1, c+2,c+2,c+2,c+2])
        }
    }
    
    func add123DD_323333_C() {
        let p = add("111 22 333 DDD DDD (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Consec Nos",  family: Family.run, concealed: true, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d, d+1,d+1, d+2,d+2,d+2, 20,20,20, 30,30,30])
            p.add([b,b,b, b+1,b+1, b+2,b+2,b+2, 10,10,10, 30,30,30])
            p.add([c,c,c, c+1,c+1, c+2,c+2,c+2, 10,10,10, 20,20,20])
        }
    }
    
    func addF12DD_23333_C() {
        let p = add("FF 111 222 DDD DDD (C)", mask: "00 ggg ggg rrr 000", note: "Any 2 Consec Nos, Opp Dragons",  family: Family.run, concealed: true, points: 30)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d, d+1,d+1,d+1, 20,20,20, 30,30,30])
            p.add([35,35, b,b,b, b+1,b+1,b+1, 10,10,10, 30,30,30])
            p.add([35,35, c,c,c, c+1,c+1,c+1, 10,10,10, 20,20,20])
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Standard Odds
    //
    // -----------------------------------------------------------------------------------------
    
    func add13579_23432_1() {
        let p = add("11 333 5555 777 99", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.add([1,1, 3,3,3, 5,5,5,5, 7,7,7, 9,9])
        p.add([11,11, 13,13,13, 15,15,15,15, 17,17,17, 19,19])
        p.add([21,21, 23,23,23, 25,25,25,25, 27,27,27, 29,29])
    }
    
    func add13579_23432_3() {
        let p = add("11 333 5555 777 99", mask: "gg ggg rrrr 000 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.add([1,1, 3,3,3, 15,15,15,15, 27,27,27, 29,29])
        p.add([1,1, 3,3,3, 25,25,25,25, 17,17,17, 19,19])
        p.add([11,11, 13,13,13, 5,5,5,5, 27,27,27, 29,29])
        p.add([11,11, 13,13,13, 25,25,25,25, 7,7,7, 9,9])
        p.add([21,21, 23,23,23, 5,5,5,5, 17,17,17, 19,19])
        p.add([21,21, 23,23,23, 15,15,15,15, 7,7,7, 9,9])
    }

    func add13579_22244_3() {
        let p = add("11 33 55 7777 9999", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 30)
        p.generateList()
    }
    
    func add13579_42224_2() {
        let p = add("1111 33 55 77 9999", mask: "gggg rr rr rr gggg", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 30)
        p.generateList()
    }
        
    func add1335_3434_2() {
        let p = add("111 3333 333 5555", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.add([1,1,1, 3,3,3,3, 13,13,13, 15,15,15,15])
        p.add([1,1,1, 3,3,3,3, 23,23,23, 25,25,25,25])
        p.add([11,11,11, 13,13,13,13, 3,3,3, 5,5,5,5])
        p.add([11,11,11, 13,13,13,13, 23,23,23, 25,25,25,25])
        p.add([21,21,21, 23,23,23,23, 3,3,3, 5,5,5,5])
        p.add([21,21,21, 23,23,23,23, 13,13,13, 15,15,15,15])
    }
    
    func add5779_3434_2() {
        let p = add("555 7777 777 9999", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.add([5,5,5, 7,7,7,7, 17,17,17, 19,19,19,19])
        p.add([5,5,5, 7,7,7,7, 27,27,27, 29,29,29,29])
        p.add([15,15,15, 17,17,17,17, 7,7,7, 9,9,9,9])
        p.add([15,15,15, 17,17,17,17, 27,27,27, 29,29,29,29])
        p.add([25,25,25, 27,27,27,27, 7,7,7, 9,9,9,9])
        p.add([25,25,25, 27,27,27,27, 17,17,17, 19,19,19,19])
    }
    
    func addF135D_22334_1() {
        let p = add("FF 11 333 555 DDDD", mask: "00 00 000 000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF135D_22343_1() {
        let p = add("FF 11 333 5555 DDD", mask: "00 00 000 0000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF579D_22334_1() {
        let p = add("FF 55 777 999 DDDD", mask: "00 00 000 000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF579D_22343_1() {
        let p = add("FF 55 777 9999 DDD", mask: "00 00 000 0000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF135_4424_1(){
        let p = add("FFFF 1111 33 5555", mask: "0000 0000 00 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF135_2444_1() {
        let p = add("FF 1111 3333 5555", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
            
    func addF579_4424_1(){
        let p = add("FFFF 5555 77 9999", mask: "0000 0000 00 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
     
    func addF579_2444_1() {
        let p = add("FF 5555 7777 9999", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func add1335D_22334_3() {
        let p = add("11 33 333 555 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func add13D35_23432_3() {
        let p = add("11 333 DDDD 333 55", mask: "gg ggg rrrr 000 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func add57D79_23432_3() {
        let p = add("55 777 DDDD 777 99", mask: "gg ggg rrrr 000 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func add135D_4343_2() {
        let p = add("1111 333 5555 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func add5779D_22334_3() {
        let p = add("55 77 777 999 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }

    func add579D_4343_2() {
        let p = add("5555 777 9999 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
        
    func add13511_22244_3() {
        let p = add("11 33 55 1111 1111", mask: "gg gg gg rrrr 0000", note: "Kongs Like 1,3,5s",  family: Family.f13579, concealed: false, points: 25)
        p.add([1,1, 3,3, 5,5, 11,11,11,11, 21,21,21,21])
        p.add([11,11, 13,13, 15,15, 1,1,1,1, 21,21,21,21])
        p.add([21,21, 23,23, 25,25, 1,1,1,1, 11,11,11,11])
        p.add([1,1, 3,3, 5,5, 13,13,13,13, 23,23,23,23])
        p.add([11,11, 13,13, 15,15, 3,3,3,3, 23,23,23,23])
        p.add([21,21, 23,23, 25,25, 3,3,3,3, 13,13,13,13])
        p.add([1,1, 3,3, 5,5, 15,15,15,15, 25,25,25,25])
        p.add([11,11, 13,13, 15,15, 5,5,5,5, 25,25,25,25])
        p.add([21,21, 23,23, 25,25, 5,5,5,5, 15,15,15,15])
    }
    
    func add57955_22244_3() {
        let p = add("55 77 99 5555 5555", mask: "gg gg gg rrrr 0000", note: "Kongs Like 5,7,9s",  family: Family.f13579, concealed: false, points: 25)
        p.add([5,5, 7,7, 9,9, 15,15,15,15, 25,25,25,25])
        p.add([15,15, 17,17, 19,19, 5,5,5,5, 25,25,25,25])
        p.add([25,25, 27,27, 29,29, 5,5,5,5, 15,15,15,15])
        p.add([5,5, 7,7, 9,9, 17,17,17,17, 27,27,27,27])
        p.add([15,15, 17,17, 19,19, 7,7,7,7, 27,27,27,27])
        p.add([25,25, 27,27, 29,29, 7,7,7,7, 17,17,17,17])
        p.add([5,5, 7,7, 9,9, 19,19,19,19, 29,29,29,29])
        p.add([15,15, 17,17, 19,19, 9,9,9,9, 29,29,29,29])
        p.add([25,25, 27,27, 29,29, 9,9,9,9, 19,19,19,19])
    }
    
    func add13135_22334_3() {
        let p = add("11 33 111 333 5555", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
    
    func add13135_23234_3() {
        let p = add("11 333 11 333 5555", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.add([1,1, 3,3,3, 11,11, 13,13,13, 25,25,25,25])
        p.add([1,1, 3,3,3, 21,21, 23,23,23, 15,15,15,15])
        p.add([11,11, 13,13,13, 21,21, 23,23,23, 5,5,5,5])
    }
    
    func add13135_33332_C() {
        let p = add("111 333 111 333 55 (C)", mask: "ggg ggg rrr rrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: true, points: 30)
        p.add([1,1,1, 3,3,3, 11,11,11, 13,13,13, 25,25])
        p.add([1,1,1, 3,3,3, 21,21,21, 23,23,23, 15,15])
        p.add([11,11,11, 13,13,13, 21,21,21, 23,23,23, 5,5])
    }
    
    func add57579_33332_C() {
        let p = add("555 777 555 777 99 (C)", mask: "ggg ggg rrr rrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: true, points: 30)
        p.add([5,5,5, 7,7,7, 15,15,15, 17,17,17, 29,29])
        p.add([5,5,5, 7,7,7, 25,25,25, 27,27,27, 19,19])
        p.add([15,15,15, 17,17,17, 25,25,25, 27,27,27, 9,9])
    }
    
    func add57579_22334_3() {
        let p = add("55 77 555 777 9999", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.generateList()
    }
        
    func add57579_23234_3() {
        let p = add("55 777 55 777 9999", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p.add([5,5, 7,7,7, 15,15, 17,17,17, 29,29,29,29])
        p.add([5,5, 7,7,7, 25,25, 27,27,27, 19,19,19,19])
        p.add([15,15, 17,17,17, 25,25, 27,27,27, 9,9,9,9])
    }
    
    func addF1F5_3434_1() {
        let p = add("FFF 1111 FFF 5555", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 30)
        p.generateList()
    }
    
    func addF5F9_3434_1() {
        let p = add("FFF 5555 FFF 9999", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 30)
        p.generateList()
    }
    
    func add135579_313313_C() {
        let p = add("111 3 555 555 7 999 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits, These Nos Only",  family: Family.f13579, concealed: true, points: 30)
        p.generateList()
    }

    func addF135D_2333_C() {
        let p = add("FF 111 333 555 DDD (C)", mask: "00 000 000 000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: true, points: 30)
        p.generateList()
    }
    
    func addF579D_2333_C() {
        let p = add("FF 555 777 999 DDD (C)", mask: "00 000 000 000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: true, points: 30)
        p.generateList()
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Standard Winds
    //
    // -----------------------------------------------------------------------------------------
    
    func addNEWS_4442() {
        let p = add("NNNN EEEE WWWW SS", mask: "0000 0000 0000 00", note: "",  family: Family.winds, concealed: false, points: 25)
        p.add([31,31,31,31, 34,34,34,34, 33,33,33,33, 32,32,])
    }
    
    func addNEWS_4334() {
        let p = add("NNNN EEE WWW SSSS", mask: "0000 000 000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p.add([31,31,31,31, 34,34,34, 33,33,33, 32,32,32,32])
    }
    
    func addNDDDS_42224_3() {
        let p = add("NNNN DD DD DD SSSS", mask: "0000 gg rr 00 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p.add([31,31,31,31, 10,10, 20,20, 30,30, 32,32,32,32])
    }
    
    func addEDDDW_42224_3() {
        let p = add("EEEE DD DD DD WWWW", mask: "0000 gg rr 00 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p.add([33,33,33,33, 10,10, 20,20, 30,30, 34,34,34,34])
    }

    func addFN11S_22442_2() {
        let p = add("FF NN 1111 1111 SS", mask: "00 00 gggg rrrr 00", note: "Any Like Odd Nos",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 1 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([35,35, 31,31, d,d,d,d, b,b,b,b, 32,32])
                p.add([35,35, 31,31, d,d,d,d, c,c,c,c, 32,32])
                p.add([35,35, 31,31, b,b,b,b, c,c,c,c, 32,32])
            }
        }
    }
    
    func add1N1S1_23234_3() {
        let p = add("11 NNN 11 SSS 1111", mask: "gg 000 rr 000 0000", note: "Any Like Odd Nos",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 1 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([d,d, 31,31,31, b,b, 32,32,32, c,c,c,c])
                p.add([d,d, 31,31,31, c,c, 32,32,32, b,b,b,b])
                p.add([b,b, 31,31,31, c,c, 32,32,32, d,d,d,d])
            }
        }
    }

    func addFE22W_22442_2() {
        let p = add("FF EE 2222 2222 WW", mask: "00 00 gggg rrrr 00", note: "Any Like Even Nos",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 0 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([35,35, 34,34, d,d,d,d, b,b,b,b, 33,33])
                p.add([35,35, 34,34, d,d,d,d, c,c,c,c, 33,33])
                p.add([35,35, 34,34, b,b,b,b, c,c,c,c, 33,33])
            }
        }
    }

    func add2E2W2_23234_3() {
        let p = add("22 EEE 22 WWW 2222", mask: "gg 000 rr 000 0000", note: "Any Like Even Nos",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 0 {
                let d = i
                let b = i+10
                let c = i+20
                p.add([d,d, 34,34,34, b,b, 33,33,33, c,c,c,c])
                p.add([d,d, 34,34,34, c,c, 33,33,33, b,b,b,b])
                p.add([b,b, 34,34,34, c,c, 33,33,33, d,d,d,d])
            }
        }
    }
    
    func addFDDD_3434_3() {
        let p = add("FFF DDDD DDD DDDD", mask: "000 gggg rrr 0000", note: "Any 3 Suits",  family: Family.winds, concealed: false, points: 30)
        p.add([35,35,35, 10,10,10,10, 20,20,20, 30,30,30,30])
        p.add([35,35,35, 10,10,10,10, 30,30,30, 20,20,20,20])
        p.add([35,35,35, 20,20,20,20, 10,10,10, 30,30,30,30])
    }
    
    func addFNEWS_2333_C() {
        let p = add("FF NNN EEE WWW SSS (C)", mask: "00 000 000 000", note: "",  family: Family.winds, concealed: true, points: 30)
        p.add([35,35, 31,31,31, 34,34,34, 33,33,33, 32,32,32])
    }
    
    func addNEWSDD_311333_C() {
        let p = add("NNN E W SSS DDD DDD (C)", mask: "000 0 0 000 ggg rrr", note: "Any 2 Dragons",  family: Family.winds, concealed: true, points: 30)
        p.add([31,31,31, 34,33, 32,32,32, 10,10,10, 20,20,20])
        p.add([31,31,31, 34,33, 32,32,32, 10,10,10, 30,30,30])
        p.add([31,31,31, 34,33, 32,32,32, 20,20,20, 30,30,30])
    }
    
    func addFNEWS_43223() {
        let p = add("FFFF NNN EE WW SSS", mask: "0000 000 00 00 000", note: "",  family: Family.winds, concealed: false, points: 30)
        p.add([35,35,35,35, 31,31,31, 34,34, 33,33, 32,32,32])
    }
    
    func addFNRS_2444() {
        let p = add("FF NNNN RRRR SSSS", mask: "00 0000 rrrr 0000", note: "Red Dragons Only",  family: Family.winds, concealed: false, points: 30)
        p.add([35,35, 31,31,31,31, 30,30,30,30, 32,32,32,32])
    }
    
    func addFEGW_2444() {
        let p = add("FF EEEE GGGG WWWW", mask: "00 0000 gggg 0000", note: "Green Dragons Only",  family: Family.winds, concealed: false, points: 30)
        p.add([35,35, 34,34,34,34, 20,20,20,20, 33,33,33,33])
    }
    
    func addFNGS_4424() {
        let p = add("FFFF NNNN DD SSSS", mask: "0000 0000 rr 0000", note: "Red Dragon only",  family: Family.winds, concealed: false, points: 25)
        p.add([35,35,35,35, 31,31,31,31, 30,30, 32,32,32,32])
    }
    
    func addFERW_4424() {
        let p = add("FFFF EEEE DD WWWW", mask: "0000 0000 gg 0000", note: "Green Dragon only",  family: Family.winds, concealed: false, points: 25)
        p.add([35,35,35,35, 34,34,34,34, 20,20, 33,33,33,33])
    }
    
    func addNS123_44123_1() {
        let p = add("NNNN SSSS 1 22 333", mask: "0000 0000 0 00 000", note: "Any 3 Consec Nos In 1 Suit",  family: Family.winds, concealed: false, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([31,31,31,31, 32,32,32,32, d, d+1,d+1, d+2,d+2,d+2])
            p.add([31,31,31,31, 32,32,32,32, b, b+1,b+1, b+2,b+2,b+2])
            p.add([31,31,31,31, 32,32,32,32, c, c+1,c+1, c+2,c+2,c+2])
        }
    }
    
    func addEW123_44123_1() {
        let p = add("EEEE WWWW 1 22 333", mask: "0000 0000 0 00 000", note: "Any 3 Consec Nos In 1 Suit",  family: Family.winds, concealed: false, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([34,34,34,34, 33,33,33,33, d, d+1,d+1, d+2,d+2,d+2])
            p.add([34,34,34,34, 33,33,33,33, b, b+1,b+1, b+2,b+2,b+2])
            p.add([34,34,34,34, 33,33,33,33, c, c+1,c+1, c+2,c+2,c+2])
        }
    }
    
    func add1NEWS1_421124_2() {
        let p = add("1111 NN E W SS 1111", mask: "gggg 00 0 0 00 rrrr", note: "Any Like Odd or Even Nos",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d,d,d, 31,31, 34,33, 32,32, b,b,b,b])
            p.add([d,d,d,d, 31,31, 34,33, 32,32, c,c,c,c])
            p.add([b,b,b,b, 31,31, 34,33, 32,32, c,c,c,c])
        }
    }
    
        
    // -----------------------------------------------------------------------------------------
    //
    //  Standard 369
    //
    // -----------------------------------------------------------------------------------------
    
    func add36369_22334_3() {
        let p = add("33 66 333 666 9999", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
     
    func add3669_3434_2() {
        let p = add("333 6666 666 9999", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
     
    func add369D_3434_2() {
        let p = add("3333 666 9999 DDD", mask: "gggg 000 gggg 000", note: "Any 2 Suits, Dragons Match",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
     
    func add369D_4343_1() {
        let p = add("3333 666 9999 DDD", mask: "0000 000 0000 000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF369_2444_1() {
        let p = add("FF 3333 6666 9999", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF369_2444_3() {
        let p = add("FF 3333 6666 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }

    func add36F69_23432_2() {
        let p = add("33 666 FFFF 666 99", mask: "gg ggg 0000 rrr rr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 30)
        p.add([3,3, 6,6,6, 35,35,35,35, 16,16,16, 19,19])
        p.add([3,3, 6,6,6, 35,35,35,35, 26,26,26, 29,29])
        p.add([13,13, 16,16,16, 35,35,35,35, 6,6,6, 9,9])
        p.add([13,13, 16,16,16, 35,35,35,35, 26,26,26, 29,29])
        p.add([23,23, 26,26,26, 35,35,35,35, 6,6,6, 9,9])
        p.add([23,23, 26,26,26, 35,35,35,35, 16,16,16, 19,19])
    }
     
    func addF369D_23333_C() {
        let p = add("FF 333 666 999 DDD (C)", mask: "00 000 000 000 000", note: "",  family: Family.f369, concealed: true, points: 30)
        p.generateList()
    }
    
    func addF369D_32324_1() {
        let p = add("FFF 33 666 99 DDDD", mask: "000 00 000 00 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF369_5234_1() {
        let p = add("FFFFF 33 666 9999", mask: "00000 00 000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF369_3434_1() {
        let p = add("FFF 3333 666 9999", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF369_3434_3() {
        let p = add("FFF 3333 666 9999", mask: "000 gggg rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func add3669_3344_2() {
        let p = add("333 666 6666 9999", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }

    func add3699_4433_3() {
        let p = add("3333 6666 999 999", mask: "gggg gggg rrr 000", note: "Any 3 Suits, Pung 9s only",  family: Family.f369, concealed: false, points: 25)
        p.add([3,3,3,3, 6,6,6,6, 19,19,19, 29,29,29])
        p.add([13,13,13,13, 16,16,16,16, 9,9,9, 29,29,29])
        p.add([23,23,23,23, 26,26,26,26, 9,9,9, 19,19,19])
    }
    
    func add36933_22244_3() {
        let p = add("33 66 99 3333 3333", mask: "gg gg gg rrrr 0000", note: "Kongs Like 3,6,9s",  family: Family.f369, concealed: false, points: 30)
        p.add([3,3,6,6,9,9, 13,13,13,13, 23,23,23,23])
        p.add([13,13,16,16,19,19, 3,3,3,3, 23,23,23,23])
        p.add([23,23,26,26,29,29, 3,3,3,3, 13,13,13,13])
        p.add([3,3,6,6,9,9, 16,16,16,16, 26,26,26,26])
        p.add([13,13,16,16,19,19, 6,6,6,6, 26,26,26,26])
        p.add([23,23,26,26,29,29, 6,6,6,6, 16,16,16,16])
        p.add([3,3,6,6,9,9, 19,19,19,19, 29,29,29,29])
        p.add([13,13,16,16,19,19, 9,9,9,9, 29,29,29,29])
        p.add([23,23,26,26,29,29, 9,9,9,9, 19,19,19,19])
    }
    
    func addF3693_23234_2() {
        let p = add("FF 333 66 999 3333", mask: "00 000 00 000 gggg", note: "Any 2 Suits, Kong 3,6, or 9",  family: Family.f369, concealed: false, points: 30)
        p.add([35,35, 3,3,3,6,6,9,9,9, 13,13,13,13])
        p.add([35,35, 3,3,3,6,6,9,9,9, 23,23,23,23])
        p.add([35,35, 13,13,13,16,16,19,19,19, 3,3,3,3])
        p.add([35,35, 13,13,13,16,16,19,19,19, 23,23,23,23])
        p.add([35,35, 23,23,23,26,26,29,29,29, 3,3,3,3])
        p.add([35,35, 23,23,23,26,26,29,29,29, 13,13,13,13])
     
        p.add([35,35, 3,3,3,6,6,9,9,9, 16,16,16,16])
        p.add([35,35, 3,3,3,6,6,9,9,9, 26,26,26,26])
        p.add([35,35, 13,13,13,16,16,19,19,19, 6,6,6,6])
        p.add([35,35, 13,13,13,16,16,19,19,19, 26,26,26,26])
        p.add([35,35, 23,23,23,26,26,29,29,29, 6,6,6,6])
        p.add([35,35, 23,23,23,26,26,29,29,29, 16,16,16,16])
        
        p.add([35,35, 3,3,3,6,6,9,9,9, 19,19,19,19])
        p.add([35,35, 3,3,3,6,6,9,9,9, 29,29,29,29])
        p.add([35,35, 13,13,13,16,16,19,19,19, 9,9,9,9])
        p.add([35,35, 13,13,13,16,16,19,19,19, 29,29,29,29])
        p.add([35,35, 23,23,23,26,26,29,29,29, 9,9,9,9])
        p.add([35,35, 23,23,23,26,26,29,29,29, 19,19,19,19])
    }
    
    func add369D_4343_2() {
        let p = add("3333 666 9999 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func add3669D_22334_3() {
        let p = add("33 66 666 999 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func add369369_313313_C() {
        let p = add("333 6 999 333 6 999 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits",  family: Family.f369, concealed: true, points: 30)
        p.add([3,3,3, 6, 9,9,9, 13,13,13, 16, 19,19,19])
        p.add([3,3,3, 6, 9,9,9, 23,23,23, 26, 29,29,29])
        p.add([13,13,13, 16, 19,19,19, 23,23,23, 26, 29,29,29])
    }
    
    func add369D_3244_1() {
        let p = add("3333 66 9999 DDDD", mask: "0000 00 0000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p.generateList()
    }
    
    func addF3699_23333_C() {
        let p = add("FF 333 666 999 999 (C)", mask: "00 ggg ggg rrr 000", note: "Any 3 Suits",  family: Family.f369, concealed: true, points: 30)
        p.add([35,35, 3,3,3,    6,6,6,    19,19,19, 29,29,29])
        p.add([35,35, 13,13,13, 16,16,16, 9,9,9,    29,29,29])
        p.add([35,35, 23,23,23, 26,26,26, 9,9,9,    19,19,19])
    }
    
    func add36369_33332_C() {
        let p = add("333 666 333 666 99 (C)", mask: "ggg ggg rrr rrr 00", note: "Any 3 Suits",  family: Family.f369, concealed: true, points: 30)
        p.add([3,3,3, 6,6,6, 13,13,13, 16,16,16, 29,29])
        p.add([3,3,3, 6,6,6, 23,23,23, 26,26,26, 19,19])
        p.add([13,13,13, 16,16,16, 23,23,23, 26,26,26, 9,9])
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Standard Pairs
    //
    // -----------------------------------------------------------------------------------------
    
    func addNEWS111_222222_3() {
        let p = add("NN EE WW SS 11 11 11 (C)", mask: "00 00 00 00 gg rr 00", note: "Any Like Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([31,31, 34,34, 33,33, 32,32, d,d, b,b, c,c])
        }
    }
    
    func addNEWSDDD_2222222_3() {
        let p = add("NN EE WW SS DD DD DD (C)", mask: "00 00 00 00 gg rr 00", note: "",  family: Family.pairs, concealed: true, points: 50)
        p.add([31,31, 34,34, 33,33, 32,32, 10,10, 20,20, 30,30])
    }
    
    func add1357911_2222222_3() {
        let p5 = add("11 33 55 77 99 11 11 (C)", mask: "gg gg gg gg gg rr 00", note: "Odd Pairs Match in Opp Suits",  family: Family.pairs, concealed: true, points: 50)
        p5.add([1,1, 3,3, 5,5, 7,7, 9,9, 11,11, 21,21])
        p5.add([1,1, 3,3, 5,5, 7,7, 9,9, 13,13, 23,23])
        p5.add([1,1, 3,3, 5,5, 7,7, 9,9, 15,15, 25,25])
        p5.add([1,1, 3,3, 5,5, 7,7, 9,9, 17,17, 27,27])
        p5.add([1,1, 3,3, 5,5, 7,7, 9,9, 19,19, 29,29])

        p5.add([11,11, 13,13, 15,15, 17,17, 19,19, 1,1, 21,21])
        p5.add([11,11, 13,13, 15,15, 17,17, 19,19, 3,3, 23,23])
        p5.add([11,11, 13,13, 15,15, 17,17, 19,19, 5,5, 25,25])
        p5.add([11,11, 13,13, 15,15, 17,17, 19,19, 7,7, 27,27])
        p5.add([11,11, 13,13, 15,15, 17,17, 19,19, 9,9, 29,29])
        
        p5.add([21,21, 23,23, 25,25, 27,27, 29,29, 11,11, 1,1])
        p5.add([21,21, 23,23, 25,25, 27,27, 29,29, 13,13, 3,3])
        p5.add([21,21, 23,23, 25,25, 27,27, 29,29, 15,15, 5,5])
        p5.add([21,21, 23,23, 25,25, 27,27, 29,29, 17,17, 7,7])
        p5.add([21,21, 23,23, 25,25, 27,27, 29,29, 19,19, 9,9])
    }
    
    func addFNEWS111_22112222_3() {
        let p = add("FF NN E W SS 11 11 11 (C)", mask: "00 00 0 0 00 gg rr 00", note: "Any Like Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, 31,31, 34, 33, 32,32, d,d, b,b, c,c])
        }
    }
    
    func add13135135_21221222_3() {
        let p = add("113 11335 113355 (C)", mask: "ggg rrrrr 000000", note: "",  family: Family.pairs, concealed: true, points: 50)
        p.add([1,1,3, 11,11,13,13,15, 21,21,23,23,25,25])
        p.add([1,1,3, 21,21,23,23,25, 11,11,13,13,15,15])
        p.add([11,11,13, 1,1,3,3,5, 21,21,23,23,25,25])
        p.add([11,11,13, 21,21,23,23,25, 1,1,3,3,5,5])
        p.add([21,21,23, 1,1,3,3,5, 11,11,13,13,15,15])
        p.add([21,21,23, 11,11,13,13,15, 1,1,3,3,5,5])
    }
    
    func add57579579_21221222_3() {
        let p = add("557 55779 557799 (C)", mask: "ggg rrrrr 000000", note: "",  family: Family.pairs, concealed: true, points: 50)
        p.add([5,5,7, 15,15,17,17,19, 25,25,27,27,29,29])
        p.add([5,5,7, 25,25,27,27,29, 15,15,17,17,19,19])
        p.add([15,15,17, 5,5,7,7,9, 25,25,27,27,29,29])
        p.add([15,15,17, 25,25,27,27,29, 5,5,7,7,9,9])
        p.add([25,25,27, 5,5,7,7,9, 15,15,17,17,19,19])
        p.add([25,25,27, 15,15,17,17,19, 5,5,7,7,9,9])
    }
        
    func addF24682468_2222222_2() {
        let p = add("FF 22 46 88 22 46 88 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p.add([35,35, 2,2, 4,6, 8,8, 12,12, 14,16, 18,18])
        p.add([35,35, 2,2, 4,6, 8,8, 22,22, 24,26, 28,28])
        p.add([35,35, 12,12, 14,16, 18,18, 22,22, 24,26, 28,28])
    }
    
    func add1234567_2222222_1() {
        let p = add("11 22 33 44 55 66 77 (C)", mask: "00 00 00 00 00 00 00", note: "Any 7 Consec Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...3 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([d,d, d+1,d+1, d+2,d+2, d+3,d+3, d+4,d+4, d+5,d+5, d+6,d+6])
            p.add([b,b, b+1,b+1, b+2,b+2, b+3,b+3, b+4,b+4, b+5,b+5, b+6,b+6])
            p.add([c,c, c+1,c+1, c+2,c+2, c+3,c+3, c+4,c+4, c+5,c+5, c+6,c+6])
        }
    }
    
    func addF123456_2222222_1() {
        let p = add("FF 11 22 33 44 55 66 (C)", mask: "00 00 00 00 00 00 00", note: "Any 6 Conces Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...4 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d, d+1,d+1, d+2,d+2, d+3,d+3, d+4,d+4, d+5,d+5])
            p.add([35,35, b,b, b+1,b+1, b+2,b+2, b+3,b+3, b+4,b+4, b+5,b+5])
            p.add([35,35, c,c, c+1,c+1, c+2,c+2, c+3,c+3, c+4,c+4, c+5,c+5])
        }
    }
    
    func addF123123_2222222_2() {
        let p = add("FF 11 22 33 11 22 33 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits, Any 3 Conces Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d, d+1,d+1, d+2,d+2, b,b, b+1,b+1, b+2,b+2])
            p.add([35,35, d,d, d+1,d+1, d+2,d+2, c,c, c+1,c+1, c+2,c+2])
            p.add([35,35, b,b, b+1,b+1, b+2,b+2, c,c, c+1,c+1, c+2,c+2])
        }
    }
        
    func addF369369_2222222_2() {
        let p = add("FF 33 66 99 33 66 99 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p.add([35,35, 3,3, 6,6, 9,9, 13,13, 16,16, 19,19])
        p.add([35,35, 3,3, 6,6, 9,9, 23,23, 26,26, 29,29])
        p.add([35,35, 13,13, 16,16, 19,19, 23,23, 26,26, 29,29])
    }
    
    func addF12D12D_2222222_2() {
        let p = add("FF 11 22 DD 11 22 DD (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits, Any 2 Like Consec Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d, d+1,d+1, 10,10, b,b, b+1,b+1, 20,20])
            p.add([35,35, d,d, d+1,d+1, 10,10, c,c, c+1,c+1, 30,30])
            p.add([35,35, b,b, b+1,b+1, 20,20, c,c, c+1,c+1, 30,30])
        }
    }
    
    func addF121212_2222222_3() {
        let p = add("FF 11 22 11 22 11 22 (C)", mask: "00 gg gg rr rr 00 00", note: "Any 2 Consec Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d+1,d+1, b,b,b+1,b+1, c,c,c+1,c+1])
        }
    }
    
    func addF123DDD_2222222_3() {
        let p = add("FF 11 22 33 DD DD DD (C)", mask: "00 00 00 00 gg rr", note: "Any 3 Consec Nos",  family: Family.pairs, concealed: true)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d, d+1,d+1, d+2,d+2, 10,10, 20,20, 30,30])
            p.add([35,35, b,b, b+1,b+1, b+2,b+2, 10,10, 20,20, 30,30])
            p.add([35,35, c,c, c+1,c+1, c+2,c+2, 10,10, 20,20, 30,30])
        }
    }
    
    func addF12345D_2222222_1() {
        let p = add("FF 11 22 33 44 55 DD (C)", mask: "00 00 00 00 00 00 00", note: "Any 5 Consec Nos",  family: Family.pairs, concealed: true)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35,d,d,d+1,d+1,d+2,d+2,d+3,d+3,d+4,d+4,10,10])
            p.add([35,35,b,b,b+1,b+1,b+2,b+2,b+3,b+3,b+4,b+4,20,20])
            p.add([35,35,c,c,c+1,c+1,c+2,c+2,c+3,c+3,c+4,c+4,30,30])
        }
    }
    
    func addF246822_2222222_3() {
        let p = add("FF 22 44 66 88 22 22 (C)", mask: "00 00 00 00 00 gg rr", note: "Any Like Even Nos in Other 2 Suits",  family: Family.pairs, concealed: true)
        p.add([35,35, 2,2,4,4,6,6,8,8, 12,12, 22,22])
        p.add([35,35, 2,2,4,4,6,6,8,8, 14,14, 24,24])
        p.add([35,35, 2,2,4,4,6,6,8,8, 16,16, 26,26])
        p.add([35,35, 2,2,4,4,6,6,8,8, 18,18, 28,28])
        p.add([35,35, 12,12,14,14,16,16,18,18, 2,2, 22,22])
        p.add([35,35, 12,12,14,14,16,16,18,18, 4,4, 24,24])
        p.add([35,35, 12,12,14,14,16,16,18,18, 6,6, 26,26])
        p.add([35,35, 12,12,14,14,16,16,18,18, 8,8, 28,28])
        p.add([35,35, 22,22,24,24,26,26,28,28, 2,2, 12,12])
        p.add([35,35, 22,22,24,24,26,26,28,28, 4,4, 14,14])
        p.add([35,35, 22,22,24,24,26,26,28,28, 6,6, 16,16])
        p.add([35,35, 22,22,24,24,26,26,28,28, 8,8, 18,18])
    }
   

}

