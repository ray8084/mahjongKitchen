//
//  SettingsViewController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 11/30/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

protocol SettingsDelegate {
    func changeTileImages()
    func changeYear(_ segmentIndex: Int)
    func getMaj() -> Maj
    func redeal()
    func updateViews()
}

class SettingsViewController: NarrowViewController, UITextFieldDelegate {
    let fontsize = CGFloat(16)
    var maj: Maj!
    var settingsDelegate: SettingsDelegate
    var revenueCat: RevenueCat!
    var yearBottom = 0
    var filtersBottom = 0
    var settingsBottom = 0
    var tilesBottom = 0
    var keywordTextEdit: UITextField!
    var tileImages: [UIImageView] = []
    var yearSegmentControl: UISegmentedControl!
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate, settingsDelegate: SettingsDelegate, revenueCat: RevenueCat) {
        self.maj = maj
        self.revenueCat = revenueCat
        print("Settings.init \(maj.enable2020) \(maj.enable2021)")
        self.settingsDelegate = settingsDelegate
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }  
        
    override func viewWillAppear(_ animated: Bool) {
        if yearBottom == 0 && view.frame.width != 0 {
            addControls()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if yearBottom == 0 {
            addControls()
        }
    }
    
    override func addControls() {
        narrowView()
        addScrollView()
        xOffset = (Int(scrollView.frame.width) - maxWidth) / 2
        yOffset = 20
        addYear()
        addFilters()
        addOptions()
        addTileImages()
        addCloseButton()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Year
    //
    // -----------------------------------------------------------------------------------------
    
    private func setTitleColor(_ label: UILabel) {
        if #available(iOS 13.0, *) {
            // label.textColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func addYear() {
        addTitle("Settings", y: yOffset)
        print("Settings.addYear \(maj.enable2020) \(maj.enable2021)")

        yearBottom = 40 + yOffset
        
        let line = addLine(x: xOffset, y: yearBottom + 10)
        yearBottom = Int(line.frame.origin.y + line.frame.height)
        
        let items = ["2017", "2018", "2019", "2020", "2021"]
        yearSegmentControl = UISegmentedControl(items: items)
        yearSegmentControl.selectedSegmentIndex = maj.getYearSegment()
        yearSegmentControl.frame = CGRect(x: xOffset, y: yearBottom + 10, width: maxWidth, height: Int(yearSegmentControl.frame.height))
        yearSegmentControl.addTarget(self, action: #selector(changeYear), for: .valueChanged)
        scrollView.addSubview(yearSegmentControl)
        yearBottom = Int(yearSegmentControl.frame.origin.y + yearSegmentControl.frame.height)
        
        if #available(iOS 13.0, *) {
            // default
        } else {
            yearSegmentControl.tintColor = .gray
        }
        
        let line2 = addLine(x: xOffset, y: yearBottom + 10)
        yearBottom = Int(line2.frame.origin.y + line2.frame.height)
    }

    @objc private func changeYear(sender: UISegmentedControl) {
        switch( sender.selectedSegmentIndex ) {
            case YearSegment.segment2017: revenueCat.changeYear(year: Year.y2017, settingsViewController: self)
            case YearSegment.segment2018: revenueCat.changeYear(year: Year.y2018, settingsViewController: self)
            case YearSegment.segment2019: revenueCat.changeYear(year: Year.y2019, settingsViewController: self)
            case YearSegment.segment2020: revenueCat.changeYear(year: Year.y2020, settingsViewController: self)
            case YearSegment.segment2021: revenueCat.changeYear(year: Year.y2021, settingsViewController: self)
            default: revenueCat.changeYear(year: Year.y2017, settingsViewController: self)
        }
    }
    
    private func setOriginWithOffset(_ frame: CGRect, x: Int, y: Int) -> CGRect {
        var f = frame
        f.origin.x = CGFloat(xOffset + x)
        f.origin.y = CGFloat(y)
        return f
    }
    
    func select2017() { yearSegmentControl.selectedSegmentIndex = YearSegment.segment2017}
    func select2018() { yearSegmentControl.selectedSegmentIndex = YearSegment.segment2018}
    func select2019() { yearSegmentControl.selectedSegmentIndex = YearSegment.segment2019}
    func select2020() { yearSegmentControl.selectedSegmentIndex = YearSegment.segment2020}
    func select2021() { yearSegmentControl.selectedSegmentIndex = YearSegment.segment2021}
    func is2017Selected() -> Bool { return yearSegmentControl.selectedSegmentIndex == YearSegment.segment2017 }
    func is2018Selected() -> Bool { return yearSegmentControl.selectedSegmentIndex == YearSegment.segment2018 }
    func is2019Selected() -> Bool { return yearSegmentControl.selectedSegmentIndex == YearSegment.segment2019 }
    func is2020Selected() -> Bool { return yearSegmentControl.selectedSegmentIndex == YearSegment.segment2020 }
    func is2021Selected() -> Bool { return yearSegmentControl.selectedSegmentIndex == YearSegment.segment2021 }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Filters
    //
    // -----------------------------------------------------------------------------------------
    
    private func addFilters() {
        let top = yearBottom + 10
        addTitle("Filters", y: top)
        
        let subtitle = UILabel(frame: CGRect(x: xOffset + 70, y: top + 15, width: 400, height: 30))
        subtitle.text = "for Pattern and Tile views"
        subtitle.font = UIFont.systemFont(ofSize: 16)
        setTitleColor(subtitle)
        scrollView.addSubview(subtitle)
         
        let yearFilter = addFilter("Year", x: 0, y: top + 55)
        let evenFilter = addFilter("2468", x: 0, y: top + 95)
        let likeFilter = addFilter("LikeNum", x: 0, y: top + 135)
        let additionFilter = addFilter("Addition", x: 0, y: top + 175)
        let quintFilter = addFilter("Quints", x: 160, y: top + 55)
        let runsFilter = addFilter("Runs", x: 160, y: top + 95)
        let oddsFilter = addFilter("13579", x: 160, y: top + 135)
        let concealedFilter = addFilter("Concealed", x: 160, y: top + 175)
        let windsFilter = addFilter("Winds", x: 320, y: top + 55)
        let three69filter = addFilter("369", x: 320, y: top + 95)
        let pairsFilter = addFilter("Pairs", x: 320, y: top + 135)
        
        yearFilter.isOn = !maj.east.filterOutYears
        evenFilter.isOn = !maj.east.filterOut2468
        likeFilter.isOn = !maj.east.filterOutLikeNumbers
        additionFilter.isOn = !maj.east.filterOutAdditionHands
        quintFilter.isOn = !maj.east.filterOutQuints
        runsFilter.isOn = !maj.east.filterOutRuns
        oddsFilter.isOn = !maj.east.filterOut13579
        concealedFilter.isOn = !maj.east.filterOutConcealed
        windsFilter.isOn = !maj.east.filterOutWinds
        three69filter.isOn = !maj.east.filterOut369
        pairsFilter.isOn = !maj.east.filterOutPairs
         
        yearFilter.addTarget(self, action: #selector(changeYearFilter), for: .valueChanged)
        evenFilter.addTarget(self, action: #selector(changeEvenFilter), for: .valueChanged)
        likeFilter.addTarget(self, action: #selector(changeLikeFilter), for: .valueChanged)
        additionFilter.addTarget(self, action: #selector(changeAdditionFilter), for: .valueChanged)
        quintFilter.addTarget(self, action: #selector(changeQuintsFilter), for: .valueChanged)
        runsFilter.addTarget(self, action: #selector(changeRunsFilter), for: .valueChanged)
        oddsFilter.addTarget(self, action: #selector(changeOddsFilter), for: .valueChanged)
        concealedFilter.addTarget(self, action: #selector(changeConcealedFilter), for: .valueChanged)
        windsFilter.addTarget(self, action: #selector(changeWindsFilter), for: .valueChanged)
        three69filter.addTarget(self, action: #selector(change369Filter), for: .valueChanged)
        pairsFilter.addTarget(self, action: #selector(changePairsFilter), for: .valueChanged)
        
        filtersBottom = Int(concealedFilter.frame.origin.y + concealedFilter.frame.height)
        let line = addLine(x: xOffset, y: filtersBottom + 30)
        filtersBottom = Int(line.frame.origin.y + line.frame.height)
    }
    
    private func addFilter(_ text: String, x: Int, y: Int) -> UISwitch {
        let filterSwitch = UISwitch()
        filterSwitch.isOn = true
        filterSwitch.setOn(true, animated: false)
        filterSwitch.frame = setOriginWithOffset(filterSwitch.frame, x: x, y: y)
        scrollView.addSubview(filterSwitch)
        addLabel(text, x: x + 60, y: y)
        return filterSwitch
    }
    
    private func addLabel(_ text: String, x: Int, y: Int) {
        let label = UILabel(frame: CGRect(x: xOffset + x, y: y, width: 300, height: 30))
        label.text = text
        if #available(iOS 13.0, *) {
            // label.textColor = .secondaryLabel
        } else {
            // Fallback on earlier versions
        }
        scrollView.addSubview(label)
    }
    
    @objc private func changeYearFilter(sender: UISwitch) {
        maj.toggleYearsFilter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeEvenFilter(sender: UISwitch) {
        maj.toggle2468Filter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeLikeFilter(sender: UISwitch) {
        maj.toggleLikeNumbersFilter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeAdditionFilter(sender: UISwitch) {
        maj.toggleAdditionFilter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeQuintsFilter(sender: UISwitch) {
        maj.toggleQuintFilter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeRunsFilter(sender: UISwitch) {
        maj.toggleRunsFilter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeOddsFilter(sender: UISwitch) {
        maj.toggle13579Filter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeConcealedFilter(sender: UISwitch) {
        maj.toggleConcealedFilter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changeWindsFilter(sender: UISwitch) {
        maj.toggleWindsFilter()
        settingsDelegate.updateViews()
    }
    
    @objc private func change369Filter(sender: UISwitch) {
        maj.toggle369Filter()
        settingsDelegate.updateViews()
    }
    
    @objc private func changePairsFilter(sender: UISwitch) {
        maj.togglePairFilter()
        settingsDelegate.updateViews()
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Options
    //
    // -----------------------------------------------------------------------------------------
   
    private func addOptions() {
        let top = filtersBottom + 10
        addTitle("Options", y: top)
        
        var nextOffset = top + 55
        let botSwitch = addSwitch("Enable Bot Wins", y: nextOffset)
        botSwitch.isOn = maj.winBotEnabled
        botSwitch.addTarget(self, action: #selector(changeBots), for: .valueChanged)
        settingsBottom = Int(botSwitch.frame.origin.y + botSwitch.frame.height)
        addWinBotHelpButton(x: xOffset + maxWidth - 60, y: nextOffset)

        nextOffset = settingsBottom + 10
        let keywordSwitch = addSwitch("Duplicate Keyword", y: nextOffset)
        keywordSwitch.isOn = maj.shuffleWithSeed
        keywordSwitch.addTarget(self, action: #selector(changeDuplicate), for: .valueChanged)
        settingsBottom = Int(keywordSwitch.frame.origin.y + keywordSwitch.frame.height)
            
        let x = xOffset + maxWidth / 2
        let width = maxWidth / 2 - 70
        keywordTextEdit =  UITextField(frame: CGRect(x: x, y: nextOffset, width: width, height: 30))
        keywordTextEdit.placeholder = "Enter keyword here"
        keywordTextEdit.borderStyle = UITextField.BorderStyle.roundedRect
        keywordTextEdit.autocorrectionType = .no
        let shortcut: UITextInputAssistantItem? = keywordTextEdit.inputAssistantItem
        shortcut?.leadingBarButtonGroups = []
        shortcut?.trailingBarButtonGroups = []
        keywordTextEdit.keyboardType = UIKeyboardType.default
        keywordTextEdit.returnKeyType = UIReturnKeyType.done
        keywordTextEdit.clearButtonMode = UITextField.ViewMode.whileEditing
        keywordTextEdit.autocapitalizationType = UITextAutocapitalizationType.none;
        keywordTextEdit.delegate = self
        keywordTextEdit.isHidden = !maj.shuffleWithSeed
        keywordTextEdit.text = maj.shuffleSeed
        scrollView.addSubview(keywordTextEdit)
        addDuplicateKeywordHelpButton(x: xOffset + maxWidth - 60, y: nextOffset)
        
        nextOffset = settingsBottom + 10
        let tapSwitch = addSwitch("Tap Tiles to Discard", y: nextOffset)
        tapSwitch.isOn = !maj.disableTapToDiscard
        tapSwitch.addTarget(self, action: #selector(changeTapToDiscard), for: .valueChanged)
        settingsBottom = Int(tapSwitch.frame.origin.y + tapSwitch.frame.height)
        addTapToDiscardHelpButton(x: xOffset + maxWidth - 60, y: nextOffset)
                
        nextOffset = settingsBottom + 10
        let techSupportSwitch = addSwitch("Tech Support Debug Messages", y: nextOffset)
        techSupportSwitch.isOn = maj.techSupportDebug
        techSupportSwitch.addTarget(self, action: #selector(changeTechSupportDebug), for: .valueChanged)
        settingsBottom = Int(techSupportSwitch.frame.origin.y + techSupportSwitch.frame.height)
                
        let line  = addLine(x: xOffset, y: settingsBottom + 30)
        settingsBottom = Int(line.frame.origin.y + line.frame.height)
    }
    
    private func addSwitch(_ text: String, y: Int) -> UISwitch {
        let filterSwitch = UISwitch()
        filterSwitch.isOn = true
        filterSwitch.setOn(true, animated: false)
        filterSwitch.frame = setOriginWithOffset(filterSwitch.frame, x: 0, y: y)
        scrollView.addSubview(filterSwitch)
        addLabel(text, x: 60, y: y)
        return filterSwitch
    }
    
    @objc private func changeTechSupportDebug(sender: UISwitch) {
        maj.setTechSupportDebug( !maj.techSupportDebug )
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  WinBot
    //
    // -----------------------------------------------------------------------------------------
    
    @objc private func changeBots(sender: UISwitch) {
        maj.toggleWinBot()
    }
    
    func addWinBotHelpButton(x: Int, y: Int) {
        let button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 30))
        let image = UIImage(named: "iconfinder_circle-26_600774.png")
        button.setImage(image, for: .normal)
        button.alpha = 0.5
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(botWinHelpButtonAction), for: .touchUpInside)
        scrollView.addSubview(button)
    }

    @objc func botWinHelpButtonAction(sender: UIButton!) {
        let title = "Bot Wins"
        let message = "Bots are the computer players that play the opponent hands. They call tiles and make patterns but they will not declare mahjong unless Bot Wins is enabled.  Bot Wins are only available when playing 2020 and 2021 patterns."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Duplicate Keyword
    //
    // -----------------------------------------------------------------------------------------
    
    @objc private func changeDuplicate(sender: UISwitch) {
        maj.setShuffleWithSeed( !maj.shuffleWithSeed )
        keywordTextEdit.isHidden = !maj.shuffleWithSeed
        settingsDelegate.redeal()
        maj = settingsDelegate.getMaj()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return maj.shuffleWithSeed
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        maj.setShuffleSeed( textField.text ?? "" )
        settingsDelegate.redeal()
        maj = settingsDelegate.getMaj()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        scrollView.endEditing(true)
        return false
    }
    
    func addDuplicateKeywordHelpButton(x: Int, y: Int) {
        let button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 30))
        let image = UIImage(named: "iconfinder_circle-26_600774.png")
        button.setImage(image, for: .normal)
        button.alpha = 0.5
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(duplicateKeywordHelpButtonAction), for: .touchUpInside)
        scrollView.addSubview(button)
    }

    @objc func duplicateKeywordHelpButtonAction(sender: UIButton!) {
        let title = "Duplicate Mahjong"
        let message = "To play a duplicate hand with a friend create a keyword with any sequence of letters or numbers. The keyword will generate the same hand every time for every player. Change the keyword or disable this feature to play a new hand."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: true, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tap To Discard
    //
    // -----------------------------------------------------------------------------------------
    
    @objc private func changeTapToDiscard(sender: UISwitch) {
        maj.setDisableTapToDiscard( !maj.disableTapToDiscard )
    }
    
    func addTapToDiscardHelpButton(x: Int, y: Int) {
        let button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 30))
        let image = UIImage(named: "iconfinder_circle-26_600774.png")
        button.setImage(image, for: .normal)
        button.alpha = 0.5
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(tapToDiscardHelpButtonAction), for: .touchUpInside)
        scrollView.addSubview(button)
    }

    @objc func tapToDiscardHelpButtonAction(sender: UIButton!) {
        let title = "Discard Options"
        let message = "There are 2 ways to discard tiles: Drag and Drop or Tap to Discard. Drag tiles from the discard location offscreen to discard or tap a tile in the discard location to discard it.  Disable Tap to Discard if you have accidental discards."
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: true, completion: nil)
    }
        
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tile Image
    //
    // -----------------------------------------------------------------------------------------
    
    private func addTileImages() {
        let top = settingsBottom + 10
        addTitle("Tile Images", y: top)
        
        let segmentOffset = top + 55
        let items = ["Classic", "Large Font"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = maj.dotTileStyle
        segment.frame = setOriginWithOffset(segment.frame, x: 0, y: top + 55)
        segment.addTarget(self, action: #selector(changeTileImages), for: .valueChanged)
        scrollView.addSubview(segment)
        
        let dragonItems = ["Red Dragon", "Alternate"]
        let dragonSegment = UISegmentedControl(items: dragonItems)
        dragonSegment.selectedSegmentIndex = maj.alternateRedDragon ? 1 : 0
        dragonSegment.frame = setOriginWithOffset(segment.frame, x: Int(segment.frame.width) + 20, y: top + 55)
        dragonSegment.addTarget(self, action: #selector(changeRedDragon), for: .valueChanged)
        scrollView.addSubview(dragonSegment)
        
        if #available(iOS 13.0, *) {
            // default
        } else {
            segment.tintColor = .gray
        }
        
        let tilesOffset = segmentOffset + 45
        addTile(maj.dotTileStyle == TileStyle.classic ? "1dot.png" : "1dotnew.png", x: 0, y: tilesOffset)
        addTile(maj.dotTileStyle == TileStyle.classic ? "2dot.png" : "2dotnew.png", x: 54, y: tilesOffset)
        addTile(maj.bamTileStyle == TileStyle.classic ? "1bam.png" : "1bamnew.png", x: 54*2, y: tilesOffset)
        addTile(maj.bamTileStyle == TileStyle.classic ? "2bam.png" : "2bamnew.png", x: 54*3, y: tilesOffset)
        addTile(maj.crakTileStyle == TileStyle.classic ? "1crak.png" : "1craknew.png", x: 54*4, y: tilesOffset)
        addTile(maj.crakTileStyle == TileStyle.classic ? "2crak.png" : "2craknew.png", x: 54*5, y: tilesOffset)
        addTile(maj.windTileStyle == TileStyle.classic ? "north.png" : "northnew.png", x: 54*6, y: tilesOffset)
        addTile(maj.flowerTileStyle == TileStyle.classic ? "f1.png" : "flowernew.png", x: 54*7, y: tilesOffset)
        addTile(maj.alternateRedDragon ? "redAlt.png" : "red.png", x: 54*8, y: tilesOffset)
        tilesBottom = tilesOffset + tileHeight
    }
    
    private func addTile(_ named: String, x: Int, y: Int) {
        let tile = UIImageView(frame:CGRect(x: xOffset + x, y: y, width: tileWidth, height: tileHeight))
        tile.contentMode = .scaleAspectFit
        tile.layer.masksToBounds = true
        tile.layer.cornerRadius = CGFloat(tileWidth / 8)
        tile.image = UIImage(named: named)
        scrollView.addSubview(tile)
        tileImages.append(tile)
    }

    @objc private func changeTileImages(sender: UISegmentedControl) {
        maj.setDotTileStyle(style: sender.selectedSegmentIndex)
        maj.setBamTileStyle(style: sender.selectedSegmentIndex)
        maj.setCrakTileStyle(style: sender.selectedSegmentIndex)
        maj.setWindTileStyle(style: sender.selectedSegmentIndex)
        maj.setFlowerTileStyle(style: sender.selectedSegmentIndex)
        settingsDelegate.changeTileImages()
        
        if tileImages.count >= 8 {
            tileImages[0].image = UIImage(named: maj.dotTileStyle == TileStyle.classic ? "1dot.png" : "1dotnew.png" )
            tileImages[1].image = UIImage(named: maj.dotTileStyle == TileStyle.classic ? "2dot.png" : "2dotnew.png" )
            tileImages[2].image = UIImage(named: maj.bamTileStyle == TileStyle.classic ? "1bam.png" : "1bamnew.png" )
            tileImages[3].image = UIImage(named: maj.bamTileStyle == TileStyle.classic ? "2bam.png" : "2bamnew.png" )
            tileImages[4].image = UIImage(named: maj.crakTileStyle == TileStyle.classic ? "1crak.png" : "1craknew.png" )
            tileImages[5].image = UIImage(named: maj.crakTileStyle == TileStyle.classic ? "2crak.png" : "2craknew.png" )
            tileImages[6].image = UIImage(named: maj.windTileStyle == TileStyle.classic ? "north.png" : "northnew.png" )
            tileImages[7].image = UIImage(named: maj.flowerTileStyle == TileStyle.classic ? "f1.png" : "flowernew.png" )
        }
    }
    
    @objc private func changeRedDragon(sender: UISegmentedControl) {
        maj.setAlternateRedDragon(sender.selectedSegmentIndex == 1)
        if tileImages.count == 9 {
            tileImages[8].image = UIImage(named: maj.alternateRedDragon ? "redAlt.png" : "red.png" )
        }
        settingsDelegate.changeTileImages()
    }
    
}
