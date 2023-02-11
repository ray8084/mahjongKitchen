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
        let p = add("FF 2023 2023 2023 (C)", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.year, concealed: true, points: 85)
        p.add([35,35, 2,10,2,3, 12,10,13,13, 22,10,23,23])
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
    }
    
}

