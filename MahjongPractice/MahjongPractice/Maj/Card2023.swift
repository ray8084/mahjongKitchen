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

