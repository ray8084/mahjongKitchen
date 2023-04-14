//
//  DiscardTable.swift
//  Mahjong2017
//
//  Created by Ray on 12/7/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import UIKit

class DiscardTableView {
    var parent = UIView()
    
    let gap = 18
    var rowHeader: CGFloat = 0
    let rowHeight: CGFloat = 18
    var offset: CGFloat = 20
    
    var tableLabels: [UILabel] = []
    var jokerView = UIView()
    var flowerView = UIView()
    var wndView = [UIView(), UIView(), UIView(), UIView()]
    var dotView = [UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView()]
    var bamView = [UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView()]
    var crakView = [UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView(), UIView()]
    var wallCountView = UIView()
    
    var isHidden = true
    let red = UIColor.red
    let green = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
    
    //
    // Init
    //
    
    init() {
    }
  
    func row1() -> CGFloat {
        return rowHeader + rowHeight
    }
    
    func row2() -> CGFloat {
        return row1() + rowHeight
    }
    
    func row3() -> CGFloat {
        return row2() + rowHeight
    }
    
    func clearTableLabels() {
        for label in tableLabels {
            label.removeFromSuperview()
        }
        tableLabels = []
    }
  
    func hide() {
        clearTableLabels()
        for view in dotView {
            view.removeFromSuperview()
        }
        for view in bamView {
            view.removeFromSuperview()
        }
        for view in crakView {
            view.removeFromSuperview()
        }
        for view in wndView {
            view.removeFromSuperview()
        }
        jokerView.removeFromSuperview()
        flowerView.removeFromSuperview()
    }
    
    func showText(_ x: CGFloat, y: CGFloat, text: String, alignment: NSTextAlignment) -> UILabel {
        return showTextColor(x, y:y, text: text, alignment: alignment, color: UIColor.black)
    }
    
    func showTextColor(_ x: CGFloat, y: CGFloat, text: String, alignment: NSTextAlignment, color: UIColor) -> UILabel {
        let frame = CGRect(x: x, y: y, width: 50, height: 18)
        let label = UILabel(frame: frame)
        label.text = text
        label.frame = frame
        label.textAlignment = alignment
        label.textColor = color
        parent.addSubview(label)
        tableLabels.append(label)
        return label
    }
    
    func showTextWide(_ x: CGFloat, y: CGFloat, text: String, alignment: NSTextAlignment) -> UILabel {
        let frame = CGRect(x: x, y: y, width: 170, height: 18)
        let label = UILabel(frame: frame)
        label.text = text
        label.frame = frame
        label.textAlignment = alignment
        label.font = UIFont(name: "Chalkduster", size: 15)
        label.textColor = UIColor.black
        parent.addSubview(label)
        tableLabels.append(label)
        return label
    }
    
    func show(parent: UIView, rowHeader: CGFloat, maj: Maj, margin: CGFloat) {
        offset = margin
        self.parent = parent
        self.rowHeader = rowHeader
        clearTableLabels()
        for i in 1...9 {
            let _ = showText(CGFloat((i+1)*gap)+offset, y: rowHeader, text: "\(i)", alignment: .center)
        }
        let _ = showText(offset+15, y: row1(), text: "Dot", alignment: .left)
        let _ = showText(offset+15, y: row2(), text: "Bam", alignment: .left)
        let _ = showText(offset+15, y: row3(), text: "Crak", alignment: .left)
        let _ = showText(CGFloat(11*gap)+offset, y: rowHeader, text: "D", alignment: .center)
        let _ = showText(CGFloat(13*gap)+offset, y: row1(), text: "Wind", alignment: .right)
        let _ = showText(CGFloat(13*gap)+offset, y: row2(), text: "Joker", alignment: .right)
        let _ = showText(CGFloat(13*gap)+offset, y: row3(), text: "Flwr", alignment: .right)
        let _ = showText(CGFloat(15*gap)+offset, y: rowHeader, text: "N", alignment: .center)
        let _ = showText(CGFloat(16*gap)+offset, y: rowHeader, text: "S", alignment: .center)
        let _ = showText(CGFloat(17*gap)+offset, y: rowHeader, text: "W", alignment: .center)
        let _ = showText(CGFloat(18*gap)+offset, y: rowHeader, text: "E", alignment: .center)
        let _ = showText(CGFloat(20*gap)+offset, y: rowHeader, text: "Wall", alignment: .right)
        showCounts(maj: maj)
    }
    
    func showCounts(maj: Maj) {
        for i in 0...9 {
            if( maj.discardTable.dotCount[i] > 0 ) {
                dotView[i].removeFromSuperview()
                let v = showText(CGFloat((i+2)*gap)+offset, y: row1(), text: "\(maj.discardTable.dotCount[i])", alignment: .center)
                dotView[i] = v
            }
            if( maj.discardTable.bamCount[i] > 0 ) {
                bamView[i].removeFromSuperview()
                let v = showTextColor(CGFloat((i+2)*gap)+offset, y: row2(), text: "\(maj.discardTable.bamCount[i])", alignment: .center, color: green)
                bamView[i] = v
            }
            if( maj.discardTable.crakCount[i] > 0 ) {
                crakView[i].removeFromSuperview()
                let v = showTextColor(CGFloat((i+2)*gap)+offset, y: row3(), text: "\(maj.discardTable.crakCount[i])", alignment: .center, color: red)
                crakView[i] = v
            }
        }
        showWinds(maj: maj)
        showJokerCount(maj: maj)
        showFlowerCount(maj: maj)
        showWallCount(maj: maj)
    }
    
    private func showWinds(maj: Maj) {
        for i in 0...3 {
            if( maj.discardTable.wndCount[i] > 0) {
                wndView[i].removeFromSuperview()
                let v = showText(CGFloat((i+1+14)*gap)+offset, y: row1(), text: "\(maj.discardTable.wndCount[i])", alignment: .center)
                wndView[i] = v
            }
        }
    }
    
    private func showJokerCount(maj: Maj) {
        if maj.discardTable.jokerCount > 0 {
            jokerView.removeFromSuperview()
            let v = showText(CGFloat(15*gap)+offset, y: row2(), text: "\(maj.discardTable.jokerCount)", alignment: .center)
            jokerView = v
        }
    }
    
    private func showFlowerCount(maj: Maj) {
        if maj.discardTable.flowerCount > 0 {
            flowerView.removeFromSuperview()
            let v = showText(CGFloat(15*gap)+offset, y: row3(), text: "\(maj.discardTable.flowerCount)", alignment: .center)
            flowerView = v
        }
    }
    
    func countTile(_ tile: Tile, increment: Int, maj: Maj) {
        switch tile.suit {
        case "dot":
            let index = tile.number - 1
            let count = maj.discardTable.dotCount[index] + increment
            maj.discardTable.dotCount[index] = count
            dotView[index].removeFromSuperview()
            if (maj.discardTable.dotCount[index] > 0) && (isHidden == false) {
                let v = showText(CGFloat((tile.number+1)*gap)+offset, y: row1(), text: "\(count)", alignment: .center)
                dotView[index] = v
            }
            break
        case "bam":
            let index = tile.number - 1
            let count = maj.discardTable.bamCount[index] + increment
            maj.discardTable.bamCount[index] = count
            bamView[index].removeFromSuperview()
            if (maj.discardTable.bamCount[index] > 0) && (isHidden == false) {
                let v = showText(CGFloat((tile.number+1)*gap)+offset, y: row2(), text: "\(count)", alignment: .center)
                bamView[index] = v
            }
            break
        case "crak":
            let index = tile.number - 1
            let count = maj.discardTable.crakCount[index] + increment
            maj.discardTable.crakCount[index] = count
            crakView[index].removeFromSuperview()
            if (maj.discardTable.crakCount[index] > 0) && (isHidden == false) {
                let v = showText(CGFloat((tile.number+1)*gap)+offset, y: row3(), text: "\(count)", alignment: .center)
                crakView[index] = v
            }
            break
        case "wnd":
            let index = tile.number - 1
            let count = maj.discardTable.wndCount[index] + increment
            maj.discardTable.wndCount[index] = count
            wndView[index].removeFromSuperview()
            if (maj.discardTable.wndCount[index] > 0) && (isHidden == false) {
                let v = showText(CGFloat((tile.number+14)*gap)+offset, y: row1(), text: "\(count)", alignment: .center)
                wndView[index] = v
            }
            break
        case "jkr":
            maj.discardTable.jokerCount += increment
            jokerView.removeFromSuperview()
            if (maj.discardTable.jokerCount > 0) && (isHidden == false) {
                let v = showText(CGFloat(15*gap)+offset, y: row2(), text: "\(maj.discardTable.jokerCount)", alignment: .center)
                jokerView = v
            }
            break
        case "flwr":
            maj.discardTable.flowerCount += increment
            flowerView.removeFromSuperview()
            if (maj.discardTable.flowerCount > 0) && (isHidden == false) {
                let v = showText(CGFloat(15*gap)+offset, y: row3(), text: "\(maj.discardTable.flowerCount)", alignment: .center)
                flowerView = v
            }
            break
        default:
            break
        }
        showWallCount(maj: maj)
        let totalCount = maj.wall.tiles.count + maj.discardTable.getCount()
        print(totalCount)
    }
    
    func showWallCount(maj: Maj) {
        let wallCount =  maj.wall.tiles.count
        wallCountView.removeFromSuperview()
        let v = showText(CGFloat(20*gap)+offset, y: row1(), text: "\(wallCount)", alignment: .right)
        wallCountView = v
        
        //print("TotalCount \(wallCount) + \(maj.discardTable.getCount()) = \(wallCount + maj.discardTable.getCount())")
    }
    
}
