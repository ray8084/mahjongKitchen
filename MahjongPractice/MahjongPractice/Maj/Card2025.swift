//
//  Card2025.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 1/26/25.
//

import Foundation

class Card2025 : Card {
    
    override init() {
        super.init()
        add2025()
        add2468()
        addLikeNumbers()
        addQuints()
        addRuns()
        add13579()
        addWinds()
        add369()
        addSinglesAndPairs()
        
        var count = 0
        for p in letterPatterns {
            count = count + p.idList.list.count
            let hand = p.getFamilyString() + " " + p.text.string + " " + p.note.string
            print("\(p.id+1) count:\(p.idList.list.count) - \(hand)")
        }
        print(count)
    }
    
    override func getYear() -> String {
        return "2025"
    }
        
    func add2025() {
        let p4 = add("FFFF 2025 222 222", mask: "0000 gggg rrr 000", note: "Any 3 Suits, Like Pungs 2s or 5s in Opp.Suits",  family: Family.year, concealed: false, points: 30)
        p4.add([35,35,35,35, 2,10,2,5, 12,12,12, 22,22,22])
        p4.add([35,35,35,35, 12,10,12,15, 2,2,2, 22,22,22])
        p4.add([35,35,35,35, 22,10,22,25, 2,2,2, 12,12,12])
        p4.add([35,35,35,35, 2,10,2,5, 15,15,15, 25,25,25])
        p4.add([35,35,35,35, 12,10,12,15, 5,5,5, 25,25,25])
        p4.add([35,35,35,35, 22,10,22,25, 5,5,5, 15,15,15])
        
        let p1 = add("222 0000 222 5555", mask: "ggg 0000 rrr rrrr", note: "Any 2 Suits",  family: Family.year, concealed : false, points: 25)
        p1.generateList()
        
        let p0 = add("2025 222 555 DDDD", mask: "gggg rrr rrr 0000", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p0.add([2,10,2,5, 12,12,12, 15,15,15, 30,30,30,30])
        p0.add([12,10,12,15, 2,2,2, 5,5,5, 30,30,30,30])
        p0.add([22,10,22,25, 2,2,2, 5,5,5, 20,20,20,20])
        p0.add([2,10,2,5, 22,22,22, 25,25,25, 20,20,20,20])
        p0.add([12,10,12,15, 22,22,22, 25,25,25, 10,10,10,10])
        p0.add([22,10,22,25, 12,12,12, 15,15,15, 10,10,10,10])
        
        let p5 = add("FF 222 000 222 555 (C)", mask: "00 ggg 000 rrr 000",   note: "Any 3 Suits",  family: Family.year, concealed: true, points: 30)
        p5.add([35,35, 2,2,2, 10,10,10, 12,12,12, 25,25,25])
        //p5.add([35,35, 12,12,12, 10,10,10, 2,2,2, 25,25,25])
        p5.add([35,35, 22,22,22, 10,10,10, 2,2,2, 15,15,15])
        //p5.add([35,35, 2,2,2, 10,10,10, 22,22,22, 15,15,15])
        p5.add([35,35, 12,12,12, 10,10,10, 22,22,22, 5,5,5])
        //p5.add([35,35, 22,22,22, 10,10,10, 12,12,12, 5,5,5])
    }
    
    func add2468() {
        let p3 = add("222 4444 666 8888", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p3.generateList()
        
        let p4 = add("222 4444 666 8888", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p4.generateList()
        
        let p2 = add("FF 2222+4444=6666", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p2.generateList()
        
        let p22 = add("FF 2222+6666=8888", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p22.generateList()
        
        let p5 = add("22 444 66 888 DDDD", mask: "00 000 00 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p5.generateList()
        
        let p = add("FFFF 2468 222 222", mask: "0000 gggg rrr 000", note: "Any 3 Suits, Like Pungs Any Even No.",  family: Family.f2468, concealed: false, points: 25)
        p.add([35,35,35,35, 2,4,6,8, 12,12,12, 22,22,22])
        p.add([35,35,35,35, 2,4,6,8, 14,14,14, 24,24,24])
        p.add([35,35,35,35, 2,4,6,8, 16,16,16, 26,26,26])
        p.add([35,35,35,35, 2,4,6,8, 18,18,18, 28,28,28])
        p.add([35,35,35,35, 12,14,16,18, 2,2,2, 22,22,22])
        p.add([35,35,35,35, 12,14,16,18, 4,4,4, 24,24,24])
        p.add([35,35,35,35, 12,14,16,18, 6,6,6, 26,26,26])
        p.add([35,35,35,35, 12,14,16,18, 8,8,8, 28,28,28])
        p.add([35,35,35,35, 22,24,26,28, 2,2,2, 12,12,12])
        p.add([35,35,35,35, 22,24,26,28, 4,4,4, 14,14,14])
        p.add([35,35,35,35, 22,24,26,28, 6,6,6, 16,16,16])
        p.add([35,35,35,35, 22,24,26,28, 8,8,8, 18,18,18])
        
        let p0 = add("FFF 22 44 666 8888", mask: "000 00 00 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        p0.generateList()
        
        let p42 = add("222 4444 666 88 88", mask: "ggg gggg ggg rr 00", note: "Any 3 Suits, Pairs 8s Only",  family: Family.f2468, concealed: false, points: 25)
        p42.add([2,2,2, 4,4,4,4, 6,6,6, 18,18, 28,28])
        p42.add([12,12,12, 14,14,14,14, 16,16,16, 8,8, 28,28])
        p42.add([22,22,22, 24,24,24,24, 26,26,26, 8,8, 18,18])
        
        let p6 = add("FF 2222 DDDD 2222", mask: "00 gggg rrrr 0000", note: "Any 3 Suits, Like Kongs Any Even No.",  family: Family.f2468, concealed: false, points: 25)
        p6.add([35,35, 2,2,2,2, 20,20,20,20, 22,22,22,22])
        p6.add([35,35, 2,2,2,2, 30,30,30,30, 12,12,12,12])
        p6.add([35,35, 12,12,12,12, 10,10,10,10, 22,22,22,22])
        p6.add([35,35, 4,4,4,4, 20,20,20,20, 24,24,24,24])
        p6.add([35,35, 4,4,4,4, 30,30,30,30, 14,14,14,14])
        p6.add([35,35, 14,14,14,14, 10,10,10,10, 24,24,24,24])
        p6.add([35,35, 6,6,6,6, 20,20,20,20, 26,26,26,26])
        p6.add([35,35, 6,6,6,6, 30,30,30,30, 16,16,16,16])
        p6.add([35,35, 16,16,16,16, 10,10,10,10, 26,26,26,26])
        p6.add([35,35, 8,8,8,8, 20,20,20,20, 28,28,28,28])
        p6.add([35,35, 8,8,8,8, 30,30,30,30, 18,18,18,18])
        p6.add([35,35, 18,18,18,18, 10,10,10,10, 28,28,28,28])
        
        let p7 = add("22 44 66 88 222 222 (C)", mask: "gg gg gg gg rrr 000", note: "Any 3 Suits, Like Pungs Any Even No.",  family: Family.f2468, concealed: true, points: 30)
        p7.add([2,2,4,4,6,6,8,8, 12,12,12, 22,22,22])
        p7.add([2,2,4,4,6,6,8,8, 14,14,14, 24,24,24])
        p7.add([2,2,4,4,6,6,8,8, 16,16,16, 26,26,26])
        p7.add([2,2,4,4,6,6,8,8, 18,18,18, 28,28,28])
        p7.add([12,12,14,14,16,16,18,18, 2,2,2, 22,22,22])
        p7.add([12,12,14,14,16,16,18,18, 4,4,4, 24,24,24])
        p7.add([12,12,14,14,16,16,18,18, 6,6,6, 26,26,26])
        p7.add([12,12,14,14,16,16,18,18, 8,8,8, 28,28,28])
        p7.add([22,22,24,24,26,26,28,28, 2,2,2, 12,12,12])
        p7.add([22,22,24,24,26,26,28,28, 4,4,4, 14,14,14])
        p7.add([22,22,24,24,26,26,28,28, 6,6,6, 16,16,16])
        p7.add([22,22,24,24,26,26,28,28, 8,8,8, 18,18,18])
        
    }
        
    func addLikeNumbers() {
        let p2 = add("FF 1111 D 1111 D 11", mask: "00 gggg g rrrr r 00", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([35,35, d,d,d,d, 10, b,b,b,b, 20, c,c])
            p2.add([35,35, d,d,d,d, 10, c,c,c,c, 30, b,b])
            p2.add([35,35, b,b,b,b, 20, c,c,c,c, 30, d,d])
        }
        
        let p1 = add("FFFF 11 111 111 11", mask: "0000 gg rrr 000 gg", note: "Any 3 Suits, Pairs Must Be Same Suit",  family: Family.likeNumbers, concealed: false, points: 25)
        p1.add([35,35,35,35, 1,1, 11,11,11, 21,21,21, 1,1], singles: 1)
        p1.add([35,35,35,35, 11,11, 1,1,1, 21,21,21, 11,11], singles: 11)
        p1.add([35,35,35,35, 21,21, 1,1,1, 11,11,11, 21,21], singles: 21)
        
        p1.add([35,35,35,35, 2,2, 12,12,12, 22,22,22, 2,2], singles: 2)
        p1.add([35,35,35,35, 12,12, 2,2,2, 22,22,22, 12,12], singles: 12)
        p1.add([35,35,35,35, 22,22, 2,2,2, 12,12,12, 22,22], singles: 22)
        
        p1.add([35,35,35,35, 3,3, 13,13,13, 23,23,23, 3,3], singles: 3)
        p1.add([35,35,35,35, 13,13, 3,3,3, 23,23,23, 13,13], singles: 13)
        p1.add([35,35,35,35, 23,23, 3,3,3, 13,13,13, 23,23], singles: 23)
        
        p1.add([35,35,35,35, 4,4, 14,14,14, 24,24,24, 4,4], singles: 4)
        p1.add([35,35,35,35, 14,14, 4,4,4, 24,24,24, 14,14], singles: 14)
        p1.add([35,35,35,35, 24,24, 4,4,4, 14,14,14, 24,24], singles: 24)
        
        p1.add([35,35,35,35, 5,5, 15,15,15, 25,25,25, 5,5], singles: 5)
        p1.add([35,35,35,35, 15,15, 5,5,5, 25,25,25, 15,15], singles: 15)
        p1.add([35,35,35,35, 25,25, 5,5,5, 15,15,15, 25,25], singles: 25)
        
        p1.add([35,35,35,35, 6,6, 16,16,16, 26,26,26, 6,6], singles: 6)
        p1.add([35,35,35,35, 16,16, 6,6,6, 26,26,26, 16,16], singles: 16)
        p1.add([35,35,35,35, 26,26, 6,6,6, 16,16,16, 26,26], singles: 26)
        
        p1.add([35,35,35,35, 7,7, 17,17,17, 27,27,27, 7,7], singles: 7)
        p1.add([35,35,35,35, 17,17, 7,7,7, 27,27,27, 17,17], singles: 17)
        p1.add([35,35,35,35, 27,27, 7,7,7, 17,17,17, 27,27], singles: 27)
        
        p1.add([35,35,35,35, 8,8, 18,18,18, 28,28,28, 8,8], singles: 8)
        p1.add([35,35,35,35, 18,18, 8,8,8, 28,28,28, 18,18], singles: 18)
        p1.add([35,35,35,35, 28,28, 8,8,8, 18,18,18, 28,28], singles: 28)
        
        p1.add([35,35,35,35, 9,9, 19,19,19, 29,29,29, 9,9], singles: 9)
        p1.add([35,35,35,35, 19,19, 9,9,9, 29,29,29, 19,19], singles: 19)
        p1.add([35,35,35,35, 29,29, 9,9,9, 19,19,19, 29,29], singles: 29)
        
        let p3 = add("FF 111 111 111 DDD (C)", mask: "00 ggg rrr 000 ggg", note: "Any 3 Suits, Any Dragon",  family: Family.likeNumbers, concealed: true, points: 30)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([35,35, d,d,d, b,b,b, c,c,c, 10,10,10])
            p3.add([35,35, d,d,d, b,b,b, c,c,c, 20,20,20])
            p3.add([35,35, d,d,d, b,b,b, c,c,c, 30,30,30])
        }
    }
    
    func addQuints() {
        let p = add("FF 111 2222 33333", mask: "00 ggg rrrr 00000", note: "Any 3 Suits, Any 3 Consec Nos.",  family: Family.quints, concealed: false, points: 40)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d, b+1,b+1,b+1,b+1, c+2,c+2,c+2,c+2,c+2])
            p.add([35,35, d,d,d, c+1,c+1,c+1,c+1, b+2,b+2,b+2,b+2,b+2])
            p.add([35,35, b,b,b, d+1,d+1,d+1,d+1, c+2,c+2,c+2,c+2,c+2])
            p.add([35,35, b,b,b, c+1,c+1,c+1,c+1, d+2,d+2,d+2,d+2,d+2])
            p.add([35,35, c,c,c, d+1,d+1,d+1,d+1, b+2,b+2,b+2,b+2,b+2])
            p.add([35,35, c,c,c, b+1,b+1,b+1,b+1, d+2,d+2,d+2,d+2,d+2])
        }
    
        let p1 = add("11111 NNNN 22222", mask: "00000 0000 00000", note: "Any 1 Suit, Any 2 Consec Nos, Any Wind",  family: Family.quints, concealed: false, points: 45)
        for w in 31...34 {
            for i in 1...8 {
                let d = i
                let b = i+10
                let c = i+20
                p1.add([d,d,d,d,d, w,w,w,w, d+1,d+1,d+1,d+1,d+1])
                p1.add([b,b,b,b,b, w,w,w,w, b+1,b+1,b+1,b+1,b+1])
                p1.add([c,c,c,c,c, w,w,w,w, c+1,c+1,c+1,c+1,c+1])
            }
        }

        let p2 = add("FF 11111 11 11111", mask: "00 ggggg rr 00000", note: "Any 3 Suits, Any Like Nos.",  family: Family.quints, concealed: false, points: 45)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([35,35, d,d,d,d,d, b,b, c,c,c,c,c])
            p2.add([35,35, d,d,d,d,d, c,c, b,b,b,b,b])
            p2.add([35,35, b,b,b,b,b, d,d, c,c,c,c,c])
        }

    }
    
    func addRuns() {
        let p = add("11 222 3333 444 55", mask: "00 000 0000 000 00", note: "Any 1 Suit, These Nos. Only",  family: Family.run, concealed: false, points: 25)
        p.add([1,1, 2,2,2, 3,3,3,3, 4,4,4, 5,5])
        p.add([11,11, 12,12,12, 13,13,13,13, 14,14,14, 15,15])
        p.add([21,21, 22,22,22, 23,23,23,23, 24,24,24, 25,25])
        
        let p2 = add("55 666 7777 888 99", mask: "00 000 0000 000 00", note: "Any 1 Suit, These Nos. Only",  family: Family.run, concealed: false, points: 25 )
        p2.add([5,5, 6,6,6, 7,7,7,7, 8,8,8, 9,9])
        p2.add([15,15, 16,16,16, 17,17,17,17, 18,18,18, 19,19])
        p2.add([25,25, 26,26,26, 27,27,27,27, 28,28,28, 29,29])
        
        let p3 = add("111 2222 333 4444", mask: "000 0000 000 0000", note: "Any 1 Suit, Any 4 Consec. Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([d,d,d, d+1,d+1,d+1,d+1 ,d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p3.add([b,b,b, b+1,b+1,b+1,b+1 ,b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p3.add([c,c,c, c+1,c+1,c+1,c+1 ,c+2,c+2,c+2, c+3,c+3,c+3,c+3])
        }
        
        let p4 = add("111 2222 333 4444", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits, Any 4 Consec. Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([d,d,d, d+1,d+1,d+1,d+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p4.add([d,d,d, d+1,d+1,d+1,d+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p4.add([b,b,b, b+1,b+1,b+1,b+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p4.add([b,b,b, b+1,b+1,b+1,b+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3])
            p4.add([c,c,c, c+1,c+1,c+1,c+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p4.add([c,c,c, c+1,c+1,c+1,c+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3])
        }
        
        let p42 = add("FFFF 1111 22 3333", mask: "0000 0000 00 0000", note: "Any 1 Suit, Any 3 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p42.add([35,35,35,35, d,d,d,d, d+1,d+1, d+2,d+2,d+2,d+2])
            p42.add([35,35,35,35, b,b,b,b, b+1,b+1, b+2,b+2,b+2,b+2])
            p42.add([35,35,35,35, c,c,c,c, c+1,c+1, c+2,c+2,c+2,c+2])
        }
        
        let p5 = add("FFFF 1111 22 3333", mask: "0000 gggg rr 0000", note: "Any 3 Suits, Any 3 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([35,35,35,35, d,d,d,d, b+1,b+1, c+2,c+2,c+2,c+2])
            p5.add([35,35,35,35, d,d,d,d, c+1,c+1, b+2,b+2,b+2,b+2])
            p5.add([35,35,35,35, b,b,b,b, d+1,d+1, c+2,c+2,c+2,c+2])
            p5.add([35,35,35,35, b,b,b,b, c+1,c+1, d+2,d+2,d+2,d+2])
            p5.add([35,35,35,35, c,c,c,c, d+1,d+1, b+2,b+2,b+2,b+2])
            p5.add([35,35,35,35, c,c,c,c, b+1,b+1, d+2,d+2,d+2,d+2])
        }
        
        let p8 = add("FFF 123 4444 5555", mask: "000 ggg rrrr 0000", note: "Any 3 Suits, Any 5 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p8.add([35,35,35, d,d+1,d+2, b+3,b+3,b+3,b+3, c+4,c+4,c+4,c+4])
            p8.add([35,35,35, b,b+1,b+2, d+3,d+3,d+3,d+3, c+4,c+4,c+4,c+4])
            p8.add([35,35,35, c,c+1,c+2, d+3,d+3,d+3,d+3, b+4,b+4,b+4,b+4])
            p8.add([35,35,35, d,d+1,d+2, c+3,c+3,c+3,c+3, b+4,b+4,b+4,b+4])
            p8.add([35,35,35, b,b+1,b+2, c+3,c+3,c+3,c+3, d+4,d+4,d+4,d+4])
            p8.add([35,35,35, c,c+1,c+2, b+3,b+3,b+3,b+3, d+4,d+4,d+4,d+4])
        }
        
        let p99 = add("FF 11 222 3333 DDD", mask: "00 00 000 0000 000", note: "Any 1 Suit, Any 3 Consec. Nos.",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p99.add([35,35, d,d, d+1,d+1,d+1, d+2,d+2,d+2,d+2, 10,10,10])
            p99.add([35,35, b,b, b+1,b+1,b+1, b+2,b+2,b+2,b+2, 20,20,20])
            p99.add([35,35, c,c, c+1,c+1,c+1, c+2,c+2,c+2,c+2, 30,30,30])
        }
        
        let p0 = add("111 222 3333 DD DD", mask: "ggg ggg gggg rr 00", note: "Any 3 Suits, Any 3 Consec Nos, Opp Dragons",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p0.add([d,d,d, d+1,d+1,d+1, d+2,d+2,d+2,d+2, 20,20, 30,30])
            p0.add([b,b,b, b+1,b+1,b+1, b+2,b+2,b+2,b+2, 10,10, 30,30])
            p0.add([c,c,c, c+1,c+1,c+1, c+2,c+2,c+2,c+2, 10,10, 20,20])
        }
        
        let p32 = add("112345 1111 1111", mask: "gggggg rrrr 0000", note: "Any Run, Any Pair, Kongs Match Pair",  family: Family.run, concealed: false, points: 30)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p32.add([d,d,d+1,d+2,d+3,d+4, b,b,b,b, c,c,c,c])
            p32.add([b,b,b+1,b+2,b+3,b+4, d,d,d,d, c,c,c,c])
            p32.add([c,c,c+1,c+2,c+3,c+4, d,d,d,d, b,b,b,b])
            p32.add([d,d+1,d+1,d+2,d+3,d+4, b+1,b+1,b+1,b+1, c+1,c+1,c+1,c+1])
            p32.add([b,b+1,b+1,b+2,b+3,b+4, d+1,d+1,d+1,d+1, c+1,c+1,c+1,c+1])
            p32.add([c,c+1,c+1,c+2,c+3,c+4, d+1,d+1,d+1,d+1, b+1,b+1,b+1,b+1])
            p32.add([d,d+1,d+2,d+2,d+3,d+4, b+2,b+2,b+2,b+2, c+2,c+2,c+2,c+2])
            p32.add([b,b+1,b+2,b+2,b+3,b+4, d+2,d+2,d+2,d+2, c+2,c+2,c+2,c+2])
            p32.add([c,c+1,c+2,c+2,c+3,c+4, d+2,d+2,d+2,d+2, b+2,b+2,b+2,b+2])
            p32.add([d,d+1,d+2,d+3,d+3,d+4, b+3,b+3,b+3,b+3, c+3,c+3,c+3,c+3])
            p32.add([b,b+1,b+2,b+3,b+3,b+4, d+3,d+3,d+3,d+3, c+3,c+3,c+3,c+3])
            p32.add([c,c+1,c+2,c+3,c+3,c+4, d+3,d+3,d+3,d+3, b+3,b+3,b+3,b+3])
            p32.add([d,d+1,d+2,d+3,d+4,d+4, b+4,b+4,b+4,b+4, c+4,c+4,c+4,c+4])
            p32.add([b,b+1,b+2,b+3,b+4,b+4, d+4,d+4,d+4,d+4, c+4,c+4,c+4,c+4])
            p32.add([c,c+1,c+2,c+3,c+4,c+4, d+4,d+4,d+4,d+4, b+4,b+4,b+4,b+4])
        }
        
        let p6 = add("FF 1 22 333 1 22 333 (C)", mask: "00 g gg ggg r rr rrr", note: "Any 2 Suits, Any Same 3 Consec Nos",  family: Family.run, concealed: true, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([35,35, d, d+1,d+1, d+2,d+2,d+2, b, b+1,b+1, b+2,b+2,b+2])
            p6.add([35,35, d, d+1,d+1, d+2,d+2,d+2, c, c+1,c+1, c+2,c+2,c+2])
            p6.add([35,35, b, b+1,b+1, b+2,b+2,b+2, c, c+1,c+1, c+2,c+2,c+2])
        }
    }
    
    func add13579() {
        let p0 = add("11 333 5555 777 99", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
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
        
        let p5 = add("1111 333 5555 DDD", mask: "0000 000 0000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p5.generateList()
        
        let p6 = add("5555 777 9999 DDD", mask: "0000 000 0000 000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p6.generateList()
        
        let p11 = add("FFFF 1111+9999=10", mask: "0000 gggg gggg rr", note: "Any 2 Suits, These Nos. Only",  family: Family.f13579, concealed: false, points: 25)
        p11.add([35,35,35,35, 1,1,1,1, 9,9,9,9, 11,10])
        p11.add([35,35,35,35, 11,11,11,11, 19,19,19,19, 1,10])
        p11.add([35,35,35,35, 21,21,21,21, 29,29,29,29, 1,10])
        p11.add([35,35,35,35, 1,1,1,1, 9,9,9,9, 21,10])
        p11.add([35,35,35,35, 11,11,11,11, 19,19,19,19, 21,10])
        p11.add([35,35,35,35, 21,21,21,21, 29,29,29,29, 11,10])
        
        let p10 = add("FFF 135 7777 9999", mask: "000 000 0000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p10.generateList()
        
        let p12 = add("FFF 135 7777 9999", mask: "000 ggg rrrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p12.generateList()
        
        let p55 = add("111 333 5555 DD DD", mask: "ggg ggg gggg rr 00", note: "Any 3 Suits, Opp Dragons",  family: Family.f13579, concealed: false, points: 25)
        p55.add([1,1,1, 3,3,3, 5,5,5,5, 30,30, 20,20])
        p55.add([11,11,11, 13,13,13, 15,15,15,15, 10,10, 30,30])
        p55.add([21,21,21, 23,23,23, 25,25,25,25, 10,10, 20,20])
        
        let p557 = add("555 777 9999 DD DD", mask: "ggg ggg gggg rr 00", note: "Any 3 Suits, Opp Dragons",  family: Family.f13579, concealed: false, points: 25)
        p557.add([5,5,5, 7,7,7, 9,9,9,9, 30,30, 20,20])
        p557.add([15,15,15, 17,17,17, 19,19,19,19, 10,10, 30,30])
        p557.add([25,25,25, 27,27,27, 29,29,29,29, 10,10, 20,20])
        
        let p4 = add("11 333 NEWS 333 55", mask: "gg ggg 0000 rrr rr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 30)
        p4.add([1,1, 3,3,3, 31,34,33,32, 13,13,13, 15,15])
        p4.add([1,1, 3,3,3, 31,34,33,32, 23,23,23, 25,25])
        p4.add([11,11, 13,13,13, 31,34,33,32, 3,3,3, 5,5])
        p4.add([11,11, 13,13,13, 31,34,33,32, 23,23,23, 25,25])
        p4.add([21,21, 23,23,23, 31,34,33,32, 3,3,3, 5,5])
        p4.add([21,21, 23,23,23, 31,34,33,32, 13,13,13, 15,15])
        
        let p45 = add("55 777 NEWS 777 99", mask: "gg ggg 0000 rrr rr", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 30)
        p45.add([5,5, 7,7,7, 31,34,33,32, 17,17,17, 19,19])
        p45.add([5,5, 7,7,7, 31,34,33,32, 27,27,27, 29,29])
        p45.add([15,15, 17,17,17, 31,34,33,32, 7,7,7, 9,9])
        p45.add([15,15, 17,17,17, 31,34,33,32, 27,27,27, 29,29])
        p45.add([25,25, 27,27,27, 31,34,33,32, 7,7,7, 9,9])
        p45.add([25,25, 27,27,27, 31,34,33,32, 17,17,17, 19,19])
        
        let p13 = add("1111 33 55 77 9999", mask: "gggg rr rr rr gggg", note: "Any 2 Suits",  family: Family.f13579, concealed: false, points: 30)
        p13.generateList()
        
        let p66 = add("FF 11 33 111 333 55 (C)", mask: "00 gg gg rrr rrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: true, points: 30)
        p66.generateList()
        
        let p67 = add("FF 55 77 555 777 99 (C)", mask: "00 gg gg rrr rrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: true, points: 30)
        p67.generateList()
    }

    func addWinds() {
        let p = add("NNNN EEE WWW SSSS", mask: "0000 000 000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p.add([31,31,31,31, 34,34,34, 33,33,33, 32,32,32,32])
        
        let p2 = add("NNN EEEE WWWW SSS", mask: "000 0000 0000 000", note: "",  family: Family.winds, concealed: false, points: 25)
        p2.add([31,31,31, 34,34,34,34, 33,33,33,33, 32,32,32])
        
        let p33 = add("FF 123 DD DDD DDDD", mask: "00 000 gg rrr 0000", note: "Any 3 Consec Nos, Any 1 Suit, Any Dragons",  family: Family.winds, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p33.add([35,35, d,d+1,d+2, 10,10, 20,20,20, 30,30,30,30])
            p33.add([35,35, b,b+1,b+2, 10,10, 20,20,20, 30,30,30,30])
            p33.add([35,35, c,c+1,c+2, 10,10, 20,20,20, 30,30,30,30])
            p33.add([35,35, d,d+1,d+2, 10,10, 30,30,30, 20,20,20,20])
            p33.add([35,35, b,b+1,b+2, 10,10, 30,30,30, 20,20,20,20])
            p33.add([35,35, c,c+1,c+2, 10,10, 30,30,30, 20,20,20,20])
            
            p33.add([35,35, d,d+1,d+2, 20,20, 10,10,10, 30,30,30,30])
            p33.add([35,35, b,b+1,b+2, 20,20, 10,10,10, 30,30,30,30])
            p33.add([35,35, c,c+1,c+2, 20,20, 10,10,10, 30,30,30,30])
            p33.add([35,35, d,d+1,d+2, 20,20, 30,30,30, 10,10,10,10])
            p33.add([35,35, b,b+1,b+2, 20,20, 30,30,30, 10,10,10,10])
            p33.add([35,35, c,c+1,c+2, 20,20, 30,30,30, 10,10,10,10])
            
            p33.add([35,35, d,d+1,d+2, 30,30, 10,10,10, 20,20,20,20])
            p33.add([35,35, b,b+1,b+2, 30,30, 10,10,10, 20,20,20,20])
            p33.add([35,35, c,c+1,c+2, 30,30, 10,10,10, 20,20,20,20])
            p33.add([35,35, d,d+1,d+2, 30,30, 20,20,20, 10,10,10,10])
            p33.add([35,35, b,b+1,b+2, 30,30, 20,20,20, 10,10,10,10])
            p33.add([35,35, c,c+1,c+2, 30,30, 20,20,20, 10,10,10,10])
        }
        
        let p0 = add("FFF NN EE WWW SSSS", mask: "000 00 00 000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p0.add([35,35,35, 31,31, 34,34, 33,33,33, 32,32,32,32])
        
        let p8 = add("FFFF DDD NEWS DDD", mask: "0000 ggg 0000 rrr", note: "Any 2 Dragons",  family: Family.winds, concealed: false, points: 25)
        p8.add([35,35,35,35, 10,10,10, 31,34,33,32, 30,30,30])
        p8.add([35,35,35,35, 10,10,10, 31,34,33,32, 20,20,20])
        p8.add([35,35,35,35, 20,20,20, 31,34,33,32, 30,30,30])
        
        let p4 = add("NNNN 1 11 111 SSSS", mask: "0000 g rr 000 0000", note: "Any Like Odd Nos in 3 Suits",  family: Family.winds, concealed: false, points: 25)
        for i in 1...9 {
            if i & 1 == 1 {
                let d = i
                let b = i+10
                let c = i+20
                p4.add([31,31,31,31, d, b,b, c,c,c, 32,32,32,32])
                p4.add([31,31,31,31, d, c,c, b,b,b, 32,32,32,32])
                p4.add([31,31,31,31, b, d,d, c,c,c, 32,32,32,32])
                p4.add([31,31,31,31, b, c,c, d,d,d, 32,32,32,32])
                p4.add([31,31,31,31, c, d,d, b,b,b, 32,32,32,32])
                p4.add([31,31,31,31, c, b,b, d,d,d, 32,32,32,32])
            }
        }
        
        let p5 = add("EEEE 2 22 222 WWWW", mask: "0000 g rr 000 0000", note: "Any Like Even Nos 3 Suits",  family: Family.winds, concealed: false, points: 25)
        for i in 1...9 {
            if i & 1 == 0 {
                let d = i
                let b = i+10
                let c = i+20
                p5.add([34,34,34,34, d, b,b, c,c,c, 33,33,33,33])
                p5.add([34,34,34,34, d, c,c, b,b,b, 33,33,33,33])
                p5.add([34,34,34,34, b, d,d, c,c,c, 33,33,33,33])
                p5.add([34,34,34,34, b, c,c, d,d,d, 33,33,33,33])
                p5.add([34,34,34,34, c, d,d, b,b,b, 33,33,33,33])
                p5.add([34,34,34,34, c, b,b, d,d,d, 33,33,33,33])
            }
        }
        
        let p1 = add("NN EEE WWW SS 2025", mask: "00 000 000 00 0000", note: "2025 Any 1 Suit",  family: Family.winds, concealed: false, points: 30)
        p1.add([31,31, 34,34,34, 33,33,33, 32,32, 2,10,2,5])
        p1.add([31,31, 34,34,34, 33,33,33, 32,32, 12,10,12,15])
        p1.add([31,31, 34,34,34, 33,33,33, 32,32, 22,10,22,25])
        
        let p12 = add("NNN EE WW SSS 2025", mask: "000 00 00 000 0000", note: "2025 Any 1 Suit",  family: Family.winds, concealed: false, points: 30)
        p12.add([31,31,31, 34,34, 33,33, 32,32,32, 2,10,2,5])
        p12.add([31,31,31, 34,34, 33,33, 32,32,32, 12,10,12,15])
        p12.add([31,31,31, 34,34, 33,33, 32,32,32, 22,10,22,25])
        
        let p10 = add("NN EE WWW SSS DDDD (C)", mask: "00 00 000 000 0000", note: "Kong Any Dragon",  family: Family.winds, concealed: true, points: 30)
        p10.add([31,31, 34,34, 33,33,33, 32,32,32, 10,10,10,10])
        p10.add([31,31, 34,34, 33,33,33, 32,32,32, 20,20,20,20])
        p10.add([31,31, 34,34, 33,33,33, 32,32,32, 30,30,30,30])
    }
    
    func add369() {
        let p2 = add("333 6666 666 9999", mask: "ggg gggg rrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p2.generateList()
        
        let p22 = add("333 6666 666 9999", mask: "ggg gggg rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p22.generateList()
        
        let p4 = add("FF 3333+6666=9999", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        let p5 = add("FF 3333+6666=9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p4.generateList()
        p5.generateList()
        
        let p23 = add("3333 DDD 3333 DDD", mask: "gggg ggg rrrr rrr", note: "Any 2 Suits, Like Kongs 3,6,9",  family: Family.f369, concealed: false, points: 25)
        p23.add([3,3,3,3, 10,10,10, 13,13,13,13, 20,20,20])
        p23.add([3,3,3,3, 10,10,10, 23,23,23,23, 30,30,30])
        p23.add([13,13,13,13, 20,20,20, 23,23,23,23, 30,30,30])
        
        p23.add([6,6,6,6, 10,10,10, 16,16,16,16, 20,20,20])
        p23.add([6,6,6,6, 10,10,10, 26,26,26,26, 30,30,30])
        p23.add([16,16,16,16, 20,20,20, 26,26,26,26, 30,30,30])
        
        p23.add([9,9,9,9, 10,10,10, 19,19,19,19, 20,20,20])
        p23.add([9,9,9,9, 10,10,10, 29,29,29,29, 30,30,30])
        p23.add([19,19,19,19, 20,20,20, 29,29,29,29, 30,30,30])
        
        let p55 = add("FFF 3333 369 9999", mask: "000 gggg rrr gggg", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p55.generateList()
        
        let p3 = add("33 66 99 3333 3333", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits, Like Kongs 3,6 or 9",  family: Family.f369, concealed: false, points: 25)
        p3.add([3,3,6,6,9,9, 13,13,13,13, 23,23,23,23])
        p3.add([13,13,16,16,19,19, 3,3,3,3, 23,23,23,23])
        p3.add([23,23,26,26,29,29, 3,3,3,3, 13,13,13,13])
        p3.add([3,3,6,6,9,9, 16,16,16,16, 26,26,26,26])
        p3.add([13,13,16,16,19,19, 6,6,6,6, 26,26,26,26])
        p3.add([23,23,26,26,29,29, 6,6,6,6, 16,16,16,16])
        p3.add([3,3,6,6,9,9, 19,19,19,19, 29,29,29,29])
        p3.add([13,13,16,16,19,19, 9,9,9,9, 29,29,29,29])
        p3.add([23,23,26,26,29,29, 9,9,9,9, 19,19,19,19])
        
        let p33 = add("FF 333 D 666 D 999 D (C)", mask: "00 ggg g rrr r 000 0", note: "Any 3 Suits, Matching Dragons",  family: Family.f369, concealed: true, points: 30)
        p33.generateList()
    }
    
    func addSinglesAndPairs() {
        let p6 = add("NN EW SS 11 22 33 44 (C)", mask: "00 00 00 00 00 00 00", note: "Any 1 Suit, Any 4 Consec Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([31,31, 34,33, 32,32, d,d, d+1,d+1, d+2,d+2, d+3,d+3])
            p6.add([31,31, 34,33, 32,32, b,b, b+1,b+1, b+2,b+2, b+3,b+3])
            p6.add([31,31, 34,33, 32,32, c,c, c+1,c+1, c+2,c+2, c+3,c+3])
        }
        
        let p2 = add("FF 2468 DD 2468 DD (C)", mask: "00 gggg gg rrrr rr", note: "Any 2 Suits, Matching Dragons",  family: Family.pairs, concealed: true, points: 50)
        p2.add([35,35, 2,4,6,8, 10,10, 12,14,16,18, 20,20])
        p2.add([35,35, 2,4,6,8, 10,10, 22,24,26,28, 30,30])
        p2.add([35,35, 12,14,16,18, 20,20, 22,24,26,28, 30,30])
        
        let p3 = add("336699 336699 33 (C)", mask: "gggggg rrrrrr 00", note: "Any 3 Suits, Pair 3,6 or 9 in Third Suit",  family: Family.pairs, concealed: true, points: 50)
        p3.add([13,13,16,16,19,19, 23,23,26,26,29,29, 3,3])
        p3.add([3,3,6,6,9,9, 23,23,26,26,29,29, 13,13])
        p3.add([3,3,6,6,9,9, 13,13,16,16,19,19, 23,23])
        p3.add([13,13,16,16,19,19, 23,23,26,26,29,29, 6,6])
        p3.add([3,3,6,6,9,9, 23,23,26,26,29,29, 16,16])
        p3.add([3,3,6,6,9,9, 13,13,16,16,19,19, 26,26])
        p3.add([13,13,16,16,19,19, 23,23,26,26,29,29, 9,9])
        p3.add([3,3,6,6,9,9, 23,23,26,26,29,29, 19,19])
        p3.add([3,3,6,6,9,9, 13,13,16,16,19,19, 29,29])
        
        let p = add("FF 11 22 11 22 11 22 (C)", mask: "00 gg gg rr rr 00 00", note: "Any 3 Suits, Any 2 Consec Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p.add([35,35, d,d,d+1,d+1, b,b,b+1,b+1, c,c,c+1,c+1])
        }
        
        let p5 = add("11 33 55 77 99 11 11 (C)", mask: "gg gg gg gg gg rr 00", note: "Any 3 Suits, Pairs Any Like Odds in Opp Suits",  family: Family.pairs, concealed: true, points: 50)
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
        
        let p61 = add("FF 2025 2025 2025 (C)", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 75)
        p61.add([35,35, 2,10,2,5, 12,10,12,15, 22,10,22,25])
    }
    
}
