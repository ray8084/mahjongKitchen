//
//  StatViewController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 11/28/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

class StatViewController: NarrowViewController {
    private let fontsize = CGFloat(16)
    private let tableWidth = 375
    private var tableOffset = 10
    private var maj: Maj!
    private var rowBottom = 0
    private var progressBottom = 0
    private var cardStatsOffset = 0
    private var circleText: [UIView] = []
    private var circleLayers: [CAShapeLayer] = []
    private var statLabels: [UILabel] = []
    private var loadButton = UIButton()
    private var loadingLabel = UITextView()
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate) {
        self.maj = maj
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
        maxWidth = tableWidth
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewWillAppear(_ animated: Bool) {
        if xOffset == 0 && view.frame.width != 0 {
            addControls()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if xOffset == 0 {
            addControls()
        }
    }
    
    override func addControls() {
        scrollViewHeight = 34000
        narrowView()
        addScrollView()
        xOffset = (Int(scrollView.frame.width) - tableWidth) / 2
        yOffset = scrollView.frame.height > 350 ? 20 : 0
        addTitle()
        addResetButton(y: yOffset)
        let _ = addLine(x: xOffset, y: yOffset + 55)
        addProgress(maj: maj, top: yOffset + 110)
        tableOffset = progressBottom + 40
        addStatTable(maj: maj)
        addCloseButton()
        addAllHands(550)
    }
    
    func addAddition() -> Bool {
        return (maj.year != Year.y2020) && (maj.year != Year.y2021) && (maj.year != Year.y2022)
    }
    
    // -----------------------------------------------------------------------------------------
    //
    //  Title
    //
    // -----------------------------------------------------------------------------------------
    
    private func addTitle() {
        let title = UILabel(frame: CGRect(x: xOffset, y: yOffset, width: 250, height: 60))
        title.text = "Your Stats"
        title.font = UIFont.boldSystemFont(ofSize: 22)
        self.scrollView.addSubview(title)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Table
    //
    // -----------------------------------------------------------------------------------------
    
    private func addStatTable(maj: Maj) {
        addHeader()
        let _  = addLine(x: xOffset, y: tableOffset + 25)
        addRowLabels()
        if !addAddition() {
            let _  = addLine(x: xOffset, y: tableOffset + 215 + 5)
        } else {
            let _  = addLine(x: xOffset, y: tableOffset + 235 + 5)
        }
        update(maj: maj)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Header
    //
    // -----------------------------------------------------------------------------------------
    
    private func addHeader() {
        addHeaderLabel(x: 60, width: 45, text: "Wins")
        addHeaderLabel(x: 110, width: 65, text: "Patterns")
        addHeaderLabel(x: 180, width: 75, text: "Pattern %")
        addHeaderLabel(x: 262, width: 55, text: "Losses")
        addHeaderLabel(x: 325, width: 50, text: "Win %")
    }
 
    private func addHeaderLabel(x: Int, width: Int, text: String) {
        let label = UILabel(frame: CGRect(x: xOffset + x, y: tableOffset, width: width, height: 21))
        label.text = text
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: fontsize)
        self.scrollView.addSubview(label)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Row Labels
    //
    // -----------------------------------------------------------------------------------------
    
    private func addRowLabels() {
        rowBottom = 35
        addRowLabel(y: rowBottom, text: "Year")
        addRowLabel(y: rowBottom, text: "2468")
        addRowLabel(y: rowBottom, text: "LikeNum")
        if addAddition() { addRowLabel(y: rowBottom, text: "Addition") }
        addRowLabel(y: rowBottom, text: "Quints")
        addRowLabel(y: rowBottom, text: "Runs")
        addRowLabel(y: rowBottom, text: "13579")
        addRowLabel(y: rowBottom, text: "Winds")
        addRowLabel(y: rowBottom, text: "369")
        addRowLabel(y: rowBottom, text: "Pairs")
        addRowLabel(y: rowBottom + 10, text: "Totals")
    }
    
    private func addRowLabel(y: Int, text: String) {
        let label = UILabel(frame: CGRect(x: xOffset, y: tableOffset + y, width: 100, height: 21))
        label.text = text
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: fontsize)
        self.scrollView.addSubview(label)
        rowBottom += 20
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Stats
    //
    // -----------------------------------------------------------------------------------------
    
    private func update(maj: Maj) {
        for label in statLabels {
            label.removeFromSuperview()
        }
        statLabels = []
        rowBottom = 35
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.year))
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.f2468))
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.likeNumbers))
        if addAddition() {addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.addition))}
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.quints))
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.run))
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.f13579))
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.winds))
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.f369))
        addWins(y: rowBottom, text: maj.card.getTotalWins(family: Family.pairs))
        addWins(y: rowBottom + 10, text: maj.card.getTotalWins(family: Family.all))
        
        rowBottom = 35
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.year))
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.f2468))
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.likeNumbers))
        if addAddition() {addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.addition))}
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.quints))
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.run))
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.f13579))
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.winds))
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.f369))
        addPatternWins(y: rowBottom, text: maj.card.getPatternWins(family: Family.pairs))
        addPatternWins(y: rowBottom + 10, text: maj.card.getPatternWins(family: Family.all))
        
        rowBottom = 35
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.year))
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.f2468))
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.likeNumbers))
        if addAddition() {addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.addition))}
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.quints))
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.run))
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.f13579))
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.winds))
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.f369))
        addPatternPercent(y: rowBottom, text: maj.card.getPatternWinPercentageString(family: Family.pairs))
        addPatternPercent(y: rowBottom + 10, text: maj.card.getPatternWinPercentageString(family: Family.all))
        
        rowBottom = 35
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.year))
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.f2468))
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.likeNumbers))
        if addAddition() {addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.addition))}
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.quints))
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.run))
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.f13579))
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.winds))
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.f369))
        addLosses(y: rowBottom, text: maj.card.getLosses(family: Family.pairs))
        addLosses(y: rowBottom + 10, text: maj.card.getLosses(family: Family.all))
        
        rowBottom = 35
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.year))
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.f2468))
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.likeNumbers))
        if addAddition() {addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.addition))}
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.quints))
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.run))
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.f13579))
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.winds))
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.f369))
        addWinPercentage(y: rowBottom, text: maj.card.getWinLossPercent(family: Family.pairs))
        addWinPercentage(y: rowBottom + 10 , text: maj.card.getWinLossPercent(family: Family.all))
    }
    
    func addWins(y: Int, text: String) {
        let label = UILabel(frame: CGRect(x: xOffset + 60, y: tableOffset + y, width: 35, height: 21))
        label.text = text
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: fontsize)
        scrollView.addSubview(label)
        statLabels.append(label)
        rowBottom += 20
    }
    
    func addPatternWins(y: Int, text: String) {
        let label = UILabel(frame: CGRect(x: xOffset + 105, y: tableOffset + y, width: 55, height: 21))
        label.text = text
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: fontsize)
        scrollView.addSubview(label)
        statLabels.append(label)
        rowBottom += 20
    }
    
    func addPatternPercent(y: Int, text: String) {
        let label = UILabel(frame: CGRect(x: xOffset + 170, y: tableOffset + y, width: 60, height: 21))
        label.text = text
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: fontsize)
        scrollView.addSubview(label)
        statLabels.append(label)
        rowBottom += 20
    }
    
    func addLosses(y: Int, text: String) {
        let label = UILabel(frame: CGRect(x: xOffset + 252, y: tableOffset + y, width: 45, height: 21))
        label.text = text
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: fontsize)
        scrollView.addSubview(label)
        statLabels.append(label)
        rowBottom += 20
    }
    
    func addWinPercentage(y: Int, text: String) {
        let label = UILabel(frame: CGRect(x: xOffset + 325, y: tableOffset + y, width: 45, height: 21))
        label.text = text
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: fontsize)
        scrollView.addSubview(label)
        statLabels.append(label)
        rowBottom += 20
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Progress Rings
    //
    // -----------------------------------------------------------------------------------------
    
    private func addProgress(maj: Maj, top: Int) {
        for view in circleText {
            view.removeFromSuperview()
        }
        for layer in circleLayers {
            layer.removeFromSuperlayer()
        }
        circleText = []
        circleLayers = []
        let center = maxWidth / 2
        let radius = CGFloat(30)
        let firstOffset = radius
        let distance = (center - Int(firstOffset)) / 2
        let year = maj.card.getPatternWinPercentage(family: Family.year)
        let even = maj.card.getPatternWinPercentage(family: Family.f2468)
        let like = maj.card.getPatternWinPercentage(family: Family.likeNumbers)
        let quints = maj.card.getPatternWinPercentage(family: Family.quints)
        let runs = maj.card.getPatternWinPercentage(family: Family.run)
        let odds = maj.card.getPatternWinPercentage(family: Family.f13579)
        let winds = maj.card.getPatternWinPercentage(family: Family.winds)
        let three69 = maj.card.getPatternWinPercentage(family: Family.f369)
        let pairs = maj.card.getPatternWinPercentage(family: Family.pairs)
        let total = maj.card.getPatternWinPercentage(family: Family.all)
        var y = top
        addProgressCircle(x: xOffset + Int(firstOffset), y: y, radius: radius, toValue: year, label: "Year")
        addProgressCircle(x: xOffset + Int(firstOffset) + distance, y: y, radius: radius, toValue: like, label: "Like")
        addProgressCircle(x: xOffset + center, y: y, radius: radius, toValue: runs, label: "Run")
        addProgressCircle(x: xOffset + center + distance, y: y, radius: radius, toValue: winds, label: "Wnd")
        addProgressCircle(x: xOffset + maxWidth - Int(radius), y: y, radius: radius, toValue: pairs, label: "S&P")
        y = y + (Int(radius) * 2) + 10
        addProgressCircle(x: xOffset + Int(firstOffset), y: y, radius: radius, toValue: even, label: "Even")
        addProgressCircle(x: xOffset + Int(firstOffset) + distance, y: y, radius: radius, toValue: quints, label: "Qnt")
        addProgressCircle(x: xOffset + center, y: y, radius: radius, toValue: odds, label: "Odd")
        addProgressCircle(x: xOffset + center + distance, y: y, radius: radius, toValue: three69, label: "369")
        addProgressCircle(x: xOffset + maxWidth - Int(radius), y: y, radius: radius, toValue: total, label: "Total")
        progressBottom = y + Int(radius)
    }
    
    private func addProgressCircle(x: Int, y: Int, radius: CGFloat, toValue: Double, label: String) {
        print("addProgressCircle \(x)")
        let trackLayer = CAShapeLayer()
        let shapeLayer = CAShapeLayer()
        let center = CGPoint(x: x, y: y)
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.2).cgColor
        //trackLayer.strokeColor = UIColor(red: 92.0/255.0, green: 117.0/255.0, blue: 78.0/255.0, alpha: 0.3).cgColor
        //trackLayer.strokeColor = UIColor(red: 38.0/255.0, green: 131.0/255.0, blue: 243.0/255.0, alpha: 0.1).cgColor
        trackLayer.lineWidth = 3
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        scrollView.layer.addSublayer(trackLayer)
        circleLayers.append(trackLayer)
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.systemGreen.cgColor
        //shapeLayer.strokeColor = UIColor(red: 92.0/255.0, green: 117.0/255.0, blue: 78.0/255.0, alpha: 0.7).cgColor
        //shapeLayer.strokeColor = UIColor(red: 38.0/255.0, green: 131.0/255.0, blue: 243.0/255.0, alpha: 0.8).cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        scrollView.layer.addSublayer(shapeLayer)
        circleLayers.append(shapeLayer)
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = toValue * 0.8
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "basic")
        
        let text = UILabel(frame: CGRect(x:x, y:y, width:44, height: 42))
        text.center = center
        text.numberOfLines = 2
        text.textAlignment = .center
        let percent = Int(toValue * 100)
        text.text = "\(label)\n\(percent)%"
        scrollView.addSubview(text)
        circleText.append(text)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Reset
    //
    // -----------------------------------------------------------------------------------------
    
    func addResetButton(y: Int) {
        let x = scrollView.frame.origin.x + scrollView.frame.width - 50 - 80
        let resetButton = UIButton(frame: CGRect(x: Int(x), y: y+20, width: 50, height: 25))
        resetButton.layer.cornerRadius = 5
        resetButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        resetButton.setTitle("Clear", for: .normal)
        resetButton.backgroundColor = .darkGray
        // resetButton.setTitleColor(.black, for: .normal)
        resetButton.addTarget(self, action: #selector(showResetMenu), for: .touchUpInside)
        scrollView.addSubview(resetButton)
    }
    
    @objc func showResetMenu() {
        let message = "Clear win and loss stats for this years card"
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {(action:UIAlertAction) in }));
        alert.addAction(UIAlertAction(title: "Clear", style: .default, handler: {(action:UIAlertAction) in
            self.maj.card.clearStats()
            self.update(maj: self.maj)
            self.addProgress(maj: self.maj, top: self.yOffset + 110)
        }));
        present(alert, animated: false, completion: nil)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Add all patterns
    //
    // -----------------------------------------------------------------------------------------
    
    private func addAllHands(_ yoffset: Int) {
        cardStatsOffset = yoffset
        addTitle("Card Stats", y: cardStatsOffset)
        cardStatsOffset += 55
        let _ = addLine(x: xOffset, y: cardStatsOffset)
        cardStatsOffset += 5
        loadingLabel = addLabel("Takes a long time to load and unload.  Please be patient after closing.", y: cardStatsOffset)
        cardStatsOffset += 60
        addLoadButton(y: cardStatsOffset)
    }
    
    func addLoadButton(y: Int) {
        loadButton = UIButton(frame: CGRect(x: xOffset, y: y+20, width: 200, height: 25))
        loadButton.layer.cornerRadius = 5
        loadButton.titleLabel!.font = UIFont.systemFont(ofSize: 16)
        loadButton.setTitle("Generate Card Stats", for: .normal)
        loadButton.backgroundColor = .darkGray
        loadButton.addTarget(self, action: #selector(generateCardStats), for: .touchUpInside)
        scrollView.addSubview(loadButton)
    }
    
    @objc private func generateCardStats() {
        loadingLabel.removeFromSuperview()
        loadButton.removeFromSuperview()
        cardStatsOffset -= 60
        loadingLabel = addLabel("Loading...", y: cardStatsOffset)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(loadAllHands), userInfo: nil, repeats: false)
    }
    
    @objc private func loadAllHands() -> Int {
        loadingLabel.removeFromSuperview()
        var offset = cardStatsOffset
        xOffset = (Int(scrollView.frame.width) - tableWidth) / 2 - 5
        maxWidth = 400
        
        addTitle("Sections", y: offset)
        offset += 55
        let _ = addLine(x: xOffset, y: offset)
        offset += 5
        
        var totalYearsHands = 0
        var totalEvenHands = 0
        var totalLikeNumberHands = 0
        var totalAdditionHands = 0
        var totalQuintHands = 0
        var totalRunHands = 0
        var totalOddHands = 0
        var totalWindHands = 0
        var total369Hands = 0
        var totalSinglesAndPairsHands = 0
        
        var total = 0
        for p in maj.unsortedLetterPatterns {
            switch(p.family) {
            case Family.year: totalYearsHands += p.idList.list.count
            case Family.f2468: totalEvenHands += p.idList.list.count
            case Family.likeNumbers: totalLikeNumberHands += p.idList.list.count
            case Family.addition: totalAdditionHands += p.idList.list.count
            case Family.quints: totalQuintHands += p.idList.list.count
            case Family.run: totalRunHands += p.idList.list.count
            case Family.f13579: totalOddHands += p.idList.list.count
            case Family.winds: totalWindHands += p.idList.list.count
            case Family.f369: total369Hands += p.idList.list.count
            case Family.pairs: totalSinglesAndPairsHands += p.idList.list.count
            default: break
            }
            total += p.idList.list.count
        }

        let _ = addLabel("Year \(totalYearsHands) hands", y: offset); offset += 30
        let _ = addLabel("2468 \(totalEvenHands) hands", y: offset); offset += 30
        let _ = addLabel("Like Number \(totalLikeNumberHands) hands", y: offset); offset += 30
        let _ = addLabel("Math \(totalAdditionHands) hands", y: offset); offset += 30
        let _ = addLabel("Quint \(totalQuintHands) hands", y: offset); offset += 30
        let _ = addLabel("Runs \(totalRunHands) hands", y: offset); offset += 30
        let _ = addLabel("13579 \(totalOddHands) hands", y: offset); offset += 30
        let _ = addLabel("Wind & Dragon \(totalWindHands) hands", y: offset); offset += 30
        let _ = addLabel("369 \(total369Hands) hands", y: offset); offset += 30
        let _ = addLabel("Singles And Pairs \(totalSinglesAndPairsHands) hands", y: offset); offset += 30
        let _ = addLabel("Total \(total) hands", y: offset); offset += 50

        addTitle("Patterns", y: offset)
        offset += 55
        let _ = addLine(x: xOffset, y: offset)
        offset += 5

        total = 0
        for p in maj.unsortedLetterPatterns {
            total += p.idList.list.count
            let line = "\(p.id+1).  \(p.getFamilyString()) \(p.idList.list.count) hands"
            let _ = addLabel(line, y: offset )
            print(line)
            offset += 30
        }
        offset += 50
                        
        addTitle("All Hands", y: offset)
        offset += 55
        let _ = addLine(x: xOffset, y: offset)
        offset += 5
        
        var hand = 1
        for p in maj.unsortedLetterPatterns {
            var index = 1
            for idlist in p.idList.list {
                let line = "\(p.id+1).\(index).  \(getHandString(idlist.ids))"
                print(line)
                let _ = addLabel(line, y: offset )
                offset += 30
                hand += 1
                index += 1
            }
        }
        return offset
    }
    
    func getHandString(_ ids: [Int]) -> String {
        var hand = ""
        for id in ids {
            switch(id) {
            case 1: hand += "1d "
            case 2: hand += "2d "
            case 3: hand += "3d "
            case 4: hand += "4d "
            case 5: hand += "5d "
            case 6: hand += "6d "
            case 7: hand += "7d "
            case 8: hand += "8d "
            case 9: hand += "9d "
            case 10: hand += "0 "
            case 11: hand += "1b "
            case 12: hand += "2b "
            case 13: hand += "3b "
            case 14: hand += "4b "
            case 15: hand += "5b "
            case 16: hand += "6b "
            case 17: hand += "7b "
            case 18: hand += "8b "
            case 19: hand += "9b "
            case 20: hand += "g "
            case 21: hand += "1c "
            case 22: hand += "2c "
            case 23: hand += "3c "
            case 24: hand += "4c "
            case 25: hand += "5c "
            case 26: hand += "6c "
            case 27: hand += "7c "
            case 28: hand += "8c "
            case 29: hand += "9c "
            case 30: hand += "r "
            case 31: hand += "n "
            case 32: hand += "s "
            case 33: hand += "w "
            case 34: hand += "e "
            case 35: hand += "f "
            default: break
            }
        }
        return hand
    }
 
    
}

