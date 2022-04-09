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
        year = Year.y2022
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
    
    override func getYear() -> String {
        return "2022"
    }
        
    func add2022() {
        let p2 = add("FF DDDD 2022 DDDD", mask: "00 gggg 0000 rrrr", note: "2022 Any Suit, Green & Red Dragons",  family: Family.year, concealed: false, points: 25)
        p2.add([35,35, 20,20,20,20, 2,10,2,2, 30,30,30,30], singles: Singles.dot2)
        p2.add([35,35, 20,20,20,20, 12,10,12,12, 30,30,30,30], singles: Singles.bam2)
        p2.add([35,35, 20,20,20,20, 22,10,22,22, 30,30,30,30], singles: Singles.crak2)
        
        let p3 = add("222 000 2222 2222", mask: "ggg rrr 0000 rrrr", note: "2s Any 3 Suits",  family: Family.year, concealed: false, points: 30)
        p3.add([2,2,2, 10,10,10, 12,12,12,12, 22,22,22,22])
        p3.add([12,12,12, 10,10,10, 2,2,2,2, 22,22,22,22])
        p3.add([22,22,22, 10,10,10, 2,2,2,2, 12,12,12,12])
        
        let p4 = add("FFFF 2022 222 222", mask: "0000 gggg rrr 000", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 30)
        p4.add([35,35,35,35, 2,10,2,2, 12,12,12, 22,22,22], singles: Singles.dot2)
        p4.add([35,35,35,35, 12,10,12,12, 2,2,2, 22,22,22], singles: Singles.bam2)
        p4.add([35,35,35,35, 22,10,22,22, 2,2,2, 12,12,12], singles: Singles.crak2)
        
        let p6 = add("NN EEE 2022 WWW SS (C)", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.year, concealed: true, points: 30)
        p6.add([31,31, 34,34,34, 2,10,2,2, 33,33,33, 32,32], singles: Singles.dot2)
        p6.add([31,31, 34,34,34, 12,10,12,12, 33,33,33, 32,32], singles: Singles.bam2)
        p6.add([31,31, 34,34,34, 22,10,22,22, 33,33,33, 32,32], singles: Singles.crak2)
        
        let p = add("FF 2022 2022 2022 (C)", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.year, concealed: true, points: 85)
        p.add([35,35, 2,10,2,2, 12,10,12,12, 22,10,22,22], singles: Singles.ff_2022_2022_2022)
    }

    func add2468() {
        let p0 = add("FFF 22 44 666 8888", mask: "000 00 00 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p0.generateList()
        
        let p1 = add("22 46 88 2222 2222", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits, Kongs Any Like Even No",  family: Family.f2468, concealed: false, points: 25)
        p1.add([2,2, 4,6, 8,8, 12,12,12,12, 22,22,22,22])
        p1.add([2,2, 4,6, 8,8, 14,14,14,14, 24,24,24,24])
        p1.add([2,2, 4,6, 8,8, 16,16,16,16, 26,26,26,26])
        p1.add([2,2, 4,6, 8,8, 18,18,18,18, 28,28,28,28])
        p1.add([12,12, 14,16, 18,18, 2,2,2,2, 22,22,22,22])
        p1.add([12,12, 14,16, 18,18, 4,4,4,4, 24,24,24,24])
        p1.add([12,12, 14,16, 18,18, 6,6,6,6, 26,26,26,26])
        p1.add([12,12, 14,16, 18,18, 8,8,8,8, 28,28,28,28])
        p1.add([22,22, 24,26, 28,28, 2,2,2,2, 12,12,12,12])
        p1.add([22,22, 24,26, 28,28, 4,4,4,4, 14,14,14,14])
        p1.add([22,22, 24,26, 28,28, 6,6,6,6, 16,16,16,16])
        p1.add([22,22, 24,26, 28,28, 8,8,8,8, 18,18,18,18])
        
        let p2 = add("222 444 6666 8888", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p2.generateList()
        
        let p3 = add("222 444 6666 8888", mask: "ggg ggg rrrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p3.generateList()
        
        let p4 = add("2222 44 6666 88 88", mask: "0000 00 0000 gg rr", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 30)
        p4.add([2,2,2,2, 4,4, 6,6,6,6, 18,18, 28,28])
        p4.add([12,12,12,12, 14,14, 16,16,16,16, 8,8, 28,28])
        p4.add([22,22,22,22, 24,24, 26,26,26,26, 8,8, 18,18])
        
        let p5 = add("22 444 66 888 DDDD", mask: "00 000 00 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p5.generateList()
        
        let p6 = add("22 444 66 888 DDDD", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p6.generateList()
        
        let p7 = add("FFF 2222 FFF 8888", mask: "000 gggg 000 rrrr", note: "Any 2 Suits, These Nos Only",  family: Family.f2468, concealed: false, points: 30)
        p7.add([35,35,35, 2,2,2,2, 35,35,35, 18,18,18,18])
        p7.add([35,35,35, 2,2,2,2, 35,35,35, 28,28,28,28])
        p7.add([35,35,35, 12,12,12,12, 35,35,35, 8,8,8,8])
        p7.add([35,35,35, 12,12,12,12, 35,35,35, 28,28,28,28])
        p7.add([35,35,35, 22,22,22,22, 35,35,35, 8,8,8,8])
        p7.add([35,35,35, 22,22,22,22, 35,35,35, 18,18,18,18])
        
        let p8 = add("22 444 44 666 8888", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p8.generateList()
       
        let p9 = add("FF 246 888 246 888 (C)", mask: "00 ggg ggg rrr rrr", note: "Any 2 Suits",  family: Family.f2468, concealed: true, points: 30)
        p9.add([35,35, 2,4,6, 8,8,8, 12,14,16, 18,18,18])
        p9.add([35,35, 2,4,6, 8,8,8, 22,24,26, 28,28,28])
        p9.add([35,35, 12,14,16, 18,18,18, 22,24,26, 28,28,28])
    }
    
    func addLikeNumbers() {
        addLikeF1F1_3434_2()
        addLike1D1D1_32324_3()
        addLikeF1D1_2444_3()
    }
    
    func addAdditionHands() {
    }
    
    func addQuints() {
        addQDN1_545()
        
        let p2 = add("22 444 6666 88888", mask: "00 000 0000 00000", note: "Any 1 Suit",  family: Family.quints, concealed: false, points: 45)
        p2.generateList()
        
        addQ1233_455_3()
        addQF12_455_1()
    }
    
    func addConsectiveRun() {
        let p1 = add("11 22 333 444 5555", mask: "00 00 000 000 0000", note: "Any 1 Suit",  family: Family.run, concealed: false, points: 25)
        p1.add([1,1, 2,2, 3,3,3, 4,4,4, 5,5,5,5])
        p1.add([11,11, 12,12, 13,13,13, 14,14,14, 15,15,15,15])
        p1.add([21,21, 22,22, 23,23,23, 24,24,24, 25,25,25,25])
        
        let p2 = add("55 66 777 888 9999", mask: "00 00 000 000 0000", note: "Any 1 Suit",  family: Family.run, concealed: false, points: 25 )
        p2.add([5,5, 6,6, 7,7,7, 8,8,8, 9,9,9,9])
        p2.add([15,15, 16,16, 17,17,17, 18,18,18, 19,19,19,19])
        p2.add([25,25, 26,26, 27,27,27, 28,28,28, 29,29,29,29])
        
        addF1F2_3434_2()
        addF123_2444_1()
        addF123_2444_3()
        add1212D_23234_3()
        add1234_3344_1()
        add1234_3344_2()
        add12223_42224_3()
        addF123D_42233_1()
        add122123_323323_2_C()
    }
    
    func add13579() {
        add13579_23432_1()
        add13579_23432_3()
        
        let p0 = add("FF 1111 3333 5555", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p0.generateList()
        
        let p1 = add("FF 5555 7777 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p1.generateList()
        
        let p2 = add("111 333 3333 5555", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p2.add([1,1,1, 3,3,3, 13,13,13,13, 15,15,15,15])
        p2.add([1,1,1, 3,3,3, 23,23,23,23, 25,25,25,25])
        p2.add([11,11,11, 13,13,13, 3,3,3,3, 5,5,5,5])
        p2.add([11,11,11, 13,13,13, 23,23,23,23, 25,25,25,25])
        p2.add([21,21,21, 23,23,23, 3,3,3,3, 5,5,5,5])
        p2.add([21,21,21, 23,23,23, 13,13,13,13, 15,15,15,15])
        
        let p3 = add("555 777 7777 9999", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p3.add([5,5,5, 7,7,7, 17,17,17,17, 19,19,19,19])
        p3.add([5,5,5, 7,7,7, 27,27,27,27, 29,29,29,29])
        p3.add([15,15,15, 17,17,17, 7,7,7,7, 9,9,9,9])
        p3.add([15,15,15, 17,17,17, 27,27,27,27, 29,29,29,29])
        p3.add([25,25,25, 27,27,27, 7,7,7,7, 9,9,9,9])
        p3.add([25,25,25, 27,27,27, 17,17,17,17, 19,19,19,19])
        
        let p4 = add("FFF 1111 3 5 7 9999", mask: "000 gggg r r r gggg", note: "Any 2 Suits, 1s and 9s Match",  family: Family.f13579, concealed: false, points: 25)
        p4.generateList()
        
        let p5 = add("1111 333 5555 DDD", mask: "0000 000 0000 000", note: "Any 1 Suit, Matching Dragons",  family: Family.f13579, concealed: false, points: 25)
        p5.generateList()
        
        let p6 = add("5555 777 9999 DDD", mask: "0000 000 0000 000", note: "Any 1 Suit, Matching Dragons",  family: Family.f13579, concealed: false, points: 25)
        p6.generateList()
        
        add13135_23234_3()
        add57579_23234_3()

        let p14 = add("FF 1 33 555 5 77 999 (C)", mask: "00 g gg ggg r rr rrr", note: "Any 2 Suits",  family: Family.f13579, concealed: true, points: 30)
        p14.generateList()
    }

    func addWindsAndDragons() {
        addNEWS_4442()
        addFDDD_3434_3()
        
        let p0 = add("FFFF NNNN E W SSSS", mask: "0000 0000 0 0 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p0.add([35,35,35,35, 31,31,31,31, 34,33, 32,32,32,32])
        
        add1NEWS1_421124_2()
        addNS123_44123_1()
        addEW123_44123_1()
        addNEWSDD_311333_C()
    }

    func add369() {
        add3669_3344_2()
        addF369_3434_1()
        addF369_3434_3()
        
        let p0 = add("33 666 DDDD 666 99", mask: "rr rrr gggg 000 00", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p0.generateList()
        
        let p1 = add("FF 33 666 9999 DDD", mask: "00 00 000 0000 000", note: "Any 1 Suits",  family: Family.f369, concealed: false, points: 25)
        p1.generateList()
        
        add3699_4433_3()
        addF3693_23234_2()
        
        let p7 = add("FF 3 66 999 3 66 999 (C)", mask: "00 g gg ggg r rr rrr", note: "Any 2 Suits",  family: Family.f369, concealed: true, points: 35)
        p7.add([35,35, 3, 6,6, 9,9,9, 13, 16,16, 19,19,19])
        p7.add([35,35, 3, 6,6, 9,9,9, 23, 26,26, 29,29,29])
        p7.add([35,35, 13, 16,16, 19,19,19, 23, 26,26, 29,29,29])
    }

    func addSinglesAndPairs() {
        addNEWSDDD_2222222_3()
        add1357911_2222222_3()
        addF123123_2222222_2()
        add1234567_2222222_1()
        addF24682468_2222222_2()
        
        let p3 = add("336 33669 336699 (C)", mask: "ggg rrrrr 000000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p3.add([3,3,6, 13,13,16,16,19, 23,23,26,26,29,29])
        p3.add([3,3,6, 23,23,26,26,29, 13,13,16,16,19,19])
        p3.add([13,13,16, 3,3,6,6,9, 23,23,26,26,29,29])
        p3.add([13,13,16, 23,23,26,26,29, 3,3,6,6,9,9])
        p3.add([23,23,26, 3,3,6,6,9, 13,13,16,16,19,19])
        p3.add([23,23,26, 13,13,16,16,19, 3,3,6,6,9,9])
    }
    
}

