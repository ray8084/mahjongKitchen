//
//  Card2023.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 2/11/23.
//

import Foundation

class Card2023 : Card {
    
    override init() {
        super.init()
        year = Year.y2023
        add2023()
        add2468()
        addLikeNumbers()
        addAdditionHands()
        addQuints()
        addConsectiveRun()
        add13579()
        addWindsAndDragons()
        add369()
        addSinglesAndPairs()
        
        var count = 0
        for p in letterPatterns {
            count = count + p.idList.list.count
            print("\(p.id+1) " + p.getFamilyString() + " count:\(p.idList.list.count)")
        }
        print(count)
    }
    
    override func getYear() -> String {
        return "2023"
    }
        
    func add2023() {
        let p1 = add("222 0000 222 3333", mask: "ggg 0000 rrr rrrr", note: "Any 2 Suits",  family: Family.year, concealed : false, points: 25)
        p1.generateList()
        
        let p2 = add("FF 2023 2222 3333", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p2.add([35,35, 2,10,2,3, 12,12,12,12, 23,23,23,23])
        p2.add([35,35, 2,10,2,3, 22,22,22,22, 13,13,13,13])
        p2.add([35,35, 12,10,12,13, 2,2,2,2, 23,23,23,23])
        p2.add([35,35, 12,10,12,13, 22,22,22,22, 3,3,3,3])
        p2.add([35,35, 22,10,22,23, 2,2,2,2, 13,13,13,13])
        p2.add([35,35, 22,10,22,23, 12,12,12,12, 3,3,3,3])
        
        let p3 = add("FFFF DDD 2023 DDD", mask: "0000 ggg rrrr 000", note: "2023 Any Suit, Pungs Any Dragons",  family: Family.year, concealed: false, points: 25)
        p3.add([35,35,35,35, 10,10,10, 2,10,2,3, 20,20,20])     // 2 suits
        p3.add([35,35,35,35, 10,10,10, 2,10,2,3, 30,30,30])     // 2 suits
        p3.add([35,35,35,35, 20,20,20, 2,10,2,3, 30,30,30])     // 3 suits
        p3.add([35,35,35,35, 20,20,20, 12,10,12,13, 10,10,10])  // 2 suits
        p3.add([35,35,35,35, 20,20,20, 12,10,12,13, 30,30,30])  // 2 suits
        p3.add([35,35,35,35, 10,10,10, 12,10,12,13, 30,30,30])  // 3 suits
        p3.add([35,35,35,35, 30,30,30, 22,10,22,23, 20,20,20])  // 2 suits
        p3.add([35,35,35,35, 30,30,30, 22,10,22,23, 10,10,10])  // 2 suits
        p3.add([35,35,35,35, 10,10,10, 22,10,22,23, 20,20,20])  // 3 suits

        let p4 = add("22 000 NEWS 222 33 (C)", mask: "gg 000 0000 rrr rr", note: "Any 2 Suits - Pair of 2s May Be In Any Suit",  family: Family.year, concealed: true, points: 30)
        p4.add([2,2, 10,10,10, 31,34,33,32, 12,12,12, 13,13])
        p4.add([2,2, 10,10,10, 31,34,33,32, 22,22,22, 23,23])
        p4.add([12,12, 10,10,10, 31,34,33,32, 2,2,2, 3,3])
        p4.add([12,12, 10,10,10, 31,34,33,32, 22,22,22, 23,23])
        p4.add([22,22, 10,10,10, 31,34,33,32, 2,2,2, 3,3])
        p4.add([22,22, 10,10,10, 31,34,33,32, 12,12,12, 13,13])
    }

    func add2468() {
    }
    
    func addLikeNumbers() {
    }
    
    func addAdditionHands() {
    }
    
    func addQuints() {
    }
    
    func addConsectiveRun() {
    }
    
    func add13579() {
    }

    func addWindsAndDragons() {
    }

    func add369() {
    }

    func addSinglesAndPairs() {
        let p = add("FF 2023 2023 2023 (C)", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 75)
        p.add([35,35, 2,10,2,3, 12,10,13,13, 22,10,23,23])
    }
    
}

