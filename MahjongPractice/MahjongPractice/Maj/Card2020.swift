//
//  File.swift
//  Mahjong2019
//
//  Created by Ray Meyer on 3/27/19.
//  Copyright © 2019 Ray. All rights reserved.
//

class Card2020 : Card {
    
    override init() {
        super.init()
        add2020()
        add2468()
        addLikeNumbers()
        addQuints()
        addConsectiveRun()
        add13579()
        addWindsAndDragons()
        add369()
        addSinglesAndPairs()
        
        var count = 0
        for p in letterPatterns {
            count = count + p.idList.list.count
            //print("\(p.id+1) " + p.getFamilyString() + " count:\(p.idList.list.count)")
        }
        //print(count)
    }
    
    
    func add2020() {
        let p0 = add("FF 2020 2222 2222", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.year, concealed: false, points: 25)
        p0.add([35,35, 2,10,2,10, 12,12,12,12, 22,22,22,22])
        p0.add([35,35, 12,10,12,10, 2,2,2,2, 22,22,22,22])
        p0.add([35,35, 22,10,22,10, 2,2,2,2, 12,12,12,12])
        
        let p1 = add("FF DDDD 2020 DDDD", mask: "00 rrrr 0000 gggg", note: "2s any 1 suit, Red&Green dragon",  family: Family.year, concealed: false, points: 25)
        p1.add([35,35, 30,30,30,30, 2,10,2,10, 20,20,20,20])
        p1.add([35,35, 30,30,30,30, 12,10,12,10, 20,20,20,20])
        p1.add([35,35, 30,30,30,30, 22,10,22,10, 20,20,20,20])
        
        let p2 = add("FFFFF 22 222 2020", mask: "00000 rr ggg 0000", note: "Any 3 suits",  family: Family.year, concealed: false, points: 25)
        p2.add([35,35,35,35,35, 2,2, 12,12,12, 22,10,22,10])
        p2.add([35,35,35,35,35, 2,2, 22,22,22, 12,10,12,10])
        p2.add([35,35,35,35,35, 12,12, 2,2,2, 22,10,22,10])
        p2.add([35,35,35,35,35, 12,12, 22,22,22, 2,10,2,10])
        p2.add([35,35,35,35,35, 22,22, 2,2,2, 12,10,12,10])
        p2.add([35,35,35,35,35, 22,22, 12,12,12, 2,10,2,10])
        
        let p6 = add("NN EEE 2020 WWW SS (C)", mask: "00 000 0000 000 00", note: "2s Any 1 Suit",  family: Family.year, concealed: true, points: 30)
        p6.add([31,31, 34,34,34, 2,10,2,10, 33,33,33, 32,32])
        p6.add([31,31, 34,34,34, 12,10,12,10, 33,33,33, 32,32])
        p6.add([31,31, 34,34,34, 22,10,22,10, 33,33,33, 32,32])
    }
    
    func add2468() {
        let p1 = add("FFFF 2 44 666 8888", mask: "0000 0 00 000 0000", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        let p2 = add("22 44 666 888 DDDD", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p3 = add("2222 4444 6666 88", mask: "0000 0000 0000 00", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        let p4 = add("222 444 6666 8888", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f2468, concealed: false, points: 25)
        p1.generateList()
        p2.generateList()
        p3.generateList()
        p4.generateList()
        let p5 = add("FFFF 4444 6666 24", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p6 = add("FFFF 6666 8888 48", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        p5.generateList()
        p6.generateList()
        let p7 = add("22 444 44 666 8888", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits",  family: Family.f2468, concealed: false, points: 25)
        let p8 = add("22 444 DDDD 666 88", mask: "00 000 0000 000 00", note: "Any 1 Suit",  family: Family.f2468, concealed: false, points: 25)
        let p9 = add("FF 222 444 666 888 (C)", mask: "00 ggg rrr rrr ggg", note: "Any 2 Suits",  family: Family.f2468, concealed: true, points: 30)
        p7.generateList()
        p8.generateList()
        p9.generateList()
    }
    
    func addLikeNumbers() {
        let p1 = add("FF 1111 1111 1111", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([35,35, d,d,d,d, b,b,b,b, c,c,c,c])
        }
        
        let p2 = add("FF 1111 DD 1111 DD", mask: "00 gggg gg rrrr rr", note: "Any 2 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p2.add([35,35, d,d,d,d, 10,10, b,b,b,b, 20,20])
            p2.add([35,35, d,d,d,d, 10,10, c,c,c,c, 30,30])
            p2.add([35,35, b,b,b,b, 20,20, c,c,c,c, 30,30])
        }
        
        let p3 = add("FFFFF 11 111 1111", mask: "00000 gg rrr 0000", note: "Any 3 Suits",  family: Family.likeNumbers, concealed: false, points: 25)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p3.add([35,35,35,35,35, d,d, b,b,b, c,c,c,c])
            p3.add([35,35,35,35,35, d,d, c,c,c, b,b,b,b])
            p3.add([35,35,35,35,35, b,b, d,d,d, c,c,c,c])
            p3.add([35,35,35,35,35, b,b, c,c,c, d,d,d,d])
            p3.add([35,35,35,35,35, c,c, d,d,d, b,b,b,b])
            p3.add([35,35,35,35,35, c,c, b,b,b, d,d,d,d])
        }
    }
    
    func addQuints() {
        let p4 = add("FFFFF DDDD 11111", mask: "00000 0000 ggggg", note: "Any No in Any Suit, Any Dragon",  family: Family.quints, concealed: false, points: 40)
        for i in 1...9 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([35,35,35,35,35, 10,10,10,10, d,d,d,d,d])
            p4.add([35,35,35,35,35, 10,10,10,10, b,b,b,b,b])
            p4.add([35,35,35,35,35, 10,10,10,10, c,c,c,c,c])
            p4.add([35,35,35,35,35, 20,20,20,20, d,d,d,d,d])
            p4.add([35,35,35,35,35, 20,20,20,20, b,b,b,b,b])
            p4.add([35,35,35,35,35, 20,20,20,20, c,c,c,c,c])
            p4.add([35,35,35,35,35, 30,30,30,30, d,d,d,d,d])
            p4.add([35,35,35,35,35, 30,30,30,30, b,b,b,b,b])
            p4.add([35,35,35,35,35, 30,30,30,30, c,c,c,c,c])
        }

        let p1 = add("11 22 33333 33333", mask: "gg gg rrrrr 00000", note: "Any 3 Suits, Any 3 Consec Nos",  family: Family.quints, concealed: false, points: 45)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([d,d, d+1,d+1, b+2,b+2,b+2,b+2,b+2, c+2,c+2,c+2,c+2,c+2])
            p1.add([b,b, b+1,b+1, d+2,d+2,d+2,d+2,d+2, c+2,c+2,c+2,c+2,c+2])
            p1.add([c,c, c+1,c+1, d+2,d+2,d+2,d+2,d+2, b+2,b+2,b+2,b+2,b+2])
        }
        
        let p2 = add("11111 3333 55555", mask: "00000 0000 00000", note: "Any 1 Suit, These No Only",  family: Family.quints, concealed: false, points: 45)
        let p3 = add("55555 7777 99999", mask: "00000 0000 00000", note: "Any 1 Suit, These No Only",  family: Family.quints, concealed: false, points: 45)
        p2.generateList()
        p3.generateList()
        
        let p5 = add("11111 22 33 44444", mask: "00000 00 00 00000", note: "Any 1 Suit, Any 4 Consec Nos",  family: Family.quints, concealed: false, points: 45)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([d,d,d,d,d, d+1,d+1, d+2,d+2, d+3,d+3,d+3,d+3,d+3])
            p5.add([b,b,b,b,b, b+1,b+1, b+2,b+2, b+3,b+3,b+3,b+3,b+3])
            p5.add([c,c,c,c,c, c+1,c+1, c+2,c+2, c+3,c+3,c+3,c+3,c+3])
        }
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

        let p4 = add("FFFF 1111 22 3333", mask: "0000 0000 00 0000", note: "Any 1 Suit, Any Run",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p4.add([35,35,35,35, d,d,d,d, d+1,d+1, d+2,d+2,d+2,d+2])
            p4.add([35,35,35,35, b,b,b,b, b+1,b+1, b+2,b+2,b+2,b+2])
            p4.add([35,35,35,35, c,c,c,c, c+1,c+1, c+2,c+2,c+2,c+2])
        }
        
        let p5 = add("FFFF 1111 22 3333", mask: "0000 gggg rr 0000", note: "Any 3 Suits, Any Run",  family: Family.run, concealed: false, points: 25)
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
                
        let p3 = add("111 222 3333 4444", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits, Any 4 Consec Nos",  family: Family.run, concealed: false, points: 25)
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

        let p7 = add("111 2222 333 DDDD", mask: "000 0000 000 0000", note: "Any 1 Suit, Any 3 Consec Nos",  family: Family.run, concealed: false, points: 25)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([d,d,d, d+1,d+1,d+1,d+1, d+2,d+2,d+2, 10,10,10,10])
            p7.add([b,b,b, b+1,b+1,b+1,b+1, b+2,b+2,b+2, 20,20,20,20])
            p7.add([c,c,c, c+1,c+1,c+1,c+1, c+2,c+2,c+2, 30,30,30,30])
        }
        
        let p6 = add("11 22 33 4444 5555", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits, Any 5 Consec Nos",  family: Family.run, concealed: false, points: 30)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p6.add([d,d, d+1,d+1, d+2,d+2, b+3,b+3,b+3,b+3, c+4,c+4,c+4,c+4])
            p6.add([d,d, d+1,d+1, d+2,d+2, c+3,c+3,c+3,c+3, b+4,b+4,b+4,b+4])
            p6.add([b,b, b+1,b+1, b+2,b+2, d+3,d+3,d+3,d+3, c+4,c+4,c+4,c+4])
            p6.add([b,b, b+1,b+1, b+2,b+2, c+3,c+3,c+3,c+3, d+4,d+4,d+4,d+4])
            p6.add([c,c, c+1,c+1, c+2,c+2, d+3,d+3,d+3,d+3, b+4,b+4,b+4,b+4])
            p6.add([c,c, c+1,c+1, c+2,c+2, b+3,b+3,b+3,b+3, d+4,d+4,d+4,d+4])
        }
        
        let p8 = add("FFFF 1 22 333 4444", mask: "0000 0 00 000 0000", note: "Any 1 Suit, Any 4 Consec Nos",  family: Family.run, concealed: false, points: 30)
        for i in 1...6 {
            let d = i
            let b = i+10
            let c = i+20
            p8.add([35,35,35,35, d, d+1,d+1, d+2,d+2,d+2, d+3,d+3,d+3,d+3])
            p8.add([35,35,35,35, b, b+1,b+1, b+2,b+2,b+2, b+3,b+3,b+3,b+3])
            p8.add([35,35,35,35, c, c+1,c+1, c+2,c+2,c+2, c+3,c+3,c+3,c+3])
        }
        
        let p0 = add("111 22 333 DDD DDD (C)", mask: "ggg gg ggg rrr 000", note: "Any 3 Consec Nos, Pungs-Opp Dragons",  family: Family.run, concealed: true, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p0.add([d,d,d, d+1,d+1, d+2,d+2,d+2, 20,20,20, 30,30,30])
            p0.add([b,b,b, b+1,b+1, b+2,b+2,b+2, 10,10,10, 30,30,30])
            p0.add([c,c,c, c+1,c+1, c+2,c+2,c+2, 10,10,10, 20,20,20])
        }
        
        let p9 = add("111 222 111 222 33 (C)", mask: "ggg ggg rrr rrr 00", note: "Any 3 Suits, Any 3 Consec Nos",  family: Family.run, concealed: true, points: 30)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p9.add([d,d,d, d+1,d+1,d+1, b,b,b, b+1,b+1,b+1, c+2,c+2])
            p9.add([d,d,d, d+1,d+1,d+1, c,c,c, c+1,c+1,c+1, b+2,b+2])
            p9.add([b,b,b, b+1,b+1,b+1, c,c,c, c+1,c+1,c+1, d+2,d+2])
        }
    }

    func add13579() {
        let p0 = add("11 33 555 777 9999", mask: "00 00 000 000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p0.add([1,1, 3,3, 5,5,5, 7,7,7, 9,9,9,9])
        p0.add([11,11, 13,13, 15,15,15, 17,17,17, 19,19,19,19])
        p0.add([21,21, 23,23, 25,25,25, 27,27,27, 29,29,29,29])
        
        let p1 = add("11 33 555 777 9999", mask: "gg gg rrr rrr 0000", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        p1.add([1,1, 3,3, 15,15,15, 17,17,17, 29,29,29,29])
        p1.add([1,1, 3,3, 25,25,25, 27,27,27, 19,19,19,19])
        p1.add([11,11, 13,13, 5,5,5, 7,7,7, 29,29,29,29])
        p1.add([11,11, 13,13, 25,25,25, 27,27,27, 9,9,9,9])
        p1.add([21,21, 23,23, 5,5,5, 7,7,7, 19,19,19,19])
        p1.add([21,21, 23,23, 15,15,15, 17,17,17, 9,9,9,9])
 
        let paa = add("FFFF 3333 5555 15", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        let pbb = add("FFFF 5555 7777 35", mask: "0000 gggg rrrr 00", note: "Any 3 Suits",  family: Family.f13579, concealed: false, points: 25)
        paa.generateList()
        pbb.generateList()
        
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
        
        let p8 = add("1111 33 33 33 5555", mask: "0000 gg 00 rr 0000", note: "Any 3 Suits, 1s & 5s Match",  family: Family.f13579, concealed: false, points: 25)
        p8.add([1,1,1,1, 13,13, 3,3, 23,23, 5,5,5,5])
        p8.add([11,11,11,11, 13,13, 3,3, 23,23, 15,15,15,15])
        p8.add([21,21,21,21, 13,13, 3,3, 23,23, 25,25,25,25])

        let p9 = add("5555 77 77 77 9999", mask: "0000 gg 00 rr 0000", note: "Any 3 Suits, 5s & 9s Match",  family: Family.f13579, concealed: false, points: 25)
        p9.add([5,5,5,5, 17,17, 7,7, 27,27, 9,9,9,9])
        p9.add([15,15,15,15, 17,17, 7,7, 27,27, 19,19,19,19])
        p9.add([25,25,25,25, 17,17, 7,7, 27,27, 29,29,29,29])

        let p6 = add("111 3333 555 DDDD", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        let p7 = add("555 7777 999 DDDD", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f13579, concealed: false, points: 25)
        p6.generateList()
        p7.generateList()
        
        let p14 = add("FF 1 33 555 5 77 999 (C)", mask: "00 g gg ggg r rr rrr", note: "Any 2 Suits, These Nos Only",  family: Family.f13579, concealed: true, points: 30)
        p14.generateList()
    }

    func addWindsAndDragons() {
        let p0 = add("NNNN EEE WWW SSSS", mask: "0000 000 000 0000", note: "",  family: Family.winds, concealed: false, points: 25)
        p0.add([31,31,31,31, 34,34,34, 33,33,33, 32,32,32,32])

        let p8 = add("FF DDDD NEWS DDDD", mask: "00 gggg 0000 rrrr", note: "Kongs Any 2 Dragons",  family: Family.winds, concealed: false, points: 25)
        p8.add([35,35, 10,10,10,10, 31,34,33,32, 30,30,30,30])
        p8.add([35,35, 10,10,10,10, 31,34,33,32, 20,20,20,20])
        p8.add([35,35, 20,20,20,20, 31,34,33,32, 30,30,30,30])

        let p4 = add("NNNN 11 11 11 SSSS", mask: "0000 gg 00 rr 0000", note: "Any Like Odd Nos 3 Suits",  family: Family.winds, concealed: false, points: 25)
        for i in 1...9 {
            if i & 1 == 1 {
                let d = i
                let b = i+10
                let c = i+20
                p4.add([31,31,31,31, b,b, d,d, c,c, 32,32,32,32])
            }
        }

        let p5 = add("EEEE 22 22 22 WWWW", mask: "0000 gg 00 rr 0000", note: "Any Like Even Nos 3 Suits",  family: Family.winds, concealed: false, points: 25)
        for i in 1...9 {
            if i & 1 == 0 {
                let d = i
                let b = i+10
                let c = i+20
                p5.add([34,34,34,34, b,b, d,d, c,c, 33,33,33,33])
            }
        }

        let p6 = add("NN EEE DDDD WWW SS", mask: "00 000 0000 000 00", note: "Kong-Any Dragon",  family: Family.winds, concealed: false, points: 25)
        p6.add([31,31, 34,34,34, 10,10,10,10, 33,33,33, 32,32])
        p6.add([31,31, 34,34,34, 20,20,20,20, 33,33,33, 32,32])
        p6.add([31,31, 34,34,34, 30,30,30,30, 33,33,33, 32,32])
        
        let p9 = add("FF NNNN 2020 SSSS", mask: "00 0000 0000 0000", note: "2s Any 1 Suit",  family: Family.winds, concealed: false, points: 25)
        p9.add([35,35, 31,31,31,31, 2,10,2,10, 32,32,32,32])
        p9.add([35,35, 31,31,31,31, 12,10,12,10, 32,32,32,32])
        p9.add([35,35, 31,31,31,31, 22,10,22,10, 32,32,32,32])
        
        let pa = add("FF EEEE 2020 WWWW", mask: "00 0000 0000 0000", note: "2s Any 1 Suit",  family: Family.winds, concealed: false, points: 25)
        pa.add([35,35, 34,34,34,34, 2,10,2,10, 33,33,33,33])
        pa.add([35,35, 34,34,34,34, 12,10,12,10, 33,33,33,33])
        pa.add([35,35, 34,34,34,34, 22,10,22,10, 33,33,33,33])
        
        let p7 = add("FF NNN EEE WWW SSS (C)", mask: "00 000 000 000", note: "",  family: Family.winds, concealed: true, points: 30)
        p7.add([35,35, 31,31,31, 34,34,34, 33,33,33, 32,32,32])
    }

    func add369() {
        let p2 = add("333 666 6666 9999", mask: "ggg ggg rrrr rrrr", note: "Any 2 Suits",  family: Family.f369, concealed: false, points: 25)
        p2.generateList()

        let p1a = add("33 66 99 3333 3333", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        let p1b = add("33 66 99 6666 6666", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        let p1c = add("33 66 99 9999 9999", mask: "gg gg gg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 30)
        p1a.add([3,3, 6,6, 9,9, 13,13,13,13, 23,23,23,23])
        p1a.add([13,13, 16,16, 19,19, 3,3,3,3, 23,23,23,23])
        p1a.add([23,23, 26,26, 29,29, 3,3,3,3, 13,13,13,13])
        p1b.add([3,3, 6,6, 9,9, 16,16,16,16, 26,26,26,26])
        p1b.add([13,13, 16,16, 19,19, 6,6,6,6, 26,26,26,26])
        p1b.add([23,23, 26,26, 29,29, 6,6,6,6, 16,16,16,16])
        p1c.add([3,3, 6,6, 9,9, 19,19,19,19, 29,29,29,29])
        p1c.add([13,13, 16,16, 19,19, 9,9,9,9, 29,29,29,29])
        p1c.add([23,23, 26,26, 29,29, 9,9,9,9, 19,19,19,19])

        let p3 = add("333 6666 999 DDDD", mask: "000 0000 000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        p3.generateList()
        
        let p1 = add("33 666 33 666 9999", mask: "gg ggg rr rrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p1.add([3,3, 6,6,6, 13,13, 16,16,16, 29,29,29,29])
        p1.add([3,3, 6,6,6, 23,23, 26,26,26, 19,19,19,19])
        p1.add([13,13, 16,16,16, 23,23, 26,26,26, 9,9,9,9])

        let p4 = add("FF 3333 6666 9999", mask: "00 0000 0000 0000", note: "Any 1 Suit",  family: Family.f369, concealed: false, points: 25)
        let p5 = add("FF 3333 6666 9999", mask: "00 gggg rrrr 0000", note: "Any 3 Suits",  family: Family.f369, concealed: false, points: 25)
        p4.generateList()
        p5.generateList()
        
        let p7 = add("FF 3 66 999 3 66 999 (C)", mask: "00 g gg ggg r rr rrr", note: "Any 2 Suits",  family: Family.f369, concealed: true, points: 35)
        p7.add([35,35, 3, 6,6, 9,9,9, 13, 16,16, 19,19,19])
        p7.add([35,35, 3, 6,6, 9,9,9, 23, 26,26, 29,29,29])
        p7.add([35,35, 13, 16,16, 19,19,19, 23, 26,26, 29,29,29])
    }

    func addSinglesAndPairs() {
        let p1 = add("NN EE WW SS 11 22 33 (C)", mask: "00 00 00 00 00 00 00", note: "Any 3 Consec Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...7 {
            let d = i
            let b = i+10
            let c = i+20
            p1.add([31,31, 34,34, 33,33, 32,32, d,d, d+1,d+1, d+2,d+2])
            p1.add([31,31, 34,34, 33,33, 32,32, b,b, b+1,b+1, b+2,b+2])
            p1.add([31,31, 34,34, 33,33, 32,32, c,c, c+1,c+1, c+2,c+2])
        }
        
        let p5 = add("FF 11 22 33 44 55 DD (C)", mask: "00 00 00 00 00 00 00", note: "Any 5 Consec Nos",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...5 {
            let d = i
            let b = i+10
            let c = i+20
            p5.add([35,35, d,d, d+1,d+1, d+2,d+2, d+3,d+3, d+4,d+4, 10,10])
            p5.add([35,35, b,b, b+1,b+1, b+2,b+2, b+3,b+3, b+4,b+4, 20,20])
            p5.add([35,35, c,c, c+1,c+1, c+2,c+2, c+3,c+3, c+4,c+4, 30,30])
        }

        let p7 = add("FF 11 22 11 22 11 22 (C)", mask: "00 gg gg rr rr 00 00", note: "Any 3 Suits, Any 3 Consec Pairs",  family: Family.pairs, concealed: true, points: 50)
        for i in 1...8 {
            let d = i
            let b = i+10
            let c = i+20
            p7.add([35,35, d,d, d+1,d+1, b,b, b+1,b+1, c,c, c+1,c+1])
        }
        
        let p2 = add("FF 2468 DD 2468 DD (C)", mask: "00 gggg gg rrrr rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p2.add([35,35, 2,4,6,8, 10,10, 12,14,16,18, 20,20])
        p2.add([35,35, 2,4,6,8, 10,10, 22,24,26,28, 30,30])
        p2.add([35,35, 12,14,16,18, 20,20, 22,24,26,28, 30,30])
        
        let p3 = add("336 33669 336699 (C)", mask: "ggg rrrrr 000000", note: "Any 3 Suits",  family: Family.pairs, concealed: true, points: 50)
        p3.add([3,3,6, 13,13,16,16,19, 23,23,26,26,29,29])
        p3.add([3,3,6, 23,23,26,26,29, 13,13,16,16,19,19])
        p3.add([13,13,16, 3,3,6,6,9, 23,23,26,26,29,29])
        p3.add([13,13,16, 23,23,26,26,29, 3,3,6,6,9,9])
        p3.add([23,23,26, 3,3,6,6,9, 13,13,16,16,19,19])
        p3.add([23,23,26, 13,13,16,16,19, 3,3,6,6,9,9])
        
        let p6 = add("11 3 5 7 99 11 3 5 7 99 (C)", mask: "gg g g g gg rr r r r rr", note: "Any 2 Suits",  family: Family.pairs, concealed: true, points: 50)
        p6.add([1,1, 3,5,7, 9,9, 11,11, 13,15,17, 19,19])
        p6.add([1,1, 3,5,7, 9,9, 21,21, 23,25,27, 29,29])
        p6.add([11,11, 13,15,17, 19,19, 21,21, 23,25,27, 29,29])

        let p8 = add("FF 2020 NEWS 2020 (C)", mask: "00 gggg 0000 rrrr", note: "Any 2 Suits, 2s Match in Each 2020",  family: Family.pairs, concealed: true, points: 60)
        p8.add([35,35, 2,10,2,10, 31,34,33,32, 12,10,12,10])
        p8.add([35,35, 2,10,2,10, 31,34,33,32, 22,10,22,10])
        p8.add([35,35, 12,10,12,10, 31,34,33,32, 22,10,22,10])
    }
    
}

