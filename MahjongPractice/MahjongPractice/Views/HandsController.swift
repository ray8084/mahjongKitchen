//
//  HelpTableController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/15/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

protocol HandsControllerDelegate {
    func showSuggestedHands()
}

class HandsController: NarrowViewController, CardViewDelegate  {

    private var maj: Maj!
    public var cardView = CardView()
    private var filterSegmentControl: UISegmentedControl!
    private var selectSegmentControl: UISegmentedControl!
    private var label: UILabel!
    private var yourHandLabel: UILabel!
    private var tileViews: [UIView] = []
    private var yourTileViews: [UIView] = []
    private var filterButton: UIButton!
    private var remainingTiles: [Tile] = []
    
    private var selectedPattern: LetterPattern!
    var suggestedHandA: LetterPattern!
    var suggestedHandB: LetterPattern!
    var suggestedHandC: LetterPattern!
    var handsControllerDelegate: HandsControllerDelegate
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate, handsControllerDelegate: HandsControllerDelegate) {
        self.maj = maj
        self.handsControllerDelegate = handsControllerDelegate
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
        view.backgroundColor = UIColor.init(red: 185.0/255.0, green: 190.0/255.0, blue: 183.0/255.0, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func addControls() {
        maxWidth = 700
        narrowView()
        xOffset = (Int(view.frame.width) - maxWidth) / 2
        
        showYourTiles()
        addFilterSegmentControl()

        let x = view.frame.width < 668 || view.frame.height > 650 ? 15.0 : 50.0
        var y = tileHeight() * 2 + 30 + 50
        cardView.isHidden = false
        cardView.showCard(self, delegate: self, x: x, y: y, width: view.frame.width - 50, height: 100, bgcolor: .white, maj: maj)
        view.addSubview(cardView.cardView)
        let allTiles = maj.east.tiles + maj.south.tiles + (maj.east.rack?.tiles)! + (maj.south.rack?.tiles)!
        cardView.update(maj, tiles: allTiles )
        cardView.cardView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .bottom)
        
        y = y + 100
        let frame = CGRect(x: x, y: y, width: 600, height: 50)
        let note = UILabel(frame: frame)
        note.text =  "Select up to 3 hands to see under your tiles while you are playing."
        note.frame = frame
        note.textAlignment = .left
        note.font = UIFont(name: "Chalkduster", size: 15)
        note.numberOfLines = 0
        view.addSubview(note)
                
        // showSelectedTiles(letterPattern: maj.card.letterPatterns[0])
        addCloseButton()
    }
    
    func clear() {
        suggestedHandA = nil
        suggestedHandB = nil
        suggestedHandC = nil
        selectSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Your Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    func showYourTiles() {
        let height = tileHeight()
        let width = tileWidth()
        for v in yourTileViews { v.removeFromSuperview() }
        let offset = view.frame.width < 668 || view.frame.height > 650 ? 10.0 : 50.0
        let tiles = allTiles()
        for (index, tile) in tiles.enumerated() {
            let x = CGFloat(index < 14 ? index : index - 14) * (width + 1.0) + offset
            let y = index < 14 ? 10.0 : 10.0 + height
            let v = UIImageView(frame:CGRect(x: x, y: y, width: width, height: height))
            v.contentMode = .scaleAspectFit
            v.layer.masksToBounds = true
            v.layer.cornerRadius = width / 8
            v.image = UIImage(named: Tile.getImage(id: tile.id, maj: maj!))
            view.addSubview(v)
            yourTileViews.append(v)
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Filter Button
    //
    // -----------------------------------------------------------------------------------------
    
    func addFilterButton() {
        if filterButton == nil {
            filterButton = UIButton()
            filterButton.frame = CGRect(x: 50, y: 30,  width: 55, height: 25)
            filterButton.layer.cornerRadius = 5
            filterButton.backgroundColor = .white
            filterButton.setTitleColor(.black, for: .normal)
            filterButton.setTitle("Filter", for: .normal)
            filterButton.titleLabel!.font = UIFont.systemFont(ofSize: 14)
            filterButton.addTarget(self, action: #selector(filterButtonAction), for: .touchUpInside)
            view.addSubview(filterButton)
        }
    }
    
    @objc func filterButtonAction(sender: UIButton!) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Filter out Hand1", style: .default, handler: {(action:UIAlertAction) in
            self.filterOutHand1()
        }));
        
        alert.addAction(UIAlertAction(title: "Filter out Hand2", style: .default, handler: {(action:UIAlertAction) in
            //self.sortNumbers()
        }));
        
        alert.addAction(UIAlertAction(title: "Filter out Alternate Hand", style: .default, handler: {(action:UIAlertAction) in
            //self.sortOddEven()
        }));
                
        alert.addAction(UIAlertAction(title: "Clear Filters", style: .default, handler: {(action:UIAlertAction) in
            self.remainingTiles = self.allTiles()
            self.showYourTiles()
            self.cardView.update(self.maj, tiles: self.allTiles())
        }));
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
    func filterOutHand1() {
        if suggestedHandA != nil {
            let height = tileHeight() * 1.2
            let width = tileWidth() * 1.2
            for v in self.yourTileViews { v.removeFromSuperview() }
            let tiles = allTiles()
            let jokerCount = jokerCount(tiles: tiles)
            var tileIndex = CGFloat(0.0)
            var remainingTiles: [Tile] = []
            for tile in tiles {
                var found = false
                for (index, idlist) in suggestedHandA.idList.list.enumerated() {
                    let idMap = TileIdMap(idlist.ids)
                    let count = suggestedHandA.countMatches(tiles: tiles, map: idMap.map, jokerCount: jokerCount, subId: index)
                    if count == suggestedHandA.matchCount {
                        for id in idlist.ids {
                            if id == tile.id {
                                found = true
                                break
                            }
                        }
                    }
                }
                if found == false {
                    let x = CGFloat(tileIndex < 14 ? tileIndex : tileIndex - 14) * (width + 1.0) + 150
                    let y = tileIndex < 14 ? 10.0 : 10.0 + height
                    let v = UIImageView(frame:CGRect(x: x, y: y, width: width, height: height))
                    v.contentMode = .scaleAspectFit
                    v.layer.masksToBounds = true
                    v.layer.cornerRadius = width / 8
                    v.image = UIImage(named: Tile.getImage(id: tile.id, maj: maj!))
                    view.addSubview(v)
                    yourTileViews.append(v)
                    tileIndex += 1
                    remainingTiles.append(tile)
                }
            }
            cardView.update(maj, tiles: remainingTiles)
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Selected Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    func allTiles() -> [Tile] {
        return maj.east.tiles + maj.south.tiles + (maj.east.rack?.tiles)! + (maj.south.rack?.tiles)!
    }
    
    func jokerCount(tiles: [Tile]) -> Int {
        var jokerCount = 0
        for tile in tiles {
            if tile.isJoker() {
                jokerCount += 1
            }
        }
        return jokerCount
    }
        
    /*func showSelectedTiles(letterPattern: LetterPattern) {
        selectedPattern = letterPattern
        
        label?.removeFromSuperview()
        let width: CGFloat = 500
        let height: CGFloat = 75
        let labelFrame = CGRect(x: 50, y: 240, width: width, height: height)
        label = UILabel(frame: labelFrame)
        
        let text = NSMutableAttributedString(string: "")
        text.append(letterPattern.text)
        text.append(NSMutableAttributedString(string: "  "))
        text.append(letterPattern.note)
        
        label.attributedText = text
        label.frame = labelFrame
        label.textAlignment = .left
        label.numberOfLines = 1
        view.addSubview(label)
                
        let items = ["Hand1", "Hand2", "Alt"]
        selectSegmentControl?.removeFromSuperview()
        let x = Int(view.frame.width - 250)
        selectSegmentControl = UISegmentedControl(items: items)
        selectSegmentControl.frame = CGRect(x: x, y: 285, width: 230, height: Int(selectSegmentControl.frame.height))
        selectSegmentControl.addTarget(self, action: #selector(changeSelect), for: .valueChanged)
        view.addSubview(selectSegmentControl)
        
        selectSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
        if suggestedHandA != nil && suggestedHandA.id == selectedPattern.id { selectSegmentControl.selectedSegmentIndex = 0 }
        if suggestedHandB != nil && suggestedHandB.id == selectedPattern.id { selectSegmentControl.selectedSegmentIndex = 1 }
        if suggestedHandC != nil && suggestedHandC.id == selectedPattern.id { selectSegmentControl.selectedSegmentIndex = 2 }
        
        let tiles = allTiles()
        let jokerCount = jokerCount(tiles: tiles)
        for view in tileViews { view.removeFromSuperview() }
        var y = label.frame.origin.y + 55
        for (index, idlist) in letterPattern.idList.list.enumerated() {
            let idMap = TileIdMap(idlist.ids)
            let count = letterPattern.countMatches(tiles: tiles, map: idMap.map, jokerCount: jokerCount, subId: index)
            if count == letterPattern.matchCount {
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
    }*/
    
    @objc private func changeSelect(sender: UISegmentedControl) {
        switch( sender.selectedSegmentIndex ) {
        case 0: suggestedHandA = selectedPattern
        case 1: suggestedHandB = selectedPattern
        case 2: suggestedHandC = selectedPattern
        default: selectSegmentControl.selectedSegmentIndex = UISegmentedControl.noSegment
        }
        handsControllerDelegate.showSuggestedHands()
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
        let offset = view.frame.width < 668 || view.frame.height > 650 ? 10 : 45
        let items = ["2023", "Even", "Like", "Add", "Quints", "Runs", "Odds", "W&D", "369", "S&P", "All", "Slctd"]
        filterSegmentControl = UISegmentedControl(items: items)
        filterSegmentControl.selectedSegmentIndex = 10
        filterSegmentControl.frame = CGRect(x: offset, y: Int(tileHeight() * 2) + 40, width: Int(view.frame.width - 50), height: Int(filterSegmentControl.frame.height))
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
        case 11: filter(year: true, evens: true, like: true, add: true, quints: true, runs: true, odds: true, winds: true, three: true, pairs: true )
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
        let tiles = maj.east.tiles + maj.south.tiles + (maj.east.rack?.tiles)! + (maj.south.rack?.tiles)!
        cardView.update(maj, tiles: tiles)
    }
    
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tile Sizes
    //
    // -----------------------------------------------------------------------------------------

    func tileWidth() -> CGFloat {
        return view.frame.width / 16
    }
    
    func tileHeight() -> CGFloat {
        return tileWidth() * 62.5 / 46.0
    }
    
}
