//
//  Card2017.swift
//  Mahjong2017
//
//  Created by Ray on 4/9/17.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import Foundation

class Card2017 : Card {
    
    override init() {
        super.init()
        add2017()
        add2468()
        addLikeNumbers()
        addLucky13Hands()
        addQuints()
        addConsectiveRun()
        add13579()
        addWindsAndDragons()
        add369()
        addSinglesAndPairs()
        buildIdMaps()
    }
    
    func add2017() {
        let p1 = add("222 0000 111 7777", mask: "000 0000 rrr rrrr", note: "Any 2 Suits",  family: Family.year, concealed : false, points: 25)
        p1.generateList()
        let p2 = add("FF DDDD 2017 DDDD", mask: "00 gggg rrrr 0000", note: "Any 2 or 3 Suits",  family: Family.year, concealed: false, points: 25)
        p2.add([35,35, 10,10,10,10, 2,10,1,7, 20,20,20,20])
        p2.add([35,35, 10,10,10,10, 2,10,1,7, 30,30,30,30])
        p2.add([35,35, 10,10,10,10, 12,10,11,17, 20,20,20,20])
        p2.add([35,35, 10,10,10,10, 12,10,11,17, 30,30,30,30])
        p2.add([35,35, 10,10,10,10, 22,10,21,27, 20,20,20,20])
        p2.add([35,35, 10,10,10,10, 22,10,21,27, 30,30,30,30])
        p2.add([35,35, 20,20,20,20, 2,10,1,7, 30,30,30,30])
        p2.add([35,35, 20,20,20,20, 12,10,11,17, 30,30,30,30])
        p2.add([35,35, 20,20,20,20, 22,10,21,27, 30,30,30,30])
        let p3 = add("FF 2017 7777 7777", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p3.add([35,35, 2,10,1,7, 17,17,17,17, 27,27,27,27])
        p3.add([35,35, 12,10,11,17, 7,7,7,7, 27,27,27,27 ])
        p3.add([35,35, 22,10,21,27, 7,7,7,7, 17,17,17,17])
        let p4 = add("FF 222 000 111 777 (C)", mask: "00 000 000 000",   note: "",  family: Family.year, concealed: true, points: 30)
        p4.add([35,35, 2,2,2, 10,10,10, 1,1,1, 7,7,7])
        p4.add([35,35, 12,12,12, 10,10,10, 11,11,11, 17,17,17])
        p4.add([35,35, 22,22,22, 10,10,10, 21,21,21, 27,27,27])
    }
    
    func add2468() {
        let p1 = add("FFFF 2 44 666 8888", mask: "0000 0 00 000 0000", note: "",  family: Family.f2468, concealed: false, points: 25)
        let p2 = add("222 4444 666 8888", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p3 = add("2222 4444 6666 88", mask: "0000 0000 0000 00", note: "",  family: Family.f2468, concealed: false, points: 25)
        let p4 = add("22 44 444 666 8888", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p5 = add("22 44 666 888 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p6 = add("FF 222 444 666 888 (C)", mask: "00 000 000 000 000", note: "",  family: Family.f2468, concealed: true, points: 30)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
        p6.generateList()
    }
    
    func addLikeNumbers() {
        let p1 = add("FF 1111 DDDD 1111", mask: "00 gggg rrrr 0000", note: "Any Like No.",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([35,35, b,b,b,b, 10,10,10,10, c,c,c,c])
            p1.add([35,35, d,d,d,d, 20,20,20,20, c,c,c,c])
            p1.add([35,35, d,d,d,d, 30,30,30,30, b,b,b,b])
        }
        let p2 = add("FFF 1111 FFF 1111", mask: "000 gggg 000 rrrr", note: "Any Like No.",  family: Family.likeNumbers, concealed: false, points: 30)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([35,35,35, d,d,d,d, 35,35,35, b,b,b,b])
            p2.add([35,35,35, d,d,d,d, 35,35,35, c,c,c,c])
            p2.add([35,35,35, b,b,b,b, 35,35,35, c,c,c,c])
        }
    }
    
    func addLucky13Hands() {
        let p1 = add("FFFF 4444+9999=13", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p2 = add("FFFF 4444+9999=13", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        let p3 = add("FFFF 5555+8888=13", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p4 = add("FFFF 5555+8888=13", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        let p5 = add("FFFF 6666+7777=13", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p6 = add("FFFF 6666+7777=13", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
        p6.generateList()
    }
    
    func addQuints() {
        let p1 = add("NNNNN DDDD 11111", mask: "00000 gggg rrrrr", note: "Any Wind, Dragon or No.",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p1.add([w,w,w,w,w, 10,10,10,10, d,d,d,d,d])
                p1.add([w,w,w,w,w, 20,20,20,20, d,d,d,d,d])
                p1.add([w,w,w,w,w, 30,30,30,30, d,d,d,d,d])
                p1.add([w,w,w,w,w, 10,10,10,10, b,b,b,b,b])
                p1.add([w,w,w,w,w, 20,20,20,20, b,b,b,b,b])
                p1.add([w,w,w,w,w, 30,30,30,30, b,b,b,b,b])
                p1.add([w,w,w,w,w, 10,10,10,10, c,c,c,c,c])
                p1.add([w,w,w,w,w, 20,20,20,20, c,c,c,c,c])
                p1.add([w,w,w,w,w, 30,30,30,30, c,c,c,c,c])
            }
        }
        let p2 = add("11111 1111 11111", mask: "ggggg rrrr 00000", note: "Any Like No.",  family: Family.quints, concealed: false, points: 40)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([d,d,d,d,d, b,b,b,b, c,c,c,c,c])
            p2.add([d,d,d,d,d, c,c,c,c, b,b,b,b,b])
            p2.add([b,b,b,b,b, d,d,d,d, c,c,c,c,c])
        }
        let p3 = add("FF 11111 22 33333", mask: "00 00000 00 00000", note: "Any 3 Consec. Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([35,35, d,d,d,d,d, d+1,d+1, d+2,d+2,d+2,d+2,d+2])
            p3.add([35,35, b,b,b,b,b, b+1,b+1, b+2,b+2,b+2,b+2,b+2])
            p3.add([35,35, c,c,c,c,c, c+1,c+1, c+2,c+2,c+2,c+2,c+2])
        }
        let p4 = add("111 3333 55555 DD", mask: "000 0000 00000 00", note: "",  family: Family.quints, concealed: false, points: 40)
        p4.generateList()
        let p5 = add("555 7777 99999 DD", mask: "000 0000 00000 00", note: "",  family: Family.quints, concealed: false, points: 40)
        p5.generateList()
    }
    
    func addConsectiveRun() {
        let p1 = add("11 222 3333 444 55", mask: "00 000 0000 000 00", note: "",  family: Family.run, concealed: false, points: 25)
        p1.add([1,1, 2,2,2, 3,3,3,3, 4,4,4, 5,5])
        p1.add([11,11, 12,12,12, 13,13,13,13, 14,14,14, 15,15])
        p1.add([21,21, 22,22,22, 23,23,23,23, 24,24,24, 25,25])
        let p2 = add("55 666 7777 888 99", mask: "00 000 0000 000 00", note: "",  family: Family.run, concealed: false, points: 25)
        p2.add([5,5, 6,6,6, 7,7,7,7, 8,8,8, 9,9])
        p2.add([15,15, 16,16,16, 17,17,17,17, 18,18,18, 19,19])
        p2.add([25,25, 26,26,26, 27,27,27,27, 28,28,28, 29,29])
        let p3 = add("111 2222 333 4444", mask: "ggg gggg rrr rrrr", note: "Any 4 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d,d, d+1,d+1,d+1,d+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p3.add([d,d,d, d+1,d+1,d+1,d+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p3.add([b,b,b, b+1,b+1,b+1,b+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p3.add([b,b,b, b+1,b+1,b+1,b+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p3.add([c,c,c, c+1,c+1,c+1,c+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p3.add([c,c,c, c+1,c+1,c+1,c+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3])
        }
        let p4 = add("FF 1111 2222 3333", mask: "00 gggg rrrr 0000", note: "Any 3 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([35,35, d,d,d,d, b+1,b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p4.add([35,35, d,d,d,d, c+1,c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p4.add([35,35, b,b,b,b, d+1,d+1,d+1,d+1, c+2,c+2,c+2,c+2])
            p4.add([35,35, b,b,b,b, c+1,c+1,c+1,c+1, d+2,d+2,d+2,d+2])
            p4.add([35,35, c,c,c,c, d+1,d+1,d+1,d+1, b+2,b+2,b+2,b+2])
            p4.add([35,35, c,c,c,c, b+1,b+1,b+1,b+1, d+2,d+2,d+2,d+2])
        }
        let p5 = add("11 22 111 222 3333", mask: "gg gg rrr rrr", note: "Any 3 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([d,d, d+1,d+1, b,b,b, b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p5.add([d,d, d+1,d+1, c,c,c, c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p5.add([b,b, b+1,b+1, d,d,d, d+1,d+1,d+1, c+2,c+2,c+2,c+2])
            p5.add([b,b, b+1,b+1, c,c,c, c+1,c+1,c+1, d+2,d+2,d+2,d+2])
            p5.add([c,c, c+1,c+1, d,d,d, d+1,d+1,d+1, b+2,b+2,b+2,b+2])
            p5.add([c,c, c+1,c+1, b,b,b, b+1,b+1,b+1, d+2,d+2,d+2,d+2])
        }
        let p6 = add("FFFF 1111 2222 DD", mask: "0000 0000 0000 00", note: "Any 2 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([35,35,35,35, d,d,d,d, d+1,d+1,d+1,d+1, 10,10])
            p6.add([35,35,35,35, b,b,b,b, b+1,b+1,b+1,b+1, 20,20])
            p6.add([35,35,35,35, c,c,c,c, c+1,c+1,c+1,c+1, 30,30])
        }
        let p7 = add("1111 22 22 22 3333", mask: "gggg rr gg 00 gggg", note: "Any 3 Consec. Nos.",  family: Family.run, concealed: false, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([d,d,d,d, d+1,d+1, b+1,b+1, c+1,c+1, d+2,d+2,d+2,d+2])
            p7.add([b,b,b,b, d+1,d+1, b+1,b+1, c+1,c+1, b+2,b+2,b+2,b+2])
            p7.add([c,c,c,c, d+1,d+1, b+1,b+1, c+1,c+1, c+2,c+2,c+2,c+2])
        }
        let p8 = add("111 22 333 DDD DDD (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Consec. Nos.",  family: Family.run, concealed: true, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p8.add([d,d,d, d+1,d+1, d+2,d+2,d+2, 20,20,20, 30,30,30])
            p8.add([b,b,b, b+1,b+1, b+2,b+2,b+2, 10,10,10, 30,30,30])
            p8.add([c,c,c, c+1,c+1, c+2,c+2,c+2, 10,10,10, 20,20,20])
        }
    }
    
    func add13579() {
        add13579_23432_1()
        add1335_3434_2()
        add5779_3434_2()
        add1335D_22334_3()
        add5779D_22334_3()
        addF135_2444_1()
        addF579_2444_1()
        add13579_42224_2()
        add13135_22334_3()
        add57579_22334_3()
        add135579_313313_C()
    }
    
    func addWindsAndDragons() {
        let p1 = add("NNNN EEEE WWWW SS", mask: "", note: "",  family: Family.winds, concealed: false, points: 25)
        p1.add([31,31,31,31, 34,34,34,34, 33,33,33,33, 32,32,])
        let p2 = add("NNNN DD DD DD SSSS", mask: "0000 gg 00 rr 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p2.add([31,31,31,31, 10,10, 20,20, 30,30, 32,32,32,32])
        let p3 = add("EEEE DD DD DD WWWW", mask: "0000 gg 00 rr 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p3.add([33,33,33,33, 10,10, 20,20, 30,30, 34,34,34,34])
        let p4 = add("11 NNN 11 SSS 1111 (C)", mask: "gg 000 rr 000 0000", note: "Like Odd No.",  family: Family.winds, concealed: true, points: 30)
        for i in [1,3,5,7,9] {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([d,d, 31,31,31, b,b, 32,32,32, c,c,c,c])
            p4.add([d,d, 31,31,31, c,c, 32,32,32, b,b,b,b])
            p4.add([b,b, 31,31,31, c,c, 32,32,32, d,d,d,d])
        }
        let p5 = add("22 EEE 22 WWW 2222 (C)", mask: "gg 000 rr 000 0000", note: "Like Even No.",  family: Family.winds, concealed: true, points: 30)
        for i in [2,4,6,8] {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([d,d, 33,33,33, b,b, 34,34,34, c,c,c,c])
            p5.add([d,d, 33,33,33, c,c, 34,34,34, b,b,b,b])
            p5.add([b,b, 33,33,33, c,c, 34,34,34, d,d,d,d])
        }
        let p6 = add("FFF NNNN FFF SSSS", mask: "000 0000 000 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p6.add([35,35,35, 31,31,31,31, 35,35,35, 32,32,32,32])
        let p7 = add("FFF EEEE FFF WWWW", mask: "000 0000 000 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p7.add([35,35,35, 33,33,33,33, 35,35,35, 34,34,34,34])
        let p8 = add("FF DDDD DDDD DDDD", mask: "00 gggg rrrr 0000", note: "",  family: Family.winds, concealed: false, points: 30)
        p8.add([35,35, 10,10,10,10, 20,20,20,20, 30,30,30,30])
    }
 
    func add369() {
        let p1 = add("3333 66 9999 DDDD", mask: "0000 00 0000 0000", note: "",  family: Family.f369, concealed: false, points: 25)
        let p2 = add("333 6666 666 9999", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        let p3 = add("FF 3333 6666 9999", mask: "00 0000 0000 0000", note: "",  family: Family.f369, concealed: false, points: 25)
        let p4 = add("FF 3333 6666 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        let p5 = add("33 66 333 666 9999", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        let p6 = add("33 66 99 3333 3333", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        p6.add([3,3,6,6,9,9, 13,13,13,13, 23,23,23,23])
        p6.add([13,13,16,16,19,19, 3,3,3,3, 23,23,23,23])
        p6.add([23,23,26,26,29,29, 3,3,3,3, 13,13,13,13])
        let p7 = add("33 66 99 6666 6666", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        p7.add([3,3,6,6,9,9, 16,16,16,16, 26,26,26,26])
        p7.add([13,13,16,16,19,19, 6,6,6,6, 26,26,26,26])
        p7.add([23,23,26,26,29,29, 6,6,6,6, 16,16,16,16])
        let p8 = add("33 66 99 9999 9999", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        p8.add([3,3,6,6,9,9, 19,19,19,19, 29,29,29,29])
        p8.add([13,13,16,16,19,19, 9,9,9,9, 29,29,29,29])
        p8.add([23,23,26,26,29,29, 9,9,9,9, 19,19,19,19])
        let p9 = add("FF 333 666 999 999 (C)", mask: "00 ggg ggg rrr 000", note: "Any 3 Suits",  family: Family.f369, concealed: true, points: 30)
        p9.add([35,35, 3,3,3,    6,6,6,    19,19,19, 29,29,29])
        p9.add([35,35, 13,13,13, 16,16,16, 9,9,9,    29,29,29])
        p9.add([35,35, 23,23,23, 26,26,26, 9,9,9,    19,19,19])
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
    }
    
    func addSinglesAndPairs() {
        let p1 = add("NN EE WW SS 11 11 11 (C)", mask: "00 00 00 00 gg rr 00", note: "Any Like No.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([31,31, 32,32, 33,33, 34,34, d,d, b,b, c,c])
        }
        let p2 = add("11 22 33 44 55 66 77 (C)", mask: "00 00 00 00 00 00 00", note: "Any 7 Consec. No.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...3 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([d,d, d+1,d+1, d+2,d+2, d+3,d+3, d+4,d+4, d+5,d+5, d+6,d+6])
            p2.add([b,b, b+1,b+1, b+2,b+2, b+3,b+3, b+4,b+4, b+5,b+5, b+6,b+6])
            p2.add([c,c, c+1,c+1, c+2,c+2, c+3,c+3, c+4,c+4, c+5,c+5, c+6,c+6])
        }
        let p3 = add("336 33669 336699 (C)", mask: "ggg rrrrr 000000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p3.add([3,3,6, 13,13,16,16,19, 23,23,26,26,29,29])
        p3.add([3,3,6, 23,23,26,26,29, 13,13,16,16,19,19])
        p3.add([13,13,16, 3,3,6,6,9, 23,23,26,26,29,29])
        p3.add([13,13,16, 23,23,26,26,29, 3,3,6,6,9,9])
        p3.add([23,23,26, 3,3,6,6,9, 13,13,16,16,19,19])
        p3.add([23,23,26, 13,13,16,16,19, 3,3,6,6,9,9])

        let p4 = add("FF 22 4 6 88 22 4 6 88 (C)", mask: "00 gg g g gg rr r r rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p4.add([35,35, 2,2,4,6,8,8, 12,12,14,16,18,18])
        p4.add([35,35, 2,2,4,6,8,8, 22,22,24,26,28,28])
        p4.add([35,35, 12,12,14,16,18,18, 22,22,24,26,28,28])
        
        let p5 = add("11 33 55 77 99 11 11 (C)", mask: "gg gg gg gg gg rr 00", note: "Any Like Odd Prs",  family: Family.pairs, concealed: true, points: 50)
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
        
        let p6 = add("FF 11 22 11 22 11 22 (C)", mask: "00 gg gg rr rr 00 00", note: "Any 2 Consec. Nos.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([35,35, d,d,d+1,d+1, b,b,b+1,b+1, c,c,c+1,c+1])
        }
        
        let p7 = add("FF 2017 DD 2017 DD (C)", mask: "00 gggg gg rrrr rr", note: "Bams & Craks Only",  family: Family.pairs, concealed: true, points: 60)
        p7.add([35,35, 12,10,11,17, 20,20, 22,10,21,27, 30,30])
    }
}
