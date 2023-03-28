//
//  Card2021.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 3/13/21.
//  Copyright © 2021 EightBam. All rights reserved.
//

import Foundation

class Card2021 : Card {
    
    override init() {
        super.init()
        add2021()
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
            // print("\(p.id+1) " + p.getFamilyString() + " count:\(p.idList.list.count)")
        }
        // print(count)
    }
    
    override func getYear() -> String {
        return "2021"
    }
    
    func add2021() {
        let p0 = add("FF 2021 2222 1111", mask: "00 0000 gggg rrrr", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p0.add([35,35, 2,10,2,1, 12,12,12,12, 21,21,21,21])
        p0.add([35,35, 2,10,2,1, 22,22,22,22, 11,11,11,11])
        p0.add([35,35, 12,10,12,11, 2,2,2,2, 21,21,21,21])
        p0.add([35,35, 12,10,12,11, 22,22,22,22, 1,1,1,1])
        p0.add([35,35, 22,10,22,21, 2,2,2,2, 11,11,11,11])
        p0.add([35,35, 22,10,22,21, 12,12,12,12, 1,1,1,1])
        
        let p1 = add("222 0000 222 1111", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.year, concealed : false, points: 25)
        p1.generateList()
        
        let p2 = add("FFFF 2222 0000 21", mask: "0000 0000 0000 00", note: "Any 1 Suit",  family: Family.year, concealed : false, points: 25)
        p2.generateList()
        
        let p6 = add("NNN EE 2021 WW SSS (C)", mask: "000 00 0000 00 000", note: "Any 1 Suit",  family: Family.year, concealed: true, points: 30)
        p6.add([31,31,31, 34,34, 2,10,2,1, 33,33, 32,32,32])
        p6.add([31,31,31, 34,34, 12,10,12,11, 33,33, 32,32,32])
        p6.add([31,31,31, 34,34, 22,10,22,21, 33,33, 32,32,32])
    }

    func add2468() {
        add2021e1()
        add2021e2()
        add2021e3()
        add2021e4()
        add2021e5()
        add2021e6()
        add2021e7()
        add2021e8()
    }
    
    func addLikeNumbers() {
        add2021l1()
        add2021l2()
        add2021l3()
    }
    
    func addAdditionHands() {
    }
    
    func addQuints() {
        add2021q1()
        add2021q2()
        addQ123_545_1()
        addQ123_545_3()
        addQ1212_2525_2()
    }
    
    func addConsectiveRun() {
        add12345_23432_1()
        add56789_23432_1()
        add1234_3434_2()
        add1234D_12344_1()
        addF123_5234_1()
        addF123_2444_1()
        addF123_2444_3()
        add12123_23234_3()
        add12344_22244_3()
        addF12DD_23333_C()
    }
    
    func add13579() {
        add13579_23432_1()
        add13579_23432_3()
        addF135D_22343_1()
        addF579D_22343_1()
        add1335_3434_2()
        add5779_3434_2()
        add13D35_23432_3()
        add57D79_23432_3()
        addF135_4424_1()
        addF579_4424_1()
        add13579_22244_3()
        add13135_33332_C()
        add57579_33332_C()
    }

    func addWindsAndDragons() {
        addNEWS_4334()
        add1N1S1_23234_3()
        add2E2W2_23234_3()
        addFNEWS_43223()
        addFNRS_2444()
        addFEGW_2444()
        
        let p9 = add("FF NNNN 2021 SSSS", mask: "00 0000 0000 0000", note: "2021 Any 1 Suit",  family: Family.winds, concealed: false, points: 25)
        p9.add([35,35, 31,31,31,31, 2,10,2,1, 32,32,32,32])
        p9.add([35,35, 31,31,31,31, 12,10,12,11, 32,32,32,32])
        p9.add([35,35, 31,31,31,31, 22,10,22,21, 32,32,32,32])
        
        let pa = add("FF EEEE 2021 WWWW", mask: "00 0000 0000 0000", note: "2021 Any 1 Suit",  family: Family.winds, concealed: false, points: 25)
        pa.add([35,35, 34,34,34,34, 2,10,2,1, 33,33,33,33])
        pa.add([35,35, 34,34,34,34, 12,10,12,11, 33,33,33,33])
        pa.add([35,35, 34,34,34,34, 22,10,22,21, 33,33,33,33])
        
        addNEWSDD_311333_C()
    }

    func add369() {
        add3669_3434_2()
        add369D_4343_1()
        add3699_4433_3()
        addF369_5234_1()
        add3669D_22334_3()
        addF369_2444_1()
        addF369_2444_3()
        add36369_33332_C()
    }

    func addSinglesAndPairs() {
        addFNEWS111_22112222_3()
        add13135135_21221222_3()
        add57579579_21221222_3()
        addF123456_2222222_1()
        addF246822_2222222_3()
        addF369369_2222222_2()
        
        let p = add("FF 2021 2021 2021 (C)", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 60)
        p.add([35,35, 2,10,2,1, 12,10,12,11, 22,10,22,21])
    }
    
}

