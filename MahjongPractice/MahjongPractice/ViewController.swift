//
//  ViewController.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 9/25/21.
//

import UIKit

enum ErrorId: Int { case swapInHand = 801, toCharlestonOut, swapInRack, toRack, toDiscard, charlestonToHand, rackToDiscard }

class ViewController: UIViewController, GameDelegate, NarrowViewDelegate, SettingsDelegate, ValidationViewDelegate  {
    
    var revenueCat: RevenueCat!
    var backgroundImageView: UIImageView!
    var viewDidAppear = false
    let BlankColor = UIColor(white: 0.95, alpha: 0.7)
    let BackgroundColor = UIColor.init(red: 225.0/255.0, green: 230.0/255.0, blue: 223.0/255.0, alpha: 1)
    let BackgroundColorDarkMode = UIColor.init(red: 225.0/255.0, green: 230.0/255.0, blue: 223.0/255.0, alpha: 1)
    
    var maj: Maj!
    var lastMaj: Maj!
    let app = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard

    var handView: [UIView] = []
    var rackView: [UIView] = []
    var charlestonOutView: [UIView] = []
    var discardView: [UIView] = []
    var cardView = CardView()
    let tileMatchView = TileMatchView()
    let botView = BotView()
    var discardTableView = DiscardTableView()
    var validationView = ValidationView()
    
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
    let rackRow = 0
    let handRow = 1
    let discardRow = 2
    var winCounted = false
    var lossCounted = false
    var rackingInProgress = false
    
    var menuButton: UIButton!
    var settingsButton: UIButton!
    var helpButton: UIButton!
    var sortButton1: UIButton!
    var sortButton2: UIButton!
    var controlPanel: UISegmentedControl!
    var versionLabel: UILabel!
    var yearLabel: UILabel!
    var eightbamLabel: UILabel!
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Init
    //
    // -----------------------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        maj = app.maj
        maj.loadSavedValues()
        tileMatchView.loadPatterns(maj: maj, letterPatterns: maj.card.letterPatterns)
        lastMaj = Maj(maj)
        revenueCat = RevenueCat(viewController: self, gameDelegate: self)
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
            revenueCat.start()
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

    func getMaj() -> Maj {
        return maj
    }
    
    func override2021() -> Bool {
        return maj.override2021
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Game
    //
    // -----------------------------------------------------------------------------------------
    
    func load2021() {
        changeYear(YearSegment.segment2021)
        redeal()
    }
    
    func load2022() {
        changeYear(YearSegment.segment2022)
        redeal()
    }
    
    func enable2020(_ enable: Bool) {
        maj.enable2020 = enable
    }
    
    func enable2021(_ enable: Bool) {
        maj.enable2021 = enable
    }
    
    func enable2022(_ enable: Bool) {
        maj.enable2022 = enable
    }
    
    func showGame() {
        if maj.isCharlestonActive() {
            clearRack()
            showCharlestonOut()
        } else {
            showRack()
            showDiscard()
            clearCharlestonOut()
            showDiscardTable()
        }
        showHand()
        showLabel()
        showButtons()
        showControlPanel()
        cardView.update(maj)
        tileMatchView.update(maj)
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
            cardView.update(maj)
            tileMatchView.update(maj)
        }
        if maj.isGameOver() && eastWon {
            addWin()
            showWinMenu()
        } else if maj.isGameOver() && !lossCounted {
            addLoss()
            showGameMenu(title: "Game", message: "", win: false)
        } else {
            showGameMenu(title: "Game", message: "", win: false);
        }
    }
    
    func addWin() {
        if winCounted == false {
            maj.card.addWin(maj.card.winningIndex((maj.east.rack?.jokerCount())!))
            winCounted = true
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
        if (maj.unrecognizedHandDeclared() == false) {
            let title = "Mahjong - You Win!"
            let message = maj.card.winningHand(maj: maj)
            showGameMenu(title: title, message: message, win: true)
        }
    }
    
    func showGameMenu(title: String, message: String, win: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.cardView.update(maj)
        self.tileMatchView.update(maj)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default, handler: {(action:UIAlertAction) in
            self.newGameAction(win)
        }));
        
        alert.addAction(UIAlertAction(title: "Replay", style: .default, handler: {(action:UIAlertAction) in
            self.replay()
        }));
        
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
        
    func newGameAction(_ win: Bool) {
        self.revenueCat.refreshPurchaseInfo()
        if (self.maj.enable2021 == false) && (self.maj.enable2020 == false){
            self.revenueCat.showPurchaseMenu(self)
        } else if self.maj.shuffleWithSeed {
            self.showShuffleKeywordMenu()
        } else if win && (self.maj.card.getTotalWinCount() > 2 ) {
            AppStoreHistory.store.requestReview()
            self.redeal()
        } else {
            self.redeal()
        }
        eightbamLabel.isHidden = false
    }
        
    func eastWon() {
        cardView.updateRackFilter(maj)
        tileMatchView.updateRackFilter(maj)
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
        tileMatchView.clearRackFilter()
        showGame()
        botView.showHighestPatternMatch = false
        hideBotView()
        showBottomView()
        eightbamLabel.isHidden = false
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
        tileMatchView.loadPatterns(maj: maj, letterPatterns: maj.card.letterPatterns)
        discardTableView.hide()
        tileMatchView.clearRackFilter()
        showGame()
        botView.showHighestPatternMatch = false
        hideBotView()
        showBottomView()
        yearLabel?.text = maj.getYearText()
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
        for view in handView {
            view.removeFromSuperview()
        }
        handView = []
    }
        
    func showHand() {
        clearHand()
        addTiles( tileView: &handView, hand: maj.east, col: 0, row: handRow)
        let start = maj.east.tiles.count
        let count = maxHandIndex - start
        addBlanks( tileView: &handView, col: start, row: handRow, count: count, addGestures: false)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Rack
    //
    // -----------------------------------------------------------------------------------------
    
    func clearRack() {
        for view in rackView {
            view.removeFromSuperview()
        }
        rackView = []
    }

    func showRack() {
        clearRack()
        addTiles( tileView: &rackView, hand: maj.east.rack!, col: 0, row: rackRow)
        let start = maj.east.rack?.tiles.count
        let count = maxHandIndex - start!
        addBlanks( tileView: &rackView, col: start!, row: rackRow, count: count, addGestures: false)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Charleston
    //
    // -----------------------------------------------------------------------------------------
    
    func nextCharleston() -> Bool {
        maj.nextCharleston()
        showGame()
        botView.update(maj)
        if maj.isCharlestonActive() == false {
            if discardTableView.isHidden == false {
                discardTableView.show(parent: view, rowHeader: tableLocation(), maj: maj, margin: cardMarginX())
            }
        }
        eightbamLabel.isHidden = !maj.isCharlestonActive()
        return true
    }
  
    func clearCharlestonOut() {
        for view in charlestonOutView {
            view.removeFromSuperview()
        }
        charlestonOutView = []
    }
    
    func showCharlestonOut() {
        clearDiscard()
        clearCharlestonOut()
        addTiles( tileView: &charlestonOutView, hand: maj.charleston, col: charlestonOutIndex, row: discardRow)

        let start = charlestonOutIndex + maj.charleston.tiles.count
        let end = maj.maxHand - 1
        let addGestures = maj.charlestonState == 6 || maj.charlestonState == 3 || maj.isBlindPass()
        addBlanks( tileView: &charlestonOutView, col: start, row: discardRow, count: end-start, addGestures: addGestures)
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
        let movedLeft = start.x > location.x
        return movedLeft
    }
    
    func undoDiscard() -> Bool {
        var undo = false
        if (maj.lastDiscard != nil) && !maj.disableUndo {
            discardTableView.countTile(maj.lastDiscard, increment: -1, maj: maj)
            maj.copy(lastMaj)
            showDiscard()
            showLabel()
            maj.lastDiscard = nil
            undo = true
            cardView.update(maj)
            tileMatchView.update(maj)
            botView.update(maj)
            discardTableView.showCounts(maj: maj)
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
    
    func showValidationView() {
        validationView.show(view, maj: maj, delegate: self)
    }
    
    func closeValidationView() {
        validationView.removeFromSuperview()
        validationView.closeButton.removeFromSuperview()
        showGameMenu(title: "Game", message: "", win: false)
    }
    
    func showRackError(_ message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        
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
        discardTableView.show(parent: view, rowHeader: tableLocation(), maj: maj, margin: cardMarginX())
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
        var width: CGFloat = 120
        var height: CGFloat = 50
        var x = (CGFloat(discardIndex) * (tileWidth() + space)) - width - (margin * 2) + notch()
        var y: CGFloat = charlestonTop()
        if maj.isCharlestonActive() {
            width = 300
            x = (CGFloat(charlestonOutIndex) * (tileWidth() + space)) - width - (margin * 2) + notch()
            y = row1()
        } else if maj.stateLabel() == "Discard >" {
            height = 20
        }
        let labelFrame = CGRect(x: x, y: y, width: width, height: height)
        label = UILabel(frame: labelFrame)
        label.text =  maj.stateLabel()
        label.frame = labelFrame
        label.textAlignment = .right
        label.font = UIFont(name: "Chalkduster", size: 15)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        view.addSubview(label)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Buttons
    //
    // -----------------------------------------------------------------------------------------
    
    func showButtons() {
        addHelpButton()
        addSettingsButton()
        addMenuButton()
        addSortButton()
    }
    
    func addHelpButton() {
        if helpButton == nil {
            helpButton = UIButton()
            helpButton.frame = CGRect(x: helpButtonLocationX(), y: buttonLocationY(),  width: buttonSize()+20, height: buttonSize())
            helpButton.layer.cornerRadius = 5
            helpButton.titleLabel!.font = UIFont(name: "Chalkduster", size: 16)!
            helpButton.backgroundColor = .black
            helpButton.setTitle("Help", for: .normal)
            helpButton.alpha = 0.8
            helpButton.addTarget(self, action: #selector(helpButtonAction), for: .touchUpInside)
            view.addSubview(helpButton)
        }
    }
    
    func addSettingsButton() {
        if settingsButton == nil {
            settingsButton = UIButton()
            settingsButton.frame = CGRect(x: settingsButtonLocationX(), y: buttonLocationY(),  width: buttonSize(), height: buttonSize())
            let image = UIImage(named: "sideButtonSettings.png")
            settingsButton.setImage(image, for: .normal)
            settingsButton.imageView?.contentMode = .scaleAspectFit
            settingsButton.alpha = 0.95
            settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
            view.addSubview(settingsButton)
        }
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
    
    func addSortButton() {
        if sortButton1 == nil {
            sortButton1 = UIButton()
            let x = controlPanelLocationX()
            let y = charlestonTop()
            sortButton1.frame = CGRect(x: x, y: y,  width: buttonSize() + 20, height: buttonSize())
            sortButton1.layer.cornerRadius = 5
            sortButton1.titleLabel!.font = UIFont(name: "Chalkduster", size: 16)!
            sortButton1.backgroundColor = .white
            sortButton1.alpha = 0.8
            sortButton1.setTitle("Sort", for: .normal)
            sortButton1.setTitleColor(.black, for: .normal)
            sortButton1.addTarget(self, action: #selector(sortButtonAction), for: .touchUpInside)
            view.addSubview(sortButton1)
        }
        if sortButton2 == nil {
            sortButton2 = UIButton()
            let x = controlPanelLocationX() + ((tileWidth() + space) * 9)
            let y = charlestonTop()
            sortButton2.frame = CGRect(x: x, y: y,  width: buttonSize() + 20, height: buttonSize())
            sortButton2.layer.cornerRadius = 5
            sortButton2.titleLabel!.font = UIFont(name: "Chalkduster", size: 16)!
            sortButton2.backgroundColor = .white
            sortButton2.alpha = 0.8
            sortButton2.setTitle("Sort", for: .normal)
            sortButton2.setTitleColor(.black, for: .normal)
            sortButton2.addTarget(self, action: #selector(sortButtonAction), for: .touchUpInside)
            view.addSubview(sortButton2)
        }
        sortButton1.isHidden = !maj.isCharlestonActive()
        sortButton2.isHidden = maj.isCharlestonActive()
    }
    
    @objc func helpButtonAction(sender: UIButton!) {
        let help = HelpTableController(frame: view.frame, narrowViewDelegate: self)
        show(help, sender: self)
    }
        
    @objc func settingsButtonAction(sender: UIButton!) {
        let settings = SettingsViewController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self, settingsDelegate: self, revenueCat: revenueCat)
        show(settings, sender: self)
    }
    
    @objc func menuButtonAction(sender: UIButton!) {
        showSystemMenu()
    }
    
    @objc func sortButtonAction(sender: UIButton!) {
        if maj.hideSortMessage == false {
            let message = "Sort alternates between suits and numbers. Tap twice to resort with same method."
            let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
                self.maj.userSort()
                self.showHand()
            }));
            present(alert, animated: false, completion: nil)
        } else {
            self.maj.userSort()
            self.showHand()
        }
    }

    func helpButtonLocationX() -> CGFloat { return viewWidth() - buttonSize() - 15 - 30 }
    func menuButtonLocationX() -> CGFloat { return settingsButton.frame.origin.x - buttonSize() - 20 - 15 }
    func settingsButtonLocationX() -> CGFloat { return helpButton.frame.origin.x - buttonSize() - 15 }
    func buttonLocationY() -> CGFloat { return controlPanelLocationY() }
    func buttonSize() -> CGFloat { return controlPanelHeight() }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Segmented Control Panel
    //
    // -----------------------------------------------------------------------------------------
    
    func showControlPanel() {
        if controlPanel == nil {
            let items = ["Bots", "Patterns", "Tiles"]
            controlPanel = UISegmentedControl(items: items)
            controlPanel.frame = CGRect(x: controlPanelLocationX(), y: controlPanelLocationY(), width: controlPanelWidth(), height: controlPanelHeight())
            setSegmentColors(controlPanel, chalkduster: true)
            controlPanel.addTarget(self, action: #selector(controlPanelValueChanged), for: .valueChanged)
            view.addSubview(controlPanel)
        }
        if versionLabel == nil {
            versionLabel = UILabel()
            versionLabel.frame = CGRect(x: controlPanel.frame.origin.x + controlPanel.frame.width + 15, y: controlPanelLocationY(), width: 100, height: controlPanelHeight())
            versionLabel.textColor = UIColor.black
            versionLabel.text = "v" + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
            view.addSubview(versionLabel)
        }
        if yearLabel == nil {
            yearLabel = UILabel()
            yearLabel.frame = CGRect(x: helpButtonLocationX() - 80, y: controlPanelLocationY() - buttonSize() - buttonSize() - 10, width: 150, height: 100)
            yearLabel.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.bold)
            yearLabel.textColor = .white
            yearLabel.alpha = 0.5
            yearLabel.text = maj.getYearText()
            view.addSubview(yearLabel)
        }
        if eightbamLabel == nil {
            eightbamLabel = UILabel()
            eightbamLabel.frame = CGRect(x: cardMarginX(), y: tileHeight() - 40, width: 500, height: 40)
            // eightbamLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
            eightbamLabel.font = UIFont(name: "Chalkduster", size: 16)
            // titleLabel.textColor = UIColor(red: 114/255, green: 123/255, blue: 102/255, alpha: 1.0)
            eightbamLabel.textColor = .black
            eightbamLabel.textAlignment = .left
            eightbamLabel.text = "American Mahjong Practice"
            view.addSubview(eightbamLabel)
        }
    }
    
    func setSegmentColors(_ segment: UISegmentedControl, chalkduster: Bool) {
        let font = UIFont(name: "Chalkduster", size: 16)
        if #available(iOS 13.0, *) {
            segment.selectedSegmentTintColor = UIColor.white
            if chalkduster {
                let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: font! ]
                segment.setTitleTextAttributes(titleTextAttributes, for:.normal)
                segment.setTitleTextAttributes(titleTextAttributes, for:.selected)
            } else {
                let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black ]
                segment.setTitleTextAttributes(titleTextAttributes, for:.normal)
                segment.setTitleTextAttributes(titleTextAttributes, for:.selected)
            }
        } else {
            if chalkduster {
                segment.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
            }
            segment.tintColor = UIColor(white: 0.1, alpha: 1)
        }
    }
    
    @objc func controlPanelValueChanged(_ sender: Any) {
        switch (sender as AnyObject).selectedSegmentIndex {
        case 1:
            triggerCardView()
            defaults.set(1, forKey: "controlPanel")
        case 2:
            triggerTileMatchView()
            defaults.set(2, forKey: "controlPanel")
        default:
            triggerBotView()
            defaults.set(0, forKey: "controlPanel")
        }
    }
    
    func triggerCardView() {
        hideTileMatchView()
        hideBotView()
        if cardView.isHidden {
            showCard()
            cardView.updateRackFilter(maj)
        } else {
            hideCard()
        }
    }
    
    func triggerTileMatchView() {
        hideCard()
        hideBotView()
        if tileMatchView.isHidden {
            showTileMatchView()
            tileMatchView.updateRackFilter(maj)
        } else {
            hideTileMatchView()
        }
    }
    
    func triggerBotView() {
        hideCard()
        hideTileMatchView()
        if botView.isHidden {
            showBotView()
        } else {
            hideBotView()
        }
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Bottom views
    //
    // -----------------------------------------------------------------------------------------
    
    func updateViews() {
        cardView.filter(maj)
        cardView.update(maj)
        tileMatchView.update(maj)
    }
    
    func showBottomView() {
        switch(controlPanel.selectedSegmentIndex) {
            case 0: showBotView()
            case 1: showCard()
            case 2: showTileMatchView()
            default:
                controlPanel.selectedSegmentIndex = 1
                showCard()
        }
    }
    
    func showCard() {
        if maj.isCharlestonActive() {
            hideBotView()
        }
        if maj.isGameOver() {
            maj.card.clearRackFilter()
        }
        cardView.isHidden = false
        cardView.showCard(self, x: cardMarginX(), y: cardLocationY(), width: cardWidth(), height: cardHeight(), bgcolor: self.getBackgroundColor(), maj: maj)
        view.addSubview(cardView.cardView)
        cardView.update(maj)
    }
   
    func hideCard() {
        cardView.isHidden = true
        cardView.cardView.removeFromSuperview()
    }
    
    func showTileMatchView() {
        if maj.isCharlestonActive() {
            hideBotView()
        }
        tileMatchView.isHidden = false
        tileMatchView.showView(self, x: cardMarginX(), y: cardLocationY(), width: cardWidth(), height: cardHeight(), bgcolor: getBackgroundColor())
        view.addSubview(tileMatchView.tableView)
        tileMatchView.update(maj)
    }
    
    func hideTileMatchView() {
        tileMatchView.isHidden = true
        tileMatchView.tableView.removeFromSuperview()
    }
    
    func showBotView() {
        hideCard()
        hideTileMatchView()
        if maj.isCharlestonActive() == false {
            botView.isHidden = false
            botView.showView(self, x: cardMarginX(), y: cardLocationPhone(), width: cardWidth(), height: botHeight(), blankColor: BlankColor)
            view.addSubview(botView.tableView)
            botView.update(maj)
        }
    }
    
    func hideBotView() {
        if isTall() == false || maj.isCharlestonActive() {
            botView.isHidden = true
            botView.tableView.removeFromSuperview()
        }
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
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: {(action:UIAlertAction) in
            let settings = SettingsViewController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self, settingsDelegate: self, revenueCat: self.revenueCat)
            self.show(settings, sender: self)
        }));
        
        alert.addAction(UIAlertAction(title: "Stats", style: .default, handler: {(action:UIAlertAction) in
            let stats = StatViewController(maj: self.maj, frame: self.view.frame, narrowViewDelegate: self)
            self.show(stats, sender: self)
        }));
        
        if self.maj.enable2021 == false {
            alert.addAction(UIAlertAction(title: "2022 Pattern Access", style: .default, handler: {(action:UIAlertAction) in
                self.revenueCat.showPurchaseMenu(self)
            }));
        }
        
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Shuffle Keyword
    //
    // -----------------------------------------------------------------------------------------
    
    func showShuffleKeywordMenu() {
        let title = "Duplicate Enabled"
        let message = "Duplicate mode is enabled with keyword \(maj.shuffleSeed).  Every hand will be the same every time for all users with this keyword."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Disable Duplicate", style: .default, handler: {(action:UIAlertAction) in
            self.maj.setShuffleWithSeed(false)
            self.redeal()
        }));
        
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action:UIAlertAction) in
            self.redeal()
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
            
            if newDeal && (row == 1) {
                UIView.animate(withDuration: 0.5, delay: 0.2, options: [],
                    animations: {v.center.x += x},
                    completion: nil
                )
            }
        }
        if row == 1 {
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
            if index < handView.count {
                let view = handView[index] as! UIImageView
                view.image = UIImage(named: tile.getImage(maj:maj))
            }
        }
        
        for (index, tile) in maj.east.rack!.tiles.enumerated() {
            if index < rackView.count {
                let view = rackView[index] as! UIImageView
                view.image = UIImage(named: tile.getImage(maj:maj))
            }
        }
        
        tileMatchView.update(maj)
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
                if sender.view!.superview != nil { handlePanGestureEnded(sender) }
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
        let didStartRack = isRack(tag: startTag)
        let didStartHand = isHand(tag: startTag)
        let didStartDiscard = isDiscard(tag: startTag) && !maj.isCharlestonActive()
        let didStartCharlestonOut = isCharlestonOut(tag: startTag)
        let end = sender.location(in: sender.view!.superview!)
        var handled = false
        if didStartHand && isHand(end) {
            handled = swapInHand(end: end, startTag: startTag)
        } else if maj.isCharlestonActive() && didStartHand && isCharlestonOut(end) {
            handled = moveToCharlestonOut(end: end, startTag: startTag)
        } else if maj.isCharlestonActive() && didStartCharlestonOut && isHand(end) {
            handled = charlestonToHand(startTag: startTag)
        } else if maj.isCharlestonActive() && didStartCharlestonOut && maj.isCharlestonOutDone() && isCharlestonOut(end) {
            handled = nextCharleston()
        } else if maj.isCharlestonActive() && didStartCharlestonOut && maj.isCharlestonOutDone() && offScreen(end) {
            handled = nextCharleston()
        } else if didStartHand && isRack(end) {
            handled = moveToRack(end: end, startTag: startTag)
            validatePending = true
        } else if didStartRack && isHand(end) {
            handled = removeFromRack(end: end, startTag: startTag)
        } else if didStartRack && isRack(end) {
            handled = swapInRack(end: end, startTag: startTag)
        } else if didStartHand && isDiscard(end) {
            handled = moveToDiscard(startTag: startTag)
            validateRack(maj)
        } else if didStartDiscard && isHand(end) {
            handled = discardToHand(end: end)
        } else if didStartDiscard && shouldRemoveDiscard(start, location: end) {
            handled = nextState()
        } else if didStartDiscard && isRack(end) {
            handled = moveFromDiscardToRack(end: end)
            validatePending = true
        } else if didStartRack && isDiscard(end) {
            handled = rackToDiscard(end: end, startTag: startTag)
        } else if didStartDiscard && shouldUndoDiscard(start, location: end) {
            handled = undoDiscard()
        } else if didStartHand && isBot(end) {
            handled = stealJoker(tag: startTag)
        }
        if !handled {
            sender.view!.center = start
        }
    }

    func getTile(location: CGPoint) -> Tile{
        var tile = Tile()
        if isHand(location) {
            let index = getTileIndex(location)
            if index < maj.east.tiles.count {
                tile = maj.east.tiles[index]
            }
        }
        return tile
    }
    
    func getTile(tag: Int) -> Tile {
        var tile = Tile()
        if isHand(tag: tag) {
            let index = getTileColIndex(tag: tag)
            if index < maj.east.tiles.count {
                tile = maj.east.tiles[index]
            }
        }
        return tile
    }
    
    func stealJoker(handLocation: CGPoint) -> Bool {
        let steal = maj.stealJoker(tile: getTile(location: start))
        if steal {
            botView.update(maj)
            showHand()
        }
        return steal
    }
    
    func stealJoker(tag: Int) -> Bool {
        let steal = maj.stealJoker(tile: getTile(tag: tag))
        if steal {
            botView.update(maj)
            showHand()
        }
        return steal
    }
    
    func swapInHand(end: CGPoint, startTag: Int) -> Bool {
        var swapped = false
        let startIndex = getTileColIndex(tag: startTag)
        let endIndex = getTileIndex(end)
        if startIndex < maj.east.tiles.count {
            let tile = maj.east.tiles.remove(at: startIndex)
            if endIndex >= maj.east.tiles.count {
                maj.east.tiles.append(tile)
            } else {
                maj.east.tiles.insert(tile, at: endIndex)
            }
            showHand()
            swapped = true
        } else {
            showDebugMessage(ErrorId.swapInHand)
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
            markJoker(tile, index: endIndex)
            swapped = true
        } else {
            showDebugMessage(ErrorId.swapInRack)
        }
        return swapped
    }
    
    func moveToCharlestonOut(end: CGPoint, startTag: Int) -> Bool {
        var moved = false
        if maj.charleston.tiles.count < maj.maxCharleston {
            let startIndex = getTileColIndex(tag: startTag)
            if startIndex < maj.east.tiles.count {
                maj.charleston.tiles.append(maj.east.tiles[startIndex])
                maj.east.tiles.remove(at: startIndex)
                showHand()
                showCharlestonOut()
                cardView.update(maj)
                tileMatchView.update(maj)
                if label != nil {
                    label.text = maj.stateLabel()
                }
                moved = true
            } else {
                showDebugMessage(ErrorId.toCharlestonOut)
            }
        }
        return moved
    }
    
    func moveToDiscard(startTag: Int) -> Bool {
        var moved = false
        if maj.discardTile == nil {
            let index = getTileColIndex(tag: startTag)
            if index < maj.east.tiles.count {
                maj.discardTile = maj.east.tiles[index]
                maj.east.tiles.remove(at: index)
                showHand()
                showDiscard()
                cardView.update(maj)
                tileMatchView.update(maj)
                moved = true
            } else {
                showDebugMessage(ErrorId.toDiscard)
            }
            rackingInProgress = false
        }
        return moved
    }
    
    func moveToRack(end: CGPoint, startTag: Int) -> Bool {
        var moved = false
        if maj.isCharlestonActive() == false {
            let startIndex = getTileColIndex(tag: startTag)
            let endIndex = getTileIndex(end)
            if startIndex < maj.east.tiles.count {
                let tile = maj.east.tiles.remove(at: startIndex)
                if tile.isJoker() && !rackingInProgress {
                    showJokerExposeLastMessage()
                    maj.east.tiles.append(tile)
                } else {
                    if endIndex < (maj.east.rack?.tiles.count)! {
                        maj.east.rack?.tiles.insert(tile,at: endIndex)
                    } else {
                        maj.east.rack?.tiles.append(tile)
                    }
                    if maj.east.rack?.tiles.count == 14 {
                        maj.card.match(maj.east.tiles + (maj.east.rack?.tiles)!, ignoreFilters: false)
                        gameOver()
                    }
                    rackingInProgress = true
                    showHand()
                    showRack()
                    maj.letterPatternRackFilterPending = true
                    maj.tileMatchesRackFilterPending = true
                    markJoker(tile, index: endIndex)
                    moved = true
                    
                    let message = maj.card.winningHand(maj: maj)
                    if (maj.east.rack?.tiles.count == 14) && (message.count == 0) {
                        showValidationView()
                    }
                }
            } else {
                showDebugMessage(ErrorId.toRack)
            }
        }
        return moved
    }
    
    func markJoker(_ tile: Tile, index: Int) {
        if (tile.isJoker()) {
            maj.east.rack?.markJoker(joker: tile, index: index)
        }
    }
    
    func showJokerExposeLastMessage() {
        let title = "Joker"
        let message = "Please expose numbers, dragons, flowers and wind tiles before jokers.\n This is not a Mahjong rule, it just helps our app reliabliy identify jokers. Jokers replace the tile to the left."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        
        present(alert, animated: true, completion: nil)
    }
    
    func charlestonToHand(startTag: Int) -> Bool {
        var removed = false
        let index = getTileColIndex(tag: startTag) - charlestonOutIndex
        if index < maj.charleston.tiles.count {
            let tile = maj.charleston.tiles.remove(at: index)
            maj.east.tiles.append(tile)
            showHand()
            showCharlestonOut()
            removed = true
            cardView.update(maj)
            tileMatchView.update(maj)
            botView.update(maj)
            label.text = maj.stateLabel()
        } else {
            showDebugMessage(ErrorId.charlestonToHand)
        }
        return removed
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
            cardView.update(maj)
            tileMatchView.update(maj)
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
            cardView.update(maj)
            tileMatchView.update(maj)
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
                cardView.update(maj)
                tileMatchView.update(maj)
                moved = true
            } else {
                showDebugMessage(ErrorId.rackToDiscard)
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
            tileMatchView.update(maj)
            return true
        } else {
            return false
        }
    }

    func moveEntireRackToHand() {
        while maj.east.rack?.tiles.count != 0 {
            let tile = maj.east.rack?.tiles.remove(at: 0)
            maj.east.tiles.append(tile!)
        }
    }
    
    func addTapGestureDiscard(_ tile: UIView) {
        if maj.disableTapToDiscard == false {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGestureDiscard(_:)))
            tile.addGestureRecognizer(tap)
        }
    }
    
    @objc func handleTapGestureDiscard(_ sender: UITapGestureRecognizer) {
        let _ = maj.isCharlestonActive() ? nextCharleston() : nextState()
    }
    
    func showDebugMessage(_ errorId: ErrorId) {
        if maj.techSupportDebug {
            let title = "ErrorId: \(errorId.rawValue)"
            var message = "Unknown"
            switch(errorId) {
                case .charlestonToHand: message = "Error moving from charleston to hand."
                case .rackToDiscard: message = "Error moving from rack to discard."
                case .swapInHand: message = "Error swapping in hand."
                case .swapInRack: message = "Error swapping in rack."
                case .toCharlestonOut: message = "Error moving to charleston out."
                case .toDiscard: message = "Error moving to discard."
                case .toRack: message = "Error moving to rack."
            }
            message += " Take a screenshot if possible and contact support@eightbam.com."
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: {(action:UIAlertAction) in
            }));
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Change Years
    //
    // -----------------------------------------------------------------------------------------
    
    func changeYear(_ segmentIndex: Int) {
        maj.setYearSegment(segment: segmentIndex)
        tileMatchView.loadPatterns(maj: maj, letterPatterns: maj.card.letterPatterns)
        yearLabel?.text = maj.getYearText()
        updateViews()
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
        botView.update(maj)
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
            cardView.updateRackFilter(maj)
            tileMatchView.updateRackFilter(maj)
        }
        showGame()
        showDiscard()
        if maj.wall.tiles.count == 98 {
            showBottomView()
        }
        botView.update(maj)
        if maj.isWinBotEnabled() && maj.botWon() {
            botWon()
        }
        eightbamLabel.isHidden = maj.isCharlestonActive() ? false : true
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
    
    func tileWidth() -> CGFloat { return (viewWidth() - notch()) / 14.5 }
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
        let rackViewHeight = botView.isHidden ? 0 : botView.totalTileHeight()
        return cardLocationPhone() + rackViewHeight + 20
    }
    
    func tableLocation() -> CGFloat { return charlestonTop() }
    func cardMarginX() -> CGFloat { return notch() + margin }
    func cardHeight() -> CGFloat { return viewHeight() - cardLocationY() - 10 - controlPanelHeight() }
    func botHeight() -> CGFloat { return viewHeight() - botLocationY() - 10 - controlPanelHeight() }
    func cardWidth() -> CGFloat { return viewWidth() - 20 }
    func handTop() -> CGFloat { return margin + tileHeight() + margin }
    func handBottom() -> CGFloat { return handTop() + tileHeight() }
    func charlestonTop() -> CGFloat { return handBottom() + margin }
    func charlestonBottom() -> CGFloat { return charlestonTop() + tileHeight() }
    func rowHeader() -> CGFloat { return tileHeight() * 2 + (rowHeight/1.5) }
    func row1() -> CGFloat { return rowHeader() + rowHeight }
    func row2() -> CGFloat { return row1() + rowHeight }
    func row3() -> CGFloat { return row2() + rowHeight }
    func row4() -> CGFloat { return row3() + rowHeight }
    func discardTableBottom() -> CGFloat{ return row3() + rowHeight }
    func isRack(_ location: CGPoint) -> Bool { return location.y < handTop() }
    func isHand(_ location: CGPoint) -> Bool { return (location.y < handBottom() + margin) && (location.y > handTop()) }
    func isRack(tag: Int) -> Bool { return tag / 100 == 1 }
    func isHand(tag: Int) -> Bool { return tag / 100 == 2 }
    func isCharlestonOut(tag: Int) -> Bool { return tag / 100 == 3 }
    func isDiscard(tag: Int) -> Bool { return tag / 100 == 3}
    func isBot(_ location: CGPoint) -> Bool { return botView.lowerCorner(location, tileHeight: tileHeight()) }
    
    func isCharlestonOut(_ location: CGPoint) -> Bool {
        let top = charlestonTop()
        let bottom = charlestonBottom() + margin
        return (location.y > top) && (location.y < bottom) && (getTileIndex(location) >= charlestonOutIndex)
    }
    
    func controlPanelWidth() -> CGFloat { return isTall() ? 450 : 300 }
    func controlPanelHeight() -> CGFloat { return isTall() ? 45 : 32 }
    func controlPanelLocationX() -> CGFloat { return cardMarginX() }
    func controlPanelLocationY() -> CGFloat{ return cardLocationY() + cardHeight() + 5 }
}

