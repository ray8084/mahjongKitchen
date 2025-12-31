//
//  ViewController.swift
//  MahjongKitchen
//
//  Created by Ray Meyer on 9/25/21.
//

import UIKit

enum ErrorId: Int { case swapInHand = 8001, toCharlestonOut, swapInRack, toRack, toDiscard, charlestonToHand, rackToDiscard }

class ViewController: UIViewController, NarrowViewDelegate, HandsControllerDelegate, SettingsDelegate  {
    
    var backgroundImageView: UIImageView!
    var viewDidAppear = false
    let RackColor = UIColor(white: 0.93, alpha: 0.7)
    let HandColor = UIColor(white: 0.99, alpha: 0.9)
    let BlankColor = UIColor(white: 0.95, alpha: 0.7)
    let BlankColorDarkMode = UIColor(white: 0.95, alpha: 0.1)
    let BackgroundColor = UIColor.init(red: 221.0/255.0, green: 226.0/255.0, blue: 219.0/255.0, alpha: 1)
    let BackgroundColorGray = UIColor.init(red: 203.0/255.0, green: 200.0/255.0, blue: 197.0/255.0, alpha: 1)
    let BackgroundColorDarkMode = UIColor.init(red: 39.0/255.0, green: 39.0/255.0, blue: 41.0/255.0, alpha: 1)
    let BackgroundColorIconRed = UIColor.init(red: 232.0/255.0, green: 54.0/255.0, blue: 49.0/255.0, alpha: 1)
    let BackgroundColorIconRedOrange = UIColor.init(red: 241.0/255.0, green: 98.0/255.0, blue: 72.0/255.0, alpha: 1)
    let ToolbarTextColor = UIColor.init(red: 95.0/255.0, green: 95.0/255.0, blue: 94.0/255.0, alpha: 1)
    
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
    var toolbar: UIView!
    var discardTableSegmentControl: UISegmentedControl!
    
    let margin: CGFloat = 5
    let space: CGFloat = 1
    let rowHeight: CGFloat = 18
    let labelOffset: CGFloat = 2
    var start = CGPoint()
    let charlestonOutIndex = 11
    let maxHandIndex = 13
    var stateLabel: UILabel!
    var wallLabel: UILabel!
    var discardIndex = 14
    var gameButton: UIButton!
    var filterButton: UIButton!
    var handsToolbarButton: UIButton!
    var handsToolbarLabel: UILabel!
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
    var secondMahjong = false
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
            enable2025(true)
            load2025()
            redeal()
            viewDidAppear = true
            // buildIcon()
            showExperiencedPlayerAlert()
        }
    }
    
    func buildIcon() {
        let v = UIImageView(frame:CGRect(x: 0, y: 0, width: 1024, height: 1024))
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.alpha = 1.0
        v.backgroundColor = BackgroundColorIconRedOrange
        v.image = UIImage(named: "TRANS-ICON-WHITE.png")
        view.addSubview(v)
        
        let title = UILabel(frame: CGRect(x: 0, y: 412, width: 1024, height: 200))
        title.text = "Two Hand"
        title.textAlignment = .center
        title.textColor = UIColor.white
        title.alpha = 1.0
        title.backgroundColor = BackgroundColorIconRedOrange
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
        backgroundImageView.alpha = 0.0
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Introductions
    //
    // -----------------------------------------------------------------------------------------
    
    func showExperiencedPlayerAlert() {
        if maj.hideIntroduction < 2 {
            let message = "Solo Practice with No Bots\nRules are NOT Enforced\nExperienced Players Only\n\nPlay two hands of Mahjong at the same time. Move tiles between hands.\n\nsupport@eightbam.com"
            let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: {(action:UIAlertAction) in
                //self.showUseYourCardAlert()
            }));
            present(alert, animated: true, completion: nil)
        }
    }
    
    func showUseYourCardAlert() {
        let message = "Send feedback to support@eightbam.com"
        let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
            self.maj.incrementHideIntroduction()
        }));
        present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Dark Mode
    //
    // -----------------------------------------------------------------------------------------
    
    func getBackgroundColor() -> UIColor {
        if #available(iOS 12.0, *) {
            if traitCollection.userInterfaceStyle == .light {
                return maj.dotTileStyle == TileStyle.classic ? BackgroundColor : BackgroundColorGray
            } else {
                return BackgroundColorDarkMode
            }
        } else {
            return BackgroundColor
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        showGame()
    }
    
    func getBlankColor() -> UIColor {
        if #available(iOS 13.0, *) {
            if traitCollection.userInterfaceStyle == .dark {
                return BlankColorDarkMode
            }
        }
        return BlankColor
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Toolbar
    //
    // -----------------------------------------------------------------------------------------
    
    func showToolbar() {
        if toolbar == nil {
            let width = isNarrow() ? 60.0 : 80.0
            let maxDimension = max(view.frame.width, view.frame.height)
            toolbar = UIView(frame: CGRect(x: maxDimension - width, y: 0, width: width, height: view.frame.height))
            toolbar.backgroundColor = .white
            toolbar.alpha = 0.9
            view.addSubview(toolbar)
            
            let offset = (width - 40) / 2
            // let gameButton = UIButton(frame: CGRect(x: offset, y: 20, width: 40, height: 40))
            let gameButton = UIButton(frame: CGRect(x: offset, y: view.frame.height - 80.0, width: 40, height: 40))
            let gameImage = UIImage(named: "play")
            gameButton.setImage(gameImage, for: .normal)
            gameButton.alpha = 0.8
            gameButton.addTarget(self, action: #selector(gameButtonAction), for: .touchUpInside)
            toolbar.addSubview(gameButton)
            //let gameLabel = UILabel(frame: CGRect(x: 0, y: 57, width: width, height: 20))
            let gameLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height - 80.0 + 37.0, width: width, height: 20))
            gameLabel.text = "Game"
            gameLabel.textAlignment = .center
            gameLabel.font = UIFont.systemFont(ofSize: 12.0)
            gameLabel.textColor = ToolbarTextColor
            gameLabel.alpha = 0.9
            toolbar.addSubview(gameLabel)
            
            let helpButton = UIButton(frame: CGRect(x: offset, y: 80, width: 40, height: 40))
            let helpImage = UIImage(named: "help")
            helpButton.setImage(helpImage, for: .normal)
            helpButton.alpha = 0.8
            helpButton.addTarget(self, action: #selector(helpButtonAction), for: .touchUpInside)
            toolbar.addSubview(helpButton)
            let helpLabel = UILabel(frame: CGRect(x: 0, y: 117, width: width, height: 20))
            helpLabel.text = "Help"
            helpLabel.textAlignment = .center
            helpLabel.font = UIFont.systemFont(ofSize: 12.0)
            helpLabel.textColor = ToolbarTextColor
            helpLabel.alpha = 0.9
            toolbar.addSubview(helpLabel)
            
            handsToolbarButton = UIButton(frame: CGRect(x: offset, y: view.frame.height - 140.0, width: 40, height: 40))
            let cardImage = UIImage(named: "card")
            handsToolbarButton.setImage(cardImage, for: .normal)
            handsToolbarButton.alpha = 0.8
            handsToolbarButton.addTarget(self, action: #selector(cardButtonAction), for: .touchUpInside)
            toolbar.addSubview(handsToolbarButton)
            handsToolbarLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height - 103.0, width: width, height: 20))
            handsToolbarLabel.text = "Hands"
            handsToolbarLabel.textAlignment = .center
            handsToolbarLabel.font = UIFont.systemFont(ofSize: 12.0)
            handsToolbarLabel.textColor = ToolbarTextColor
            handsToolbarLabel.alpha = 0.9
            toolbar.addSubview(handsToolbarLabel)
            
            // let settingsButton = UIButton(frame: CGRect(x: offset, y: view.frame.height - 80.0, width: 40, height: 40))
            let settingsButton = UIButton(frame: CGRect(x: offset, y: 20, width: 40, height: 40))
            let settingsImage = UIImage(named: "settings")
            settingsButton.setImage(settingsImage, for: .normal)
            settingsButton.alpha = 0.8
            settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
            toolbar.addSubview(settingsButton)
            //let settingsLabel = UILabel(frame: CGRect(x: 0, y: view.frame.height - 80.0 + 37.0, width: width, height: 20))
            let settingsLabel = UILabel(frame: CGRect(x: 0, y: 57, width: width, height: 20))
            settingsLabel.text = "Settings"
            settingsLabel.textAlignment = .center
            settingsLabel.font = UIFont.systemFont(ofSize: 12.0)
            settingsLabel.textColor = ToolbarTextColor
            settingsLabel.alpha = 0.9
            toolbar.addSubview(settingsLabel)
        }
        
        handsToolbarLabel.isHidden = maj.cardSettings != 99 ? true : false
        handsToolbarButton.isHidden = maj.cardSettings != 99 ? true : false
    }

    @objc func gameButtonAction(sender: UIButton!) {
        showNewGameMenu()
    }
    
    @objc func cardButtonAction(sender: UIButton!) {
        let targetHands = HandsController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self, handsControllerDelegate: self, backgroundColor: self.getBackgroundColor())
        self.show(targetHands, sender: self)
        self.discardTableSegmentControl.selectedSegmentIndex = 0
    }
    
    @objc func settingsButtonAction(sender: UIButton!) {
        if #available(iOS 12.0, *) {
            let backgroundColor = traitCollection.userInterfaceStyle == .light ? .white : BackgroundColorDarkMode
            let settings = SettingsController(maj: maj, frame: view.frame, narrowViewDelegate: self, settingsDelegate: self, backgroundColor: backgroundColor)
            self.show(settings, sender: self)
        } else {
            let settings = SettingsController(maj: maj, frame: view.frame, narrowViewDelegate: self, settingsDelegate: self, backgroundColor: BackgroundColor)
            self.show(settings, sender: self)
        }

    }
    
    @objc func helpButtonAction(sender: UIButton!) {
        let help = HelpTableController(frame: self.view.frame, narrowViewDelegate: self)
        self.show(help, sender: self)
    }
        
        
    // -----------------------------------------------------------------------------------------
    //
    //  Game
    //
    // -----------------------------------------------------------------------------------------
       
    func load2025() {
        maj.setYearSegment(segment: YearSegment.segment2025)
        redeal()
    }
    
    func enable2025(_ enable: Bool) {
        maj.enable2025 = enable
    }
    
    func showGame() {
        showButtons()
        showRack()
        showDiscard()
        showHand()
        showLabels()
        view.backgroundColor = getBackgroundColor()
        showToolbar()
        showDiscardTable()
        showButtons()
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
        sort()
        maj.discardTable.resetCounts()
        discardTableView.hide()
        maj.card.clearRackFilter()
        showGame()
        showSuggestedHands()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Hand
    //
    // ----------------------------------------------------------------------------------------
    
    @objc func redeal() {
        clearFirstMahjong()
        newDeal = true
        resetMaj()
        showGame()
        showSuggestedHands()
    }
    
    func resetMaj() {
        app.maj = Maj()
        maj = app.maj
        maj.discardTable.resetCounts()
        sort()
    }
    
    func sort() {
        maj.south.sort()
        showHand()
    }
    
    func sortNumbers() {
        maj.south.sortNumbers()
        showHand()
    }
    
    func sortOddEven() {
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
        if endIndex >= 14 {
            return discard()
        } else if endIndex < 14 {
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
        showLabels()
        showDiscard()
        showDiscardTable()
        showSuggestedHands()
        return true
    }
    
    func undoDiscard() -> Bool {
        var undo = false
        if maj.lastDiscard != nil {
            discardTableView.countTile(maj.lastDiscard, increment: -1, maj: maj)
            maj.copy(lastMaj)
            maj.lastDiscard = nil
            // discardTableView.showCounts(maj: maj)
            showHand()
            showDiscard()
            showLabels()
            showDiscardTable()
            showSuggestedHands()
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
        if discardTableSegmentControl.selectedSegmentIndex != 99 {
            discardTableView.isHidden = false
            let margin = cardMarginX() - 15
            discardTableView.show(parent: view, rowHeader: tableLocation(), maj: maj, margin: margin)
        }
    }
    
    func hideDiscardTable() {
        discardTableView.isHidden = true
        discardTableView.hide()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //   Labels
    //
    // -----------------------------------------------------------------------------------------
    
    func showLabels() {
        showStateLabel()
        showWallLabel()
        showVersionLabel()
    }
        
    func showStateLabel() {
        stateLabel?.removeFromSuperview()
       
        let width: CGFloat = 120
        let height: CGFloat = 75
        let x = (CGFloat(discardIndex) * (tileWidth() + space)) - width - (margin * 2) + notch()
        let y: CGFloat = hand2Bottom()
        
        let labelFrame = CGRect(x: x, y: y, width: width, height: height)
        stateLabel = UILabel(frame: labelFrame)
        stateLabel.text =  getStateLabel()
        stateLabel.frame = labelFrame
        stateLabel.textAlignment = .right
        stateLabel.font = UIFont(name: "Marker Felt", size: 18)
        stateLabel.numberOfLines = 0
        view.addSubview(stateLabel)
    }
    
    func showWallLabel() {
        wallLabel?.removeFromSuperview()
       
        let width: CGFloat = 100
        let height: CGFloat = 30
        let x = view.frame.width - 200
        let y: CGFloat = view.frame.height - 40
        
        let labelFrame = CGRect(x: x, y: y, width: width, height: height)
        wallLabel = UILabel(frame: labelFrame)
        wallLabel.text =  "Wall: \(maj.wall.tiles.count)"
        wallLabel.frame = labelFrame
        wallLabel.textAlignment = .right
        wallLabel.numberOfLines = 0
        view.addSubview(wallLabel)
    }
    
    func showVersionLabel() {
        if versionLabel == nil {
            let width: CGFloat = view.frame.width
            let height: CGFloat = 30
            let x = 0.0
            let y: CGFloat = view.frame.height - 40
            
            let labelFrame = CGRect(x: x, y: y, width: width, height: height)
            versionLabel = UILabel(frame: labelFrame)
            versionLabel.text =  "v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "") 2025"
            versionLabel.frame = labelFrame
            versionLabel.textAlignment = .center
            versionLabel.numberOfLines = 0
            view.addSubview(versionLabel)
        }
    }
        
    func getStateLabel() -> String {
        var state = ""
        
        switch(maj.state) {
        case State.west: state = "Discard from West"
        default:
            if maj.discardTile == nil {
                state = "Drag discard tile here >"
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
    
    func declareMahjong() {
        if firstMahjong == false {
            if isDeclareFirstMahjong(hand: maj.east) {
                firstMahjong = true
                firstMahjongHand1 = true
            } else if isDeclareFirstMahjong(hand: maj.south) {
                firstMahjong = true
                firstMahjongHand2 = true
            }
        } else {
            if firstMahjongHand1 == false {
                checkSecondMahjong(hand: maj.east)
            }
            if firstMahjongHand2 == false {
               checkSecondMahjong(hand: maj.south)
            }
        }
        
        if firstMahjong == false && secondMahjong == false {
            let message = "Move each hand into its own row."
            let alert = UIAlertController(title: "Hand not recognized", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
            }));
            present(alert, animated: true, completion: nil)
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
    
    func isDeclareFirstMahjong(hand: Hand) -> Bool {
        var mahj = false
        let highest = maj.card.getClosestPattern(tiles: hand.tiles)
        if highest.matchCount == 14 {
            maj.card.saveFirstWin(pattern: highest)
            showDeclareFirstMahjong(pattern: highest)
            mahj = true
        }
        return mahj
    }
        
    func checkSecondMahjong(hand: Hand) {
        let highest = maj.card.getClosestPattern(tiles: hand.tiles)
        if highest.matchCount == 14 {
            secondMahjong = true
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
    
    func showDeclareFirstMahjong(pattern: LetterPattern) {
        let message = pattern.text.string + " " + pattern.note.string
        
        let alert = UIAlertController(title: "First Mahjong!", message: message, preferredStyle: .alert)
                
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
            if self.firstMahjongHand1 == false {
                self.checkSecondMahjong(hand: self.maj.east)
            }
            if self.firstMahjongHand2 == false {
                self.checkSecondMahjong(hand: self.maj.south)
            }
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
        addDiscardTableSegmentControl()
    }
    
    func addDiscardTableSegmentControl() {
        if discardTableSegmentControl == nil {
            let items = ["Hands", "Discards"]
            discardTableSegmentControl = UISegmentedControl(items: items)
            discardTableSegmentControl.selectedSegmentIndex = 1
            discardTableSegmentControl.frame = CGRect(x: cardMarginX(), y: view.frame.height - 40 , width: 130, height: 30)
            discardTableSegmentControl.addTarget(self, action: #selector(changeDiscardTableSegmentControl), for: .valueChanged)
            
            if #available(iOS 13.0, *) {
            } else {
                discardTableSegmentControl.tintColor = UIColor.black
                discardTableSegmentControl.alpha = 0.7
            }
            
            view.addSubview(discardTableSegmentControl)
        }
        if maj.cardSettings != 99 {
            discardTableSegmentControl.isHidden = true
            discardTableSegmentControl.selectedSegmentIndex = 1
            hideSuggestedHands()
            showDiscardTable()
            suggestedHand1?.text = ""
        } else {
            discardTableSegmentControl.isHidden = false
            showSuggestedHands()
        }
    }
    
    @objc private func changeDiscardTableSegmentControl(sender: UISegmentedControl) {
        switch( sender.selectedSegmentIndex ) {
            case 0:
                hideDiscardTable()
                showSuggestedHands()
            default:
                showDiscardTable()
                hideSuggestedHands()
        }
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
            // handsButton.setTitle("Hands", for: .normal)
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
    
    func allTiles() -> [Tile] {
        return maj.east.tiles + maj.south.tiles + (maj.east.rack?.tiles)! + (maj.south.rack?.tiles)!
    }
    
    func showSuggestedHands() {
        if discardTableSegmentControl.selectedSegmentIndex == 99 {
            hideDiscardTable()
            suggestedHand1?.removeFromSuperview()
            suggestedHand2?.removeFromSuperview()
            suggestedHandAlt?.removeFromSuperview()
            let selectedPatterns = maj.getSelectedPatterns()
            let width = view.frame.width - 250
            
            if selectedPatterns.count > 0 {
                let height: CGFloat = 25
                let x = cardMarginX()
                let y: CGFloat = tableLocation()
                let labelFrame = CGRect(x: x, y: y, width: width, height: height)
                suggestedHand1 = UILabel(frame: labelFrame)
                let text1 = NSMutableAttributedString(string: "")
                selectedPatterns[0].match(allTiles(), ignoreFilters: true)
                text1.append(NSMutableAttributedString(string: "\(selectedPatterns[0].matchCount)     "))
                text1.append(selectedPatterns[0].getDarkModeString())
                text1.append(NSMutableAttributedString(string: "     "))
                text1.append(selectedPatterns[0].note)
                suggestedHand1.attributedText = text1
                suggestedHand1.frame = labelFrame
                suggestedHand1.textAlignment = .left
                suggestedHand1.numberOfLines = 1
                view.addSubview(suggestedHand1)
            }
            
            if selectedPatterns.count > 1 {
                let height: CGFloat = 25
                let x = cardMarginX()
                let y: CGFloat = tableLocation() + 25
                let labelFrame = CGRect(x: x, y: y, width: width, height: height)
                suggestedHand2 = UILabel(frame: labelFrame)
                let text2 = NSMutableAttributedString(string: "")
                selectedPatterns[1].match(allTiles(), ignoreFilters: true)
                text2.append(NSMutableAttributedString(string: "\(selectedPatterns[1].matchCount)     "))
                text2.append(selectedPatterns[1].getDarkModeString())
                text2.append(NSMutableAttributedString(string: "     "))
                text2.append(selectedPatterns[1].note)
                suggestedHand2.attributedText = text2
                suggestedHand2.frame = labelFrame
                suggestedHand2.textAlignment = .left
                suggestedHand2.numberOfLines = 1
                view.addSubview(suggestedHand2)
            }
            
            if selectedPatterns.count > 2 {
                let height: CGFloat = 25
                let x = cardMarginX()
                let y: CGFloat = tableLocation() + 50
                let labelFrame = CGRect(x: x, y: y, width: width, height: height)
                suggestedHandAlt = UILabel(frame: labelFrame)
                let text3 = NSMutableAttributedString(string: "")
                selectedPatterns[2].match(allTiles(), ignoreFilters: true)
                text3.append(NSMutableAttributedString(string: "\(selectedPatterns[2].matchCount)     "))
                text3.append(selectedPatterns[2].getDarkModeString())
                text3.append(NSMutableAttributedString(string: "     "))
                text3.append(selectedPatterns[2].note)
                suggestedHandAlt.attributedText = text3
                suggestedHandAlt.frame = labelFrame
                suggestedHandAlt.textAlignment = .left
                suggestedHandAlt.numberOfLines = 1
                view.addSubview(suggestedHandAlt)
            }
            
            if selectedPatterns.count == 0 {
                let height: CGFloat = 60
                let x = cardMarginX()
                let y: CGFloat = tableLocation()
                
                let labelFrame = CGRect(x: x, y: y, width: width - 100, height: height)
                suggestedHand1 = UILabel(frame: labelFrame)
                suggestedHand1.font = UIFont(name: "Chalkduster", size: 16)!
                suggestedHand1.text = maj.cardSettings == 0 ? "" : "Use the toolbar to the right to select hands to see here, or use your card."
                suggestedHand1.frame = labelFrame
                suggestedHand1.textAlignment = .left
                suggestedHand1.numberOfLines = 2
                view.addSubview(suggestedHand1)
            }
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
        
        alert.addAction(UIAlertAction(title: "Select Target Hands", style: .default, handler: {(action:UIAlertAction) in
            let targetHands = HandsController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self, handsControllerDelegate: self, backgroundColor: self.getBackgroundColor())
            self.show(targetHands, sender: self)
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
    
    func showNewGameMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.redeal()
        }));
        
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.replay()
        }));
                
        //alert.addAction(UIAlertAction(title: "History", style: .default, handler: {(action:UIAlertAction) in
        //    let history = HistoryController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self)
        //    self.show(history, sender: self)
        //}));
        
        //alert.addAction(UIAlertAction(title: "Declare Mahjong", style: .default, handler: {(action:UIAlertAction) in
        //    self.declareMahjong()
        //}));
                        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
        
    func showSettingsMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Classic Tiles", style: .default, handler: {(action:UIAlertAction) in
            self.maj.setDotTileStyle(style: TileStyle.classic)
            self.showGame()
        }));
        
        alert.addAction(UIAlertAction(title: "Light Tiles", style: .default, handler: {(action:UIAlertAction) in
            self.maj.setDotTileStyle(style: TileStyle.light)
            self.showGame()
        }));
        
        alert.addAction(UIAlertAction(title: "Large Font Tiles", style: .default, handler: {(action:UIAlertAction) in
            self.maj.setDotTileStyle(style: TileStyle.largeFont)
            self.showGame()
        }));
        
        alert.addAction(UIAlertAction(title: "Dark Tiles", style: .default, handler: {(action:UIAlertAction) in
            self.maj.setDotTileStyle(style: TileStyle.dark)
            self.showGame()
        }));
        
        alert.addAction(UIAlertAction(title: "Solid Color Tiles", style: .default, handler: {(action:UIAlertAction) in
            self.maj.setDotTileStyle(style: TileStyle.solid)
            self.showGame()
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
                v.backgroundColor = getBlankColor()
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
        showSuggestedHands()
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
                showLabels()
                showSuggestedHands()
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
        showLabels()
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
    
    func tileWidth() -> CGFloat { return (viewWidth() - notch()) / 17.5 }
    func tileHeight() -> CGFloat { return tileWidth() * 62.5 / 46.0 }
    
    func notch() -> CGFloat {
        var notch = CGFloat(0)
        if #available(iOS 11.0, *) {
            notch = UIApplication.shared.keyWindow?.safeAreaInsets.left ?? 0
        }
        return notch
    }
    
    func isTall() -> Bool { return viewHeight() > 500 }
    func isNarrow() -> Bool {
        print(view.frame.width)
        return view.frame.width < 668
    }
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
    // func menuButtonLocationX() -> CGFloat { return cardMarginX() }
    func menuButtonLocationX() -> CGFloat { return view.frame.width - controlPanelHeight() - 40 }
    // func buttonLocationY() -> CGFloat { return tableLocation() + buttonSize() + 10}
    func buttonLocationY() -> CGFloat { return 80}
    func buttonSize() -> CGFloat { return controlPanelHeight() }
}

