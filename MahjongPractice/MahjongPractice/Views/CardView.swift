//
//  CardView.swift
//  Mahjong2017
//
//  Created by Ray on 8/15/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import UIKit

protocol CardViewDelegate {
    // func showSelectedTiles(letterPattern: LetterPattern)
}

class CardView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cardView: UITableView  = UITableView()
    var maj: Maj!
    var columnWidth: CGFloat = 0
    var location: CGFloat = 0
    var lp: UILongPressGestureRecognizer! = nil
    let cellHeight: CGFloat = 20.0
    var root: UIViewController!
    var maxRows = 5
    var isHidden = true
    let darkBamboo:UIColor = UIColor(red: 114/255, green: 123/255, blue: 102/255, alpha: 1.0)
    var cardViewDelegate: CardViewDelegate!
    var hand: [Tile] = []
    
    func showCard(_ rootView: UIViewController, delegate: CardViewDelegate, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, bgcolor: UIColor, maj: Maj) {
        self.maj = maj
        if location != y {
            location = y
            var cardHeight = height
            let maxHeight = CGFloat(maxRows) * cellHeight
            if cardHeight > maxHeight {
                cardHeight = maxHeight
            }
            cardView.frame         =   CGRect(x: x, y: y, width: width, height: cardHeight);
            cardView.delegate      =   self
            cardView.dataSource    =   self
            cardView.register(UITableViewCell.self, forCellReuseIdentifier: "cardViewCell")
            cardView.backgroundColor = UIColor.clear
            cardView.separatorColor = UIColor.clear
            columnWidth = width / 3.0
            root = rootView
            cardViewDelegate = delegate
        }
        filter(maj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        let title = "Error: 701 PatternView MemoryWarning"
        let message = "Contact support@eightbam.com"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: true, completion: nil)
    }

    func allTiles(_ maj: Maj) -> [Tile] {
        return maj.east.tiles + maj.south.tiles + (maj.east.rack?.tiles)! + (maj.south.rack?.tiles)!
    }
    
    func update(_ maj: Maj, tiles: [Tile]) {
        if isHidden == false {
            self.maj = maj
            self.hand = tiles
            maj.card.match(hand, ignoreFilters: false)
            sort(maj)
            cardView.reloadData()
        }
    }
        
    func sort(_ maj: Maj) {
        if maj.east.tileMatches.stopSorting == false {
            maj.card.letterPatterns.sort(by: { $0.matchCount == $1.matchCount ? $0.id < $1.id : $0.matchCount > $1.matchCount} )
        }
    }
    
    func filter(_ maj: Maj) {
        for p in maj.card.letterPatterns {
            switch p.family {
            case Family.year: p.filterOut = maj.east.filterOutYears
            case Family.f2468: p.filterOut = maj.east.filterOut2468
            case Family.likeNumbers: p.filterOut = maj.east.filterOutLikeNumbers
            case Family.addition: p.filterOut = maj.east.filterOutAdditionHands
            case Family.quints: p.filterOut = maj.east.filterOutQuints
            case Family.run: p.filterOut = maj.east.filterOutRuns
            case Family.f13579: p.filterOut = maj.east.filterOut13579
            case Family.winds: p.filterOut = maj.east.filterOutWinds
            case Family.f369: p.filterOut = maj.east.filterOut369
            case Family.pairs: p.filterOut = maj.east.filterOutPairs
            default: p.filterOut = false
            }
            if maj.east.filterOutConcealed && p.concealed {
                p.filterOut = true
            }
            let count = maj.east.rack?.tiles.count
            if (count! > 0) && (count! < 14) && p.concealed {
                p.filterOut = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for p in maj.card.letterPatterns {
            if p.matchCount > 0 {
                count+=1
            }
        }
        if count > maxRows {
            count = maxRows
        }
        if maj.isGameOver() {
            count = 0
        }
        
        if maj.east.filterOutYears && maj.east.filterOut2468 {
            for lp in maj.card.letterPatterns {
                if lp.selected == true {
                    count += 1
                }
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allFiltersAreOn() {
            let pattern = getSelectedPattern(indexPath.row)
            pattern.selected = !pattern.selected
        } else {
            let pattern = maj.card.letterPatterns[indexPath.row]
            pattern.selected = !pattern.selected
        }
        cardView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cardViewCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        cell.textLabel!.font = cell.textLabel!.font.withSize(16)
        
        let index = indexPath.row
        
        // column 1 patterns
        let col1 = getLabel(cell, x: 0, width: col1Width(), tag: 1)
        col1?.attributedText = allFiltersAreOn() ? getSelectedPattern(index).getDarkModeString() : maj.card.text(index)
        
        // column 2 notes
        let col2 = getLabel(cell, x: col1Width(), width: col2Width(), tag: 2)
        col2?.attributedText = allFiltersAreOn() ? getSelectedPattern(index).note : maj.card.note(index)
        
        // column 3 matching tiles
        let col3 = getLabel(cell, x: col1Width() + col2Width() + 5, width: col3Width(), tag: 3)
        if allFiltersAreOn() {
            col3?.text = maj.card.matchCountText(getSelectedPattern(index).id).string   // todo
        } else {
            col3?.text = maj.card.matchCountText(index).string
        }
           
        let selected = allFiltersAreOn() ? getSelectedPattern(index).selected : maj.card.letterPatterns[index].selected
        if selected {
            cell.accessoryType = .checkmark
            // cell.tintColor = .darkGray
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
        
    func allFiltersAreOn() -> Bool {
        return maj.east.filterOutYears && maj.east.filterOut2468 && maj.east.filterOutLikeNumbers && maj.east.filterOutAdditionHands && maj.east.filterOutQuints && maj.east.filterOutRuns && maj.east.filterOut13579 && maj.east.filterOutWinds && maj.east.filterOut369 && maj.east.filterOutPairs
    }
    
    func getSelectedPattern(_ index: Int) -> LetterPattern {
        var count = 0
        for lp in maj.card.letterPatterns {
            if lp.selected == true {
                if count == index {
                    return lp
                }
                count += 1
            }
        }
        return maj.card.letterPatterns[0]
    }
        
    func width() -> CGFloat {
        return cardView.frame.width
    }
    
    func isNarrow() -> Bool {
        return cardView.frame.width < 600
    }
    
    func col1Width() -> CGFloat {
        let col1 = isNarrow() ? 200 : width() * 0.32
        return col1 > 300 ? 300 : col1
    }
    
    func col2Width() -> CGFloat {
        let col2 = isNarrow() ? 190 : width() * 0.33
        return col2 > 300 ? 300 : col2
    }
    
    func col3Width() -> CGFloat {
        let col3 = isNarrow() ? 60 : width() * 0.15
        return col3 > 100 ? 100 : col3
    }
    
    func col4Width() -> CGFloat {
        let col4 = isNarrow() ? 110 : width() * 0.16
        return col4 > 110 ? 110 : col4
    }
    
    func hideButtonWidth() -> CGFloat {
        let button = isNarrow() ? 60 : width() * 0.10
        return button > 100 ? 100 : button
    }
    
    func getLabel(_ cell: UITableViewCell, x: CGFloat, width: CGFloat, tag: Int) -> UILabel? {
        var label = UILabel()
        var found = false
        for v in cell.subviews {
            if v.tag == tag {
                label = v as! UILabel
                found = true
                break
            }
        }
        if found == false {
            label.frame = CGRect(x: x, y: 0, width: width, height: rowHeight())
            label.font = label.font.withSize(16)
            label.tag = tag
            cell.addSubview(label)
        }
        return label
    }

    func addHideButton(_ cell: UITableViewCell, x: CGFloat, width: CGFloat, tag: Int) {
        var found = false
        for v in cell.subviews {
            if v.tag >= 100 {
                v.tag = tag
                found = true
                break
            }
        }
        if found == false {
            let button = UIButton()
            button.frame = CGRect(x: x, y: 0, width: width, height: rowHeight())
            button.tag = tag
            button.setTitle("[hide]", for: .normal)
            button.setTitleColor(UIColor.darkGray, for: .normal)
            button.addTarget(self, action: #selector(CardView.hideButton), for: .touchUpInside)
            cell.addSubview(button)
        }
    }
    
    @objc func hideButton(_ sender: UIView) {
        if maj.east.tileMatches.stopSorting == true {
            let alert = UIAlertController(title: "Sorting is off", message: "You cannot hide patterns when sorting is off", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil));
            root.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Hide this pattern for this game", message: maj.card.text(sender.tag-100).string, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Hide", style: .default, handler: {(action:UIAlertAction) in
                self.maj.card.hidePattern(sender.tag-100)
                self.update(self.maj, tiles: self.hand)
            }));
            
            alert.addAction(UIAlertAction(title: "Unhide All", style: .default, handler: {(action:UIAlertAction) in
                self.maj.card.unhideAll()
                self.update(self.maj, tiles: self.hand)
            }));
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil));
            root.present(alert, animated: true, completion: nil)
        }
    }
    
    func rowHeight() -> CGFloat  {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
