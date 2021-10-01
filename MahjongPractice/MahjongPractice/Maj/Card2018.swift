//
//  File.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 3/28/18.
//  Copyright © 2018 Ray. All rights reserved.
//

class Card2018 : Card {
    
    override init() {
        super.init()
        add2018()
        add2468()
        addLikeNumbers()
        addAdditionHands()
        addQuints()
        addConsectiveRun()
        add13579()
        addWindsAndDragons()
        add369()
        addSinglesAndPairs()
    }
    
    func add2018() {
        let p1 = add("222 000 1111 8888", mask: "000 000 gggg rrrr", note: "Any 3 Suits",  family: Family.year, concealed : false, points: 25)
        p1.generateList()
        let p2 = add("FF 2018 1111 1111", mask: "00 0000 gggg rrrr", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p2.add([35,35, 2,10,1,8, 11,11,11,11, 21,21,21,21])
        p2.add([35,35, 12,10,11,18, 1,1,1,1, 21,21,21,21 ])
        p2.add([35,35, 22,10,21,28, 1,1,1,1, 11,11,11,11])
        let p3 = add("FF 2018 2222 2222", mask: "00 0000 gggg rrrr", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p3.add([35,35, 2,10,1,8, 12,12,12,12, 22,22,22,22])
        p3.add([35,35, 12,10,11,18, 2,2,2,2, 22,22,22,22 ])
        p3.add([35,35, 22,10,21,28, 2,2,2,2, 12,12,12,12])
        let p4 = add("FF 2018 8888 8888", mask: "00 0000 gggg rrrr", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p4.add([35,35, 2,10,1,8, 18,18,18,18, 28,28,28,28])
        p4.add([35,35, 12,10,11,18, 8,8,8,8, 28,28,28,28 ])
        p4.add([35,35, 22,10,21,28, 8,8,8,8, 18,18,18,18])
        let p5 = add("FFFF 2222 0000 18", mask: "0000 0000 0000 00", note: "",  family: Family.year, concealed: false, points: 25)
        p5.add([35,35,35,35, 2,2,2,2,     10,10,10,10, 1,8])
        p5.add([35,35,35,35, 12,12,12,12, 10,10,10,10, 11,18])
        p5.add([35,35,35,35, 22,22,22,22, 10,10,10,10, 21,28])
        let p6 = add("22 000 NEWS 111 88 (C)", mask: "rr rrr 0000 rrr rr", note: "",  family: Family.year, concealed: true, points: 30)
        p6.add([2,2, 10,10,10, 31,34,33,32, 1,1,1, 8,8])
        p6.add([12,12, 10,10,10, 31,34,33,32, 11,11,11, 18,18])
        p6.add([22,22, 10,10,10, 31,34,33,32, 21,21,21, 28,28])
    }

    func add2468() {
        let p1 = add("FFF 22 44 666 8888", mask: "000 00 00 000 0000", note: "",  family: Family.f2468, concealed: false, points: 25)
        let p2 = add("2222 44 6666 88 88", mask: "0000 00 0000 gg rr", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 30)
        p2.add([2,2,2,2, 4,4, 6,6,6,6, 18,18, 28,28])
        p2.add([12,12,12,12, 14,14, 16,16,16,16, 8,8, 28,28])
        p2.add([22,22,22,22, 24,24, 26,26,26,26, 8,8, 18,18])
        let p3 = add("22 44 666 888 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p4 = add("2222 4444 6666 88", mask: "0000 0000 0000 00", note: "",  family: Family.f2468, concealed: false, points: 25)
        let p5 = add("222 444 6666 8888", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p6 = add("222 444 666 888 DD (C)", mask: "000 000 000 000 00", note: "Any 1 Suit",  family: Family.f2468, concealed: true, points: 30)
        p1.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
        p6.generateList()
    }
    
    func addLikeNumbers() {
        let p1 = add("FF 1111 DDDD 1111", mask: "00 gggg 0000 rrrr", note: "Any Like No.",  family: Family.likeNumbers, concealed: false, points: 25)
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
        let p3 = add("11 DD 111 DDD 1111 (C)", mask: "gg gg rrr rrr 0000", note: "Any Like No.",  family: Family.likeNumbers, concealed: true, points: 30)
        p3.generateList()
    }
    
    func addAdditionHands() {
        let p1 = add("FFFF 3333+9999=12", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p2 = add("FFFF 3333+9999=12", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        let p3 = add("FFFF 4444+8888=12", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p4 = add("FFFF 4444+8888=12", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
        let p5 = add("FFFF 5555+7777=12", mask: "0000 0000 0000 00", note: "",  family: Family.addition, concealed: false, points: 25)
        let p6 = add("FFFF 5555+7777=12", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.addition, concealed: false, points: 25)
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
        let p2 = add("FF 33333 66 99999", mask: "00 00000 00 00000", note: "",  family: Family.quints, concealed: false, points: 45)
        p2.generateList()
        let p3 = add("1123 11111 11111", mask: "gggg rrrrr 00000", note: "Any Run, Any Pair",  family: Family.quints, concealed: false, points: 40)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d,d+1,d+2, b,b,b,b,b, c,c,c,c,c])
            p3.add([b,b,b+1,b+2, d,d,d,d,d, c,c,c,c,c])
            p3.add([c,c,c+1,c+2, d,d,d,d,d, b,b,b,b,b])
            p3.add([d,d+1,d+1,d+2, b+1,b+1,b+1,b+1,b+1, c+1,c+1,c+1,c+1,c+1])
            p3.add([b,b+1,b+1,b+2, d+1,d+1,d+1,d+1,d+1, c+1,c+1,c+1,c+1,c+1])
            p3.add([c,c+1,c+1,c+2, d+1,d+1,d+1,d+1,d+1, b+1,b+1,b+1,b+1,b+1])
            p3.add([d,d+1,d+2,d+2, b+2,b+2,b+2,b+2,b+2, c+2,c+2,c+2,c+2,c+2])
            p3.add([b,b+1,b+2,b+2, d+2,d+2,d+2,d+2,d+2, c+2,c+2,c+2,c+2,c+2])
            p3.add([c,c+1,c+2,c+2, d+2,d+2,d+2,d+2,d+2, b+2,b+2,b+2,b+2,b+2])
        }
        let p4 = add("11111 22 33 44444", mask: "00000 00 00 00000", note: "Any 4 Consec. Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([d,d,d,d,d, d+1,d+1, d+2,d+2, d+3,d+3,d+3,d+3,d+3])
            p4.add([b,b,b,b,b, b+1,b+1, b+2,b+2, b+3,b+3,b+3,b+3,b+3])
            p4.add([c,c,c,c,c, c+1,c+1, c+2,c+2, c+3,c+3,c+3,c+3,c+3])
        }
    }
    
    func addConsectiveRun() {
        let p1 = add("11 22 333 444 5555", mask: "00 00 000 000 0000", note: "",  family: Family.run, concealed: false, points: 25)
        p1.add([1,1, 2,2, 3,3,3, 4,4,4, 5,5,5,5])
        p1.add([11,11, 12,12, 13,13,13, 14,14,14, 15,15,15,15])
        p1.add([21,21, 22,22, 23,23,23, 24,24,24, 25,25,25,25])
        let p2 = add("55 66 777 888 9999", mask: "00 00 000 000 0000", note: "",  family: Family.run, concealed: false, points: 25 )
        p2.add([5,5, 6,6, 7,7,7, 8,8,8, 9,9,9,9])
        p2.add([15,15, 16,16, 17,17,17, 18,18,18, 19,19,19,19])
        p2.add([25,25, 26,26, 27,27,27, 28,28,28, 29,29,29,29])
        let p3 = add("111 222 3333 4444", mask: "ggg ggg rrrr rrrr", note: "Any 4 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d,d, d+1,d+1,d+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p3.add([d,d,d, d+1,d+1,d+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p3.add([b,b,b, b+1,b+1,b+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p3.add([b,b,b, b+1,b+1,b+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p3.add([c,c,c, c+1,c+1,c+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p3.add([c,c,c, c+1,c+1,c+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
        }
        let p4 = add("FF 1111 2222 DDDD", mask: "00 0000 0000 0000", note: "Any 2 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([35,35, d,d,d,d, d+1,d+1,d+1,d+1, 10,10,10,10])
            p4.add([35,35, b,b,b,b, b+1,b+1,b+1,b+1, 20,20,20,20])
            p4.add([35,35, c,c,c,c, c+1,c+1,c+1,c+1, 30,30,30,30])
        }
        let p5 = add("11 22 33 4444 5555", mask: "gg gg gg rrrr 0000", note: "Any 5 Consec. Nos.",  family: Family.run, concealed: false, points: 30)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([d,d, d+1,d+1, d+2,d+2, b+3,b+3,b+3,b+3, c+4,c+4,c+4,c+4])
            p5.add([d,d, d+1,d+1, d+2,d+2, c+3,c+3,c+3,c+3, b+4,b+4,b+4,b+4])
            p5.add([b,b, b+1,b+1, b+2,b+2, d+3,d+3,d+3,d+3, c+4,c+4,c+4,c+4])
            p5.add([b,b, b+1,b+1, b+2,b+2, c+3,c+3,c+3,c+3, d+4,d+4,d+4,d+4])
            p5.add([c,c, c+1,c+1, c+2,c+2, d+3,d+3,d+3,d+3, b+4,b+4,b+4,b+4])
            p5.add([c,c, c+1,c+1, c+2,c+2, b+3,b+3,b+3,b+3, d+4,d+4,d+4,d+4])
        }
        let p6 = add("FF 1111 2222 3333", mask: "00 0000 0000 0000", note: "Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([35,35, d,d,d,d, d+1,d+1,d+1,d+1, d+2,d+2,d+2,d+2])
            p6.add([35,35, b,b,b,b, b+1,b+1,b+1,b+1, b+2,b+2,b+2,b+2])
            p6.add([35,35, c,c,c,c, c+1,c+1,c+1,c+1, c+2,c+2,c+2,c+2])
        }
        let p7 = add("FF 1111 2222 3333", mask: "00 gggg rrrr 0000", note: "Any 3 Suits, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([35,35, d,d,d,d, b+1,b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p7.add([35,35, d,d,d,d, c+1,c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p7.add([35,35, b,b,b,b, d+1,d+1,d+1,d+1, c+2,c+2,c+2,c+2])
            p7.add([35,35, b,b,b,b, c+1,c+1,c+1,c+1, d+2,d+2,d+2,d+2])
            p7.add([35,35, c,c,c,c, d+1,d+1,d+1,d+1, b+2,b+2,b+2,b+2])
            p7.add([35,35, c,c,c,c, b+1,b+1,b+1,b+1, d+2,d+2,d+2,d+2])
        }
        let p8 = add("1111 222 3333 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            let s = 10
            let g = 20
            let r = 30
            p8.add([d,d,d,d, b+1,b+1,b+1, d+2,d+2,d+2,d+2, g,g,g])
            p8.add([d,d,d,d, c+1,c+1,c+1, d+2,d+2,d+2,d+2, r,r,r])
            p8.add([b,b,b,b, d+1,d+1,d+1, b+2,b+2,b+2,b+2, s,s,s])
            p8.add([b,b,b,b, c+1,c+1,c+1, b+2,b+2,b+2,b+2, r,r,r])
            p8.add([c,c,c,c, d+1,d+1,d+1, c+2,c+2,c+2,c+2, s,s,s])
            p8.add([c,c,c,c, b+1,b+1,b+1, c+2,c+2,c+2,c+2, g,g,g])
        }
        let p9 = add("FF 111 222 111 222 (C)", mask: "00 ggg ggg rrr rrr", note: "Any 2 Suits, Any Run",  family: Family.run, concealed: true, points: 30)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p9.add([35,35, d,d,d, d+1,d+1,d+1, b,b,b, b+1,b+1,b+1])
            p9.add([35,35, d,d,d, d+1,d+1,d+1, c,c,c, c+1,c+1,c+1])
            p9.add([35,35, b,b,b, b+1,b+1,b+1, c,c,c, c+1,c+1,c+1])
        }
    }
    
    func add13579() {
        let p1 = add("11 33 555 777 9999", mask: "00 00 000 000 0000", note: "",  family: Family.f13579, concealed: false, points: 25)
        p1.add([1,1, 3,3, 5,5,5, 7,7,7, 9,9,9,9])
        p1.add([11,11, 13,13, 15,15,15, 17,17,17, 19,19,19,19])
        p1.add([21,21, 23,23, 25,25,25, 27,27,27, 29,29,29,29])
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
        let p4 = add("FF 1111 3333 5555", mask: "00 0000 0000 0000", note: "",  family: Family.f13579, concealed: false, points: 25)
        let p5 = add("FF 5555 7777 9999", mask: "00 0000 0000 0000", note: "",  family: Family.f13579, concealed: false, points: 25)
        let p6 = add("1111 333 5555 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        let p7 = add("5555 777 9999 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 25)
        let p8 = add("FFF 1111 FFF 5555", mask: "000 0000 000 0000", note: "",  family: Family.f13579, concealed: false, points: 30)
        let p9 = add("FFF 5555 FFF 9999", mask: "000 0000 000 0000", note: "",  family: Family.f13579, concealed: false, points: 30)
        let p10 = add("11 33 55 7777 9999", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 30)
        let p11 = add("FF 111 333 555 DDD (C)", mask: "00 000 000 000 000", note: "",  family: Family.f13579, concealed: true, points: 30)
        let p12 = add("FF 555 777 999 DDD (C)", mask: "00 000 000 000 000", note: "",  family: Family.f13579, concealed: true, points: 30)
        p4.generateList()
        p5.generateList()
        p6.generateList()
        p7.generateList()
        p8.generateList()
        p9.generateList()
        p10.generateList()
        p11.generateList()
        p12.generateList()
    }

    func addWindsAndDragons() {
        let p1 = add("FFFF NNNN DD SSSS", mask: "0000 0000 rr 0000", note: "Red Dragon only",  family: Family.winds, concealed: false, points: 25)
        p1.add([35,35,35,35, 31,31,31,31, 30,30, 32,32,32,32])
        let p2 = add("FFFF EEEE DD WWWW", mask: "0000 0000 gg 0000", note: "Green Dragon only",  family: Family.winds, concealed: false, points: 25)
        p2.add([35,35,35,35, 34,34,34,34, 20,20, 33,33,33,33])
        let p3 = add("NNNN EEEE WWWW SS", mask: "0000 0000 0000 00", note: "",  family: Family.winds, concealed: false, points: 25)
        p3.add([31,31,31,31, 34,34,34,34, 33,33,33,33, 32,32,])
        let p4 = add("FF DDDD NEWS DDDD", mask: "00 gggg 0000 rrrr", note: "Any 2 Dragons",  family: Family.winds, concealed: false, points: 25)
        p4.add([35,35, 10,10,10,10, 31,34,33,32, 20,20,20,20])
        p4.add([35,35, 10,10,10,10, 31,34,33,32, 30,30,30,30])
        p4.add([35,35, 20,20,20,20, 31,34,33,32, 30,30,30,30])
        let p5 = add("NNNN 11 11 11 SSSS", mask: "0000 gg rr 00 0000", note: "Like Odd No.",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 1 {
                let d = i
                let b = i+10
                let c = i+20
                p5.add([31,31,31,31, d,d, b,b, c,c, 32,32,32,32])
            }
        }
        let p6 = add("EEEE 22 22 22 WWWW", mask: "0000 gg rr 00 0000", note: "Like Even No.",  family: Family.winds, concealed: false, points: 30)
        for i in 1...9 {
            if i & 1 == 0 {
                let d = i
                let b = i+10
                let c = i+20
                p6.add([34,34,34,34, d,d, b,b, c,c, 33,33,33,33])
            }
        }
        let p7 = add("FF NNN EEE WWW SSS (C)", mask: "00 000 000 000", note: "",  family: Family.winds, concealed: true, points: 30)
        p7.add([35,35, 31,31,31, 34,34,34, 33,33,33, 32,32,32])
    }

    func add369() {
        let p1 = add("FFF 33 666 99 DDDD", mask: "000 00 000 00 0000", note: "",  family: Family.f369, concealed: false, points: 25)
        let p2 = add("333 666 6666 9999", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p1.generateList()
        p2.generateList()
        let p3 = add("33 66 99 3333 3333", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        p3.add([3,3,6,6,9,9, 13,13,13,13, 23,23,23,23])
        p3.add([13,13,16,16,19,19, 3,3,3,3, 23,23,23,23])
        p3.add([23,23,26,26,29,29, 3,3,3,3, 13,13,13,13])
        let p4 = add("33 66 99 6666 6666", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        p4.add([3,3,6,6,9,9, 16,16,16,16, 26,26,26,26])
        p4.add([13,13,16,16,19,19, 6,6,6,6, 26,26,26,26])
        p4.add([23,23,26,26,29,29, 6,6,6,6, 16,16,16,16])
        let p5 = add("33 66 99 9999 9999", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        p5.add([3,3,6,6,9,9, 19,19,19,19, 29,29,29,29])
        p5.add([13,13,16,16,19,19, 9,9,9,9, 29,29,29,29])
        p5.add([23,23,26,26,29,29, 9,9,9,9, 19,19,19,19])
        let p6 = add("FF 3333 6666 9999", mask: "00 0000 0000 0000", note: "",  family: Family.f369, concealed: false, points: 25)
        let p7 = add("FF 3333 6666 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        let p8 = add("3333 666 9999 DDD", mask: "gggg rrr gggg rrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p6.generateList()
        p7.generateList()
        p8.generateList()
        let p9 = add("333 6 999 333 6 999 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits",  family: Family.f369, concealed: true, points: 30)
        p9.add([3,3,3, 6, 9,9,9, 13,13,13, 16, 19,19,19])
        p9.add([3,3,3, 6, 9,9,9, 23,23,23, 26, 29,29,29])
        p9.add([13,13,13, 16, 19,19,19, 23,23,23, 26, 29,29,29])
    }

    func addSinglesAndPairs() {
        let p1 = add("NN EE WW SS 11 22 33 (C)", mask: "00 00 00 00 00 00 00", note: "Any 3 Consec. Nos.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([31,31, 34,34, 33,33, 32,32, d,d, d+1,d+1, d+2,d+2])
            p1.add([31,31, 34,34, 33,33, 32,32, b,b, b+1,b+1, b+2,b+2])
            p1.add([31,31, 34,34, 33,33, 32,32, c,c, c+1,c+1, c+2,c+2])
        }
        
        let p2 = add("FF 22 44 66 88 22 22 (C)", mask: "00 gg gg gg gg rr 00", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p2.add([35,35, 2,2, 4,4, 6,6, 8,8, 12,12, 22,22])
        p2.add([35,35, 12,12, 14,14, 16,16, 18,18, 2,2, 22,22])
        p2.add([35,35, 22,22, 24,24, 26,26, 28,28, 2,2, 12,12])
        
        let p3 = add("FF 22 44 66 88 44 44 (C)", mask: "00 gg gg gg gg rr 00", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p3.add([35,35, 2,2, 4,4, 6,6, 8,8, 14,14, 24,24])
        p3.add([35,35, 12,12, 14,14, 16,16, 18,18, 4,4, 24,24])
        p3.add([35,35, 22,22, 24,24, 26,26, 28,28, 4,4, 14,14])
        
        let p4 = add("FF 22 44 66 88 66 66 (C)", mask: "00 gg gg gg gg rr 00", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p4.add([35,35, 2,2, 4,4, 6,6, 8,8, 16,16, 26,26])
        p4.add([35,35, 12,12, 14,14, 16,16, 18,18, 6,6, 26,26])
        p4.add([35,35, 22,22, 24,24, 26,26, 28,28, 6,6, 16,16])
        
        let p5 = add("FF 22 44 66 88 88 88 (C)", mask: "00 gg gg gg gg rr 00", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p5.add([35,35, 2,2, 4,4, 6,6, 8,8, 18,18, 28,28])
        p5.add([35,35, 12,12, 14,14, 16,16, 18,18, 8,8, 28,28])
        p5.add([35,35, 22,22, 24,24, 26,26, 28,28, 8,8, 18,18])
        
        let p6 = add("FF 11 33 55 55 77 99 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p6.generateList()
        
        let p7 = add("FF 11 22 33 44 55 DD (C)", mask: "00 00 00 00 00 00 00", note: "Any 5 Consec. No.",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([35,35, d,d, d+1,d+1, d+2,d+2, d+3,d+3, d+4,d+4, 10,10])
            p7.add([35,35, b,b, b+1,b+1, b+2,b+2, b+3,b+3, b+4,b+4, 20,20])
            p7.add([35,35, c,c, c+1,c+1, c+2,c+2, c+3,c+3, c+4,c+4, 30,30])
        }
        
        let p8 = add("FF 33 66 99 33 66 99 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p8.add([35,35, 3,3, 6,6, 9,9, 13,13, 16,16, 19,19])
        p8.add([35,35, 3,3, 6,6, 9,9, 23,23, 26,26, 29,29])
        p8.add([35,35, 13,13, 16,16, 19,19, 23,23, 26,26, 29,29])
        
        let p9 = add("998 99887 998877 (C)", mask: "ggg rrrrr 000000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p9.add([9,9,8, 19,19,18,18,17, 29,29,28,28,27,27])
        p9.add([9,9,8, 29,29,28,28,27, 19,19,18,18,17,17])
        p9.add([19,19,18, 9,9,8,8,7, 29,29,28,28,27,27])
        p9.add([19,19,18, 29,29,28,28,27, 9,9,8,8,7,7])
        p9.add([29,29,28, 9,9,8,8,7, 19,19,18,18,17,17])
        p9.add([29,29,28, 19,19,18,18,17, 9,9,8,8,7,7])
        
        let p10 = add("FF 2018 DD 2018 DD (C)", mask: "00 gggg gg rrrr rr", note: "Bams & Craks Only",  family: Family.pairs, concealed: true, points: 60)
        p10.add([35,35, 12,10,11,18, 20,20, 22,10,21,28, 30,30])
    }
    
}

