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
    private var label: UILabel!
    private var tileViews: [UIView] = []
    var handsControllerDelegate: HandsControllerDelegate
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate, handsControllerDelegate: HandsControllerDelegate, backgroundColor: UIColor) {
        self.maj = maj
        self.handsControllerDelegate = handsControllerDelegate
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
        view.backgroundColor = backgroundColor
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
        cardView.showCard(self, delegate: self, x: x, y: y, width: view.frame.width - 100, height: 100, bgcolor: .white, maj: maj)
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

        addCloseButton()
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Your Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    func showYourTiles() {
        let height = tileHeight()
        let width = tileWidth()
        for v in tileViews { v.removeFromSuperview() }
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
            tileViews.append(v)
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
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Close Button
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
    
    @objc override func closeButtonAction(sender: UIButton!) {
        handsControllerDelegate.showSuggestedHands()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Filters
    //
    // -----------------------------------------------------------------------------------------
    
    func addFilterSegmentControl() {
        let offset = view.frame.width < 668 || view.frame.height > 650 ? 10 : 45
        let items = ["2023", "Even", "Like", "Add", "Quints", "Runs", "Odds", "W&D", "369", "S&P", "All", "Sel"]
        filterSegmentControl = UISegmentedControl(items: items)
        filterSegmentControl.selectedSegmentIndex = 10
        filterSegmentControl.frame = CGRect(x: offset, y: Int(tileHeight() * 2) + 40, width: Int(view.frame.width - 100), height: Int(filterSegmentControl.frame.height))
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
        return view.frame.width / 17
    }
    
    func tileHeight() -> CGFloat {
        return tileWidth() * 62.5 / 46.0
    }
    
}
