//
//  ViewController.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 9/25/21.
//

import UIKit

enum ErrorId: Int { case swapInHand = 8001, toCharlestonOut, swapInRack, toRack, toDiscard, charlestonToHand, rackToDiscard }

class ViewController: UIViewController, NarrowViewDelegate  {
    
    var backgroundImageView: UIImageView!
    var viewDidAppear = false
    let BlankColor = UIColor(white: 0.95, alpha: 0.7)
    let BackgroundColor = UIColor.init(red: 225.0/255.0, green: 230.0/255.0, blue: 223.0/255.0, alpha: 1)
    let BackgroundColorDarkMode = UIColor.init(red: 225.0/255.0, green: 230.0/255.0, blue: 223.0/255.0, alpha: 1)
    
    var maj: Maj!
    var lastMaj: Maj!
    let app = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard

    var handView1: [UIView] = []
    var handView2: [UIView] = []
    var rackView1: [UIView] = []
    var rackView2: [UIView] = []
    var discardView: [UIView] = []
    var discardTableView = DiscardTableView()
    var newGameMenu =  UIAlertController()
    
    let margin: CGFloat = 5
    let space: CGFloat = 1
    let rowHeight: CGFloat = 18
    let labelOffset: CGFloat = 2
    var start = CGPoint()
    let charlestonOutIndex = 11
    let maxHandIndex = 13
    var label: UILabel!
    var discardIndex = 13
    var gameButton: UIButton!
    var filterButton: UIButton!
    var gameView = true
    var newDeal = true
    var validatePending = false
    var redealPending = false
    var newStart = true
    let rackRow1 = 0
    let rackRow2 = 1
    let handRow1 = 2
    let handRow2 = 3
    let discardRow = 4
    var winCounted = false
    var lossCounted = false
    var rackingInProgress = false
    var reviewInProgress = false
    
    var menuButton: UIButton!
    var versionLabel: UILabel!

    
    // -----------------------------------------------------------------------------------------
    //
    //  Init
    //
    // -----------------------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        maj = app.maj
        maj.loadSavedValues()
        lastMaj = Maj(maj)
    }
     
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if viewDidAppear == false {
            setBackground()
            enable2023(true)
            load2023()
            redeal()
            viewDidAppear = true
        }
    }
    
    func setBackground(){
        view.backgroundColor = getBackgroundColor()
        backgroundImageView?.removeFromSuperview()
        let background = UIImage(named: "TRANS-ICON-WHITE.png")
        backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = background
        backgroundImageView.center = view.center
        backgroundImageView.alpha = 0.15
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    func getBackgroundColor() -> UIColor {
        if #available(iOS 12.0, *) {
            return traitCollection.userInterfaceStyle == .light ? BackgroundColor : BackgroundColorDarkMode
        } else {
            return BackgroundColor
        }
    }

    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Game
    //
    // -----------------------------------------------------------------------------------------
       
    func load2023() {
        maj.setYearSegment(segment: YearSegment.segment2023)
        redeal()
    }
    
    func enable2023(_ enable: Bool) {
        maj.enable2023 = enable
    }
    
    func showGame() {
        showRack()
        showDiscard()
        showDiscardTable()
        showHand()
        showButtons()
    }
    
    func gameOver() {
        maj.discardLastDiscard()
        maj.state = State.wall
        label.text = "Game Over"
        if maj.eastWon() == false {
            maj.rackOpponentHands()
        }
        showGameMenu()
    }
    
    func showGameMenu() {
        let eastWon = maj.eastWon()
        if maj.isGameOver() {
            maj.card.clearRackFilter()
            maj.east.tileMatches.clearRackFilter()
        }
        if maj.isGameOver() && eastWon {
            showWinMenu()
        } else if maj.isGameOver() && !lossCounted {
            addLoss()
            showGameMenu(title: "Game", message: "", win: false)
        } else {
            showGameMenu(title: "Game", message: "", win: false);
        }
    }
    
    func addWin() {
        print("ViewController addWin")
        if maj.eastWon() && winCounted == false {
            winCounted = maj.card.addWin(maj.card.winningIndex((maj.east.rack?.jokerCount())!))
        }
    }
    
    func addLoss() {
        if lossCounted == false {
            self.lossCounted = true
            let letterPattern = maj.card.getClosestPattern(tiles: maj.east.tiles + maj.rackTiles())
            self.maj.card.addLoss(letterPattern)
        }
    }
    
    func showWinMenu() {
        let title = "Mahjong - You Win!"
        let message = maj.card.winningHand(maj: maj)
        showGameMenu(title: title, message: message, win: true)
        addWin() // debugging
    }
           
    func showGameMenu(title: String, message: String, win: Bool) {
        newGameMenu = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        newGameMenu.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.addWin()
            self.newGameAction(win)
        }));
        
        newGameMenu.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.addWin()
            self.replay()
        }));
        
        newGameMenu.addAction(UIAlertAction(title: "Review", style: .default, handler: {(action:UIAlertAction) in
            self.addWin()
            self.reviewInProgress = true
        }));
        
        present(newGameMenu, animated: true, completion: nil)
    }
        
    func newGameAction(_ win: Bool) {
        if win && (self.maj.card.getTotalWinCount() > 2 ) {
            self.redeal()
        } else {
            self.redeal()
        }
    }
        
    func eastWon() {
        gameOver()
    }
    
    func replay() {
        winCounted = false
        lossCounted = false
        newDeal = true
        maj.replay()
        maj.discardTable.resetCounts()
        discardTableView.hide()
        maj.card.clearRackFilter()
        showGame()
        reviewInProgress = false
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Hand
    //
    // ----------------------------------------------------------------------------------------
    
    @objc func redeal() {
        print("redeal")
        winCounted = false
        lossCounted = false
        newDeal = true
        resetMaj()
        discardTableView.hide()
        showGame()
    }
    
    func resetMaj() {
        let enable2020 = maj.enable2020
        let enable2021 = maj.enable2021
        let shuffleSeed = maj.shuffleSeed
        let shuffleWithSeed = maj.shuffleWithSeed
        app.maj = Maj()
        maj = app.maj
        maj.enable2020 = enable2020
        maj.enable2021 = enable2021
        maj.shuffleSeed = shuffleSeed
        maj.shuffleWithSeed = shuffleWithSeed
        if maj.shuffleWithSeed { maj.deal() }
        maj.discardTable.resetCounts()
        maj.card.clearRackFilter()
    }
    
    func clearHand() {
        for view in handView1 { view.removeFromSuperview() }
        for view in handView2 { view.removeFromSuperview() }
        handView1 = []
        handView2 = []
    }
        
    func showHand() {
        clearHand()
        addTiles( tileView: &handView1, hand: maj.east, col: 0, row: handRow1)
        var start = maj.east.tiles.count
        var count = maxHandIndex - start + 1
        addBlanks( tileView: &handView1, col: start, row: handRow1, count: count, addGestures: false)
        
        addTiles( tileView: &handView2, hand: maj.south, col: 0, row: handRow2)
        start = maj.south.tiles.count
        count = maxHandIndex - start + 1
        addBlanks( tileView: &handView2, col: start, row: handRow2, count: count, addGestures: false)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Rack
    //
    // -----------------------------------------------------------------------------------------
    
    func clearRack() {
        for view in rackView1 { view.removeFromSuperview() }
        for view in rackView2 { view.removeFromSuperview() }
        rackView1 = []
        rackView2 = []
    }

    func showRack() {
        clearRack()
        
        addTiles( tileView: &rackView1, hand: maj.east.rack!, col: 0, row: rackRow1)
        var start = maj.east.rack?.tiles.count
        var count = maxHandIndex - start!
        addBlanks( tileView: &rackView1, col: start!, row: rackRow1, count: count, addGestures: false)
        
        addTiles( tileView: &rackView2, hand: maj.south.rack!, col: 0, row: rackRow2)
        start = maj.south.rack?.tiles.count
        count = maxHandIndex - start!
        addBlanks( tileView: &rackView2, col: start!, row: rackRow2, count: count, addGestures: false)
    }
        
    
    // -----------------------------------------------------------------------------------------
    //
    //  Discard
    //
    // -----------------------------------------------------------------------------------------
    
    func clearDiscard() {
        for view in discardView {
            view.removeFromSuperview()
        }
        discardView = []
    }
    
    func showDiscard() {
        clearDiscard()
        if maj.discardTile != nil {
            let discard = Hand("Discard")
            discard.tiles.append(maj.discardTile)
            addTiles( tileView: &discardView, hand: discard, col: discardIndex, row: discardRow)
        } else {
            addBlanks( tileView: &discardView, col: discardIndex, row: discardRow, count: 0, addGestures: false)
        }
    }

    func offScreen(_ location: CGPoint) -> Bool {
        return Int(location.x / (tileWidth() + space)) > maxHandIndex
    }

    func isDiscard(_ location: CGPoint) -> Bool {
        let isDiscardRow = (location.y < charlestonBottom() + margin) && (location.y > charlestonTop())
        let isDiscardIndex = (getTileIndex(location) == discardIndex)
        return isDiscardRow && isDiscardIndex
    }
    
    func shouldRemoveDiscard(_ start: CGPoint, location: CGPoint) -> Bool {
        let movedRight = start.x < location.x
        let isDiscardRow = (location.y > charlestonTop())
        let isDiscardIndex = (getTileIndex(location) == discardIndex)
        return isDiscardRow && isDiscardIndex && movedRight
    }
    
    func shouldUndoDiscard(_ start: CGPoint, location: CGPoint) -> Bool {
        let movedLeft = (start.x - 20) > location.x
        return movedLeft
    }
    
    func undoDiscard() -> Bool {
        print("undoDiscard")
        var undo = false
        if (maj.lastDiscard != nil) && !maj.disableUndo {
            discardTableView.countTile(maj.lastDiscard, increment: -1, maj: maj)
            maj.copy(lastMaj)
            showDiscard()
            maj.lastDiscard = nil
            undo = true
            discardTableView.showCounts(maj: maj)
            showHand()
        }
        return undo
    }
        
    func validateRack(_ maj: Maj) {
        if validatePending {
            let message = maj.validateRack()
            validatePending = false
            if message != "" {
                showRackError(message)
            }
        }
    }

    func showRackError(_ message: String) {
        let alert = UIAlertController(title: "Singles and Pairs Error", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.redeal()
        }));
        
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.replay()
        }));
        
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: {(action:UIAlertAction) in
            self.validatePending = true
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
        
    // -----------------------------------------------------------------------------------------
    //
    //  Discard Table
    //
    // -----------------------------------------------------------------------------------------
    
    func showDiscardTable() {
        discardTableView.isHidden = false
        discardTableView.show(parent: view, rowHeader: tableLocation(), maj: maj, margin: 200)
    }
    
    func hideDiscardTable() {
        discardTableView.isHidden = true
        discardTableView.hide()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Buttons
    //
    // -----------------------------------------------------------------------------------------
    
    func showButtons() {
        addMenuButton()
    }
    
    func addMenuButton() {
        if menuButton == nil {
            menuButton = UIButton()
            menuButton.frame = CGRect(x: menuButtonLocationX(), y: buttonLocationY(),  width: buttonSize() + 20, height: buttonSize())
            menuButton.layer.cornerRadius = 5
            menuButton.titleLabel!.font = UIFont(name: "Chalkduster", size: 16)!
            menuButton.backgroundColor = .black
            menuButton.alpha = 0.8
            menuButton.setTitle("Menu", for: .normal)
            menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
            view.addSubview(menuButton)
        }
    }
    
    @objc func menuButtonAction(sender: UIButton!) {
        showSystemMenu()
    }
      
    
    // -----------------------------------------------------------------------------------------
    //
    //  System Menu
    //
    // -----------------------------------------------------------------------------------------
    
    func showSystemMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.newGameAction(false)
        }));
        
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.replay()
        }));
        
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    func addTiles( tileView: inout [UIView], hand: Hand, col: Int, row: Int ) {
        var index = 0
        var y: CGFloat = 0.0
        switch(row) {
            case 0: y = margin
            case 1: y = handTop()
            case 2: y = charlestonTop()
            case 3: y = handTop() + charlestonTop() - margin
            default: y = 0.0
        }
        for tile in hand.tiles {
            let x = CGFloat(col+index) * (tileWidth() + space) + margin + notch()
            let v = UIImageView(frame:CGRect(x: newDeal ? 0.0 : x, y: y, width: tileWidth(), height: tileHeight()))
            v.contentMode = .scaleAspectFit
            v.layer.masksToBounds = true
            v.layer.cornerRadius = tileWidth() / 8
            v.image = UIImage(named: tile.getImage(maj: maj))
            v.isUserInteractionEnabled = true
            v.tag = ((row + 1) * 100) + (col + index + 1)
            let g = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestures))
            g.minimumNumberOfTouches = 1
            g.maximumNumberOfTouches = 1
            v.addGestureRecognizer(g)
            view.addSubview(v)
            tileView.append(v)
            index += 1
            if row == discardRow {
                addTapGestureDiscard(v)
            }
            
            if newDeal && (row == 1 || row == 2 || row == 3) {
                UIView.animate(withDuration: 0.5, delay: 0.2, options: [],
                    animations: {v.center.x += x},
                    completion: nil
                )
            }
        }
        if row == 3 {
            newDeal = false
        }
    }

    func getTileIndex(_ location: CGPoint) -> Int {
        var index = Int((location.x - notch()) / (tileWidth() + space))
        if index < 0 {
            index = 0
        } else if index > maxHandIndex {
            index = maxHandIndex
        }
        return index
    }
    
    func getTileColIndex(tag: Int) -> Int {
        return tag % 100 - 1
    }
    
    func addBlanks( tileView: inout [UIView], col: Int, row: Int, count: Int, addGestures: Bool) {
        let start = col
        let end = col + count
        var y: CGFloat = 0.0
        switch(row) {
            case 0: y = margin
            case 1: y = handTop()
            case 2: y = charlestonTop()
            case 3: y = handTop() + charlestonTop() - margin
            default: y = 0.0
        }
        if start <= end {
            for index in start...end {
                let x = CGFloat(index) * (tileWidth() + space) + margin + notch()
                let v = UIView(frame:CGRect(x: x, y: y, width: tileWidth(),height: tileHeight()))
                v.backgroundColor = BlankColor
                v.layer.masksToBounds = true
                v.layer.cornerRadius = tileWidth() / 8
                if addGestures {
                    let g = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestures))
                    g.minimumNumberOfTouches = 1
                    g.maximumNumberOfTouches = 1
                    v.addGestureRecognizer(g)
                    v.tag = ((row + 1) * 100) + (col + index + 1)
                }
                view.addSubview(v)
                tileView.append(v)
            }
        }
    }
        
    func changeTileImages() {
        for (index, tile) in maj.east.tiles.enumerated() {
            if index < handView1.count {
                let view = handView1[index] as! UIImageView
                view.image = UIImage(named: tile.getImage(maj:maj))
            }
        }
        
        for (index, tile) in maj.east.rack!.tiles.enumerated() {
            if index < rackView1.count {
                let view = rackView1[index] as! UIImageView
                view.image = UIImage(named: tile.getImage(maj:maj))
            }
        }
    }
    
    
    // ----------------------------------------------------------------------------------
    //
    //  Gestures
    //
    // ----------------------------------------------------------------------------------
    
    @objc func handlePanGestures(_ sender: UIPanGestureRecognizer) {
        if sender.view != nil {
            switch sender.state {
            case .began:
                handlePanGestureBegin(sender)
                break
            case .ended:
                if sender.view!.superview != nil {
                    if reviewInProgress {
                        handlePanGestureDuringReview(sender)
                    } else {
                        handlePanGestureEnded(sender)
                    }
                }
                break
            case .changed:
                if sender.view!.superview != nil { handlePanGestureChanged(sender) }
                break
            default:
                break
            }
        }
    }
    
    func handlePanGestureBegin(_ sender: UIPanGestureRecognizer) {
        if sender.view != nil {
            start = sender.view!.center
        }
    }

    func handlePanGestureChanged(_ sender: UIPanGestureRecognizer) {
        if sender.view != nil {
            if sender.view!.superview != nil {
                let end = sender.location(in: sender.view!.superview!)
                sender.view!.center = end
                view.bringSubviewToFront(sender.view!)
            }
        }
    }
    
    func handlePanGestureDuringReview(_ sender: UIPanGestureRecognizer ) {
        let startTag = sender.view?.tag ?? 0
        let endLocation = sender.location(in: sender.view!.superview!)
        if isRack(tag: startTag) && isRack(endLocation) {
            let _ = swapInRack(end: endLocation, startTag: startTag)
        } else {
            sender.view!.center = start
            showGameMenu()
        }
    }
    
    func handlePanGestureEnded(_ sender: UIPanGestureRecognizer) {
        let startTag = sender.view?.tag ?? 0
        let row = startTag / 100
        let end = sender.location(in: sender.view!.superview!)
        let endRow = getRow(end.y)
        var handled = false
        print("\(row) \(endRow)")
        switch(row) {
        case 3:
            switch(endRow) {
            case 1: handled = moveToRack(hand: maj.east, rack: maj.east.rack!, end: end, startTag: startTag)
            case 2: handled = moveToRack(hand: maj.east, rack: maj.south.rack!, end: end, startTag: startTag)
            case 3: handled = swapInHand(hand: maj.east, end: end, startTag: startTag)
            case 4: handled = swapBetweenHands(startHand: maj.east, endHand: maj.south, end: end, startTag: startTag)
            default: handled = false }
        case 4:
            switch(endRow) {
            case 1: handled = moveToRack(hand: maj.south, rack: maj.east.rack!, end: end, startTag: startTag)
            case 2: handled = moveToRack(hand: maj.south, rack: maj.south.rack!, end: end, startTag: startTag)
            case 3: handled = swapBetweenHands(startHand: maj.south, endHand: maj.east, end: end, startTag: startTag)
            case 4: handled = swapInHand(hand: maj.south, end: end, startTag: startTag)
            default: handled = false }
        default:
            print("todo")
        }

        if !handled {
            sender.view!.center = start
        }
    }
    
    func getRow(_ location: Double) -> Int {
        var row = 0
        if location < rack1Bottom() {
            row = 1
        } else if location < rack2Bottom() {
            row = 2
        } else if location < hand1Bottom() {
            row = 3
        } else {
            row = 4
        }
        return row
    }
       
    func swapInHand(hand: Hand, end: CGPoint, startTag: Int) -> Bool {
        var swapped = false
        let startIndex = getTileColIndex(tag: startTag)
        let endIndex = getTileIndex(end)
        if startIndex < hand.tiles.count {
            let tile = hand.tiles.remove(at: startIndex)
            if endIndex >= hand.tiles.count {
                hand.tiles.append(tile)
            } else {
                hand.tiles.insert(tile, at: endIndex)
            }
            showHand()
            swapped = true
        }
        return swapped
    }
    
    func swapBetweenHands(startHand: Hand, endHand: Hand, end: CGPoint, startTag: Int) -> Bool {
        var swapped = false
        let startIndex = getTileColIndex(tag: startTag)
        let endIndex = getTileIndex(end)
        if startIndex < startHand.tiles.count {
            let tile = startHand.tiles.remove(at: startIndex)
            if endHand.tiles.count == 15 {
                let moveTile = endHand.tiles.remove(at: endHand.tiles.count - 1)
                startHand.tiles.append(moveTile)
                endHand.tiles.insert(tile, at: endIndex)
            } else if endIndex >= endHand.tiles.count {
                endHand.tiles.append(tile)
            } else {
                endHand.tiles.insert(tile, at: endIndex)
            }
            showHand()
            swapped = true
        }
        return swapped
    }
    
    func swapInRack(end: CGPoint, startTag: Int) -> Bool {
        var swapped = false
        let startIndex = getTileColIndex(tag: startTag)
        let endIndex = getTileIndex(end)
        if startIndex < maj.east.getRackCount() {
            let tile = maj.east.removeFromRack(startIndex)
            maj.east.addToRack(tile, index: endIndex)
            showRack()
            maj.east.rack?.markJokers()
            swapped = true
        }
        return swapped
    }
    
    func moveToDiscard(startTag: Int) -> Bool {
        print("moveToDiscard")
        var moved = false
        if maj.discardTile == nil {
            let index = getTileColIndex(tag: startTag)
            if index < maj.east.tiles.count {
                maj.discardTile = maj.east.tiles[index]
                maj.east.tiles.remove(at: index)
                showHand()
                showDiscard()
                moved = true
            }
            rackingInProgress = false
        }
        return moved
    }
    
    func moveToRack(hand: Hand, rack: Rack, end: CGPoint, startTag: Int) -> Bool {
        var moved = false
        let startIndex = getTileColIndex(tag: startTag)
        let endIndex = getTileIndex(end)
        if startIndex < hand.tiles.count {
            let tile = hand.tiles.remove(at: startIndex)
            if endIndex < rack.tiles.count {
                rack.tiles.insert(tile,at: endIndex)
            } else {
                rack.tiles.append(tile)
            }
            showHand()
            showRack()
            moved = true
        }
        return moved
    }
    
    func discardToHand(end: CGPoint) -> Bool {
        var moved = false
        if maj.state == State.east {
            let endIndex = getTileIndex(end)
            if endIndex < maj.east.tiles.count {
                maj.east.tiles.insert(maj.discardTile, at: endIndex)
            } else {
                maj.east.tiles.append(maj.discardTile)
            }
            maj.discardTile = nil
            showDiscard()
            showHand()
            moved = true
        }
        return moved
    }
    
    func moveFromDiscardToRack(end: CGPoint) -> Bool {
        var moved = false
        if maj.state != State.east {
            let endIndex = getTileIndex(end)
            if endIndex < (maj.east.rack?.tiles.count)! {
                maj.east.rack?.tiles.insert(maj.discardTile, at: endIndex)
            } else {
                maj.east.rack?.tiles.append(maj.discardTile)
            }
            maj.state = State.east
            label.text = maj.stateLabel()
            maj.discardTile = nil
            showDiscard()
            showRack()
            moved = true
            maj.letterPatternRackFilterPending = true
            maj.tileMatchesRackFilterPending = true
            if maj.east.rack?.tiles.count == 14 {
                maj.card.match(maj.east.tiles + (maj.east.rack?.tiles)!, ignoreFilters: false)
                gameOver()
            }
            rackingInProgress = true
        }
        return moved
    }

    func rackToDiscard(end: CGPoint, startTag: Int) -> Bool {
        var moved = false
        if !maj.disableUndo {
            let index = getTileColIndex(tag: startTag)
            if index < maj.east.getRackCount() {
                maj.discardTile = maj.east.removeFromRack(index)
                showDiscard()
                showRack()
                 moved = true
            } 
        }
        return moved
    }
    
    func removeFromRack(end: CGPoint, startTag: Int) -> Bool {
        let startIndex = getTileColIndex(tag: startTag)
        let endIndex = getTileIndex(end)
        if (startIndex < (maj.east.rack?.tiles.count)!) && !maj.disableUndo {
            let tile = maj.east.rack?.tiles.remove(at: startIndex)
            if endIndex < maj.east.tiles.count {
                maj.east.tiles.insert(tile!,at: endIndex)
            } else {
                maj.east.tiles.append(tile!)
            }
            showHand()
            showRack()
            maj.letterPatternRackFilterPending = true
            maj.tileMatchesRackFilterPending = true
            return true
        } else {
            return false
        }
    }
    
    func addTapGestureDiscard(_ tile: UIView) {
        if maj.disableTapToDiscard == false {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureDiscard(_:)))
            tile.addGestureRecognizer(tap)
        }
    }
    
    @objc func handleTapGestureDiscard(_ sender: UITapGestureRecognizer) {
        let _ = nextState()
    }
           
    
    // -----------------------------------------------------------------------------------------
    //
    //  Bot Win
    //
    // -----------------------------------------------------------------------------------------
        
    func botWon() {
        addLoss()
        maj.discardLastDiscard()
        showDiscard()
        showDiscardTable()
        maj.rackOpponentHands()
        showBotWinMenu()
    }
    
    func showBotWinMenu() {
        let bot = maj.getWinningBot()
        if bot != nil {
            let title = "\(bot!.name) declared Mahjong\n"
            let message = maj.getWinningBotPattern() + "\n" + maj.getWinningBotPatternNote()
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
                self.newGameAction(false)
            }));
            
            alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
                self.replay()
            }));
            
            alert.addAction(UIAlertAction(title: "Review", style: .cancel, handler: {(action:UIAlertAction) in
                self.reviewInProgress = true
            }));
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  State Machine
    //
    // -----------------------------------------------------------------------------------------
    
    func nextState() -> Bool {
        print("nextState")
        if maj.isWinBotEnabled() && maj.botWon() {
            botWon()
        } else if maj.isGameOver(){
            eastWon()
        } else {
            discardTableView.showCounts(maj: maj)
            lastMaj.copy(maj)
            label.text = maj.nextState()
            if maj.discardCalled {
                discardTableView.showCounts(maj: maj)
                maj.discardCalled = false
            }
        }
        showGame()
        showDiscard()
        return true
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Position
    //
    // -----------------------------------------------------------------------------------------
    
    func viewWidth() -> CGFloat {
        var width = view.frame.width
        let height = view.frame.height
        if height > width {
            width = height
        }
        return width
    }
    
    func viewHeight() -> CGFloat {
        let width = view.frame.width
        var height = view.frame.height
        if height > width {
            height = width
        }
        return height
    }
    
    func tileWidth() -> CGFloat { return (viewWidth() - notch()) / 15.5 }
    func tileHeight() -> CGFloat { return tileWidth() * 62.5 / 46.0 }
    
    func notch() -> CGFloat {
        var notch = CGFloat(0)
        if #available(iOS 11.0, *) {
            notch = UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0
        }
        return notch
    }
    
    func isTall() -> Bool { return viewHeight() > 500 }
    func cardLocationY() -> CGFloat { return isTall() ? cardLocationPad() : cardLocationPhone()}
    func botLocationY() -> CGFloat { return cardLocationPhone() }
     
    func cardLocationPhone() -> CGFloat {
        var location: CGFloat = 0
        if charlestonBottom() > discardTableBottom() {
            location = charlestonBottom()
        } else {
            location = discardTableBottom()
        }
        return location + rowHeight/2.0
    }
    
    func cardLocationPad() -> CGFloat {
        return cardLocationPhone() + 0 + 20
    }
    
    func tableLocation() -> CGFloat { return tileHeight() * 4 + margin * 5 }
    func cardMarginX() -> CGFloat { return notch() + margin }
    func cardHeight() -> CGFloat { return viewHeight() - cardLocationY() - 10 - controlPanelHeight() }
    func botHeight() -> CGFloat { return viewHeight() - botLocationY() - 10 - controlPanelHeight() }
    func cardWidth() -> CGFloat { return viewWidth() - 20 }
    func handTop() -> CGFloat { return margin + tileHeight() + margin }
    func rack1Bottom() -> CGFloat { return margin + tileHeight() + margin }
    func rack2Bottom() -> CGFloat { return rack1Bottom() + tileHeight() + margin }
    func hand1Bottom() -> CGFloat { return rack2Bottom() + tileHeight() + margin }
    func hand2Bottom() -> CGFloat { return hand1Bottom() + tileHeight() + margin }
    func handBottom() -> CGFloat { return handTop() + tileHeight() }
    func charlestonTop() -> CGFloat { return handBottom() + margin }
    func charlestonBottom() -> CGFloat { return charlestonTop() + tileHeight() }
    func rowHeader() -> CGFloat { return tileHeight() * 2 + (rowHeight/1.5) }
    func row1() -> CGFloat { return rowHeader() + rowHeight }   // these rows are not tile rows!  they are text rows.
    func row2() -> CGFloat { return row1() + rowHeight }
    func row3() -> CGFloat { return row2() + rowHeight }
    func row4() -> CGFloat { return row3() + rowHeight }
    func discardTableBottom() -> CGFloat{ return row4() + rowHeight }
    func isRack(_ location: CGPoint) -> Bool { return location.y < handTop() }
    func isHand(_ location: CGPoint) -> Bool { return (location.y < handBottom() + margin) && (location.y > handTop()) }
    func isRack(tag: Int) -> Bool { return tag / 100 == 1 }
    func isHand(tag: Int) -> Bool { return tag / 100 == 2 }
    func isHand1(tag: Int) -> Bool { return tag / 100 == 3 }
    func isHand2(tag: Int) -> Bool { return tag / 100 == 4 }
    func isCharlestonOut(tag: Int) -> Bool { return tag / 100 == 3 }
    func isDiscard(tag: Int) -> Bool { return tag / 100 == 3}
    
    func isCharlestonOut(_ location: CGPoint) -> Bool {
        let top = charlestonTop()
        let bottom = charlestonBottom() + margin
        return (location.y > top) && (location.y < bottom) && (getTileIndex(location) >= charlestonOutIndex)
    }
    
    func controlPanelWidth() -> CGFloat { return isTall() ? 450 : 300 }
    func controlPanelHeight() -> CGFloat { return isTall() ? 45 : 32 }
    func controlPanelLocationX() -> CGFloat { return cardMarginX() }
    func controlPanelLocationY() -> CGFloat{ return cardLocationY() + cardHeight() + 5 }
    func menuButtonLocationX() -> CGFloat { return cardMarginX() }
    func buttonLocationY() -> CGFloat { return tableLocation() + rowHeight * 4 - buttonSize() }
    func buttonSize() -> CGFloat { return controlPanelHeight() }
}

