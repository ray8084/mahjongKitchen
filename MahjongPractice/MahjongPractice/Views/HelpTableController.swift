//
//  HelpTableController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/15/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

class HelpTableController: NarrowViewController, UITableViewDelegate, UITableViewDataSource {
  
    var table: UITableView  = UITableView()
    var chapters: [HelpChapter] = []
    
    override func addControls() {
        maxWidth = 620
        narrowView()
        xOffset = (Int(view.frame.width) - maxWidth) / 2
        addChapters()
        addTableView()
        addCloseButton()
    }
    
    func addChapters() {
        addIntro()
        addMovingTiles()
        addDiscarding()
        addPassing()
        addCalling()
        addWinning()
        addHands()
        //addHistory()
        addTips()
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
            let height = view.frame.height
            let width = maxWidth
            table.frame = CGRect(x: CGFloat(xOffset) - 20, y: CGFloat(yOffset), width: CGFloat(width), height: height)
        } else {
            table.backgroundColor = .white
            let height = view.frame.height
            let width = view.frame.width - 80
            table.frame = CGRect(x: 40, y: 20, width: width, height: height)
            table.layer.cornerRadius = 10
        }
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cardViewCell")
        table.contentSize.height = 11000
        table.showsVerticalScrollIndicator = false
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
        let y = table.frame.origin.y + 20
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
            removeButtons(cell)
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
    //  Intro
    //
    // -----------------------------------------------------------------------------------------
    
    private func addIntro() {
        let intro = HelpChapter("Two Handed American Mahjong Practice", xOffset: xOffset, yOffset: 30, width: view.frame.width)
        intro.addLabel("Advanced practice for experienced players. Play two hands of Mahjong at the same time. No Charleston. Move tiles between hands. Rules are not enforced. If you are a beginning player you should start with the American Mahjong Practice app.\n\nContact support@eightbam.com for help.")
        intro.expand()
        chapters.append(intro)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Moving Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    private func addMovingTiles() {
        let chapter = HelpChapter("Moving Tiles", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("To move a tile, drag it from a starting location and drop on an ending location. Tiles are not moved with tapping or swipping motions.\n\n \u{2022} Touch and hold on a tile.\n \u{2022} While maintaining a finger on the tile, move your finger away to initiate a drag gesture.\n \u{2022} You now have a tile that can be dropped onto another position.\n")
        chapters.append(chapter)
    }
 
    
    // -----------------------------------------------------------------------------------------
    //
    //  Discards
    //
    // -----------------------------------------------------------------------------------------
    
    private func addDiscarding() {
        let chapter = HelpChapter("Discarding", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Discarding is a two step processes.\n\n \u{2022} First move a tile to the empty discard position below your hand.\n \u{2022} Then drag from that position to the right to complete.\n")
        chapter.addScreenShot("discard1.png")
        chapter.addScreenShot("discard2.png")
        
        chapter.addLabel("\nWest (the opponent bot) will discard next. You will see that new tile in the discard position, along with a note that the disard came from west.  In this practice game West is discarding randomly. West is not working on a hand or providing Jokers for exchange.")
        chapter.addScreenShot("discard3.png")
        
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Passing
    //
    // -----------------------------------------------------------------------------------------
    
    private func addPassing() {
        let chapter = HelpChapter("Passing", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("When you don't want to pick up a discard from West drag it off screen like your own discard.")
        chapter.addScreenShot("discard4.png")
        
        chapter.addLabel("\nA new tile from the wall will automatically show up in your hand.")
        chapter.addScreenShot("discard5.png")
        
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Calling
    //
    // -----------------------------------------------------------------------------------------
    
    private func addCalling() {
        let chapter = HelpChapter("Calling", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Call a discard from West by dragging up and dropping on the exposed section of your rack.")
        chapter.addScreenShot("doublescall1.png")
        
        chapter.addLabel("\nThen add the rest of the tiles from your hand to complete the set.")
        chapter.addScreenShot("doublescall2.png")
        chapter.addScreenShot("doublescall3.png")
        
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Winning
    //
    // -----------------------------------------------------------------------------------------
    
    private func addWinning() {
        let chapter = HelpChapter("Winning", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Expose winning hands on the two rows above your two hands.")
        chapter.addScreenShot("doublesmaj1.png")
        chapter.addScreenShot("doublesmaj2.png")
        
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Hands
    //
    // -----------------------------------------------------------------------------------------
    
    private func addHands() {
        let hands = HelpChapter("Hands", xOffset: xOffset, width: view.frame.width)
        /*hands.addLabel("Use your 2023 mahjong card to select hands to play, or use the Hands option on the toolbar to the right.")
        hands.addLabel("With the Hands option you can see how many tiles from your 2 hands together match hands on the mahjong card. The Hands features does not account for overlapping tiles between hands, that's your challenge. Select up to 3 hands to see below your tiles. The entire 2023 card is not shown at once, only the highesst matching hands. This feature works best for the first hand.")*/
        hands.addLabel("Use your 2023 mahjong card to select hands to play.")
        chapters.append(hands)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  History
    //
    // -----------------------------------------------------------------------------------------
    
    private func addHistory() {
        let history = HelpChapter("History", xOffset: xOffset, width: view.frame.width)
        history.addLabel("See your progress completing the card with the History page on the Game menu.")
        chapters.append(history)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tips
    //
    // -----------------------------------------------------------------------------------------
    
    private func addTips() {
        let tips = HelpChapter("Tips", xOffset: xOffset, width: view.frame.width)
        tips.addLabel("Because there is no rule enforcement you can organize your tiles among 3 or 4 rows. When you are ready to declare mahjong consolidate to 2 or 3 rows.")
        chapters.append(tips)
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
