//
//  ViewController.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 9/25/21.
//

import UIKit

enum ErrorId: Int { case swapInHand = 8001, toCharlestonOut, swapInRack, toRack, toDiscard, charlestonToHand, rackToDiscard }

class ViewController: UIViewController, NarrowViewDelegate, HandsControllerDelegate  {
    
    var backgroundImageView: UIImageView!
    var viewDidAppear = false
    let RackColor = UIColor(white: 0.93, alpha: 0.7)
    let HandColor = UIColor(white: 0.99, alpha: 0.9)
    let BackgroundColor = UIColor.init(red: 225.0/255.0, green: 230.0/255.0, blue: 223.0/255.0, alpha: 1)
    let BackgroundColorDarkMode = UIColor.init(red: 185.0/255.0, green: 190.0/255.0, blue: 183.0/255.0, alpha: 1)
    let BackgroundColorDefense = UIColor.init(red: 74.0/255.0, green: 96.0/255.0, blue: 42.0/255.0, alpha: 1)
    let BackgroundColorIconRed = UIColor.init(red: 232.0/255.0, green: 54.0/255.0, blue: 49.0/255.0, alpha: 1)
    
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
    var menuButton: UIButton!
    var versionLabel: UILabel!
    var handsButton: UIButton!
    var suggestedHand1: UILabel!
    var suggestedHand2: UILabel!
    var suggestedHandAlt: UILabel!
    var suggestedHandsView: HandsController!
    
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
    var firstMahjong = false
    var firstMahjongRack1 = false
    var firstMahjongRack2 = false
    var firstMahjongHand1 = false
    var firstMahjongHand2 = false
        
    
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
            // buildIcon()
        }
    }
    
    func buildIcon() {
        let v = UIImageView(frame:CGRect(x: 0, y: 0, width: 1024, height: 1024))
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.alpha = 1.0
        v.backgroundColor = BackgroundColorIconRed
        v.image = UIImage(named: "TRANS-ICON-WHITE.png")
        view.addSubview(v)
        
        let title = UILabel(frame: CGRect(x: 0, y: 412, width: 1024, height: 200))
        title.text = "Two Hand"
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.alpha = 1.0
        title.backgroundColor = BackgroundColorIconRed
        title.font = UIFont.boldSystemFont(ofSize: 200.0)
        view.addSubview(title)
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
            return traitCollection.userInterfaceStyle == .light ? BackgroundColorDarkMode : BackgroundColorDarkMode
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
        showButtons()
        showRack()
        showDiscard()
        showSuggestedHands()
        showHand()
        showLabel()
    }
           
    func showGameMenu(title: String, message: String, win: Bool) {
        newGameMenu = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        newGameMenu.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.redeal()
        }));
        
        newGameMenu.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.replay()
        }));
                
        present(newGameMenu, animated: true, completion: nil)
    }
    
    func replay() {
        clearFirstMahjong()
        newDeal = true
        maj.replay()
        maj.south.draw(maj)
        maj.south.sort()
        maj.discardTable.resetCounts()
        discardTableView.hide()
        maj.card.clearRackFilter()
        suggestedHandsView?.showYourTiles()
        showGame()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Hand
    //
    // ----------------------------------------------------------------------------------------
    
    @objc func redeal() {
        print("redeal")
        clearFirstMahjong()
        newDeal = true
        resetMaj()
        showGame()
        suggestedHandsView?.clear()
        suggestedHandsView?.showYourTiles()
        showSuggestedHands()
    }
    
    func resetMaj() {
        app.maj = Maj()
        maj = app.maj
        maj.south.draw(maj)
        maj.discardTable.resetCounts()
        sort()
    }
    
    func sort() {
        for tile in maj.south.tiles {
            maj.east.tiles.append(tile)
        }
        maj.south.tiles = []
        
        maj.east.sort()
        for _ in 1...14 {
            let tile = maj.east.tiles.removeLast()
            maj.south.tiles.append(tile)
        }
        maj.south.sort()
    
        showHand()
    }
    
    func sortNumbers() {
        for tile in maj.south.tiles {
            maj.east.tiles.append(tile)
        }
        maj.south.tiles = []
        
        maj.east.sortNumbers()
        for _ in 1...14 {
            let tile = maj.east.tiles.removeLast()
            maj.south.tiles.append(tile)
        }
        maj.south.sortNumbers()
        
        showHand()
    }
    
    func sortOddEven() {
        for tile in maj.south.tiles {
            maj.east.tiles.append(tile)
        }
        maj.south.tiles = []
        
        maj.east.sortOddEven()
        for _ in 1...14 {
            let tile = maj.east.tiles.removeLast()
            maj.south.tiles.append(tile)
        }
        maj.south.sortOddEven()
        
        showHand()
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
        addBlanks( tileView: &handView1, col: start, row: handRow1, count: count, addGestures: false, color: HandColor)
        
        addTiles( tileView: &handView2, hand: maj.south, col: 0, row: handRow2)
        start = maj.south.tiles.count
        count = maxHandIndex - start + 1
        addBlanks( tileView: &handView2, col: start, row: handRow2, count: count, addGestures: false, color: HandColor)
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
        var count = maxHandIndex - start! + 1
        addBlanks( tileView: &rackView1, col: start!, row: rackRow1, count: count, addGestures: false, color: RackColor)
        
        addTiles( tileView: &rackView2, hand: maj.south.rack!, col: 0, row: rackRow2)
        start = maj.south.rack?.tiles.count
        count = maxHandIndex - start! + 1
        addBlanks( tileView: &rackView2, col: start!, row: rackRow2, count: count, addGestures: false, color: RackColor)
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
            addBlanks( tileView: &discardView, col: discardIndex, row: discardRow, count: 0, addGestures: false, color: RackColor)
        }
    }
    
    func checkDiscard(end: CGPoint) -> Bool {
        let endIndex = getTileIndex(end)
        if endIndex > 13 {
            return discard()
        } else if endIndex < 13 {
            return undoDiscard()
        }
        return false
    }
        
    func discard() -> Bool {
        lastMaj.copy(maj)
        maj.lastDiscard = maj.discardTile
        maj.discardLastDiscard()
        switch(maj.state) {
        case State.east:
            maj.discardTile = maj.west.getRandomDiscard(withFlowers: true)
            if maj.wall.tiles.count > 0 {
                maj.west.draw(maj)
                maj.state = State.west
            } else {
                showGameMenu(title: "Game Over", message: "Wall hand.  No tiles left.", win: false);
            }
        case State.west:
            if maj.wall.tiles.count > 0 && maj.east.tiles.count < 15 {
                maj.east.draw(maj)
                checkForMahjong()
                maj.state = State.east
            } else if maj.wall.tiles.count > 0 && maj.south.tiles.count < 15 {
                maj.south.draw(maj)
                checkForMahjong()
                maj.state = State.east
            } else {
                showGameMenu(title: "Game Over", message: "Wall hand.  No tiles left.", win: false);
            }
        default:
            print("todo discard state")
        }
        showHand()
        showLabel()
        showDiscard()
        if discardTableView.isHidden == false {
            showDiscardTable()
        }
        return true
    }
    
    func undoDiscard() -> Bool {
        print("undoDiscard")
        var undo = false
        if maj.lastDiscard != nil {
            discardTableView.countTile(maj.lastDiscard, increment: -1, maj: maj)
            maj.copy(lastMaj)
            maj.lastDiscard = nil
            discardTableView.showCounts(maj: maj)
            showHand()
            showDiscard()
            showLabel()
            undo = true
        }
        return undo
    }
    
    func addTapGestureDiscard(_ tile: UIView) {
        if maj.disableTapToDiscard == false {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureDiscard(_:)))
            tile.addGestureRecognizer(tap)
        }
    }
    
    @objc func handleTapGestureDiscard(_ sender: UITapGestureRecognizer) {
        let _ = discard()
    }
    
        
    // -----------------------------------------------------------------------------------------
    //
    //  Discard Table
    //
    // -----------------------------------------------------------------------------------------
    
    func showDiscardTable() {
        discardTableView.isHidden = false
        let margin = cardMarginX() + menuButton.frame.width
        discardTableView.show(parent: view, rowHeader: tableLocation(), maj: maj, margin: margin)
    }
    
    func hideDiscardTable() {
        discardTableView.isHidden = true
        discardTableView.hide()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  State Label
    //
    // -----------------------------------------------------------------------------------------
    
    func showLabel() {
        label?.removeFromSuperview()
       
        let width: CGFloat = 120
        let height: CGFloat = 75
        var x = (CGFloat(discardIndex) * (tileWidth() + space)) - width - (margin * 2) + notch()
        var y: CGFloat = hand2Bottom()
        
        print(view.frame.width)
        if view.frame.width < 668 {
            x = x + 50
            y = hand2Bottom() + tileHeight() - 10
        }
        
        let labelFrame = CGRect(x: x, y: y, width: width, height: height)
        label = UILabel(frame: labelFrame)
        label.text =  getStateLabel()
        label.frame = labelFrame
        label.textAlignment = .right
        label.font = UIFont(name: "Chalkduster", size: 15)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        view.addSubview(label)
    }
    
    func getStateLabel() -> String {
        var state = ""
        
        switch(maj.state) {
        case State.west: state = "Discard from West"
        default:
            if maj.discardTile == nil {
                if view.frame.width < 668 {
                    state = "Drag discard tile here \u{21E7}"
                } else {
                    state = "Drag discard tile here >"
                }
            } else {
                state = "Drag right to discard"
            }
        }

        return state
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Check for Mahjong
    //
    // -----------------------------------------------------------------------------------------
    
    func clearFirstMahjong() {
        firstMahjong = false
        firstMahjongRack1 = false
        firstMahjongRack2 = false
        firstMahjongHand1 = false
        firstMahjongHand2 = false
    }
    
    func checkForMahjong() {
        if firstMahjong == false {
            if isFirstMahjong(hand: maj.east.rack!) {
                firstMahjong = true
                firstMahjongRack1 = true
            } else if isFirstMahjong(hand: maj.south.rack!) {
                firstMahjong = true
                firstMahjongRack2 = true
            }
        } else {
            if firstMahjongRack1 == false {
                checkSecondMahjong(hand: maj.east.rack!)
            }
            if firstMahjongRack2 == false {
                checkSecondMahjong(hand: maj.south.rack!)
            }
        }
         
    }
    
    func isFirstMahjong(hand: Hand) -> Bool {
        var mahj = false
        let highest = maj.card.getClosestPattern(tiles: hand.tiles)
        if highest.matchCount == 14 {
            maj.card.saveFirstWin(pattern: highest)
            showFirstMahjong(pattern: highest)
            mahj = true
        }
        return mahj
    }
    
    func checkSecondMahjong(hand: Hand) {
        let highest = maj.card.getClosestPattern(tiles: hand.tiles)
        if highest.matchCount == 14 {
            maj.card.saveSecondWin(pattern: highest)
            showSecondMahjong(pattern: highest)
        }
    }
    
    func showFirstMahjong(pattern: LetterPattern) {
        let message = pattern.text.string + " " + pattern.note.string
        
        let alert = UIAlertController(title: "First Mahjong!", message: message, preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSecondMahjong(pattern: LetterPattern) {
        let message = pattern.text.string + " " + pattern.note.string
        
        let alert = UIAlertController(title: "Second Mahjong - You Win!", message: message, preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.redeal()
        }));
        
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.replay()
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Buttons
    //
    // -----------------------------------------------------------------------------------------
    
    func showButtons() {
        addMenuButton()
        addHandsButton()
    }
    
    func addMenuButton() {
        if menuButton == nil {
            menuButton = UIButton()
            menuButton.frame = CGRect(x: menuButtonLocationX(), y: buttonLocationY(),  width: buttonSize() + 30, height: buttonSize())
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
    
    func addHandsButton() {
        if handsButton == nil {
            handsButton = UIButton()
            handsButton.frame = CGRect(x: menuButtonLocationX(), y: buttonLocationY() - buttonSize() - 5,  width: buttonSize() + 30, height: buttonSize())
            handsButton.layer.cornerRadius = 5
            handsButton.titleLabel!.font = UIFont(name: "Chalkduster", size: 16)!
            handsButton.backgroundColor = .black
            handsButton.alpha = 0.8
            handsButton.setTitle("Hands", for: .normal)
            handsButton.addTarget(self, action: #selector(handsButtonAction), for: .touchUpInside)
            view.addSubview(handsButton)
        }
    }
    
    @objc func handsButtonAction(sender: UIButton!) {
        if discardTableView.isHidden {
            showDiscardTable()
            handsButton.setTitle("Hands", for: .normal)
            hideSuggestedHands()
        } else {
            showSuggestedHands()
        }
    }
      
    
    // -----------------------------------------------------------------------------------------
    //
    //  Suggested Hands
    //
    // -----------------------------------------------------------------------------------------
    
    func showSuggestedHands() {
        hideDiscardTable()
        handsButton.setTitle("Table", for: .normal)
        suggestedHand1?.removeFromSuperview()
        suggestedHand2?.removeFromSuperview()
        suggestedHandAlt?.removeFromSuperview()
        
        if suggestedHandsView != nil && suggestedHandsView.suggestedHandA != nil {
            let width: CGFloat = 400
            let height: CGFloat = 25
            let x = cardMarginX() + menuButton.frame.width + 15
            let y: CGFloat = tableLocation()
            
            let labelFrame = CGRect(x: x, y: y, width: width, height: height)
            suggestedHand1 = UILabel(frame: labelFrame)
            
            let text1 = NSMutableAttributedString(string: "")
            text1.append(suggestedHandsView.suggestedHandA.text)
            text1.append(NSMutableAttributedString(string: "  "))
            text1.append(suggestedHandsView.suggestedHandA.note)
            suggestedHand1.attributedText = text1
            suggestedHand1.frame = labelFrame
            suggestedHand1.textAlignment = .left
            suggestedHand1.numberOfLines = 1
            view.addSubview(suggestedHand1)
        }
        
        if suggestedHandsView != nil && suggestedHandsView.suggestedHandB != nil {
            let width: CGFloat = 400
            let height: CGFloat = 25
            let x = cardMarginX() + menuButton.frame.width + 15
            let y: CGFloat = tableLocation() + 25
            
            let labelFrame = CGRect(x: x, y: y, width: width, height: height)
            suggestedHand2 = UILabel(frame: labelFrame)
            let text2 = NSMutableAttributedString(string: "")
            text2.append(suggestedHandsView.suggestedHandB.text)
            text2.append(NSMutableAttributedString(string: "  "))
            text2.append(suggestedHandsView.suggestedHandB.note)
            suggestedHand2.attributedText = text2
            suggestedHand2.frame = labelFrame
            suggestedHand2.textAlignment = .left
            suggestedHand2.numberOfLines = 1
            view.addSubview(suggestedHand2)
        }
        
        if suggestedHandsView != nil && suggestedHandsView.suggestedHandC != nil {
            let width: CGFloat = 400
            let height: CGFloat = 25
            let x = cardMarginX() + menuButton.frame.width + 15
            let y: CGFloat = tableLocation() + 50
            
            let labelFrame = CGRect(x: x, y: y, width: width, height: height)
            suggestedHandAlt = UILabel(frame: labelFrame)
            let text3 = NSMutableAttributedString(string: "")
            text3.append(suggestedHandsView.suggestedHandC.text)
            text3.append(NSMutableAttributedString(string: "  "))
            text3.append(suggestedHandsView.suggestedHandC.note)
            suggestedHandAlt.attributedText = text3
            suggestedHandAlt.frame = labelFrame
            suggestedHandAlt.textAlignment = .left
            suggestedHandAlt.numberOfLines = 1
            view.addSubview(suggestedHandAlt)
        }
        
        if suggestedHandsView == nil || (suggestedHandsView != nil && suggestedHandsView.suggestedHandA == nil && suggestedHandsView.suggestedHandB == nil && suggestedHandsView.suggestedHandC == nil) {
            let width: CGFloat = 420
            let height: CGFloat = 50
            let x = cardMarginX() + menuButton.frame.width + 15
            let y: CGFloat = tableLocation()
            
            var labelFrame = CGRect(x: x, y: y, width: width, height: height)
            suggestedHand1 = UILabel(frame: labelFrame)
            suggestedHand1.font = UIFont(name: "Chalkduster", size: 16)!
            suggestedHand1.text = "< Show Target Hands or Discard Table"
            suggestedHand1.frame = labelFrame
            suggestedHand1.textAlignment = .left
            suggestedHand1.numberOfLines = 2
            view.addSubview(suggestedHand1)
            
            labelFrame = CGRect(x: x, y: y + 35, width: width, height: height)
            suggestedHandAlt = UILabel(frame: labelFrame)
            suggestedHandAlt.font = UIFont(name: "Chalkduster", size: 16)!
            suggestedHandAlt.text = "< Select Target Hands"
            suggestedHandAlt.frame = labelFrame
            suggestedHandAlt.textAlignment = .left
            suggestedHandAlt.numberOfLines = 1
            view.addSubview(suggestedHandAlt)
        }
    }
    
    func hideSuggestedHands() {
        suggestedHand1?.removeFromSuperview()
        suggestedHand2?.removeFromSuperview()
        suggestedHandAlt?.removeFromSuperview()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  System Menu
    //
    // -----------------------------------------------------------------------------------------
    
    func showSystemMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.redeal()
        }));
        
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.replay()
        }));
        
        alert.addAction(UIAlertAction(title: "Target Hands", style: .default, handler: {(action:UIAlertAction) in
            if self.suggestedHandsView == nil {
                self.suggestedHandsView = HandsController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self, handsControllerDelegate: self)
            } else {
                self.suggestedHandsView.showYourTiles()
            }
            self.show(self.suggestedHandsView, sender: self)
        }));
        
        alert.addAction(UIAlertAction(title: "Sort", style: .default, handler: {(action:UIAlertAction) in
            self.showSortMenu()
        }));
                
        alert.addAction(UIAlertAction(title: "History", style: .default, handler: {(action:UIAlertAction) in
            let history = HistoryController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self)
            self.show(history, sender: self)
        }));
        
        alert.addAction(UIAlertAction(title: "Help", style: .default, handler: {(action:UIAlertAction) in
            let help = HelpTableController(frame: self.view.frame, narrowViewDelegate: self)
            self.show(help, sender: self)
        }));
                
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
    func showSortMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sort by Suit", style: .default, handler: {(action:UIAlertAction) in
            self.sort()
        }));
        
        alert.addAction(UIAlertAction(title: "Sort by Numbers", style: .default, handler: {(action:UIAlertAction) in
            self.sortNumbers()
        }));
        
        alert.addAction(UIAlertAction(title: "Sort by Even then Odd", style: .default, handler: {(action:UIAlertAction) in
            self.sortOddEven()
        }));
                
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in
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
            case 4: y = hand2Bottom() + margin
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
            
            if newDeal && (row == 2 || row == 3) {
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
        } else if index > maxHandIndex + 1 {
            index = maxHandIndex + 1
        }
        return index
    }
    
    func getTileColIndex(tag: Int) -> Int {
        return tag % 100 - 1
    }
    
    func addBlanks( tileView: inout [UIView], col: Int, row: Int, count: Int, addGestures: Bool, color: UIColor) {
        let start = col
        let end = col + count
        var y: CGFloat = 0.0
        switch(row) {
            case 0: y = margin
            case 1: y = handTop()
            case 2: y = charlestonTop()
            case 3: y = handTop() + charlestonTop() - margin
            case 4: y = hand2Bottom() + margin
            default: y = 0.0
        }
        if start <= end {
            for index in start...end {
                let x = CGFloat(index) * (tileWidth() + space) + margin + notch()
                let v = UIView(frame:CGRect(x: x, y: y, width: tileWidth(),height: tileHeight()))
                v.backgroundColor = color
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
                    handlePanGestureEnded(sender)
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
    
    func handlePanGestureEnded(_ sender: UIPanGestureRecognizer) {
        let startTag = sender.view?.tag ?? 0
        let row = startTag / 100
        let end = sender.location(in: sender.view!.superview!)
        let endRow = getRow(end.y)
        var handled = false
        switch(row) {
        case 1:
            switch(endRow) {
            case 1: handled = swapInHand(hand: maj.east.rack!, end: end, startTag: startTag)
            case 2: handled = swapBetweenHands(startHand: maj.east.rack!, endHand: maj.south.rack!, end: end, startTag: startTag)
            case 3: handled = swapBetweenHands(startHand: maj.east.rack!, endHand: maj.east, end: end, startTag: startTag)
            case 4: handled = swapBetweenHands(startHand: maj.east.rack!, endHand: maj.south, end: end, startTag: startTag)
            case 5: handled = moveToDiscard(hand: maj.east.rack!, startTag: startTag)
            default: handled = false }
        case 2:
            switch(endRow) {
            case 1: handled = swapBetweenHands(startHand: maj.south.rack!, endHand: maj.east.rack!, end: end, startTag: startTag)
            case 2: handled = swapBetweenHands(startHand: maj.south.rack!, endHand: maj.south.rack!, end: end, startTag: startTag)
            case 3: handled = swapBetweenHands(startHand: maj.south.rack!, endHand: maj.east, end: end, startTag: startTag)
            case 4: handled = swapBetweenHands(startHand: maj.south.rack!, endHand: maj.south, end: end, startTag: startTag)
            case 5: handled = moveToDiscard(hand: maj.south.rack!, startTag: startTag)
            default: handled = false }
        case 3:
            switch(endRow) {
            case 1: handled = moveToRack(hand: maj.east, rack: maj.east.rack!, end: end, startTag: startTag)
            case 2: handled = moveToRack(hand: maj.east, rack: maj.south.rack!, end: end, startTag: startTag)
            case 3: handled = swapInHand(hand: maj.east, end: end, startTag: startTag)
            case 4: handled = swapBetweenHands(startHand: maj.east, endHand: maj.south, end: end, startTag: startTag)
            case 5: handled = moveToDiscard(hand: maj.east, startTag: startTag)
            default: handled = false }
        case 4:
            switch(endRow) {
            case 1: handled = moveToRack(hand: maj.south, rack: maj.east.rack!, end: end, startTag: startTag)
            case 2: handled = moveToRack(hand: maj.south, rack: maj.south.rack!, end: end, startTag: startTag)
            case 3: handled = swapBetweenHands(startHand: maj.south, endHand: maj.east, end: end, startTag: startTag)
            case 4: handled = swapInHand(hand: maj.south, end: end, startTag: startTag)
            case 5: handled = moveToDiscard(hand: maj.south, startTag: startTag)
            default: handled = false }
        case 5:
            switch(endRow) {
            case 1: handled = discardToHand(hand: maj.east.rack!, end: end)
            case 2: handled = discardToHand(hand: maj.south.rack!, end: end)
            case 3: handled = discardToHand(hand: maj.east, end: end)
            case 4: handled = discardToHand(hand: maj.south, end: end)
            case 5: handled = checkDiscard(end: end)
            default: handled = false }
        default:
            print("todo")
        }

        if !handled {
            sender.view!.center = start
        }
        
        if handled {
            checkForMahjong()
        }
    }
    
    func getRow(_ location: Double) -> Int {
        var row = 5
        if location < rack1Bottom() {
            row = 1
        } else if location < rack2Bottom() {
            row = 2
        } else if location < hand1Bottom() {
            row = 3
        } else if location < hand2Bottom() {
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
            showRack()
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
            showRack()
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
    
    func moveToDiscard(hand: Hand, startTag: Int) -> Bool {
        print("moveToDiscard")
        var moved = false
        if maj.discardTile == nil {
            let index = getTileColIndex(tag: startTag)
            if index < hand.tiles.count {
                maj.discardTile = hand.tiles[index]
                hand.tiles.remove(at: index)
                showRack()
                showHand()
                showDiscard()
                showLabel()
                moved = true
            }
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
    
    func discardToHand(hand: Hand, end: CGPoint) -> Bool {
        let endIndex = getTileIndex(end)
        if endIndex < hand.tiles.count {
            hand.tiles.insert(maj.discardTile, at: endIndex)
        } else {
            hand.tiles.append(maj.discardTile)
        }
        maj.discardTile = nil
        maj.state = State.east
        showDiscard()
        showHand()
        showRack()
        showLabel()
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
    
    func tileWidth() -> CGFloat { return (viewWidth() - notch()) / 16.5 }
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
    func controlPanelHeight() -> CGFloat { return isTall() ? 45 : 32 }
    func controlPanelLocationX() -> CGFloat { return cardMarginX() }
    func controlPanelLocationY() -> CGFloat{ return cardLocationY() + cardHeight() + 5 }
    func menuButtonLocationX() -> CGFloat { return cardMarginX() }
    func buttonLocationY() -> CGFloat { return tableLocation() + rowHeight * 4 - buttonSize() }
    func buttonSize() -> CGFloat { return controlPanelHeight() }
}

