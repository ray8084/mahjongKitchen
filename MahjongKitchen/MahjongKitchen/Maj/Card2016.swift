//
//  Card2017.swift
//  Mahjong2017
//
//  Created by Ray on 4/9/17.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import Foundation

class Card2016 : Card {
 
    override init() {
        super.init()
        add2016()
        add2468()
        addLikeNumbers()
        addElevenHands()
        addQuints()
        addConsectiveRun()
        add13579()
        addWindsAndDragons()
        add369()
        addSinglesAndPairs()
    }
    
    override func getYear() -> String {
        return "2016"
    }
    
    func add2016() {
        let p1 = add("FF NNNN 2016 SSSS", mask: "00 0000 0000 0000", note: "",  family: Family.year, concealed: false)
        let p2 = add("FF EEEE 2016 WWWW", mask: "00 0000 0000 0000", note: "",  family: Family.year, concealed: false)
        let p3 = add("222 000 1111 6666", mask: "ggg 000 rrrr 0000", note: "Any 3 Suits",  family: Family.year, concealed: false)
        let p4 = add("FFFF 2222 0000 16", mask: "0000 0000 0000 00", note: "",  family: Family.year, concealed: false)
        let p5 = add("FF 222 000 111 666 (C)", mask: "00 000 000 000 000", note: "",  family: Family.year, concealed: true)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
    }
    
    func add2468() {
        let p1 = add("FFFF 22 44 666 888", mask: "0000 00 00 000 000", note: "",  family: Family.f2468, concealed: false)
        let p2 = add("222 444 6666 8888", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false)
        let p3 = add("2222 44 6666 88 88", mask: "gggg gg gggg rr 00", note: "Any 3 Suits",  family: Family.f2468, concealed: false)
        let p4 = add("22 44 444 666 8888", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false)
        let p5 = add("2222 4444 6666 88", mask: "0000 0000 0000 00", note: "",  family: Family.f2468, concealed: false)
        let p6 = add("FF 222 DDD 888 DDD (C)", mask: "00 ggg ggg rrr rrr", note: "Any 2 Suits",  family: Family.f2468, concealed: true)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
        p6.generateList()
    }
    
    func addLikeNumbers() {
        let p1 = add("FFFF 1111 11 1111", mask: "0000 gggg rr 0000", note: "Any Like No.",  family: Family.likeNumbers, concealed: false)
        let p2 = add("11 DD 111 DDD 1111 (C)", mask: "gg gg rrr rrr 0000", note: "Any Like No.",  family: Family.likeNumbers, concealed: true)
        p1.generateList()
        p2.generateList()
    }
    
    func addElevenHands() {
        let p1 = add("FFFF 2222+9999=11", mask: "", note: "",  family: Family.addition, concealed: false)
        let p2 = add("FFFF 2222+9999=11", mask: "0000 gggg rrrr", note: "Any 3 Suits",  family: Family.addition, concealed: false)
        let p3 = add("FFFF 3333+8888=11", mask: "", note: "",  family: Family.addition, concealed: false)
        let p4 = add("FFFF 3333+8888=11", mask: "0000 gggg rrrr", note: "Any 3 Suits",  family: Family.addition, concealed: false)
        let p5 = add("FFFF 4444+7777=11", mask: "", note: "",  family: Family.addition, concealed: false)
        let p6 = add("FFFF 4444+7777=11", mask: "0000 gggg rrrr", note: "Any 3 Suits",  family: Family.addition, concealed: false)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        p5.generateList()
        p6.generateList()
    }
    
    func addQuints() {
        let p1 = add("1123 11111 11111", mask: "gggg rrrrr", note: "Any Run, Any Pair",  family: Family.quints, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([d,d,d+1,d+2, b,b,b,b,b, c,c,c,c,c])
            p1.add([b,b,b+1,b+2, d,d,d,d,d, c,c,c,c,c])
            p1.add([c,c,c+1,c+2, d,d,d,d,d, b,b,b,b,b])
            p1.add([d,d+1,d+1,d+2, b+1,b+1,b+1,b+1,b+1, c+1,c+1,c+1,c+1,c+1])
            p1.add([b,b+1,b+1,b+2, d+1,d+1,d+1,d+1,d+1, c+1,c+1,c+1,c+1,c+1])
            p1.add([c,c+1,c+1,c+2, d+1,d+1,d+1,d+1,d+1, b+1,b+1,b+1,b+1,b+1])
            p1.add([d,d+1,d+2,d+2, b+2,b+2,b+2,b+2,b+2, c+2,c+2,c+2,c+2,c+2])
            p1.add([b,b+1,b+2,b+2, d+2,d+2,d+2,d+2,d+2, c+2,c+2,c+2,c+2,c+2])
            p1.add([c,c+1,c+2,c+2, d+2,d+2,d+2,d+2,d+2, b+2,b+2,b+2,b+2,b+2])
        }
        let p2 = add("11111 2222 33333", mask: "", note: "Any 3 Consec, Nos.",  family: Family.quints, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([d,d,d,d,d, d+1,d+1,d+1,d+1, d+2,d+2,d+2,d+2,d+2])
            p2.add([b,b,b,b,b, b+1,b+1,b+1,b+1, b+2,b+2,b+2,b+2,b+2])
            p2.add([c,c,c,c,c, c+1,c+1,c+1,c+1, c+2,c+2,c+2,c+2,c+2])
        }
        let p3 = add("11111 2222 33333", mask: "ggggg rrrr", note: "Any 3 Consec, Nos.",  family: Family.quints, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d,d,d,d, b+1,b+1,b+1,b+1, c+2,c+2,c+2,c+2,c+2])
            p3.add([d,d,d,d,d, c+1,c+1,c+1,c+1, b+2,b+2,b+2,b+2,b+2])
            p3.add([b,b,b,b,b, d+1,d+1,d+1,d+1, c+2,c+2,c+2,c+2,c+2])
            p3.add([b,b,b,b,b, c+1,c+1,c+1,c+1, d+2,d+2,d+2,d+2,d+2])
            p3.add([c,c,c,c,c, d+1,d+1,d+1,d+1, b+2,b+2,b+2,b+2,b+2])
            p3.add([c,c,c,c,c, b+1,b+1,b+1,b+1, d+2,d+2,d+2,d+2,d+2])
        }
        let p4 = add("FFFF NNNNN 11111", mask: "", note: "Any Wind, Any  No.",  family: Family.quints, concealed: false)
        for w in 31...34 {
            for i in 1...9 {
                let d = i
                let b = i+10
                let c = i+20
                p4.add([35,35,35,35, w,w,w,w,w, d,d,d,d,d])
                p4.add([35,35,35,35, w,w,w,w,w, b,b,b,b,b])
                p4.add([35,35,35,35, w,w,w,w,w, c,c,c,c,c])
            }
        }
        let p5 = add("FF 11111 66 77777", mask: "", note: "",  family: Family.quints, concealed: false)
        let p6 = add("FF 11111 66 77777", mask: "00 ggggg rr", note: "Any 3 Suits",  family: Family.quints, concealed: false)
        p5.generateList()
        p6.generateList()
    }
    
    func addConsectiveRun() {
        let p1 = add("11 22 333 444 5555", mask: "", note: "",  family: Family.run, concealed: false)
        p1.add([1,1, 2,2, 3,3,3, 4,4,4, 5,5,5,5])
        p1.add([11,11, 12,12, 13,13,13, 14,14,14, 15,15,15,15])
        p1.add([21,21, 22,22, 23,23,23, 24,24,24, 25,25,25,25])
        let p2 = add("55 66 777 888 9999", mask: "", note: "",  family: Family.run, concealed: false)
        p2.add([5,5, 6,6, 7,7,7, 8,8,8, 9,9,9,9])
        p2.add([15,15, 16,16, 17,17,17, 18,18,18, 19,19,19,19])
        p2.add([25,25, 26,26, 27,27,27, 28,28,28, 29,29,29,29])
        let p3 = add("111 222 3333 4444", mask: "ggg ggg rrrr rrrr", note: "Any 4 Consec. Nos.",  family: Family.run, concealed: false)
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
        let p4 = add("1111 22 22 22 3333", mask: "gggg rr gg 00 gggg", note: "Any 3 Consec. Nos.",  family: Family.run, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([d,d,d,d, d+1,d+1, b+1,b+1, c+1,c+1, d+2,d+2,d+2,d+2])
            p4.add([b,b,b,b, d+1,d+1, b+1,b+1, c+1,c+1, b+2,b+2,b+2,b+2])
            p4.add([c,c,c,c, d+1,d+1, b+1,b+1, c+1,c+1, c+2,c+2,c+2,c+2])
        }
        let p5 = add("111 2222 333 DDDD", mask: "ggg rrrr ggg rrrr", note: "Any 3 Consec. Nos.",  family: Family.run, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            let s = 10
            let g = 20
            let r = 30
            p5.add([d,d,d, b+1,b+1,b+1,b+1, d+2,d+2,d+2, g,g,g,g])
            p5.add([d,d,d, c+1,c+1,c+1,c+1, d+2,d+2,d+2, r,r,r,r])
            p5.add([b,b,b, d+1,d+1,d+1,d+1, b+2,b+2,b+2, s,s,s,s])
            p5.add([b,b,b, c+1,c+1,c+1,c+1, b+2,b+2,b+2, r,r,r,r])
            p5.add([c,c,c, d+1,d+1,d+1,d+1, c+2,c+2,c+2, s,s,s,s])
            p5.add([c,c,c, b+1,b+1,b+1,b+1, c+2,c+2,c+2, g,g,g,g])
        }
        let p6 = add("11 22 111 222 3333", mask: "gg gg rrr rrr", note: "Any 3 Consec. Nos.",  family: Family.run, concealed: false)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([d,d, d+1,d+1, b,b,b, b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p6.add([d,d, d+1,d+1, c,c,c, c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p6.add([b,b, b+1,b+1, d,d,d, d+1,d+1,d+1, c+2,c+2,c+2,c+2])
            p6.add([b,b, b+1,b+1, c,c,c, c+1,c+1,c+1, d+2,d+2,d+2,d+2])
            p6.add([c,c, c+1,c+1, d,d,d, d+1,d+1,d+1, b+2,b+2,b+2,b+2])
            p6.add([c,c, c+1,c+1, b,b,b, b+1,b+1,b+1, d+2,d+2,d+2,d+2])
        }
        let p7 = add("FF 111 222 333 444 (C)", mask: "", note: "Any 4 Consec. Nos.",  family: Family.run, concealed: true)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([35,35, d,d,d, d+1,d+1,d+1, d+2,d+2,d+2, d+3,d+3,d+3])
            p7.add([35,35, b,b,b, b+1,b+1,b+1, b+2,b+2,b+2, b+3,b+3,b+3])
            p7.add([35,35, c,c,c, c+1,c+1,c+1, c+2,c+2,c+2, c+3,c+3,c+3])
        }
    }
    
    func add13579() {
        let p1 = add("11 33 555 777 9999", mask: "", note: "",  family: Family.f13579, concealed: false)
        p1.add([1,1, 3,3, 5,5,5, 7,7,7, 9,9,9,9])
        p1.add([11,11, 13,13, 15,15,15, 17,17,17, 19,19,19,19])
        p1.add([21,21, 23,23, 25,25,25, 27,27,27, 29,29,29,29])
        let p2 = add("111 333 3333 5555", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false)
        p2.add([1,1,1, 3,3,3, 13,13,13,13, 15,15,15,15])
        p2.add([1,1,1, 3,3,3, 23,23,23,23, 25,25,25,25])
        p2.add([11,11,11, 13,13,13, 3,3,3,3, 5,5,5,5])
        p2.add([11,11,11, 13,13,13, 23,23,23,23, 25,25,25,25])
        p2.add([21,21,21, 23,23,23, 3,3,3,3, 5,5,5,5])
        p2.add([21,21,21, 23,23,23, 13,13,13,13, 15,15,15,15])
        let p3 = add("555 777 7777 9999", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f13579, concealed: false)
        p3.add([5,5,5, 7,7,7, 17,17,17,17, 19,19,19,19])
        p3.add([5,5,5, 7,7,7, 27,27,27,27, 29,29,29,29])
        p3.add([15,15,15, 17,17,17, 7,7,7,7, 9,9,9,9])
        p3.add([15,15,15, 17,17,17, 27,27,27,27, 29,29,29,29])
        p3.add([25,25,25, 27,27,27, 7,7,7,7, 9,9,9,9])
        p3.add([25,25,25, 27,27,27, 17,17,17,17, 19,19,19,19])
        let p4 = add("1111 33 55 77 9999", mask: "gggg rr rr rr gggg", note: "Any 2 Suits",  family: Family.f13579, concealed: false)
        p4.add([1,1,1,1, 13,13, 15,15, 17,17, 9,9,9,9])
        p4.add([1,1,1,1, 23,23, 25,25, 27,27, 9,9,9,9])
        p4.add([11,11,11,11, 3,3, 5,5, 7,7, 19,19,19,19])
        p4.add([11,11,11,11, 23,23, 25,25, 27,27, 19,19,19,19])
        p4.add([21,21,21,21, 3,3, 5,5, 7,7, 29,29,29,29])
        p4.add([21,21,21,21, 13,13, 15,15, 17,17, 29,29,29,29])
        let p5 = add("11 333 DDDD 333 55", mask: "gg ggg rrrr", note: "Any 3 Suits",  family: Family.f13579, concealed: false)
        p5.add([1,1, 3,3,3, 20,20,20,20, 23,23,23, 25,25])
        p5.add([1,1, 3,3,3, 30,30,30,30, 13,13,13, 15,15])
        p5.add([11,11, 13,13,13, 10,10,10,10, 23,23,23, 25,25])
        p5.add([11,11, 13,13,13, 30,30,30,30, 3,3,3, 5,5])
        p5.add([21,21, 23,23,23, 10,10,10,10, 13,13,13, 15,15])
        p5.add([21,21, 23,23,23, 20,20,20,20, 3,3,3, 5,5])
        let p6 = add("55 777 DDDD 777 99", mask: "gg ggg rrrr", note: "Any 3 Suits",  family: Family.f13579, concealed: false)
        p6.add([5,5, 7,7,7, 20,20,20,20, 27,27,27, 29,29])
        p6.add([5,5, 7,7,7, 30,30,30,30, 17,17,17, 19,19])
        p6.add([15,15, 17,17,17, 10,10,10,10, 27,27,27, 29,29])
        p6.add([15,15, 17,17,17, 30,30,30,30, 7,7,7, 9,9])
        p6.add([25,25, 27,27,27, 10,10,10,10, 17,17,17, 19,19])
        p6.add([25,25, 27,27,27, 20,20,20,20, 7,7,7, 9,9])
        let p7 = add("FFFF 1111 33 5555", mask: "", note: "",  family: Family.f13579, concealed: false)
        p7.add([35,35,35,35, 1,1,1,1, 3,3, 5,5,5,5])
        p7.add([35,35,35,35, 11,11,11,11, 13,13, 15,15,15,15])
        p7.add([35,35,35,35, 21,21,21,21, 23,23, 25,25,25,25])
        let p8 = add("FFFF 5555 77 9999", mask: "", note: "",  family: Family.f13579, concealed: false)
        p8.add([35,35,35,35, 5,5,5,5, 7,7, 9,9,9,9])
        p8.add([35,35,35,35, 15,15,15,15, 17,17, 19,19,19,19])
        p8.add([35,35,35,35, 25,25,25,25, 27,27, 29,29,29,29])
        let p9 = add("11 33 555 777 9999", mask: "gg gg rrr rrr", note: "Any 3 Suits",  family: Family.f13579, concealed: false)
        p9.add([1,1, 3,3, 15,15,15, 17,17,17, 29,29,29,29])
        p9.add([1,1, 3,3, 25,25,25, 27,27,27, 19,19,19,19])
        p9.add([11,11, 13,13, 5,5,5, 7,7,7, 29,29,29,29])
        p9.add([11,11, 13,13, 25,25,25, 27,27,27, 9,9,9,9])
        p9.add([21,21, 23,23, 5,5,5, 7,7,7, 19,19,19,19])
        p9.add([21,21, 23,23, 15,15,15, 17,17,17, 9,9,9,9])
        let p10 = add("FF 111 333 555 DDD (C)", mask: "", note: "",  family: Family.f13579, concealed: true)
        p10.add([35,35, 1,1,1, 3,3,3, 5,5,5, 10,10,10])
        p10.add([35,35, 11,11,11, 13,13,13, 15,15,15, 20,20,20])
        p10.add([35,35, 21,21,21, 23,23,23, 25,25,25, 30,30,30])
        let p11 = add("FF 555 777 999 DDD (C)", mask: "", note: "",  family: Family.f13579, concealed: true)
        p11.add([35,35, 5,5,5, 7,7,7, 9,9,9, 10,10,10])
        p11.add([35,35, 15,15,15, 17,17,17, 19,19,19, 20,20,20])
        p11.add([35,35, 25,25,25, 27,27,27, 29,29,29, 30,30,30])
    }
    
    func addWindsAndDragons() {
        let p1 = add("NNNN EEEE WWWW SS", mask: "", note: "",  family: Family.winds, concealed: false)
        p1.add([31,31,31,31, 34,34,34,34, 33,33,33,33, 32,32,])
        let p2 = add("NN 11 SSS 111 1111 (C)", mask: "00 gg 000 rrr", note: "Like Odd No.",  family: Family.winds, concealed: false)
        for i in 1...9 {
            if i & 1 == 1 {
                let d = i
                let b = i+10
                let c = i+20
                p2.add([31,31, d,d, 32,32,32, b,b,b, c,c,c,c])
                p2.add([31,31, d,d, 32,32,32, c,c,c, b,b,b,b])
                p2.add([31,31, b,b, 32,32,32, d,d,d, c,c,c,c])
                p2.add([31,31, b,b, 32,32,32, c,c,c, d,d,d,d])
                p2.add([31,31, c,c, 32,32,32, d,d,d, b,b,b,b])
                p2.add([31,31, c,c, 32,32,32, b,b,b, d,d,d,d])
            }
        }
        let p3 = add("EE 22 WWW 222 2222 (C)", mask: "00 gg 000 rrr", note: "Like Even No.",  family: Family.winds, concealed: true)
        for i in 1...9 {
            if i & 1 == 0 {
                let d = i
                let b = i+10
                let c = i+20
                p3.add([34,34, d,d, 33,33,33, b,b,b, c,c,c,c])
                p3.add([34,34, d,d, 33,33,33, c,c,c, b,b,b,b])
                p3.add([34,34, b,b, 33,33,33, d,d,d, c,c,c,c])
                p3.add([34,34, b,b, 33,33,33, c,c,c, d,d,d,d])
                p3.add([34,34, c,c, 33,33,33, d,d,d, b,b,b,b])
                p3.add([34,34, c,c, 33,33,33, b,b,b, d,d,d,d])
            }
        }
        let p4 = add("FF NNNN EE WW SSSS", mask: "", note: "",  family: Family.winds, concealed: false)
        p4.add([35,35, 31,31,31,31, 34,34, 33,33, 32,32,32,32])
        let p5 = add("DDDD NN EW SS DDDD", mask: "gggg 00 00 00 rrrr", note: "Any 2 Dragons",  family: Family.winds, concealed: false)
        p5.add([10,10,10,10, 31,31, 34,33, 32,32, 20,20,20,20])
        p5.add([10,10,10,10, 31,31, 34,33, 32,32, 30,30,30,30])
        p5.add([20,20,20,20, 31,31, 34,33, 32,32, 30,30,30,30])
        let p6 = add("FFFF DDDD DD DDDD", mask: "0000 gggg rr", note: "Any 3 Suits",  family: Family.winds, concealed: false)
        p6.add([35,35,35,35, 10,10,10,10, 20,20, 30,30,30,30])
        p6.add([35,35,35,35, 10,10,10,10, 30,30, 20,20,20,20])
        p6.add([35,35,35,35, 20,20,20,20, 10,10, 30,30,30,30])
    }
    
    func add369() {
        let p1 = add("FFFF 3 66 999 DDDD", mask: "", note: "",  family: Family.f369, concealed: false)
        p1.add([35,35,35,35, 3, 6,6, 9,9,9, 10,10,10,10])
        p1.add([35,35,35,35, 13, 16,16, 19,19,19, 20,20,20,20])
        p1.add([35,35,35,35, 23, 26,26, 29,29,29, 30,30,30,30])
        let p2 = add("333 666 6666 9999", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false)
        p2.add([3,3,3, 6,6,6, 16,16,16,16, 19,19,19,19])
        p2.add([3,3,3, 6,6,6, 26,26,26,26, 29,29,29,29])
        p2.add([13,13,13, 16,16,16, 6,6,6,6, 9,9,9,9])
        p2.add([13,13,13, 16,16,16, 26,26,26,26, 29,29,29,29])
        p2.add([23,23,23, 26,26,26, 6,6,6,6, 9,9,9,9])
        p2.add([23,23,23, 26,26,26, 16,16,16,16, 19,19,19,19])
        let p3 = add("FF 3333 6666 9999", mask: "", note: "",  family: Family.f369, concealed: false)
        p3.add([35,35, 3,3,3,3, 6,6,6,6, 9,9,9,9])
        p3.add([35,35, 13,13,13,13, 16,16,16,16, 19,19,19,19])
        p3.add([35,35, 23,23,23,23, 26,26,26,26, 29,29,29,29])
        let p4 = add("FF 3333 6666 9999", mask: "00 gggg rrrr", note: "Any 3 Suits",  family: Family.f369, concealed: false)
        p4.add([35,35, 3,3,3,3, 16,16,16,16, 29,29,29,29])
        p4.add([35,35, 3,3,3,3, 26,26,26,26, 19,19,19,19])
        p4.add([35,35, 13,13,13,13, 6,6,6,6, 29,29,29,29])
        p4.add([35,35, 13,13,13,13, 26,26,26,26, 9,9,9,9])
        p4.add([35,35, 23,23,23,23, 6,6,6,6, 19,19,19,19])
        p4.add([35,35, 23,23,23,23, 16,16,16,16, 9,9,9,9])
        let p5 = add("33 66 333 666 9999", mask: "gg gg rrr rrr", note: "Any 3 Suits",  family: Family.f369, concealed: false)
        p5.add([3,3, 6,6, 13,13,13, 16,16,16, 29,29,29,29])
        p5.add([3,3, 6,6, 23,23,23, 26,26,26, 19,19,19,19])
        p5.add([13,13, 16,16, 3,3,3, 6,6,6, 29,29,29,29])
        p5.add([13,13, 16,16, 23,23,23, 26,26,26, 9,9,9,9])
        p5.add([23,23, 26,26, 3,3,3, 6,6,6, 19,19,19,19])
        p5.add([23,23, 26,26, 13,13,13, 16,16,16, 9,9,9,9])
        let p6 = add("333 66 999 333 333", mask: "ggg gg ggg rrr rrr", note: "Like Pungs 3, 6, 9",  family: Family.f369, concealed: false)
        p6.add([3,3,3, 6,6, 9,9,9, 13,13,13, 13,13,13])
        p6.add([3,3,3, 6,6, 9,9,9, 16,16,16, 16,16,16])
        p6.add([3,3,3, 6,6, 9,9,9, 19,19,19, 19,19,19])
        p6.add([3,3,3, 6,6, 9,9,9, 23,23,23, 23,23,23])
        p6.add([3,3,3, 6,6, 9,9,9, 26,26,26, 26,26,26])
        p6.add([3,3,3, 6,6, 9,9,9, 29,29,29, 29,29,29])
        p6.add([13,13,13, 16,16, 19,19,19, 3,3,3, 3,3,3])
        p6.add([13,13,13, 16,16, 19,19,19, 6,6,6, 6,6,6])
        p6.add([13,13,13, 16,16, 19,19,19, 9,9,9, 9,9,9])
        p6.add([13,13,13, 16,16, 19,19,19, 23,23,23, 23,23,23])
        p6.add([13,13,13, 16,16, 19,19,19, 26,26,26, 26,26,26])
        p6.add([13,13,13, 16,16, 19,19,19, 29,29,29, 29,29,29])
        p6.add([23,23,23, 26,26, 29,29,29, 3,3,3, 3,3,3])
        p6.add([23,23,23, 26,26, 29,29,29, 6,6,6, 6,6,6])
        p6.add([23,23,23, 26,26, 29,29,29, 9,9,9, 9,9,9])
        p6.add([23,23,23, 26,26, 29,29,29, 13,13,13, 13,13,13])
        p6.add([23,23,23, 26,26, 29,29,29, 16,16,16, 16,16,16])
        p6.add([23,23,23, 26,26, 29,29,29, 19,19,19, 19,19,19])
        let p7 = add("333 6 999 333 6 999 (C)", mask: "ggg g ggg rrr r rrr", note: "Any 2 Suits",  family: Family.f369, concealed: true)
        p7.add([3,3,3, 6, 9,9,9, 13,13,13, 16, 19,19,19])
        p7.add([3,3,3, 6, 9,9,9, 23,23,23, 26, 29,29,29])
        p7.add([13,13,13, 16, 19,19,19, 3,3,3, 6, 9,9,9])
        p7.add([13,13,13, 16, 19,19,19, 23,23,23, 26, 29,29,29])
        p7.add([23,23,23, 26, 29,29,29, 3,3,3, 6, 9,9,9])
        p7.add([23,23,23, 26, 29,29,29, 23,23,23, 26, 29,29,29])
    }
    
    func addSinglesAndPairs() {
        let p1 = add("NN 11 33 55 77 99 SS (C)", mask: "", note: "",  family: Family.pairs, concealed: true)
        p1.add([31,31, 1,1, 3,3, 5,5, 7,7, 9,9, 32,32])
        p1.add([31,31, 11,11, 13,13, 15,15, 17,17, 19,19, 32,32])
        p1.add([31,31, 21,21, 23,23, 25,25, 27,27, 29,29, 32,32])
        let p2 = add("FF EE 22 44 66 88 WW (C)", mask: "", note: "",  family: Family.pairs, concealed: true)
        p2.add([35,35, 34,34, 2,2, 4,4, 6,6, 8,8, 33,33])
        p2.add([35,35, 34,34, 12,12, 14,14, 16,16, 18,18, 33,33])
        p2.add([35,35, 34,34, 22,22, 24,24, 26,26, 28,28, 33,33])
        let p3 = add("FF 11 22 33 44 55 DD (C)", mask: "", note: "Any 5 Consec. Nos.",  family: Family.pairs, concealed: true)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([35,35,d,d,d+1,d+1,d+2,d+2,d+3,d+3,d+4,d+4,10,10])
            p3.add([35,35,b,b,b+1,b+1,b+2,b+2,b+3,b+3,b+4,b+4,20,20])
            p3.add([35,35,c,c,c+1,c+1,c+2,c+2,c+3,c+3,c+4,c+4,30,30])
        }
        let p4 = add("FF 11 22 11 22 11 22 (C)", mask: "00 gg gg rr rr", note: "Any 2 Consec. Nos.",  family: Family.pairs, concealed: true)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([35,35, d,d,d+1,d+1, b,b,b+1,b+1, c,c,c+1,c+1])
        }
        let p5 = add("336 33669 336699 (C)", mask: "ggg rrrrr", note: "Any 3 Suits",  family: Family.pairs, concealed: true)
        p5.add([3,3,6, 13,13,16,16,19, 23,23,26,26,29,29])
        p5.add([3,3,6, 23,23,26,26,29, 13,13,16,16,19,19])
        p5.add([13,13,16, 3,3,6,6,9, 23,23,26,26,29,29])
        p5.add([13,13,16, 23,23,26,26,29, 3,3,6,6,9,9])
        p5.add([23,23,26, 3,3,6,6,9, 13,13,16,16,19,19])
        p5.add([23,23,26, 13,13,16,16,19, 3,3,6,6,9,9])
        let p6 = add("FF 11 22 33 DD DD DD (C)", mask: "00 00 00 00 gg rr", note: "Any 3 Consec. Nos.",  family: Family.pairs, concealed: true)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([35,35, d,d, d+1,d+1, d+2,d+2, 10,10, 20,20, 30,30])
            p6.add([35,35, b,b, b+1,b+1, b+2,b+2, 10,10, 20,20, 30,30])
            p6.add([35,35, c,c, c+1,c+1, c+2,c+2, 10,10, 20,20, 30,30])
        }
        let p7 = add("FF 2016 2016 2016 (C)", mask: "00 gggg rrrr", note: "Any 3 Suits",  family: Family.pairs, concealed: true)
        p7.add([35,35, 2,10,1,6, 12,10,11,16, 22,10,21,26])
    }
}
