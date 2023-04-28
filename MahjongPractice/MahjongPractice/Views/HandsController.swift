//
//  HelpTableController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/15/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

class HandsController: NarrowViewController, CardViewDelegate  {

    private var maj: Maj!
    public var cardView = CardView()
    private var filterSegmentControl: UISegmentedControl!
    private var selectSegmentControl: UISegmentedControl!
    private var label: UILabel!
    private var tileViews: [UIView] = []
    private var selectedPattern: LetterPattern!
    var suggestedHand1: LetterPattern!
    var suggestedHand2: LetterPattern!
    var suggestedHandAlt: LetterPattern!
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate) {
        self.maj = maj
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func addControls() {
        maxWidth = 700
        narrowView()
        xOffset = (Int(view.frame.width) - maxWidth) / 2
        
        addFilterSegmentControl()
        addCloseButton()

        cardView.isHidden = false
        cardView.showCard(self, delegate: self, x: 50, y: 70, width: view.frame.width - 50, height: 100, bgcolor: .white, maj: maj)
        view.addSubview(cardView.cardView)
        cardView.update(maj)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Selected Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    func allTiles() -> [Tile] {
        return maj.east.tiles + maj.south.tiles + (maj.east.rack?.tiles)! + (maj.south.rack?.tiles)!
    }
        
    func showSelectedTiles(letterPattern: LetterPattern) {
        selectedPattern = letterPattern
        
        label?.removeFromSuperview()
        let width: CGFloat = 500
        let height: CGFloat = 75
        let labelFrame = CGRect(x: 50, y: 160, width: width, height: height)
        label = UILabel(frame: labelFrame)
        
        let text = NSMutableAttributedString(string: "")
        text.append(letterPattern.text)
        text.append(NSMutableAttributedString(string: "  "))
        text.append(letterPattern.note)
        
        label.attributedText = text
        label.frame = labelFrame
        label.textAlignment = .left
        label.numberOfLines = 0
        view.addSubview(label)
        
        if selectSegmentControl == nil {
            let items = ["Hand1", "Hand2", "Alt"]
            let x = Int(view.frame.width - 220)
            selectSegmentControl = UISegmentedControl(items: items)
            // segmentControl.selectedSegmentIndex =
            selectSegmentControl.frame = CGRect(x: x, y: 185, width: 200, height: Int(selectSegmentControl.frame.height))
            selectSegmentControl.addTarget(self, action: #selector(changeSelect), for: .valueChanged)
            view.addSubview(selectSegmentControl)
        }
        
        let tiles = allTiles()
        var jokerCount = 0
        for tile in tiles {
            if tile.isJoker() {
                jokerCount += 1
            }
        }

        for view in tileViews { view.removeFromSuperview() }
        var y = label.frame.origin.y + 55
        for (index, idlist) in letterPattern.idList.list.enumerated() {
            let idMap = TileIdMap(idlist.ids)
            let count = letterPattern.countMatches(tiles: tiles, map: idMap.map, jokerCount: jokerCount, subId: index)
            if count == letterPattern.matchCount {
                print(idMap.map)
                print(idlist)
                
                var tileIndex = CGFloat(0.0)
                for id in idlist.ids {
                    let x = tileIndex * (tileWidth() + 1.0) + 50
                    let v = UIImageView(frame:CGRect(x: x, y: y, width: tileWidth(), height: tileHeight()))
                    v.contentMode = .scaleAspectFit
                    v.layer.masksToBounds = true
                    v.layer.cornerRadius = tileWidth() / 8
                    v.image = UIImage(named: Tile.getImage(id: id, maj: maj!))
                    view.addSubview(v)
                    tileIndex += 1
                    tileViews.append(v)
                }
                y = y + tileHeight() + 4
            }
        }
    }
    
    @objc private func changeSelect(sender: UISegmentedControl) {
        switch( sender.selectedSegmentIndex ) {
        case 0: suggestedHand1 = selectedPattern
        case 1: suggestedHand2 = selectedPattern
        case 2: suggestedHandAlt = selectedPattern
        default: print("todo changeSelect")
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Clost Button
    //
    // -----------------------------------------------------------------------------------------
     
    override func addCloseButton() {
        let x = view.frame.width - 50
        let closeButton = UIButton(frame: CGRect(x: x, y: 20, width: 30, height: 30))
        let image = UIImage(named: "iconfinder_circle-02_600789.png")
        closeButton.setImage(image, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        view.addSubview(closeButton)
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Filters
    //
    // -----------------------------------------------------------------------------------------
    
    func addFilterSegmentControl() {
        let items = ["2023", "2468", "Like", "Add", "Quints", "Runs", "13579", "W&D", "369", "S&P", "All"]
        filterSegmentControl = UISegmentedControl(items: items)
        filterSegmentControl.selectedSegmentIndex = 10
        filterSegmentControl.frame = CGRect(x: 45, y: 20, width: 580, height: Int(filterSegmentControl.frame.height))
        filterSegmentControl.addTarget(self, action: #selector(changeFilter), for: .valueChanged)
        view.addSubview(filterSegmentControl)
    }
    
    @objc private func changeFilter(sender: UISegmentedControl) {
        switch( sender.selectedSegmentIndex ) {
        case 0: filter(year: false, evens: true, like: true, add: true, quints: true, runs: true, odds: true, winds: true, three: true, pairs: true )
        case 1: filter(year: true, evens: false, like: true, add: true, quints: true, runs: true, odds: true, winds: true, three: true, pairs: true )
        case 2: filter(year: true, evens: true, like: false, add: true, quints: true, runs: true, odds: true, winds: true, three: true, pairs: true )
        case 3: filter(year: true, evens: true, like: true, add: false, quints: true, runs: true, odds: true, winds: true, three: true, pairs: true )
        case 4: filter(year: true, evens: true, like: true, add: true, quints: false, runs: true, odds: true, winds: true, three: true, pairs: true )
        case 5: filter(year: true, evens: true, like: true, add: true, quints: true, runs: false, odds: true, winds: true, three: true, pairs: true )
        case 6: filter(year: true, evens: true, like: true, add: true, quints: true, runs: true, odds: false, winds: true, three: true, pairs: true )
        case 7: filter(year: true, evens: true, like: true, add: true, quints: true, runs: true, odds: true, winds: false, three: true, pairs: true )
        case 8: filter(year: true, evens: true, like: true, add: true, quints: true, runs: true, odds: true, winds: true, three: false, pairs: true )
        case 9: filter(year: true, evens: true, like: true, add: true, quints: true, runs: true, odds: true, winds: true, three: true, pairs: false )
        case 10: filter(year: false, evens: false, like: false, add: false, quints: false, runs: false, odds: false, winds: false, three: false, pairs: false )
        default: print("new filter")
        }
    }
    
    func filter(year: Bool, evens: Bool, like: Bool, add: Bool, quints: Bool, runs: Bool, odds: Bool, winds: Bool, three: Bool, pairs: Bool) {
        maj.east.filterOutYears = year
        maj.east.filterOut2468 = evens
        maj.east.filterOutLikeNumbers = like
        maj.east.filterOutAdditionHands = add
        maj.east.filterOutQuints = quints
        maj.east.filterOutRuns = runs
        maj.east.filterOut13579 = odds
        maj.east.filterOutWinds = winds
        maj.east.filterOut369 = three
        maj.east.filterOutPairs = pairs
        cardView.filter(maj)
        cardView.update(maj)
    }
    
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tile Sizes
    //
    // -----------------------------------------------------------------------------------------

    func tileWidth() -> CGFloat {
        return view.frame.width / 28
    }
    
    func tileHeight() -> CGFloat {
        return tileWidth() * 62.5 / 46.0
    }
    
}
