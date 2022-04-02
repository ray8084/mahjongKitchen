//
//  ValidationView.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 4/9/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

protocol ValidationViewDelegate {
    func closeValidationView()
}

class ValidationView: UIScrollView {
    var y: CGFloat = 0
    let top: CGFloat = 20
    let leftMargin: CGFloat = 20
    var okButtonLocation: CGFloat = 0
    let labelHeight: CGFloat = 21
    let margin: CGFloat = 5
    let space: CGFloat = 1
    var views: [UIView] = []
    var parent: UIView!
    var closeButton: UIButton!
    var validationDelegate: ValidationViewDelegate!
    
    func show(_ parent: UIView, maj: Maj, delegate: ValidationViewDelegate) {
        self.parent = parent
        self.backgroundColor = parent.backgroundColor
        self.validationDelegate = delegate
        isHidden = false
        isScrollEnabled = true
        frame = CGRect(x: 0, y: 0, width: parent.frame.width, height: parent.frame.height);
        parent.bringSubviewToFront(self)
         
        removeViews()
        y = top
        addLabelLarge("Pattern unknown")
        addTiles(maj.east.rack!, maj: maj)
        y += margin * 3
        let match = findTopMatch( maj )
        let pattern = findPattern( maj, id: match.letterPatternId )
        addLabelAttributed( getClosestPatternString(pattern) )
        addMatchingTiles( match, maj: maj )
        y += margin * 3
        addLabelLarge("FAQ")
        var tips = "Jokers\nJokers can only be used in 3,4,5 or 6 of the same kind of tile. Jokers can not be used in Singles & Pairs including 2022 and NEWS."
        tips += "\n\nSuits\nSuit counts must be correct. If a pattern says Any 3 Suits, all 3 suits must be used."
        tips += "\n\nDragons\nRed Dragons match the Crak suit. Green Dragons match the Bam suit. Soaps match the Dot suit. Dragons suits must follow the rules for each pattern."
        tips += "\n\nOneBam\nOneBam is a bird on bamboo in the classic tile set we use. It looks like an owl."
        tips += "\n\nFlowers\nWe use 8 different flower tiles. All flower tiles are interchangable. See Help for images."
        tips += "\n\nTile Order\nTile order does not matter. We will sort them for you. However problems are easier to see with tiles in order."
        addWrappingLabel(tips)
        addLabel("\n")
        addLabel("Email support@eightbam.com with a screen shot for help")
        contentSize = CGSize( width: parent.frame.width, height: y + 50 )
        parent.addSubview(self)
        addCloseButton()
        
    }
    
    func removeViews() {
        for v in views {v.removeFromSuperview()}
        views = []
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Close Button
    //
    // -----------------------------------------------------------------------------------------
     
    func addCloseButton() {
        let x = parent.frame.origin.x + parent.frame.width - 50
        let y = parent.frame.origin.y + parent.frame.height - 50
        closeButton = UIButton(frame: CGRect(x: x, y: y, width: 30, height: 30))
        let image = UIImage(named: "iconfinder_circle-02_600789.png")
        closeButton.setImage(image, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        parent.addSubview(closeButton)
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
        validationDelegate.closeValidationView()
    }
    

    // -----------------------------------------------------------------------------------------
    //
    //  Best Match
    //
    // -----------------------------------------------------------------------------------------
    
    func findTopMatch(_ maj: Maj) -> TileMatchItem {
        maj.east.tileMatches.countMatchesForEastNoFilters(maj)
        maj.east.tileMatches.sort()
        return maj.east.tileMatches.list[0]
    }
    
    func findPattern(_ maj: Maj, id: Int) -> LetterPattern {
        var topPattern = maj.card.letterPatterns[0]
        for lp in maj.card.letterPatterns {
            if lp.id == id {
                topPattern = lp
                break
            }
        }
        return topPattern
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Labels
    //
    // -----------------------------------------------------------------------------------------
   
    func addLabel(_ text: String) {
        let x = margin + notch()
        let width = frame.width - x - margin
        let label = UILabel(frame: CGRect(x: x, y: y, width: width - 100, height: labelHeight))
        label.text = text
        label.textColor = UIColor.black
        addSubview(label)
        views.append(label)
        y += label.frame.height + margin
    }
    
    func addLabelLarge(_ text: String) {
        let x = margin + notch()
        let width = frame.width - x - margin
        let label = UILabel(frame: CGRect(x: x, y: y, width: width - 100, height: labelHeight))
        label.text = text
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20.0)
        addSubview(label)
        views.append(label)
        y += label.frame.height + margin
    }
    
    func addLabelCentered(_ text: String) {
        let x = margin + notch()
        let width = frame.width - x - margin
        let label = UILabel(frame: CGRect(x: x, y: y, width: width - 100, height: labelHeight))
        label.text = text
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.center
        addSubview(label)
        views.append(label)
        y += label.frame.height + margin
    }
    
    func addLabelAttributed(_ text: NSAttributedString) {
        let x = margin + notch()
        let width = frame.width - x - margin
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: labelHeight))
        label.attributedText = text
        addSubview(label)
        views.append(label)
        y += label.frame.height + margin
    }
    
    func getClosestPatternString(_ pattern: LetterPattern) -> NSAttributedString {
        let closestPattern: NSMutableAttributedString = NSMutableAttributedString()
        let title = NSAttributedString(string: "Best match ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0), NSAttributedString.Key.foregroundColor: UIColor.black])
        closestPattern.append( title )
        closestPattern.append( pattern.text )
        closestPattern.append( NSAttributedString(string: " ") )
        pattern.note.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: pattern.note.string.count))
        closestPattern.append( pattern.note )
        return closestPattern
    }
    
    func addWrappingLabel(_ text: String) {
        let x = margin + notch()
        let width = frame.width - x - margin - 100
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.black
        label.numberOfLines = 0
        let maximumLabelSize: CGSize = CGSize(width: width, height: 9999)
        let expectedLabelSize: CGSize = label.sizeThatFits(maximumLabelSize)
        var newFrame: CGRect = label.frame
        newFrame.origin.x = x
        newFrame.origin.y = y
        newFrame.size.width = width
        newFrame.size.height = expectedLabelSize.height
        label.frame = newFrame
        addSubview(label)
        views.append(label)
        y += label.frame.size.height
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    func addTiles(_ hand: Hand, maj: Maj) {
        for (index, tile) in hand.tiles.enumerated() {
            let x = CGFloat(index) * (tileWidth() + space) + margin + notch()
            let v = UIImageView(frame:CGRect(x: x, y: y, width: tileWidth(), height: tileHeight()))
            v.contentMode = .scaleAspectFit
            v.layer.masksToBounds = true
            v.layer.cornerRadius = tileWidth() / 8
            v.image = UIImage(named: tile.getImage(maj: maj))
            v.isUserInteractionEnabled = false
            addSubview(v)
            views.append(v)
        }
        y += tileHeight() + margin
    }
     
    func addMatchingTiles(_ match: TileMatchItem, maj: Maj) {
        for (index, id) in match.tileIds.enumerated() {
            let x = CGFloat(index) * (tileWidth() + space) + margin + notch()
            let v = UIImageView(frame:CGRect(x: x, y: y, width: tileWidth(), height: tileHeight()))
            v.contentMode = .scaleAspectFit
            v.layer.masksToBounds = true
            v.layer.cornerRadius = tileWidth() / 8
            v.image = UIImage(named: Tile.getImage(id: id, maj: maj))
            addSubview(v)
            views.append(v)
        }
        y += tileHeight() + margin
    }
        
    func tileWidth() -> CGFloat {
        return (frame.width - notch()) / 14.5
    }
    
    func tileHeight() -> CGFloat {
        return tileWidth() * 62.5 / 46.0
    }
    
    func notch() -> CGFloat {
        var notch = leftMargin
        if #available(iOS 11.0, *) {
            notch = UIApplication.shared.keyWindow?.safeAreaInsets.left ?? leftMargin
        }
        return notch
    }
    
}
