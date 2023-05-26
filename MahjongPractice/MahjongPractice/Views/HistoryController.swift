//
//  HelpTableController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/15/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

class HistoryController: NarrowViewController, UITableViewDelegate, UITableViewDataSource {
  
    var table: UITableView  = UITableView()
    var chapters: [HelpChapter] = []
    private var maj: Maj!
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate) {
        self.maj = maj
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func addControls() {
        maxWidth = 620
        narrowView()
        xOffset = (Int(view.frame.width) - maxWidth) / 2
        addSummary()
        addChapters()
        addTableView()
        addCloseButton()
    }
    
    func addChapters() {
        // addHeader()
        addSection(name: "2023", family: Family.year)
        addSection(name: "2468", family: Family.f2468)
        addSection(name: "Like Numbers", family: Family.likeNumbers)
        addSection(name: "Addition", family: Family.addition)
        addSection(name: "Quints", family: Family.quints)
        addSection(name: "Consecutive Runs", family: Family.run)
        addSection(name: "13579", family: Family.f13579)
        addSection(name: "Winds", family: Family.winds)
        addSection(name: "369", family: Family.f369)
        addSection(name: "Singles & Pairs", family: Family.pairs)
        addEndCap()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Table View
    //
    // -----------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chapters.count
    }
        
    func addTableView() {
        if #available(iOS 13.0, *) {
            let height = view.frame.height - 200
            let width = maxWidth
            table.frame = CGRect(x: CGFloat(xOffset) - 20, y: CGFloat(yOffset + 150), width: CGFloat(width), height: height)
        } else {
            table.backgroundColor = .white
            let width = maxWidth + 160
            let narrow = parentWidth - width
             if narrow >= 20 {
                table.frame = CGRect(x:narrow/2, y:10 + 150, width:parentWidth - narrow, height: parentHeight - 20)
                table.layer.cornerRadius = 10
                setBackgroundImage()
            } else {
                let height = view.frame.height
                let width = view.frame.width
                table.frame = CGRect(x: 0, y: 20 + 150, width: width, height: height)
            }
        }
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cardViewCell")
        table.contentSize.height = 11000
        table.showsVerticalScrollIndicator = false
        table.separatorColor = .clear
        view.addSubview(table)
        print("tableView width \(table.frame.width)")
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Buttons
    //
    // -----------------------------------------------------------------------------------------
     
    override func addCloseButton() {
        // let x = table.frame.origin.x + table.frame.width - 60
        let x = view.frame.width - 50
        let y = view.frame.origin.y + 20
        let closeButton = UIButton(frame: CGRect(x: x, y: y, width: 30, height: 30))
        let image = UIImage(named: "iconfinder_circle-02_600789.png")
        closeButton.setImage(image, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
        
    
    // -----------------------------------------------------------------------------------------
    //
    //  Cells
    //
    // -----------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cardViewCell")! as UITableViewCell
        cell.selectionStyle = .none
        
        if indexPath.row < chapters.count {
            removeChapters(cell)
            cell.addSubview(chapters[indexPath.row])
            // removeButtons(cell)
        }
        return cell
    }
    
    private func removeChapters(_ cell: UITableViewCell) {
        for v in cell.subviews {
            if v.tag == 999 {
                v.removeFromSuperview()
            }
        }
    }
        
    private func removeButtons(_ cell: UITableViewCell) {
        for v in cell.subviews {
            if v.tag > 0 && v.tag < 999 {
                v.removeFromSuperview()
            }
        }
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat(0.0)
        if indexPath.row < chapters.count {
            height = chapters[indexPath.row].getHeight()
        }
        if indexPath.row + 1 == chapters.count {
            height += 40
        }
        return height
    }

    private func scrollIfLastRow(_ index: Int) {
        if index + 1 == chapters.count {
            let indexPath = IndexPath(row: index, section: 0)
            table.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func reloadRow(_ index: Int) {
        UIView.setAnimationsEnabled(false)
        CATransaction.setCompletionBlock { () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        let indexPath = IndexPath(row: index, section: 0)
        table.reloadRows(at: [indexPath], with: .none)
        CATransaction.commit()
    }
            
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < chapters.count {
            let chapter = chapters[indexPath.row]
            if chapter.expanded {
                chapters[indexPath.row].collapse()
                reloadRow(indexPath.row)
            } else {
                chapters[indexPath.row].expand()
                reloadRow(indexPath.row)
                scrollIfLastRow(indexPath.row)
            }
        }
    }
        
   
    // -----------------------------------------------------------------------------------------
    //
    //  Header
    //
    // -----------------------------------------------------------------------------------------
    
    private func addHeader() {
        let chapter = HelpChapter("Wins:   Singles \(maj.card.singleWins)    Doubles \(maj.card.doubleWins)", xOffset: xOffset, yOffset: 30, width: view.frame.width)
        chapter.addLabel("2023 \(maj.card.singleWins)             Quints \(maj.card.doubleWins)       Winds \(maj.card.doubleWins)")
        chapter.addLabel("2468 \(maj.card.singleWins)             Runs \(maj.card.doubleWins)         369 \(maj.card.doubleWins)")
        chapter.addLabel("LikeNum \(maj.card.singleWins)        13579 \(maj.card.doubleWins)       S&P \(maj.card.doubleWins)")
        chapter.addLabel("Addition \(maj.card.singleWins)")
        chapter.expand()
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Summary
    //
    // -----------------------------------------------------------------------------------------
    
    private func addSummary() {
        let label1 = UILabel(frame: CGRect(x: xOffset, y: 20, width: 600, height: 30))
        label1.text =  "Wins:  Singles \(maj.card.singleWins)  Doubles \(maj.card.doubleWins)"
        label1.font = UIFont.boldSystemFont(ofSize: 22)
        view.addSubview(label1)
        
        addItem("2023", x: xOffset, y: 50)
        addItem("2468", x: xOffset, y: 70)
        addItem("LikeNum", x: xOffset, y: 90)
        addItem("Addition", x: xOffset, y: 110)
        
        addItem("\(maj.card.getPatternWins(family: Family.year))", x: xOffset + 80, y: 50)
        addItem("\(maj.card.getPatternWins(family: Family.f2468))", x: xOffset + 80, y: 70)
        addItem("\(maj.card.getPatternWins(family: Family.likeNumbers))", x: xOffset + 80, y: 90)
        addItem("\(maj.card.getPatternWins(family: Family.addition))", x: xOffset + 80, y: 110)
                        
        addItem("Quints", x: xOffset + 200, y: 50)
        addItem("Runs", x: xOffset + 200, y: 70)
        addItem("13579", x: xOffset + 200, y: 90)
        
        addItem("\(maj.card.getPatternWins(family: Family.quints))", x: xOffset + 280, y: 50)
        addItem("\(maj.card.getPatternWins(family: Family.run))", x: xOffset + 280, y: 70)
        addItem("\(maj.card.getPatternWins(family: Family.f13579))", x: xOffset + 280, y: 90)

        addItem("Winds", x: xOffset + 400, y: 50)
        addItem("369", x: xOffset + 400, y: 70)
        addItem("S&P", x: xOffset + 400, y: 90)
        addItem("Total", x: xOffset + 400, y: 110)
        
        addItem("\(maj.card.getPatternWins(family: Family.winds))", x: xOffset + 480, y: 50)
        addItem("\(maj.card.getPatternWins(family: Family.f369))", x: xOffset + 480, y: 70)
        addItem("\(maj.card.getPatternWins(family: Family.pairs))", x: xOffset + 480, y: 90)
        addItem("\(maj.card.getPatternWins(family: Family.all))", x: xOffset + 480, y: 110)
    }
    
    private func addItem(_ text: String, x: Int, y: Int) {
        let label = UILabel(frame: CGRect(x: x, y: y, width: 100, height: 30))
        label.text =  text
        view.addSubview(label)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Section
    //
    // -----------------------------------------------------------------------------------------
    
    private func addSection(name: String, family: Int) {
        let chapter = HelpChapter(name, xOffset: xOffset, yOffset: 30, width: view.frame.width)
        for pattern in maj.card.letterPatterns {
            if pattern.family == family {
                var text = pattern.text.string
                let start = text.index(text.startIndex, offsetBy: 8);
                let end = text.index(text.startIndex, offsetBy: text.count );
                text.replaceSubrange(start..<end, with: "********")
                text = text.padding(toLength: 20, withPad: " ", startingAt: 0)
                chapter.addLabelCourier(text + "\(pattern.wins)")
            }
        }
        chapter.expand()
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  End Cap
    //
    // -----------------------------------------------------------------------------------------
    
    private func addEndCap() {
        let chapter = HelpChapter("", xOffset: xOffset, width: view.frame.width)
        chapters.append(chapter)
    }
    

}
