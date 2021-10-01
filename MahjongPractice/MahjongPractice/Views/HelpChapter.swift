//
//  HelpChapter.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/15/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

class HelpChapter: UIView {
    var expanded = false
    
    private var width = 650
    private var xOffset = 20
    private var yOffset = 10
    private var tileHeight = Int(72 * 0.8)
    private var tileWidth = Int(54 * 0.8)
    private var body: UIView = UIView()
        
    
    // -----------------------------------------------------------------------------------------
    //
    //  Init
    //
    // -----------------------------------------------------------------------------------------
    
    init(_ title : String, xOffset: Int, width: CGFloat) {
        self.width = Int(width)
        super.init(frame: CGRect(x: 0, y: 0, width: self.width, height: 0))
        addTitle(title)
    }
    
    init(_ title : String, xOffset: Int, yOffset: Int, width: CGFloat) {
        self.width = Int(width)
        self.yOffset = yOffset
        super.init(frame: CGRect(x: 0, y: 0, width: self.width, height: 0))
        addTitle(title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    
    // -----------------------------------------------------------------------------------------
    //
    //  Title
    //
    // -----------------------------------------------------------------------------------------
            
    func addTitle(_ text: String) {
        let label = UILabel()
        label.frame = CGRect(x: xOffset, y: yOffset, width: width - (xOffset * 2) - 200, height: 25)
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = text
        expandFrame(CGFloat(yOffset) + label.frame.height)
        expandBody(CGFloat(yOffset) + label.frame.height)
        addSubview(label)
        tag = 999
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Body
    //
    // -----------------------------------------------------------------------------------------
    
    func addLabel(_ text: String) {
        let width = Int(Double(self.width) * 0.7)
        let label = UITextView(frame: CGRect(x: xOffset, y: Int(body.frame.height), width: width, height: 21))
        label.text = text
        label.isScrollEnabled = false
        label.isEditable = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        expandBody(label.frame.height)
        body.addSubview(label)
    }
    
    func addLabelItalic(_ text: String) {
        let width = Int(Double(self.width) * 0.7)
        let label = UITextView(frame: CGRect(x: xOffset, y: Int(body.frame.height), width: width, height: 21))
        label.text = text
        label.isScrollEnabled = false
        label.isEditable = false
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.sizeToFit()
        expandBody(label.frame.height)
        body.addSubview(label)
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Add Images
    //
    // -----------------------------------------------------------------------------------------
    
    func addScreenShot(_ named: String) {
        let width = Int(Double(self.width) * 0.7)
        let height = Int(Double(width * 1170 / 2532))
        let v = UIImageView(frame:CGRect(x: xOffset, y: Int(body.frame.height) + 10, width: width, height: height))
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 10
        v.image = UIImage(named: named)
        expandBody(v.frame.height + 10)
        body.addSubview(v)
    }
    
    func addTile(_ named: String, index: Int) {
        let x = xOffset + (index * tileWidth) + 5
        let tile = UIImageView(frame:CGRect(x: x, y: Int(body.frame.height), width: tileWidth, height: tileHeight))
        tile.contentMode = .scaleAspectFit
        tile.layer.masksToBounds = true
        tile.layer.cornerRadius = CGFloat(tileWidth / 8)
        tile.image = UIImage(named: named)
        body.addSubview(tile)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Expand and Collapse
    //
    // -----------------------------------------------------------------------------------------
    
    @objc func expand() {
        addSubview(body)
        expandFrame(body.frame.height - frame.height)
        expanded = true
    }
    
    func collapse() {
        body.removeFromSuperview()
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: CGFloat(yOffset + 25))
        expanded = false
    }
    
    func getHeight() -> CGFloat {
        return frame.height + 10
    }
    
    private func expandFrame(_ height: CGFloat) {
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.height + height)
    }
    
    func expandBody(_ height: CGFloat) {
        body.frame = CGRect(x: body.frame.origin.x, y: body.frame.origin.y, width: body.frame.width, height: body.frame.height + height)
    }
    
    func expandBodyTileHeight() {
        expandBody(CGFloat(tileHeight))
    }
    
    
}
