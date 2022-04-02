//
//  File.swift
//  Mahjong2019
//
//  Created by Ray Meyer on 3/27/19.
//  Copyright © 2019 Ray. All rights reserved.
//

class Card2019 : Card {
    
    override init() {
        super.init()
        add2019()
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
        return "2019"
    }
    
    func add2019() {
        let p0 = add("FFFF 2019 111 999", mask: "0000 gggg rrr 000", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p0.add([35,35,35,35, 2,10,1,9, 11,11,11, 29,29,29])
        p0.add([35,35,35,35, 2,10,1,9, 21,21,21, 19,19,19])
        p0.add([35,35,35,35, 12,10,11,19, 1,1,1, 29,29,29])
        p0.add([35,35,35,35, 12,10,11,19, 21,21,21, 9,9,9])
        p0.add([35,35,35,35, 22,10,21,29, 1,1,1, 19,19,19])
        p0.add([35,35,35,35, 22,10,21,29, 11,11,11, 9,9,9])
        
        let p1 = add("222 0000 111 9999", mask: "000 0000 000 0000", note: "",  family: Family.year, concealed : false, points: 25)
        p1.generateList()
        
        let p2 = add("222 0000 111 9999", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.year, concealed : false, points: 25)
        p2.generateList()
        
        let p5 = add("FF DDDD 2019 DDDD", mask: "00 gggg rrrr 0000", note: "Any 2 or 3 Suits",  family: Family.year, concealed: false, points: 25)
        p5.add([35,35, 10,10,10,10, 2,10,1,9, 20,20,20,20])     // 2 suits
        p5.add([35,35, 10,10,10,10, 2,10,1,9, 30,30,30,30])     // 2 suits
        p5.add([35,35, 20,20,20,20, 2,10,1,9, 30,30,30,30])     // 3 suits
        p5.add([35,35, 20,20,20,20, 12,10,11,19, 10,10,10,10])  // 2 suits
        p5.add([35,35, 20,20,20,20, 12,10,11,19, 30,30,30,30])  // 2 suits
        p5.add([35,35, 10,10,10,10, 12,10,11,19, 30,30,30,30])  // 3 suits
        p5.add([35,35, 30,30,30,30, 22,10,21,29, 20,20,20,20])  // 2 suits
        p5.add([35,35, 30,30,30,30, 22,10,21,29, 10,10,10,10])  // 2 suits
        p5.add([35,35, 10,10,10,10, 22,10,21,29, 20,20,20,20])  // 3 suits
        
        let p6 = add("22 000 NEWS 111 99 (C)", mask: "rr rrr 0000 rrr rr", note: "Any 1 Suit",  family: Family.year, concealed: true, points: 30)
        p6.add([2,2, 10,10,10, 31,34,33,32, 1,1,1, 9,9])
        p6.add([12,12, 10,10,10, 31,34,33,32, 11,11,11, 19,19])
        p6.add([22,22, 10,10,10, 31,34,33,32, 21,21,21, 29,29])
    }

    func add2468() {
        let p1 = add("FFF 22 44 666 8888", mask: "000 00 00 000 0000", note: "",  family: Family.f2468, concealed: false, points: 25)
        let p2 = add("222 4444 666 8888", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p3 = add("2222 4444 6666 88", mask: "0000 0000 0000 00", note: "",  family: Family.f2468, concealed: false, points: 25)
        let p4 = add("FF 2222 44 66 8888", mask: "00 rrrr gg gg rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p5 = add("22 444 DDDD 666 88", mask: "00 000 0000 000 00", note: "",  family: Family.f2468, concealed: false, points: 25)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()

        let p6 = add("222 44 666 888 888 (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Suits",  family: Family.f2468, concealed: true, points: 30)
        p6.add([2,2,2, 4,4, 6,6,6, 18,18,18, 28,28,28])
        p6.add([12,12,12, 14,14, 16,16,16, 8,8,8, 28,28,28])
        p6.add([22,22,22, 24,24, 26,26,26, 8,8,8, 18,18,18])
    }
    
    func addLikeNumbers() {
        let p1 = add("FF 1111 1111 1111", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([35,35, d,d,d,d, b,b,b,b, c,c,c,c])
        }
        let p3 = add("11 DD 111 DDD 1111 (C)", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: true, points: 30)
        p3.generateList()
    }
    
    func addAdditionHands() {
        let p1 = add("FFFF 5555+6666=11", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p2 = add("FFFF 5555+6666=11", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        let p3 = add("FFFF 5555+7777=12", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p4 = add("FFFF 5555+7777=12", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        let p5 = add("FFFF 5555+8888=13", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p6 = add("FFFF 5555+8888=13", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
        p6.generateList()
    }
    
    func addQuints() {
        let p1 = add("11 222 3333 44444", mask: "00 000 0000 00000", note: "Any 4 Consec Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([d,d, d+1,d+1,d+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3,d+3])
            p1.add([b,b, b+1,b+1,b+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3,b+3])
            p1.add([c,c, c+1,c+1,c+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3,c+3])
        }
        let p2 = add("FFFF NNNNN 11111", mask: "0000 00000 ggggg", note: "Any Wind, Any No.",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p2.add([35,35,35,35, w,w,w,w,w, d,d,d,d,d])
                p2.add([35,35,35,35, w,w,w,w,w, b,b,b,b,b])
                p2.add([35,35,35,35, w,w,w,w,w, c,c,c,c,c])
            }
        }
        let p3 = add("11111 22 33333 DD", mask: "00000 00 00000 00", note: "Any 3 Consec Nos. Dragons Match",  family: Family.quints, concealed: false, points: 45)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d,d,d,d, d+1,d+1, d+2,d+2,d+2,d+2,d+2, 10,10])
            p3.add([b,b,b,b,b, b+1,b+1, b+2,b+2,b+2,b+2,b+2, 20,20])
            p3.add([c,c,c,c,c, c+1,c+1, c+2,c+2,c+2,c+2,c+2, 30,30])
        }
        let p4 = add("11111 DDDD 11111", mask: "ggggg 0000 rrrrr", note: "Any Like Nos. Opposite Dragon",  family: Family.quints, concealed: false, points: 40)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([d,d,d,d,d, 20,20,20,20, c,c,c,c,c])
            p4.add([d,d,d,d,d, 30,30,30,30, b,b,b,b,b])
            p4.add([b,b,b,b,b, 10,10,10,10, c,c,c,c,c])
        }
    }
    
    func addConsectiveRun() {
        add12345_23432_1()
        add56789_23432_1()
        add1234_3434_2()
        addF123_2444_1()
        addF123_2444_3()
        add12344_22244_3()
        addF12D_3443_1()
        addF1212_42323_2()
        add12322_32333_C()
    }
    
    func add13579() {
        let p0 = add("11 333 5555 777 99", mask: "00 000 0000 000 00", note: "",  family: Family.f13579, concealed: false, points: 25)
        p0.add([1,1, 3,3,3, 5,5,5,5, 7,7,7, 9,9])
        p0.add([11,11, 13,13,13, 15,15,15,15, 17,17,17, 19,19])
        p0.add([21,21, 23,23,23, 25,25,25,25, 27,27,27, 29,29])
        
        let p1 = add("11 333 5555 777 99", mask: "gg ggg rrrr 000 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p1.add([1,1, 3,3,3, 15,15,15,15, 27,27,27, 29,29])
        p1.add([1,1, 3,3,3, 25,25,25,25, 17,17,17, 19,19])
        p1.add([11,11, 13,13,13, 5,5,5,5, 27,27,27, 29,29])
        p1.add([11,11, 13,13,13, 25,25,25,25, 7,7,7, 9,9])
        p1.add([21,21, 23,23,23, 5,5,5,5, 17,17,17, 19,19])
        p1.add([21,21, 23,23,23, 15,15,15,15, 7,7,7, 9,9])
        
        let p2 = add("111 3333 333 5555", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p2.add([1,1,1, 3,3,3,3, 13,13,13, 15,15,15,15])
        p2.add([1,1,1, 3,3,3,3, 23,23,23, 25,25,25,25])
        p2.add([11,11,11, 13,13,13,13, 3,3,3, 5,5,5,5])
        p2.add([11,11,11, 13,13,13,13, 23,23,23, 25,25,25,25])
        p2.add([21,21,21, 23,23,23,23, 3,3,3, 5,5,5,5])
        p2.add([21,21,21, 23,23,23,23, 13,13,13, 15,15,15,15])
        
        let p3 = add("555 7777 777 9999", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        p3.add([5,5,5, 7,7,7,7, 17,17,17, 19,19,19,19])
        p3.add([5,5,5, 7,7,7,7, 27,27,27, 29,29,29,29])
        p3.add([15,15,15, 17,17,17,17, 7,7,7, 9,9,9,9])
        p3.add([15,15,15, 17,17,17,17, 27,27,27, 29,29,29,29])
        p3.add([25,25,25, 27,27,27,27, 7,7,7, 9,9,9,9])
        p3.add([25,25,25, 27,27,27,27, 17,17,17, 19,19,19,19])
        
        let p4 = add("FFFF 1111 33 5555", mask: "0000 0000 00 0000", note: "",  family: Family.f13579, concealed: false, points: 25)
        let p5 = add("FFFF 5555 77 9999", mask: "0000 0000 00 0000", note: "",  family: Family.f13579, concealed: false, points: 25)
        p4.generateList()
        p5.generateList()
        
        let p6 = add("11 33 333 555 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        let p7 = add("55 77 777 999 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p6.generateList()
        p7.generateList()
        
        let p8 = add("11 33 55 1111 1111", mask: "gg gg gg rrrr 0000", note: "Kongs Like 1s",  family: Family.f13579, concealed: false, points: 25)
        p8.add([1,1, 3,3, 5,5, 11,11,11,11, 21,21,21,21])
        p8.add([11,11, 13,13, 15,15, 1,1,1,1, 21,21,21,21])
        p8.add([21,21, 23,23, 25,25, 1,1,1,1, 11,11,11,11])
        
        let p9 = add("11 33 55 3333 3333", mask: "gg gg gg rrrr 0000", note: "Kongs Like 3s",  family: Family.f13579, concealed: false, points: 25)
        p9.add([1,1, 3,3, 5,5, 13,13,13,13, 23,23,23,23])
        p9.add([11,11, 13,13, 15,15, 3,3,3,3, 23,23,23,23])
        p9.add([21,21, 23,23, 25,25, 3,3,3,3, 13,13,13,13])

        let p10 = add("11 33 55 5555 5555", mask: "gg gg gg rrrr 0000", note: "Kongs Like 5s",  family: Family.f13579, concealed: false, points: 25)
        p10.add([1,1, 3,3, 5,5, 15,15,15,15, 25,25,25,25])
        p10.add([11,11, 13,13, 15,15, 5,5,5,5, 25,25,25,25])
        p10.add([21,21, 23,23, 25,25, 5,5,5,5, 15,15,15,15])
        
        let p11 = add("55 77 99 5555 5555", mask: "gg gg gg rrrr 0000", note: "Kongs Like 5s",  family: Family.f13579, concealed: false, points: 25)
        p11.add([5,5, 7,7, 9,9, 15,15,15,15, 25,25,25,25])
        p11.add([15,15, 17,17, 19,19, 5,5,5,5, 25,25,25,25])
        p11.add([25,25, 27,27, 29,29, 5,5,5,5, 15,15,15,15])

        let p12 = add("55 77 99 7777 7777", mask: "gg gg gg rrrr 0000", note: "Kongs Like 7s",  family: Family.f13579, concealed: false, points: 25)
        p12.add([5,5, 7,7, 9,9, 17,17,17,17, 27,27,27,27])
        p12.add([15,15, 17,17, 19,19, 7,7,7,7, 27,27,27,27])
        p12.add([25,25, 27,27, 29,29, 7,7,7,7, 17,17,17,17])

        let p13 = add("55 77 99 9999 9999", mask: "gg gg gg rrrr 0000", note: "Kongs Like 9s",  family: Family.f13579, concealed: false, points: 25)
        p13.add([5,5, 7,7, 9,9, 19,19,19,19, 29,29,29,29])
        p13.add([15,15, 17,17, 19,19, 9,9,9,9, 29,29,29,29])
        p13.add([25,25, 27,27, 29,29, 9,9,9,9, 19,19,19,19])
        
        let p14 = add("111 3 555 555 7 999 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits, These Nos Only",  family: Family.f13579, concealed: true, points: 30)
        p14.generateList()
    }

    func addWindsAndDragons() {
        let p0 = add("NNNN EEEE WWWW SS", mask: "0000 0000 0000 00", note: "",  family: Family.winds, concealed: false, points: 25)
        p0.add([31,31,31,31, 34,34,34,34, 33,33,33,33, 32,32,])

        let p1 = add("NNNN E W SSSS 2019", mask: "0000 0 0 0000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p1.add([31,31,31,31, 34,33, 32,32,32,32, 2,10,1,9])
        p1.add([31,31,31,31, 34,33, 32,32,32,32, 12,10,11,19])
        p1.add([31,31,31,31, 34,33, 32,32,32,32, 22,10,21,29])
        
        let p2 = add("NNNN DD DD DD SSSS", mask: "0000 gg rr 00 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p2.add([31,31,31,31, 10,10, 20,20, 30,30, 32,32,32,32])
        
        let p3 = add("EEEE DD DD DD WWWW", mask: "0000 gg rr 00 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p3.add([33,33,33,33, 10,10, 20,20, 30,30, 34,34,34,34])

        let p4 = add("FF NN 1111 1111 SS", mask: "00 00 gggg rrrr 00", note: "Any Like Odd Nos.",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 1 {
                let d = i
                let b = i+10
                let c = i+20
                p4.add([35,35, 31,31, d,d,d,d, b,b,b,b, 32,32])
                p4.add([35,35, 31,31, d,d,d,d, c,c,c,c, 32,32])
                p4.add([35,35, 31,31, b,b,b,b, c,c,c,c, 32,32])
            }
        }

        let p5 = add("FF EE 2222 2222 WW", mask: "00 00 gggg rrrr 00", note: "Any Like Even Nos.",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 0 {
                let d = i
                let b = i+10
                let c = i+20
                p5.add([35,35, 34,34, d,d,d,d, b,b,b,b, 33,33])
                p5.add([35,35, 34,34, d,d,d,d, c,c,c,c, 33,33])
                p5.add([35,35, 34,34, b,b,b,b, c,c,c,c, 33,33])
            }
        }

        let p6 = add("FFF DDDD DDD DDDD", mask: "000 gggg rrr 0000", note: "Any 3 Suits",  family: Family.winds, concealed: false, points: 30)
        p6.add([35,35,35, 10,10,10,10, 20,20,20, 30,30,30,30])
        p6.add([35,35,35, 10,10,10,10, 30,30,30, 20,20,20,20])
        p6.add([35,35,35, 20,20,20,20, 10,10,10, 30,30,30,30])
        
        let p7 = add("FF NNN EEE WWW SSS (C)", mask: "00 000 000 000", note: "",  family: Family.winds, concealed: true, points: 30)
        p7.add([35,35, 31,31,31, 34,34,34, 33,33,33, 32,32,32])
    }

    func add369() {
        let p1 = add("33 66 333 666 9999", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p1.generateList()

        let p2 = add("333 6666 666 9999", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p2.generateList()

        let p3 = add("3333 666 9999 DDD", mask: "gggg 000 gggg 000", note: "Any 2 Suits, Dragons Match",  family: Family.f369, concealed: false, points: 25)
        p3.generateList()

        let p4 = add("FF 3333 6666 9999", mask: "00 0000 0000 0000", note: "",  family: Family.f369, concealed: false, points: 25)
        let p5 = add("FF 3333 6666 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p4.generateList()
        p5.generateList()

        let p6 = add("33 666 FFFF 666 99", mask: "gg ggg 0000 rrr rr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 30)
        p6.add([3,3, 6,6,6, 35,35,35,35, 16,16,16, 19,19])
        p6.add([3,3, 6,6,6, 35,35,35,35, 26,26,26, 29,29])
        p6.add([13,13, 16,16,16, 35,35,35,35, 6,6,6, 9,9])
        p6.add([13,13, 16,16,16, 35,35,35,35, 26,26,26, 29,29])
        p6.add([23,23, 26,26,26, 35,35,35,35, 6,6,6, 9,9])
        p6.add([23,23, 26,26,26, 35,35,35,35, 16,16,16, 19,19])
        
        let p7 = add("FF 333 666 999 DDD (C)", mask: "00 000 000 000 000", note: "",  family: Family.f369, concealed: true, points: 30)
        p7.generateList()
    }

    func addSinglesAndPairs() {
        let p1 = add("NN EE WW SS 11 11 11 (C)", mask: "00 00 00 00 gg rr 00", note: "Any Like Nos.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([31,31, 34,34, 33,33, 32,32, d,d, b,b, c,c])
        }
        
        let p2 = add("FF 22 4 6 88 22 4 6 88 (C)", mask: "00 gg g g gg rr r r rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p2.add([35,35, 2,2, 4,6, 8,8, 12,12, 14,16, 18,18])
        p2.add([35,35, 2,2, 4,6, 8,8, 22,22, 24,26, 28,28])
        p2.add([35,35, 12,12, 14,16, 18,18, 22,22, 24,26, 28,28])

        let p3 = add("113 11335 113355 (C)", mask: "ggg rrrrr 000000", note: "",  family: Family.pairs, concealed: true, points: 50)
        p3.add([1,1,3, 11,11,13,13,15, 21,21,23,23,25,25])
        p3.add([1,1,3, 21,21,23,23,25, 11,11,13,13,15,15])
        p3.add([11,11,13, 1,1,3,3,5, 21,21,23,23,25,25])
        p3.add([11,11,13, 21,21,23,23,25, 1,1,3,3,5,5])
        p3.add([21,21,23, 1,1,3,3,5, 11,11,13,13,15,15])
        p3.add([21,21,23, 11,11,13,13,15, 1,1,3,3,5,5])
        
        let p4 = add("557 55779 557799 (C)", mask: "ggg rrrrr 000000", note: "",  family: Family.pairs, concealed: true, points: 50)
        p4.add([5,5,7, 15,15,17,17,19, 25,25,27,27,29,29])
        p4.add([5,5,7, 25,25,27,27,29, 15,15,17,17,19,19])
        p4.add([15,15,17, 5,5,7,7,9, 25,25,27,27,29,29])
        p4.add([15,15,17, 25,25,27,27,29, 5,5,7,7,9,9])
        p4.add([25,25,27, 5,5,7,7,9, 15,15,17,17,19,19])
        p4.add([25,25,27, 15,15,17,17,19, 5,5,7,7,9,9])
        
        let p5 = add("11 22 33 44 55 66 77 (C)", mask: "00 00 00 00 00 00 00", note: "Any Run of 7 Nos.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...3 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([d,d, d+1,d+1, d+2,d+2, d+3,d+3, d+4,d+4, d+5,d+5, d+6,d+6])
            p5.add([b,b, b+1,b+1, b+2,b+2, b+3,b+3, b+4,b+4, b+5,b+5, b+6,b+6])
            p5.add([c,c, c+1,c+1, c+2,c+2, c+3,c+3, c+4,c+4, c+5,c+5, c+6,c+6])
        }

        let p6 = add("FF 33 66 99 33 66 99 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p6.add([35,35, 3,3, 6,6, 9,9, 13,13, 16,16, 19,19])
        p6.add([35,35, 3,3, 6,6, 9,9, 23,23, 26,26, 29,29])
        p6.add([35,35, 13,13, 16,16, 19,19, 23,23, 26,26, 29,29])
        
        let p7 = add("FF 11 22 DD 11 22 DD (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits, Any 2 Like Consec. No.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([35,35, d,d, d+1,d+1, 10,10, b,b, b+1,b+1, 20,20])
            p7.add([35,35, d,d, d+1,d+1, 10,10, c,c, c+1,c+1, 30,30])
            p7.add([35,35, b,b, b+1,b+1, 20,20, c,c, c+1,c+1, 30,30])
        }
        
        let p8 = add("FF 2019 2019 2019 (C)", mask: "00 gggg rrrr 0000", note: "",  family: Family.pairs, concealed: true, points: 60)
        p8.add([35,35, 2,10,1,9, 12,10,11,19, 22,10,21,29])
    }
    
}

