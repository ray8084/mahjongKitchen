//
//  Card2021.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 3/13/21.
//  Copyright © 2021 EightBam. All rights reserved.
//

import Foundation

class Card2022 : Card {
    
    override init() {
        super.init()
        add2022()
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
    
    func add2022() {
        let p2 = add("FF DDDD 2022 DDDD", mask: "00 gggg 0000 rrrr", note: "2022 Any Suit, Green & Red Dragons",  family: Family.year, concealed: false, points: 25)
        p2.add([35,35, 20,20,20,20, 2,10,2,2, 30,30,30,30])
        p2.add([35,35, 20,20,20,20, 12,10,12,12, 30,30,30,30])
        p2.add([35,35, 20,20,20,20, 22,10,22,22, 30,30,30,30])
        
        let p3 = add("222 000 2222 2222", mask: "ggg rrr 0000 rrrr", note: "2s Any 3 Suits",  family: Family.year, concealed: false, points: 30)
        p3.add([2,2,2, 10,10,10, 12,12,12,12, 22,22,22,22])
        p3.add([12,12,12, 10,10,10, 2,2,2,2, 22,22,22,22])
        p3.add([22,22,22, 10,10,10, 2,2,2,2, 12,12,12,12])
        
        let p4 = add("FFFF 2022 222 222", mask: "0000 gggg rrr 000", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 30)
        p4.add([35,35,35,35, 2,10,2,2, 12,12,12, 22,22,22])
        p4.add([35,35,35,35, 12,10,12,12, 2,2,2, 22,22,22])
        p4.add([35,35,35,35, 22,10,22,22, 2,2,2, 12,12,12])
        
        let p6 = add("NN EEE 2022 WWW SS (C)", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.year, concealed: true, points: 30)
        p6.add([31,31, 34,34,34, 2,10,2,2, 33,33,33, 32,32])
        p6.add([31,31, 34,34,34, 12,10,12,12, 33,33,33, 32,32])
        p6.add([31,31, 34,34,34, 22,10,22,22, 33,33,33, 32,32])
        
        let p = add("FF 2022 2022 2022 (C)", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 85)
        p.add([35,35, 2,10,2,2, 12,10,12,12, 22,10,22,22])
    }

    func add2468() {
        /*add24F68_23432_1()
        add2468_3434_2()
        add2468D_22334_1()
        addF2468_24224_2()
        add2468_3344_3()
        add2468_4442_1()
        addFD2468D_2411114_3()
        add246822_311333_3()*/
    }
    
    func addLikeNumbers() {
        /*addLikeF1NEWS1_2444_2()
        addLikeF111_4424_3()
        addLike1D1D_3434_2()*/
    }
    
    func addAdditionHands() {
    }
    
    func addQuints() {
        /*addQF1N_545()
        addQ1234_5225_2()
        addQ123_545_1()
        addQ123_545_3()
        addQ1212_2525_2()*/
    }
    
    func addConsectiveRun() {
        /*add12345_23432_1()
        add56789_23432_1()
        add1234_3434_2()
        add1234D_12344_1()
        addF123_5234_1()
        addF123_2444_1()
        addF123_2444_3()
        add12123_23234_3()
        add12344_22244_3()
        addF12DD_23333_C()*/
    }
    
    func add13579() {
        /*add13579_23432_1()
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
        add57579_33332_C()*/
    }

    func addWindsAndDragons() {
        /*addNEWS_4334()
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
        
        addNEWSDD_311333_C()*/
    }

    func add369() {
        /*add3669_3434_2()
        add369D_4343_1()
        add3699_4433_3()
        addF369_5234_1()
        add3669D_22334_3()
        addF369_2444_1()
        addF369_2444_3()
        add36369_33332_C()*/
    }

    func addSinglesAndPairs() {
        /*addFNEWS111_22112222_3()
        add13135135_21221222_3()
        add57579579_21221222_3()
        addF123456_2222222_1()
        addF246822_2222222_3()
        addF369369_2222222_2()*/
    }
    
}

