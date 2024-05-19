//
//  Card2024Combo.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 5/19/24.
//

import Foundation

class Card2024Combo : Card {
    
    override init() {
        super.init()
        year = Year.y2024
        let c2024 = Card2024()
        let c2024Siamese = Card2024Siamese()
        letterPatterns = c2024.letterPatterns
        letterPatterns += c2024Siamese.letterPatterns
        
        var count = 0
        for p in letterPatterns {
            count = count + p.idList.list.count
            print("\(p.id+1) " + p.getFamilyString() + " count:\(p.idList.list.count)")
        }
        print(count)
    }
}
