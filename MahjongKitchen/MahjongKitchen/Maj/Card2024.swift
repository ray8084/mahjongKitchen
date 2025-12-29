//
//  Card2024.swift
//  MahjongKitchen
//
//  Created by Ray Meyer on 3/27/24.
//

import Foundation

class Card2024 : Card {
    
    override init() {
        super.init()
        year = Year.y2024
        add2024()
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
        return "2024"
    }
        
    func add2024() {
        let p1 = add("222 000 2222 4444", mask: "ggg 000 rrrr rrrr", note: "Any 2 Suits",  family: Family.year, concealed : false, points: 25)
        p1.generateList()
        
        let p2 = add("FFFF 2222 0000 24", mask: "0000 gggg 0000 rr", note: "Any 2 Suit",  family: Family.year, concealed : false, points: 25)
        p2.generateList()
        
        let p3 = add("FF 2024 2222 2222", mask: "00 gggg rrrr 0000", note: "Any 3 Suits, Like Kongs 2s or 4s",  family: Family.year, concealed: false, points: 25)
        p3.add([35,35, 2,10,2,4, 12,12,12,12, 22,22,22,22])
        p3.add([35,35, 2,10,2,4, 14,14,14,14, 24,24,24,24])
        p3.add([35,35, 12,10,12,14, 2,2,2,2, 22,22,22,22])
        p3.add([35,35, 12,10,12,14, 4,4,4,4, 24,24,24,24])
        p3.add([35,35, 22,10,22,24, 2,2,2,2, 12,12,12,12])
        p3.add([35,35, 22,10,22,24, 4,4,4,4, 14,14,14,14])
        
        let p4 = add("NN EEE 2024 WWW SS (C)", mask: "00 000 0000 000 00", note: "2024 Any 1 Suit",  family: Family.year, concealed: true, points: 30)
        p4.add([31,31, 34,34,34, 2,10,2,4, 33,33,33, 32,32], singles: Singles.dot2)
        p4.add([31,31, 34,34,34, 12,10,12,14, 33,33,33, 32,32], singles: Singles.bam2)
        p4.add([31,31, 34,34,34, 22,10,22,24, 33,33,33, 32,32], singles: Singles.crak2)
    }
    
    func add2468() {
        let p1 = add("222 444 6666 8888", mask: "000 000 0000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p1.generateList()
        
        let p2 = add("222 444 6666 8888", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p2.generateList()
        
        let p3 = add("22 444 44 666 8888", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p3.generateList()
        
        let p4 = add("22 44 666 888 DDDD", mask: "00 00 000 000 0000", note: "Any 1 Suit, Matching Dragon",  family: Family.f2468, concealed: false, points: 25)
        p4.generateList()
        
        let p5 = add("FFFF 4444 6666 24", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p5.generateList()
        
        let p6 = add("FFFF 6666 8888 48", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p6.generateList()
        
        let p7 = add("FF 2222 44 66 8888", mask: "00 0000 00 00 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p7.generateList()
        
        let p8 = add("FF 2222 44 66 8888", mask: "00 gggg rr rr gggg", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p8.generateList()
        
        let p9 = add("FF 222 44 666 88 88 (C)", mask: "00 ggg gg ggg rr 00", note: "Any 3 Suits",  family: Family.f2468, concealed: true, points: 35)
        p9.generateList()
    }
    
    func addLikeNumbers() {
        let p1 = add("FFFF 111 1111 111", mask: "0000 ggg rrrr 000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([35,35,35,35, d,d,d, b,b,b,b, c,c,c])
            p1.add([35,35,35,35, b,b,b, d,d,d,d, c,c,c])
            p1.add([35,35,35,35, d,d,d, c,c,c,c, b,b,b])
        }
        
        let p2 = add("11 DDD 11 DDD 1111", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits, Pairs and Dragons Match",  family: Family.likeNumbers, concealed: false, points: 30)
        p2.generateList()

        let p3 = add("FF 1111 NEWS 1111", mask: "00 gggg 0000 rrrr", note: "Any 2 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([35,35, d,d,d,d, 31,34,33,32, b,b,b,b])
            p3.add([35,35, d,d,d,d, 31,34,33,32, c,c,c,c])
            p3.add([35,35, b,b,b,b, 31,34,33,32, c,c,c,c])
        }
    }
    
    func addAdditionHands() {
        let p1 = add("FF 1111+6666=7777", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.addition, concealed: false, points: 25)
        p1.add([35,35, 1,1,1,1, 6,6,6,6, 7,7,7,7])
        p1.add([35,35, 11,11,11,11, 16,16,16,16, 17,17,17,17])
        p1.add([35,35, 21,21,21,21, 26,26,26,26, 27,27,27,27])
        
        let p2 = add("FF 2222+5555=7777", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.addition, concealed: false, points: 25)
        p2.add([35,35, 2,2,2,2, 5,5,5,5, 7,7,7,7])
        p2.add([35,35, 12,12,12,12, 15,15,15,15, 17,17,17,17])
        p2.add([35,35, 22,22,22,22, 25,25,25,25, 27,27,27,27])

        let p3 = add("FF 3333+4444=7777", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.addition, concealed: false, points: 25)
        p3.add([35,35, 3,3,3,3, 4,4,4,4, 7,7,7,7])
        p3.add([35,35, 13,13,13,13, 14,14,14,14, 17,17,17,17])
        p3.add([35,35, 23,23,23,23, 24,24,24,24, 27,27,27,27])
    }
    
    func addQuints() {
        let p1 = add("FF 11111 22 33333", mask: "00 00000 00 00000", note: "Any 1 Suit, Any 3 Consec. Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([35,35, d,d,d,d,d, d+1,d+1, d+2,d+2,d+2,d+2,d+2])
            p1.add([35,35, b,b,b,b,b, b+1,b+1, b+2,b+2,b+2,b+2,b+2])
            p1.add([35,35, c,c,c,c,c, c+1,c+1, c+2,c+2,c+2,c+2,c+2])
        }
        
        let p2 = add("11111 NNNN 88888", mask: "ggggg 0000 rrrrr", note: "Any 2 Suits, Non-Matching Nos, Any Wind",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...9 {
                let d1 = i
                let b1 = i+10
                for j in 1...9 {
                    let b2 = j+10
                    let c2 = j+20
                    if i != j {
                        p2.add([d1,d1,d1,d1,d1, w,w,w,w, b2,b2,b2,b2,b2])
                        p2.add([d1,d1,d1,d1,d1, w,w,w,w, c2,c2,c2,c2,c2])
                        p2.add([b1,b1,b1,b1,b1, w,w,w,w, c2,c2,c2,c2,c2])
                    }
                }
            }
        }
        
        let p3 = add("11 22222 11 22222", mask: "gg ggggg rr rrrrr", note: "Any 2 Suits, Any 2 Consec Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d, d+1,d+1,d+1,d+1,d+1, b,b, b+1,b+1,b+1,b+1,b+1])
            p3.add([d,d, d+1,d+1,d+1,d+1,d+1, c,c, c+1,c+1,c+1,c+1,c+1])
            p3.add([b,b, b+1,b+1,b+1,b+1,b+1, c,c, c+1,c+1,c+1,c+1,c+1])
        }
        
        let p4 = add("FFFFF DDDD 11111", mask: "00000 gggg rrrrr", note: "Any 2 Suits, Quint Any No.",  family: Family.quints, concealed: false, points: 40)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([35,35,35,35,35, 10,10,10,10, b,b,b,b,b])
            p4.add([35,35,35,35,35, 10,10,10,10, c,c,c,c,c])
            p4.add([35,35,35,35,35, 20,20,20,20, d,d,d,d,d])
            p4.add([35,35,35,35,35, 20,20,20,20, c,c,c,c,c])
            p4.add([35,35,35,35,35, 30,30,30,30, d,d,d,d,d])
            p4.add([35,35,35,35,35, 30,30,30,30, b,b,b,b,b])
        }
    }
        
    func addConsectiveRun() {
        let p1 = add("111 22 3333 44 555", mask: "000 00 0000 00 000", note: "These Nos Only",  family: Family.run, concealed: false, points: 25)
        p1.add([1,1,1, 2,2, 3,3,3,3, 4,4, 5,5,5])
        p1.add([11,11,11, 12,12, 13,13,13,13, 14,14, 15,15,15])
        p1.add([21,21,21, 22,22, 23,23,23,23, 24,24, 25,25,25])
        
        let p2 = add("555 66 7777 88 999", mask: "000 00 0000 00 000", note: "These Nos Only",  family: Family.run, concealed: false, points: 25)
        p2.add([5,5,5, 6,6, 7,7,7,7, 8,8, 9,9,9])
        p2.add([15,15,15, 16,16, 17,17,17,17, 18,18, 19,19,19])
        p2.add([25,25,25, 26,26, 27,27,27,27, 28,28, 29,29,29])
        
        let p3 = add("11 222 DDDD 333 44", mask: "gg ggg rrrr ggg gg", note: "Any 4 Consec. Nos. in 1 Suit, Op Dragons",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d, d+1,d+1,d+1, 20,20,20,20, d+2,d+2,d+2, d+3,d+3])
            p3.add([d,d, d+1,d+1,d+1, 30,30,30,30, d+2,d+2,d+2, d+3,d+3])
            p3.add([b,b, b+1,b+1,b+1, 10,10,10,10, b+2,b+2,b+2, b+3,b+3])
            p3.add([c,c, c+1,c+1,c+1, 10,10,10,10, c+2,c+2,c+2, c+3,c+3])
            p3.add([b,b, b+1,b+1,b+1, 30,30,30,30, b+2,b+2,b+2, b+3,b+3])
            p3.add([c,c, c+1,c+1,c+1, 20,20,20,20, c+2,c+2,c+2, c+3,c+3])
        }
        
        let p4 = add("FF 1111 2222 3333", mask: "00 0000 0000 0000", note: "Any 1 Suit, Any 3 Consec. Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([35,35, d,d,d,d, d+1,d+1,d+1,d+1, d+2,d+2,d+2,d+2])
            p4.add([35,35, b,b,b,b, b+1,b+1,b+1,b+1, b+2,b+2,b+2,b+2])
            p4.add([35,35, c,c,c,c, c+1,c+1,c+1,c+1, c+2,c+2,c+2,c+2])
        }
        
        let p5 = add("FF 1111 2222 3333", mask: "00 gggg rrrr 0000", note: "Any 3 Suits, Any 3 Consec. Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([35,35, d,d,d,d, b+1,b+1,b+1,b+1, c+2,c+2,c+2,c+2])
            p5.add([35,35, d,d,d,d, c+1,c+1,c+1,c+1, b+2,b+2,b+2,b+2])
            p5.add([35,35, b,b,b,b, d+1,d+1,d+1,d+1, c+2,c+2,c+2,c+2])
            p5.add([35,35, b,b,b,b, c+1,c+1,c+1,c+1, d+2,d+2,d+2,d+2])
            p5.add([35,35, c,c,c,c, d+1,d+1,d+1,d+1, b+2,b+2,b+2,b+2])
            p5.add([35,35, c,c,c,c, b+1,b+1,b+1,b+1, d+2,d+2,d+2,d+2])
        }
        
        let p6 = add("1 22 3333 1 22 3333", mask: "g gg gggg r rr rrrr", note: "Any 2 Suits, Any 3 Consec Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([d, d+1,d+1, d+2,d+2,d+2,d+2, b, b+1,b+1, b+2,b+2,b+2,b+2])
            p6.add([d, d+1,d+1, d+2,d+2,d+2,d+2, c, c+1,c+1, c+2,c+2,c+2,c+2])
            p6.add([b, b+1,b+1, b+2,b+2,b+2,b+2, c, c+1,c+1, c+2,c+2,c+2,c+2])
        }
        
        let p7 = add("11 22 333 444 DDDD", mask: "00 00 000 000 0000", note: "Any 1 Suit, Any Run, Matching Dragons",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([d,d, d+1,d+1, d+2,d+2,d+2, d+3,d+3,d+3, 10,10,10,10])
            p7.add([b,b, b+1,b+1, b+2,b+2,b+2, b+3,b+3,b+3, 20,20,20,20])
            p7.add([c,c, c+1,c+1, c+2,c+2,c+2, c+3,c+3,c+3, 30,30,30,30])
        }
        
        let p8 = add("FFFFF 123 444 444", mask: "00000 ggg rrr 000", note: "Any 3 Suits, Any 4 Consec. Nos.",  family: Family.run, concealed: false, points: 30)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p8.add([35,35,35,35,35, d,d+1,d+2, b+3,b+3,b+3, c+3,c+3,c+3])
            p8.add([35,35,35,35,35, b,b+1,b+2, d+3,d+3,d+3, c+3,c+3,c+3])
            p8.add([35,35,35,35,35, c,c+1,c+2, d+3,d+3,d+3, b+3,b+3,b+3])
        }
        
        let p9 = add("111 222 3333 4444", mask: "000 000 0000 0000", note: "Any 1 Suit, Any 4 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p9.add([d,d,d, d+1,d+1,d+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p9.add([b,b,b, b+1,b+1,b+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p9.add([c,c,c, c+1,c+1,c+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
        }
        
        let p10 = add("111 222 3333 4444", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits, Any 4 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p10.add([d,d,d, d+1,d+1,d+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p10.add([d,d,d, d+1,d+1,d+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p10.add([b,b,b, b+1,b+1,b+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p10.add([b,b,b, b+1,b+1,b+1, c+2,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p10.add([c,c,c, c+1,c+1,c+1, d+2,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p10.add([c,c,c, c+1,c+1,c+1, b+2,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
        }
        
        let p11 = add("111 222 111 222 33 (C)", mask: "ggg ggg rrr rrr 00", note: "Any 3 Suits, Any 3 Consec. Nos.",  family: Family.run, concealed: true, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p11.add([d,d,d, d+1,d+1,d+1, b,b,b, b+1,b+1,b+1, c+2,c+2])
            p11.add([d,d,d, d+1,d+1,d+1, c,c,c, c+1,c+1,c+1, b+2,b+2])
            p11.add([b,b,b, b+1,b+1,b+1, c,c,c, c+1,c+1,c+1, d+2,d+2])
        }
    }
    
    func add13579() {
        let p0 = add("111 33 5555 77 999", mask: "000 00 0000 00 000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p0.add([1,1,1, 3,3, 5,5,5,5, 7,7, 9,9,9])
        p0.add([11,11,11, 13,13, 15,15,15,15, 17,17, 19,19,19])
        p0.add([21,21,21, 23,23, 25,25,25,25, 27,27, 29,29,29])
        
        let p1 = add("111 33 5555 77 999", mask: "ggg gg rrrr 00 000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p1.add([1,1,1, 3,3, 15,15,15,15, 27,27, 29,29,29])
        p1.add([1,1,1, 3,3, 25,25,25,25, 17,17, 19,19,19])
        p1.add([11,11,11, 13,13, 5,5,5,5, 27,27, 29,29,29])
        p1.add([11,11,11, 13,13, 25,25,25,25, 7,7, 9,9,9])
        p1.add([21,21,21, 23,23, 5,5,5,5, 17,17, 19,19,19])
        p1.add([21,21,21, 23,23, 15,15,15,15, 7,7, 9,9,9])
        
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
        
        let p4 = add("FF 11 333 5555 DDD", mask: "00 00 000 0000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p4.generateList()
        
        let p5 = add("FF 55 777 9999 DDD", mask: "00 00 000 0000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p5.generateList()
        
        let p6 = add("11 33 55 7777 9999", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 30)
        p6.generateList()
        
        let p7 = add("FFFF 3333 5555 15", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        let p8 = add("FFFF 5555 7777 35", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p7.generateList()
        p8.generateList()
        
        let p9 = add("11 33 333 555 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        let p11 = add("55 77 777 999 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p9.generateList()
        p11.generateList()
        
        let p12 = add("111 33 555 333 333 (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Suits, These Nos Only",  family: Family.f13579, concealed: true, points: 35)
        p12.add([1,1,1, 3,3, 5,5,5, 13,13,13, 23,23,23])
        p12.add([11,11,11, 13,13, 15,15,15, 3,3,3, 23,23,23])
        p12.add([21,21,21, 23,23, 25,25,25, 3,3,3, 13,13,13])
        
        let p13 = add("555 77 999 777 777 (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Suits, These Nos Only",  family: Family.f13579, concealed: true, points: 35)
        p13.add([5,5,5, 7,7, 9,9,9, 17,17,17, 27,27,27])
        p13.add([15,15,15, 17,17, 19,19,19, 7,7,7, 27,27,27])
        p13.add([25,25,25, 27,27, 29,29,29, 7,7,7, 17,17,17])
    }
    
    func addWindsAndDragons() {
        addNEWS_4334()
        
        let p2 = add("NNN EEEE WWWW SSS", mask: "000 0000 0000 000", note: "",  family: Family.winds, concealed: false, points: 25)
        p2.add([31,31,31, 34,34,34,34, 33,33,33,33, 32,32,32])
        
        let p = add("FFFF DDD DDDD DDD", mask: "0000 ggg rrrr 000", note: "Any 3 Dragons",  family: Family.winds, concealed: false, points: 25)
        p.add([35,35,35,35, 10,10,10, 20,20,20,20, 30,30,30])
        p.add([35,35,35,35, 10,10,10, 30,30,30,30, 20,20,20])
        p.add([35,35,35,35, 20,20,20, 10,10,10,10, 30,30,30])
        
        let p3n = add("NNN SSS 1111 2222", mask: "000 000 gggg rrrr", note: "Any 2 Suits, Any 2 Consec Nos",  family: Family.winds, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p3n.add([31,31,31, 32,32,32, d,d,d,d, b+1,b+1,b+1,b+1])
            p3n.add([31,31,31, 32,32,32, d,d,d,d, c+1,c+1,c+1,c+1])
            p3n.add([31,31,31, 32,32,32, b,b,b,b, d+1,d+1,d+1,d+1])
            p3n.add([31,31,31, 32,32,32, b,b,b,b, c+1,c+1,c+1,c+1])
            p3n.add([31,31,31, 32,32,32, c,c,c,c, d+1,d+1,d+1,d+1])
            p3n.add([31,31,31, 32,32,32, c,c,c,c, b+1,b+1,b+1,b+1])
        }
        
        let p3e = add("EEE WWW 1111 2222", mask: "000 000 gggg rrrr", note: "Any 2 Suits, Any 2 Consec. Nos",  family: Family.winds, concealed: false, points: 25)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p3e.add([33,33,33, 34,34,34, d,d,d,d, b+1,b+1,b+1,b+1])
            p3e.add([33,33,33, 34,34,34, d,d,d,d, c+1,c+1,c+1,c+1])
            p3e.add([33,33,33, 34,34,34, b,b,b,b, d+1,d+1,d+1,d+1])
            p3e.add([33,33,33, 34,34,34, b,b,b,b, c+1,c+1,c+1,c+1])
            p3e.add([33,33,33, 34,34,34, c,c,c,c, d+1,d+1,d+1,d+1])
            p3e.add([33,33,33, 34,34,34, c,c,c,c, b+1,b+1,b+1,b+1])
        }
                
        let p0 = add("FF NN EEE WWW SSSS", mask: "00 00 000 000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p0.add([35,35, 31,31, 34,34,34, 33,33,33, 32,32,32,32])
                
        let p4 = add("NNNN 11 22 33 SSSS", mask: "0000 00 00 00 0000", note: "Any 1 Suit, Any 3 Consec. Nos",  family: Family.winds, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([31,31,31,31, d,d, d+1,d+1, d+2,d+2, 32,32,32,32])
            p4.add([31,31,31,31, b,b, b+1,b+1, b+2,b+2, 32,32,32,32])
            p4.add([31,31,31,31, c,c, c+1,c+1, c+2,c+2, 32,32,32,32])
        }
        
        let p5 = add("EEEE 11 22 33 WWWW", mask: "0000 00 00 00 0000", note: "Any 1 Suit, Any 3 Consec. Nos",  family: Family.winds, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([34,34,34,34, d,d, d+1,d+1, d+2,d+2, 33,33,33,33])
            p5.add([34,34,34,34, b,b, b+1,b+1, b+2,b+2, 33,33,33,33])
            p5.add([34,34,34,34, c,c, c+1,c+1, c+2,c+2, 33,33,33,33])
        }
               
        let p8 = add("FF DDDD NEWS DDDD", mask: "00 gggg 0000 rrrr", note: "Any 2 Dragons",  family: Family.winds, concealed: false, points: 25)
        p8.add([35,35, 10,10,10,10, 31,34,33,32, 30,30,30,30])
        p8.add([35,35, 10,10,10,10, 31,34,33,32, 20,20,20,20])
        p8.add([35,35, 20,20,20,20, 31,34,33,32, 30,30,30,30])
        
        let p11 = add("NNN EW SSS 111 111 (C)", mask: "000 00 000 ggg rrr", note: "Any 2 Suits, Any Like Nos",  family: Family.winds, concealed: true, points: 30)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p11.add([31,31,31, 34,33, 32,32,32, d,d,d, b,b,b])
            p11.add([31,31,31, 34,33, 32,32,32, d,d,d, c,c,c])
            p11.add([31,31,31, 34,33, 32,32,32, c,c,c, b,b,b])
        }
    }

    func add369() {
        add3669_3344_2()

        let p2 = add("333 666 6666 9999", mask: "ggg ggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p2.generateList()
        
        let p3 = add("FF 3 66 999 333 333", mask: "00 g gg ggg rrr 000", note: "Any 3 Suits, Like Pungs 3,6 or 9",  family: Family.f369, concealed: false, points: 25)
        p3.add([35,35, 3, 6,6, 9,9,9, 13,13,13, 23,23,23])
        p3.add([35,35, 13, 16,16, 19,19,19, 3,3,3, 23,23,23])
        p3.add([35,35, 23, 26,26, 29,29,29, 3,3,3, 13,13,13])
        p3.add([35,35, 3, 6,6, 9,9,9, 16,16,16, 26,26,26])
        p3.add([35,35, 13, 16,16, 19,19,19, 6,6,6, 26,26,26])
        p3.add([35,35, 23, 26,26, 29,29,29, 6,6,6, 16,16,16])
        p3.add([35,35, 3, 6,6, 9,9,9, 19,19,19, 29,29,29])
        p3.add([35,35, 13, 16,16, 19,19,19, 9,9,9, 29,29,29])
        p3.add([35,35, 23, 26,26, 29,29,29, 9,9,9, 19,19,19])
        
        let p4 = add("FF 3333 6666 9999", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        let p5 = add("FF 3333 6666 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p4.generateList()
        p5.generateList()
        
        let p6 = add("333 DDDD 333 DDDD", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits, Pungs 3,6,9, Match Dragons",  family: Family.f369, concealed: false, points: 25)
        for i in [3,6,9] {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([d,d,d, 10,10,10,10, b,b,b, 20,20,20,20])
            p6.add([d,d,d, 10,10,10,10, c,c,c, 30,30,30,30])
            p6.add([b,b,b, 20,20,20,20, c,c,c, 30,30,30,30])
        }
        
        let p7 = add("3333 66 66 66 9999", mask: "gggg rr gg 00 gggg", note: "Any 3 Suits, 3s & 9s Match",  family: Family.f369, concealed: false, points: 30)
        let d = 3
        let b = 13
        let c = 23
        p7.add([d,d,d,d, c+3,c+3, b+3,b+3, d+3,d+3, d+6,d+6,d+6,d+6])
        p7.add([b,b,b,b, c+3,c+3, b+3,b+3, d+3,d+3, b+6,b+6,b+6,b+6])
        p7.add([c,c,c,c, c+3,c+3, b+3,b+3, d+3,d+3, c+6,c+6,c+6,c+6])
        
        let p8 = add("FFFF 33 66 999 DDD", mask: "0000 gg gg ggg rrr", note: "Any 1 Suit, Any Opp Dragon",  family: Family.f369, concealed: false, points: 30)
        p8.add([35,35,35,35, 3,3, 6,6, 9,9,9, 30,30,30])
        p8.add([35,35,35,35, 3,3, 6,6, 9,9,9, 20,20,20])
        p8.add([35,35,35,35, 13,13, 16,16, 19,19,19, 10,10,10])
        p8.add([35,35,35,35, 13,13, 16,16, 19,19,19, 30,30,30])
        p8.add([35,35,35,35, 23,23, 26,26, 29,29,29, 10,10,10])
        p8.add([35,35,35,35, 23,23, 26,26, 29,29,29, 20,20,20])
        
        let p9 = add("333 666 333 666 99 (C)", mask: "ggg ggg rrr rrr 00", note: "Any 3 Suits",  family: Family.f369, concealed: true, points: 30)
        p9.add([3,3,3, 6,6,6, 13,13,13, 16,16,16, 29,29])
        p9.add([3,3,3, 6,6,6, 23,23,23, 26,26,26, 19,19])
        p9.add([13,13,13, 16,16,16, 23,23,23, 26,26,26, 9,9])
    }
 
    func addSinglesAndPairs() {
        let p1 = add("FF 22 46 88 22 46 88 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p1.add([35,35, 2,2, 4,6, 8,8, 12,12, 14,16, 18,18])
        p1.add([35,35, 2,2, 4,6, 8,8, 22,22, 24,26, 28,28])
        p1.add([35,35, 12,12, 14,16, 18,18, 22,22, 24,26, 28,28])
        
        let p2 = add("FF 11 33 55 55 77 99 (C)", mask: "00 gg gg gg rr rr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p2.generateList()
        
        let p3 = add("112 11223 112233 (C)", mask: "ggg rrrrr 000000", note: "Any 3 Suits, These Nos Only",  family: Family.pairs, concealed: true, points: 50)
        p3.add([1,1,2, 11,11,12,12,13, 21,21,22,22,23,23])
        p3.add([1,1,2, 21,21,22,22,23, 11,11,12,12,13,13])
        p3.add([11,11,12, 1,1,2,2,3, 21,21,22,22,23,23])
        p3.add([11,11,12, 21,21,22,22,23, 1,1,2,2,3,3])
        p3.add([21,21,22, 1,1,2,2,3, 11,11,12,12,13,13])
        p3.add([21,21,22, 11,11,12,12,13, 1,1,2,2,3,3])
                
        let p4 = add("998 99887 998877 (C)", mask: "ggg rrrrr 000000", note: "Any 3 Suits, These Nos Only",  family: Family.pairs, concealed: true, points: 50)
        p4.add([9,9,8, 19,19,18,18,17, 29,29,28,28,27,27])
        p4.add([9,9,8, 29,29,28,28,27, 19,19,18,18,17,17])
        p4.add([19,19,18, 9,9,8,8,7, 29,29,28,28,27,27])
        p4.add([19,19,18, 29,29,28,28,27, 9,9,8,8,7,7])
        p4.add([29,29,28, 9,9,8,8,7, 19,19,18,18,17,17])
        p4.add([29,29,28, 19,19,18,18,17, 9,9,8,8,7,7])
        
        let p5 = add("FF 33 66 99 369 369 (C)", mask: "00 gg gg gg rrr 000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p5.add([35,35, 3,3, 6,6, 9,9, 13,16,19, 23,26,29])
        p5.add([35,35, 23,23, 26,26, 29,29, 13,16,19, 3,6,9])
        p5.add([35,35, 13,13, 16,16, 19,19, 3,6,9, 23,26,29])
        
        let p6 = add("11 22 33 44 55 DD DD (C)", mask: "gg gg gg gg gg rr 00", note: "Any 5 Consec Nos, Op Dragons",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([d,d, d+1,d+1, d+2,d+2, d+3,d+3, d+4,d+4, 20,20, 30,30])
            p6.add([b,b, b+1,b+1, b+2,b+2, b+3,b+3, b+4,b+4, 10,10, 30,30])
            p6.add([c,c, c+1,c+1, c+2,c+2, c+3,c+3, c+4,c+4, 10,10, 20,20])
        }
        
        let p7 = add("2024 NN EW SS 2024 (C)", mask: "gggg 00 00 00 rrrr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 75)
        p7.add([2,10,2,4, 31,31, 34,33, 32,32, 12,10,12,14])
        p7.add([2,10,2,4, 31,31, 34,33, 32,32, 22,10,22,24])
        p7.add([12,10,12,14, 31,31, 34,33, 32,32, 22,10,22,24])
    }
    
    
}
