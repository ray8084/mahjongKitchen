//
//  HelpTableController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/15/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

class HandsController: NarrowViewController  {

    private var maj: Maj!
    private var cardView = CardView()
    private var tileMatchView = TileMatchView()
    private var filterSegmentControl: UISegmentedControl!
    
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
        cardView.showCard(self, x: 30, y: 60, width: view.frame.width - 50, height: 100, bgcolor: .white, maj: maj)
        view.addSubview(cardView.cardView)
        cardView.update(maj)
        
        tileMatchView.isHidden = false
        tileMatchView.showView(self, x: 30, y: 180, width: view.frame.width - 50, height: view.frame.height - 200, bgcolor: .black)
        view.addSubview(tileMatchView.tableView)
        tileMatchView.loadPatterns(maj: maj, letterPatterns: maj.card.letterPatterns)
        tileMatchView.update(maj)
        
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
        filterSegmentControl.frame = CGRect(x: 25, y: 20, width: 580, height: Int(filterSegmentControl.frame.height))
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
        tileMatchView.update(maj)
    }
    

}
