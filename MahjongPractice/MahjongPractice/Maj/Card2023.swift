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
        let p1 = add("FFFF 2222 46 8888", mask: "0000 0000 00 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p1.generateList()
        
        let p2 = add("22 46 88 2222 2222", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits, Kongs Any Like Even No",  family: Family.f2468, concealed: false, points: 25)
        p2.add([2,2, 4,6, 8,8, 12,12,12,12, 22,22,22,22])
        p2.add([2,2, 4,6, 8,8, 14,14,14,14, 24,24,24,24])
        p2.add([2,2, 4,6, 8,8, 16,16,16,16, 26,26,26,26])
        p2.add([2,2, 4,6, 8,8, 18,18,18,18, 28,28,28,28])
        p2.add([12,12, 14,16, 18,18, 2,2,2,2, 22,22,22,22])
        p2.add([12,12, 14,16, 18,18, 4,4,4,4, 24,24,24,24])
        p2.add([12,12, 14,16, 18,18, 6,6,6,6, 26,26,26,26])
        p2.add([12,12, 14,16, 18,18, 8,8,8,8, 28,28,28,28])
        p2.add([22,22, 24,26, 28,28, 2,2,2,2, 12,12,12,12])
        p2.add([22,22, 24,26, 28,28, 4,4,4,4, 14,14,14,14])
        p2.add([22,22, 24,26, 28,28, 6,6,6,6, 16,16,16,16])
        p2.add([22,22, 24,26, 28,28, 8,8,8,8, 18,18,18,18])
        
        let p3 = add("222 4444 666 8888", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p3.generateList()

        let p4 = add("222 4444 666 8888", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p4.generateList()
        
        let p5 = add("22 4444 44 6666 88", mask: "gg gggg rr rrrr 00", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p5.generateList()
        
        let p6 = add("222 888 DDDD DDDD", mask: "ggg ggg rrrr 0000", note: "Any 3 Suits, 2s and 8s Only",  family: Family.f2468, concealed: false, points: 25)
        p6.add([2,2,2, 8,8,8, 20,20,20,20, 30,30,30,30])
        p6.add([12,12,12, 18,18,18, 10,10,10,10, 30,30,30,30])
        p6.add([22,22,22, 28,28,28, 10,10,10,10, 20,20,20,20])
        
        let p7 = add("FF 222 44 66 888 DD (C)", mask: "00 000 00 00 000 00", note: "Any 1 Suit with Matching Dragons",  family: Family.f2468, concealed: true, points: 30)
        p7.generateList()
    }
    
    func addLikeNumbers() {
        add2021l2()
        
        let p2 = add("FF 111 D 111 D 111 D (C)", mask: "00 ggg g rrr r 000 0", note: "Any 3 Suits, Any Like Nos",  family: Family.likeNumbers, concealed: true, points: 30)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([35,35, d,d,d, 10, b,b,b, 20, c,c,c, 30])
        }
    }
    
    func addAdditionHands() {
        let p1 = add("FF 1111+1111=2222", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        p1.add([35,35, 1,1,1,1, 11,11,11,11, 22,22,22,22])
        p1.add([35,35, 1,1,1,1, 21,21,21,21, 12,12,12,12])
        p1.add([35,35, 21,21,21,21, 11,11,11,11, 2,2,2,2])
        
        let p2 = add("FF 2222+2222=4444", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        p2.add([35,35, 2,2,2,2, 12,12,12,12, 24,24,24,24])
        p2.add([35,35, 2,2,2,2, 22,22,22,22, 14,14,14,14])
        p2.add([35,35, 22,22,22,22, 12,12,12,12, 4,4,4,4])
        
        let p3 = add("FF 3333+3333=6666", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        p3.add([35,35, 3,3,3,3, 13,13,13,13, 26,26,26,26])
        p3.add([35,35, 3,3,3,3, 23,23,23,23, 16,16,16,16])
        p3.add([35,35, 23,23,23,23, 13,13,13,13, 6,6,6,6])
        
        let p4 = add("FF 4444+4444=8888", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        p4.add([35,35, 4,4,4,4, 14,14,14,14, 28,28,28,28])
        p4.add([35,35, 4,4,4,4, 24,24,24,24, 18,18,18,18])
        p4.add([35,35, 24,24,24,24, 14,14,14,14, 8,8,8,8])
    }
    
    func addQuints() {
        let p1 = add("11111 NNNN 11111", mask: "ggggg 0000 rrrrr", note: "Any 2 Suits, Any Like Nos, Any Wind",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p1.add([c,c,c,c,c, w,w,w,w, d,d,d,d,d])
                p1.add([b,b,b,b,b, w,w,w,w, d,d,d,d,d])
                p1.add([c,c,c,c,c, w,w,w,w, b,b,b,b,b])
            }
        }
        
        let p2 = add("22 333 4444 55555", mask: "00 000 0000 00000", note: "Any 1 Suit, These Nos. Only",  family: Family.quints, concealed: false, points: 40)
        p2.generateList()
        
        let p3 = add("FFFF 11111 22222", mask: "0000 ggggg rrrrr", note: "Any 2 Suits, Any 2 Consec Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([35,35,35,35, d,d,d,d,d, b+1,b+1,b+1,b+1,b+1])
            p3.add([35,35,35,35, d,d,d,d,d, c+1,c+1,c+1,c+1,c+1])
            p3.add([35,35,35,35, b,b,b,b,b, c+1,c+1,c+1,c+1,c+1])
        }
    }
    
    func addConsectiveRun() {
        add12345_23432_1()
        add56789_23432_1()
        
        let p3 = add("111 2222 333 4444", mask: "000 0000 000 0000", note: "Any Run, Any 1 Suit",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d,d, d+1,d+1,d+1,d+1 ,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p3.add([b,b,b, b+1,b+1,b+1,b+1 ,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p3.add([c,c,c, c+1,c+1,c+1,c+1 ,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
        }
        
        add1234_3434_2()
        
        let p5 = add("FF 1111 2222 DDDD", mask: "00 0000 0000 0000", note: "Any 1 Suit, Any Run, Matching Dragons",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([35,35, d,d,d,d, d+1,d+1,d+1,d+1, 10,10,10,10])
            p5.add([35,35, b,b,b,b, b+1,b+1,b+1,b+1, 20,20,20,20])
            p5.add([35,35, c,c,c,c, c+1,c+1,c+1,c+1, 30,30,30,30])
        }
        
        let p6 = add("1 22 333 4444 5555", mask: "g gg ggg rrrr 0000", note: "Any 3 Suits, Any 5 Consec Nos",  family: Family.run, concealed: false, points: 30)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([d, d+1,d+1, d+2,d+2,d+2, b+3,b+3,b+3,b+3, c+4,c+4,c+4,c+4])
            p6.add([d, d+1,d+1, d+2,d+2,d+2, c+3,c+3,c+3,c+3, b+4,b+4,b+4,b+4])
            p6.add([b, b+1,b+1, b+2,b+2,b+2, d+3,d+3,d+3,d+3, c+4,c+4,c+4,c+4])
            p6.add([b, b+1,b+1, b+2,b+2,b+2, c+3,c+3,c+3,c+3, d+4,d+4,d+4,d+4])
            p6.add([c, c+1,c+1, c+2,c+2,c+2, d+3,d+3,d+3,d+3, b+4,b+4,b+4,b+4])
            p6.add([c, c+1,c+1, c+2,c+2,c+2, b+3,b+3,b+3,b+3, d+4,d+4,d+4,d+4])
        }
        
        addF123_2444_1()
        addF123_2444_3()
        
        let p9 = add("111 2222 111 2222", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits, Any 2 Consec Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p9.add([d,d,d, d+1,d+1,d+1,d+1, b,b,b, b+1,b+1,b+1,b+1])
            p9.add([d,d,d, d+1,d+1,d+1,d+1, c,c,c, c+1,c+1,c+1,c+1])
            p9.add([b,b,b, b+1,b+1,b+1,b+1, c,c,c, c+1,c+1,c+1,c+1])
        }
        
        let p10 = add("FFFF 11 22 333 333", mask: "0000 gg gg rrr 000", note: "Any 3 Suits, Any 3 Consec Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p10.add([35,35,35,35, d,d, d+1,d+1, b+2,b+2,b+2, c+2,c+2,c+2])
            p10.add([35,35,35,35, b,b, b+1,b+1, d+2,d+2,d+2, c+2,c+2,c+2])
            p10.add([35,35,35,35, c,c, c+1,c+1, d+2,d+2,d+2, b+2,b+2,b+2])
        }

        let p11 = add("FF 111 22 33 444 DD (C)", mask: "00 000 00 00 000 00", note: "Any 1 Suit, Any Run, Matching Dragons",  family: Family.run, concealed: true, points: 30)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p11.add([35,35, d,d,d, d+1,d+1, d+2,d+2, d+3,d+3,d+3, 10,10])
            p11.add([35,35, b,b,b, b+1,b+1, b+2,b+2, b+3,b+3,b+3, 20,20])
            p11.add([35,35, c,c,c, c+1,c+1, c+2,c+2, c+3,c+3,c+3, 30,30])
        }
    }
    
    func add13579() {
        add13579_23432_1()
        add13579_23432_3()
        add1335_3434_2()
        add5779_3434_2()
        
        let p5 = add("FF 1111 3333 5555", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p5.generateList()
        
        let p6 = add("FF 5555 7777 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p6.generateList()
        
        let p7 = add("FF 1111 33 5555 DD", mask: "00 0000 00 0000 00", note: "Any 1 Suit, Matching Dragon",  family: Family.f13579, concealed: false, points: 30)
        p7.generateList()

        let p8 = add("FF 5555 77 9999 DD", mask: "00 0000 00 0000 00", note: "Any 1 Suit, Matching Dragon",  family: Family.f13579, concealed: false, points: 30)
        p8.generateList()
        
        add13D35_23432_3()
        add57D79_23432_3()
        
        let p11 = add("FFFF 11 33 555 555", mask: "0000 gg gg rrr 000", note: "These Nos Only",  family: Family.f13579, concealed: false, points: 25)
        p11.add([35,35,35,35, 1,1, 3,3, 15,15,15, 25,25,25])
        p11.add([35,35,35,35, 11,11, 13,13, 5,5,5, 25,25,25])
        p11.add([35,35,35,35, 21,21, 23,23, 5,5,5, 15,15,15])
        
        let p12 = add("FFFF 55 77 999 999", mask: "0000 gg gg rrr 000", note: "These Nos Only",  family: Family.f13579, concealed: false, points: 25)
        p12.add([35,35,35,35, 5,5, 7,7, 19,19,19, 29,29,29])
        p12.add([35,35,35,35, 15,15, 17,17, 9,9,9, 29,29,29])
        p12.add([35,35,35,35, 25,25, 27,27, 9,9,9, 19,19,19])
        
        let p13 = add("1111 33 55 77 9999", mask: "gggg rr rr rr gggg", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 30)
        p13.generateList()
        
        let p14 = add("111 3 555 555 7 999 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits",  family: Family.f13579, concealed: true, points: 30)
        p14.generateList()
    }

    func addWindsAndDragons() {
        addNEWS_4334()
        
        let p2 = add("NNN EEEE WWWW SSS", mask: "000 0000 0000 000", note: "",  family: Family.winds, concealed: false, points: 25)
        p2.add([31,31,31, 34,34,34,34, 33,33,33,33, 32,32,32])
        
        let p3 = add("NNN SSS 11 22 3333", mask: "000 000 00 00 0000", note: "Any Run",  family: Family.winds, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([31,31,31, 32,32,32, d,d, d+1,d+1, d+2,d+2,d+2,d+2])
            p3.add([31,31,31, 32,32,32, b,b, b+1,b+1, b+2,b+2,b+2,b+2])
            p3.add([31,31,31, 32,32,32, c,c, c+1,c+1, c+2,c+2,c+2,c+2])
        }
        
        let p4 = add("EEE WWW 11 22 3333", mask: "000 000 00 00 0000", note: "Any Run",  family: Family.winds, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([34,34,34, 33,33,33, d,d, d+1,d+1, d+2,d+2,d+2,d+2])
            p4.add([34,34,34, 33,33,33, b,b, b+1,b+1, b+2,b+2,b+2,b+2])
            p4.add([34,34,34, 33,33,33, c,c, c+1,c+1, c+2,c+2,c+2,c+2])
        }
        
        let p5 = add("NNNN SSSS DDD DDD", mask: "0000 0000 ggg rrr", note: "Any 2 Dragons",  family: Family.winds, concealed: false, points: 25)
        p5.add([31,31,31,31, 32,32,32,32, 10,10,10, 20,20,20])
        p5.add([31,31,31,31, 32,32,32,32, 10,10,10, 30,30,30])
        p5.add([31,31,31,31, 32,32,32,32, 20,20,20, 30,30,30])
        
        let p6 = add("EEEE WWWW DDD DDD", mask: "0000 0000 ggg rrr", note: "Any 2 Dragons",  family: Family.winds, concealed: false, points: 25)
        p6.add([34,34,34,34, 33,33,33,33, 10,10,10, 20,20,20])
        p6.add([34,34,34,34, 33,33,33,33, 10,10,10, 30,30,30])
        p6.add([34,34,34,34, 33,33,33,33, 20,20,20, 30,30,30])
        
        let p7 = add("FF NNNN 2023 SSSS", mask: "00 0000 0000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p7.add([35,35, 31,31,31,31, 2,10,2,3, 32,32,32,32])
        p7.add([35,35, 31,31,31,31, 12,10,12,13, 32,32,32,32])
        p7.add([35,35, 31,31,31,31, 22,10,22,23, 32,32,32,32])
        
        let p8 = add("FF EEEE 2023 WWWW", mask: "00 0000 0000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p8.add([35,35, 34,34,34,34, 2,10,2,3, 33,33,33,33])
        p8.add([35,35, 34,34,34,34, 12,10,12,13, 33,33,33,33])
        p8.add([35,35, 34,34,34,34, 22,10,22,23, 33,33,33,33])
        
        let p9 = add("FFFF N EE WWW SSSS", mask: "0000 0 00 000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p9.add([35,35,35,35, 31, 34,34, 33,33,33, 32,32,32,32])
        
        let p10 = add("DDDD NN EW SS DDDD", mask: "gggg 00 00 00 rrrr", note: "Any 2 Dragons",  family: Family.winds, concealed: false, points: 30)
        p10.add([10,10,10,10, 31,31, 34,33, 32,32, 30,30,30,30])
        p10.add([10,10,10,10, 31,31, 34,33, 32,32, 20,20,20,20])
        p10.add([20,20,20,20, 31,31, 34,33, 32,32, 30,30,30,30])
        
        let p11 = add("NNN EW SSS 111 222 (C)", mask: "000 00 000 ggg rrr", note: "Any Consec Nos, Any 2 Suits",  family: Family.winds, concealed: true, points: 30)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p11.add([31,31,31, 34,33, 32,32,32, d,d,d, b+1,b+1,b+1])
            p11.add([31,31,31, 34,33, 32,32,32, d,d,d, c+1,c+1,c+1])
            p11.add([31,31,31, 34,33, 32,32,32, b,b,b, d+1,d+1,d+1])
            p11.add([31,31,31, 34,33, 32,32,32, b,b,b, c+1,c+1,c+1])
            p11.add([31,31,31, 34,33, 32,32,32, c,c,c, d+1,d+1,d+1])
            p11.add([31,31,31, 34,33, 32,32,32, c,c,c, b+1,b+1,b+1])
        }
    }
    
    func add369() {
        add3669_3434_2()
        
        let p2 = add("FFFF 3333 66 9999", mask: "0000 0000 00 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p2.generateList()
        
        let p3 = add("FFFF 3333 66 9999", mask: "0000 gggg rr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p3.generateList()
        
        let p4 = add("33 66 333 666 9999", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p4.generateList()
        
        let p5 = add("FF 33 66 99 DDD DDD", mask: "00 gg gg gg rrr 000", note: "Any 3 Suits, Opp Dragons",  family: Family.f369, concealed: false, points: 30)
        p5.add([35,35, 3,3, 6,6, 9,9, 30,30,30, 20,20,20])
        p5.add([35,35, 13,13, 16,16, 19,19, 10,10,10, 30,30,30])
        p5.add([35,35, 23,23, 26,26, 29,29, 10,10,10, 20,20,20])
        
        let p6 = add("3 66 999 3333 3333", mask: "g gg ggg rrrr 0000", note: "Kongs 3,6 or 9",  family: Family.f369, concealed: false, points: 25)
        p6.add([3, 6,6, 9,9,9, 13,13,13,13, 23,23,23,23])
        p6.add([13, 16,16, 19,19,19, 3,3,3,3, 23,23,23,23])
        p6.add([23, 26,26, 29,29,29, 3,3,3,3, 13,13,13,13])
        p6.add([3, 6,6, 9,9,9, 16,16,16,16, 26,26,26,26])
        p6.add([13, 16,16, 19,19,19, 6,6,6,6, 26,26,26,26])
        p6.add([23, 26,26, 29,29,29, 6,6,6,6, 16,16,16,16])
        p6.add([3, 6,6, 9,9,9, 19,19,19,19, 29,29,29,29])
        p6.add([13, 16,16, 19,19,19, 9,9,9,9, 29,29,29,29])
        p6.add([23, 26,26, 29,29,29, 9,9,9,9, 19,19,19,19])
        
        let p7 = add("3333 666 9999 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits, 6s and Dragons Match",  family: Family.f369, concealed: false, points: 25)
        p7.generateList()
        
        let p8 = add("333 6 999 333 6 999 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits",  family: Family.f369, concealed: true, points: 30)
        p8.add([3,3,3, 6, 9,9,9, 13,13,13, 16, 19,19,19])
        p8.add([3,3,3, 6, 9,9,9, 23,23,23, 26, 29,29,29])
        p8.add([13,13,13, 16, 19,19,19, 23,23,23, 26, 29,29,29])
    }

    func addSinglesAndPairs() {
        let p = add("FF 2023 2023 2023 (C)", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 75)
        p.add([35,35, 2,10,2,3, 12,10,13,13, 22,10,23,23])
    }
    
}

