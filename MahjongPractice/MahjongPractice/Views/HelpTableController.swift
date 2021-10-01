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
        //addExpandAllButton()   // cleaner without this
        //addCollapseAllButton()    // cleaner without this
    }
    
    func addChapters() {
        addIntro()
        addRules()
        addHands()
        addMovingTiles()
        addSortingTiles()
        addPassingAndDiscards()
        addCharleston()
        addPlay()
        addCalling()
        addDrawing()
        addDeclaring()
        addBots()
        addBlindPassing()
        addUndo()
        addHowToClose()
        addFlowers()
        addBams()
        addDots()
        addCraks()
        addWinds()
        addJokers()
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
            let width = maxWidth + 160
            let narrow = parentWidth - width
             if narrow >= 20 {
                table.frame = CGRect(x:narrow/2, y:10, width:parentWidth - narrow, height: parentHeight - 20)
                table.layer.cornerRadius = 10
                setBackgroundImage()
            } else {
                let height = view.frame.height
                let width = view.frame.width
                table.frame = CGRect(x: 0, y: 20, width: width, height: height)
            }
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
    
    func addExpandAllButton() {
         if #available(iOS 13.0, *) {
             let x = view.frame.width - 60
             let y = view.frame.height - 120
             let button = UIButton(frame: CGRect(x: x, y: y, width: 40, height: 40))
             let image = UIImage(named: "arrow_right.png")
             button.setImage(image, for: .normal)
             button.imageView?.contentMode = .scaleAspectFit
             button.addTarget(self, action: #selector(expandAllButtonAction), for: .touchUpInside)
             self.view.addSubview(button)
         } else {
             let x = scrollView.frame.origin.x + scrollView.frame.width - 115
             let y = CGFloat(20)
             let button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 30))
             button.backgroundColor = .darkGray
             button.layer.cornerRadius = 5
             button.setTitle("Expand", for: .normal)
             button.addTarget(self, action: #selector(expandAllButtonAction), for: .touchUpInside)
             self.view.addSubview(button)
         }
    }
    
    @objc func expandAllButtonAction(sender: UIButton!) {
        for (index, chapter) in chapters.enumerated() {
            chapter.expand()
            reloadRow(index)
        }
    }
    
    func addCollapseAllButton() {
         if #available(iOS 13.0, *) {
             let x = view.frame.width - 60
             let y = view.frame.height - 80
             let button = UIButton(frame: CGRect(x: x, y: y, width: 40, height: 40))
             let image = UIImage(named: "arrow_down.png")
             button.setImage(image, for: .normal)
             button.imageView?.contentMode = .scaleAspectFit
             button.addTarget(self, action: #selector(collapseAllButtonAction), for: .touchUpInside)
             self.view.addSubview(button)
         } else {
             let x = scrollView.frame.origin.x + scrollView.frame.width - 115
             let y = CGFloat(20)
             let button = UIButton(frame: CGRect(x: x, y: y, width: 80, height: 30))
             button.backgroundColor = .darkGray
             button.layer.cornerRadius = 5
             button.setTitle("Collapse", for: .normal)
             button.addTarget(self, action: #selector(collapseAllButtonAction), for: .touchUpInside)
             self.view.addSubview(button)
         }
    }
    
    @objc func collapseAllButtonAction(sender: UIButton!) {
        for (index, chapter) in chapters.enumerated() {
            if index > 0 {
                chapter.collapse()
                reloadRow(index)
            }
        }
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
            
            // Removed the arrow buttons for expanding and colapsing each entry because is cleaner.
            //if indexPath.row != 0 {
            //    addButton(cell, index: indexPath.row)
            //}
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
    
    private func addButton(_ cell: UITableViewCell, index: Int) {
        if index < chapters.count {
            let chapter = chapters[index]
            if chapter.expanded {
                let button = UIButton()
                button.frame = CGRect(x: Int(table.frame.width) - 60, y: yOffset, width: 40, height: 40)
                button.setImage(UIImage(named: "arrow_down"), for: .normal)
                button.setTitleColor(UIColor.darkGray, for: .normal)
                button.addTarget(self, action: #selector(collapse), for: .touchUpInside)
                button.tag = index
                cell.addSubview(button)
            } else {
                let button = UIButton()
                button.frame = CGRect(x: Int(table.frame.width) - 60, y: yOffset, width: 40, height: 40)
                button.setImage(UIImage(named: "arrow_right"), for: .normal)
                button.setTitleColor(UIColor.darkGray, for: .normal)
                button.addTarget(self, action: #selector(expand), for: .touchUpInside)
                button.tag = index
                cell.addSubview(button)
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

    @objc func expand(_ sender: UIView) {
        if sender.tag < chapters.count {
            chapters[sender.tag].expand()
            reloadRow(sender.tag)
            scrollIfLastRow(sender.tag)
        }
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
        
    @objc func collapse(_ sender: UIView) {
        if sender.tag < chapters.count {
            chapters[sender.tag].collapse()
            reloadRow(sender.tag)
        }
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
    
    private func collapseAll() {
        for (index, chapter) in chapters.enumerated() {
            if chapter.expanded {
                chapter.collapse()
                reloadRow(index)
            }
        }
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Intro
    //
    // -----------------------------------------------------------------------------------------
    
    private func addIntro() {
        let intro = HelpChapter("American Mahjong Practice", xOffset: xOffset, yOffset: 30, width: view.frame.width)
        intro.addLabel("Contact support@eightbam.com for help.")
        intro.expand()
        chapters.append(intro)
    }
    
    // -----------------------------------------------------------------------------------------
    //
    //  Rules
    //
    // -----------------------------------------------------------------------------------------
    
    private func addRules() {
        let rules = HelpChapter("Rules & References", xOffset: xOffset, width: view.frame.width)
        rules.addLabel("Beginners should learn basic American Mahjong rules before playing. This game is designed for practicing patterns with any MahJong card from any league. Rules are not enforced.\n\nReferences:\n\n \u{2022} The back of your card\n \u{2022} Mahjong Classes\n \u{2022} Online References\n \u{2022} YouTube Michelle Frizzel Fundamentals\n\nBooks:")
        rules.addLabelItalic(" \u{2022} The Red Dragon & The West Wind\n \u{2022} American Mah Jongg for Everyone\n \u{2022} Searching for Bubbe Fischer: The Path to Mah Jongg Wisdom")
        rules.addLabel("Events, Clubs, Teachers and more:\n\n \u{2022} https://modernmahjong.com\n")
        chapters.append(rules)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Hands
    //
    // -----------------------------------------------------------------------------------------
    
    private func addHands() {
        let chapter = HelpChapter("Suggested Hands", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("The Patterns and Tiles buttons show suggested hands. Hands are sorted by the matching tile count only. They do not account for dead hands, discarded tiles, or the chances of making pairs.  Those details and strategy are up to you when you decide what hands to play.")
        chapter.addScreenShot("counters12.png")
        chapter.addLabel("You can filter out entire sections in Settings or hide individual pattterns on the Patterns view. These views will show you patterns you don't normally think of, and combinations of patterns that work well together\n\n")
        chapters.append(chapter)
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
    //  Sorting Tiles
    //
    // -----------------------------------------------------------------------------------------
    
    private func addSortingTiles() {
        let chapter = HelpChapter("Sorting Tiles", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Sort your tiles for the hand you are playing. Follow the tile moving instructions above. Move each tile into position as needed.")
        chapter.addScreenShot("sort1.png")
        chapter.addScreenShot("sort2.png")
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Passing & Discards
    //
    // -----------------------------------------------------------------------------------------
    
    private func addPassingAndDiscards() {
        let chapter = HelpChapter("Passing & Discards", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Passing and discarding are two step processes.\n\n \u{2022} First move tiles to the empty passing or discard positions below your hand.\n \u{2022} Then drag from that position off screen to the right to complete.\n\n")
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Charleston
    //
    // -----------------------------------------------------------------------------------------
    
    private func addCharleston() {
        let chapter = HelpChapter("Charleston", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("There are 2 rows showing during the Charleston.\n\n \u{2022} The first row of 14 tiles is your hand.\n \u{2022} The second row of 3 tiles is for passing tiles.\n\nDrag 3 tiles from your hand onto the empty 3 positions below your hand.  Then drag tiles off screen to the right to pass.\n\nInitiate a drag gesture:")
        chapter.addScreenShot("charles11.png")

        chapter.addLabel("\nDrop in passing position:")
        chapter.addScreenShot("charles12.png")
        
        chapter.addLabel("\nComplete with 2 more tiles, then drag offscreen to pass:")
        chapter.addScreenShot("charles13.png")
        
        chapter.addLabel("\nThree new tiles will show up in your hand.  They were passed to you from an opponent bot:")
        chapter.addScreenShot("charles14.png")

        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Play
    //
    // -----------------------------------------------------------------------------------------
    
    private func addPlay() {
        let chapter = HelpChapter("Play", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("After the Charleston 3 rows are showing.\n\n \u{2022} The top row of 14 tiles is your empty rack. Expose tiles that you call here.\n \u{2022} The second row of 14 tiles is your hand.\n \u{2022} The third row with a single tile is used for both your discard and the opponent discards.\n\nYou are always the East player. The text next to the discard position tells you when it is your turn or whose discard is showing.\n\nOn your turn, when the discard position is empty, drag a tile from your hand to the discard position first and then drag it off screen to discard.\n\nDrag:")
        chapter.addScreenShot("play11.png")
        
        chapter.addLabel("\nDrop:")
        chapter.addScreenShot("play12.png")
        
        chapter.addLabel("\nDiscard:")
        chapter.addScreenShot("play13.png")
       
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Calling
    //
    // -----------------------------------------------------------------------------------------
    
    private func addCalling() {
        let chapter = HelpChapter("Calling", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("To pick up an opponents discarded tile, drag it from the discard position and drop it onto the top row above your hand exposing it. After a call, complete the top rack exposure with the matching tiles from your hand. Then discard a tile from your hand to continue.\n\nCall an opponent discard by dragging it to your rack:")
        chapter.addScreenShot("call11.png")
        
        chapter.addLabel("\nAdd matching tiles from your hand to complete the exposure. Jokers should be placed to the right of tiles they are being used for. Repositioning exposed Jokers on the top rack will reassign them when placed to the right of a different tile:")
        chapter.addScreenShot("call12.png")
        
        chapter.addLabel("\nDiscard to continue play:")
        chapter.addScreenShot("call13.png")
        
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Drawing from the Wall
    //
    // -----------------------------------------------------------------------------------------
    
    private func addDrawing() {
        let chapter = HelpChapter("Drawing from the Wall", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Tiles from the wall are put into your hand automatically when you don't call discards. Each player discards and then waits for you to pick up or pass on their tile. When you pass on every tile discarded by the opponent bots a tile from the wall will be automatically added to the end of your hand. You will never draw from the wall directly:")
        chapter.addScreenShot("draw1.png")
        chapter.addScreenShot("draw2.png")
        chapter.addScreenShot("draw3.png")
        chapter.addScreenShot("draw4.png")
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Declaring Mahjong
    //
    // -----------------------------------------------------------------------------------------
    
    private func addDeclaring() {
        let chapter = HelpChapter("Declaring Mahjong", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Move all your tiles to the rack above your hand to expose and declare Mahjong:")
        chapter.addScreenShot("declaremahjong.png")
        chapter.expandBody(30)
        chapters.append(chapter)
    }

    
    // -----------------------------------------------------------------------------------------
    //
    //  Bots
    //
    // -----------------------------------------------------------------------------------------
    
    private func addBots() {
        let chapter = HelpChapter("Opponent Bots", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("The computer players you play against are called Bots. Bots play valid mahjong patterns and call tiles, but will not declare mahjong unless enabled in Settings. In MahJong Practice you can play against the Wall with bot wins disabled. Bots will exchange tiles for exposed jokers on their turn, and they provide jokers you can take. If you wish to play against bots go to the Settings View from the Menu Button and enable Opponent Bot Wins.\n\nTo claim a joker drag a tile from your hand and drop it onto a bot hand on your turn:")
        chapter.addScreenShot("bots1.png")
        
        chapter.addLabel("\nThe Joker will show up in your hand in the last open position:")
        chapter.addScreenShot("bots2.png")
        
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Charleston Blind Passing
    //
    // -----------------------------------------------------------------------------------------
    
    private func addBlindPassing() {
        let chapter = HelpChapter("Charleston Blind Passing, Stopping and Courtesy Pass", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("During blind passing rounds only, like the First Left, you can pass with fewer tiles.  For example pass 2 tiles on the First Left if you dont want to pass all 3:")
        chapter.addScreenShot("blind3.png")
        
        chapter.addLabel("\nIf you want to pass 0 tiles from your hand on a blind pass round, or to stop the charleston on the Second Left, drag the first empty charleston position off screen:")
        chapter.addScreenShot("blind2.png")
        
        chapter.expandBody(30)
        chapters.append(chapter)
    }
   
    
    // -----------------------------------------------------------------------------------------
    //
    //  Undo
    //
    // -----------------------------------------------------------------------------------------
    
    private func addUndo() {
        let chapter = HelpChapter("Undo", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Drag a tile from the discard position to the left to undo. The previous tile will return to the discard position.\n")
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  How to close
    //
    // -----------------------------------------------------------------------------------------
    
    private func addHowToClose() {
        let chapter = HelpChapter("How To Close Newer iPhones", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("To close any app without a home button, swipe up from the bottom of screen and pause halfway. You'll then see all the apps that are currently open. Swipe an app up to close an individual app.  Since this app is always in landscape mode the bottom is the long side. There will be a black bar on the bottom of the screen.\n")
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Flowers for Beginners
    //
    // -----------------------------------------------------------------------------------------
    
    private func addFlowers() {
        let chapter = HelpChapter("Flowers for Beginners", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("These are the 8 flower tiles we use. Flowers are interchangable. Learning to recognize flower tiles is important. Note flower tiles and One Bam often look alike.")

        chapter.addTile("f1.png", index: 0)
        chapter.addTile("f2.png", index: 1)
        chapter.addTile("f3.png", index: 2)
        chapter.addTile("f4.png", index: 3)
        chapter.addTile("spr.png", index: 4)
        chapter.addTile("sum.png", index: 5)
        chapter.addTile("aut.png", index: 6)
        chapter.addTile("win.png", index: 7)
        
        chapter.expandBodyTileHeight()
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Bams
    //
    // -----------------------------------------------------------------------------------------
    
    private func addBams() {
        let chapter = HelpChapter("Bams & Green Dragon", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("One Bam is usually a bird on bamboo. Ours looks like an owl.")
        chapter.addTile("1bam.png", index: 0)
        chapter.addTile("2bam.png", index: 1)
        chapter.addTile("3bam.png", index: 2)
        chapter.addTile("4bam.png", index: 3)
        chapter.addTile("5bam.png", index: 4)
        chapter.addTile("6bam.png", index: 5)
        chapter.addTile("7bam.png", index: 6)
        chapter.addTile("8bam.png", index: 7)
        chapter.addTile("9bam.png", index: 8)
        chapter.addTile("green.png", index: 9)
        chapter.expandBodyTileHeight()
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Dots
    //
    // -----------------------------------------------------------------------------------------
    
    private func addDots() {
        let chapter = HelpChapter("Dots & Soap", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Year patterns require the Soap tile for zero.")
        chapter.addTile("1dot.png", index: 0)
        chapter.addTile("2dot.png", index: 1)
        chapter.addTile("3dot.png", index: 2)
        chapter.addTile("4dot.png", index: 3)
        chapter.addTile("5dot.png", index: 4)
        chapter.addTile("6dot.png", index: 5)
        chapter.addTile("7dot.png", index: 6)
        chapter.addTile("8dot.png", index: 7)
        chapter.addTile("9dot.png", index: 8)
        chapter.addTile("soap.png", index: 9)
        chapter.expandBodyTileHeight()
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Craks
    //
    // -----------------------------------------------------------------------------------------
    
    private func addCraks() {
        let chapter = HelpChapter("Craks & Red Dragon", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Dragon suits are important. Craks go with Red Dragon. Bams go with Green Dragon. Dots go with Soaps.")
        chapter.addTile("1crak.png", index: 0)
        chapter.addTile("2crak.png", index: 1)
        chapter.addTile("3crak.png", index: 2)
        chapter.addTile("4crak.png", index: 3)
        chapter.addTile("5crak.png", index: 4)
        chapter.addTile("6crak.png", index: 5)
        chapter.addTile("7crak.png", index: 6)
        chapter.addTile("8crak.png", index: 7)
        chapter.addTile("9crak.png", index: 8)
        chapter.addTile("red.png", index: 9)
        chapter.expandBodyTileHeight()
        chapter.expandBody(30)
        chapters.append(chapter)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Winds
    //
    // -----------------------------------------------------------------------------------------
    
    private func addWinds() {
        let chapter = HelpChapter("Winds", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("There are 4 of each Wind Tile, like Dots, Bams and Craks")
        chapter.addTile("north.png", index: 0)
        chapter.addTile("east.png", index: 1)
        chapter.addTile("west.png", index: 2)
        chapter.addTile("south.png", index: 3)
        chapter.expandBodyTileHeight()
        chapter.expandBody(30)
        chapters.append(chapter)
    }
        
    
    // -----------------------------------------------------------------------------------------
    //
    // Jokers
    //
    // -----------------------------------------------------------------------------------------
    
    private func addJokers() {
        let chapter = HelpChapter("Jokers", xOffset: xOffset, width: view.frame.width)
        chapter.addLabel("Jokers can only be used in 3, 4, 5 or 6 of the same kind of tile. Jokers can never be used in singles or pairs including 2020 and NEWS. There are 8 Joker tiles.")
        chapter.addTile("joker.png", index: 0)
        chapter.expandBodyTileHeight()
        chapter.expandBody(30)
        chapters.append(chapter)
    }
  


}
