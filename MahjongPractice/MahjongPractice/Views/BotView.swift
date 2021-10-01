//
//  OpponentHandView.swift
//  Mahjong2017
//
//  Created by Ray Meyer on 2/19/18.
//  Copyright © 2018 Ray. All rights reserved.
//

import UIKit

class BotView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tableView: UITableView  = UITableView()
    var isHidden = true
    var maj: Maj?
    var root: UIViewController!
    var rowCount = 3
    var blankColor:UIColor = UIColor(white: 0.85, alpha: 1)
    var origin = CGPoint()
    var rackCorner = CGPoint()
    var showHighestPatternMatch = false
   
    func tileWidth() -> CGFloat {
        var h = tableView.frame.height / 3 - 4
        if UIDevice.current.userInterfaceIdiom == .pad {
            h = tableView.frame.height / 8 - 4
        }
        let w = h / 1.36
        return w
    }
    
    func tileHeight() -> CGFloat {
        return tileWidth() * 62.5 / 46.0
    }
    
    func totalTileHeight() -> CGFloat {
        return tileHeight() * 3
    }
    
    func update(_ maj: Maj) {
        if isHidden == false {
            self.maj = maj
            reloadData()
        }
    }
   
    func showView(_ rootView: UIViewController, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, blankColor: UIColor) {
        tableView.frame        =   CGRect(x: x, y: y, width: width, height: height);
        // print(tableView.frame)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "opponentTileCell")
        tableView.backgroundColor = UIColor.clear
        tableView.allowsSelection = false
        tableView.isScrollEnabled = totalTileHeight() > height ? true : false
        tableView.separatorColor = UIColor(white: 1, alpha: 0)
        
        self.blankColor = blankColor
        root = rootView
        isHidden = false
        origin.x = x
        origin.y = y
        rackCorner.y = origin.y + (tileHeight() * CGFloat(rowCount))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        let title = "Error: 501 TileView MemoryWarning"
        let message = "Contact support@eightbam.com"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: true, completion: nil)
    }
    
    func checkBounds(_ location: CGPoint) -> Bool {
        return (location.x >= origin.x) && (location.x <= rackCorner.x) && (location.y >= origin.y) && (location.y <= rackCorner.y)
    }
    
    func lowerCorner(_ location: CGPoint, tileHeight: CGFloat) -> Bool {
        return (location.x <= rackCorner.x) && (location.y >= (origin.y - tileHeight))
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = rowCount
        if maj?.viewOpponentHands ?? false {
            count = rowCount * 2
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tileHeight() + 4.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "opponentTileCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clear
        for v in cell.subviews {
            v.removeFromSuperview()
        }

        switch indexPath.row {
            case 0: showRack(cell: cell, maj: maj! , state: State.south)
            case 1: showRack(cell: cell, maj: maj!, state: State.west)
            case 2: showRack(cell: cell, maj: maj!, state: State.north)
            default: break
        }
        
        return cell
    }
    
    func showRack(cell: UITableViewCell, maj: Maj, state: Int) {
        let rack = maj.getRack(state: state)
        
        var tileIndex = CGFloat(0.0)
        for tile in rack.tiles {
            let x = tileIndex * (tileWidth() + 1.0)
            let y: CGFloat = 2.0
            let v = UIImageView(frame:CGRect(x: x, y: y, width: tileWidth(), height: tileHeight()))
            v.contentMode = .scaleAspectFit
            v.layer.masksToBounds = true
            v.layer.cornerRadius = tileWidth() / 8
            v.image = UIImage(named: tile.getImage(maj: maj))
            cell.addSubview(v)
            tileIndex += 1
            rackCorner.x = origin.x + x + tileWidth()
        }

        if tileIndex < 14
        {
            let start = Int(tileIndex)
            for _ in start...13 {
                let x = tileIndex * (tileWidth() + 1.0)
                let y: CGFloat = 2.0
                let v = UIView(frame:CGRect(x: x, y: y, width: tileWidth(), height: tileHeight()))
                v.backgroundColor = blankColor
                v.layer.masksToBounds = true
                v.layer.cornerRadius = tileWidth() / 8
                cell.addSubview(v)
                tileIndex += 1
                rackCorner.x = origin.x + x + tileWidth()
            }
        }
        
        if showHighestPatternMatch {
            let hand = maj.getHand(state: state)
            let label1 = UILabel()
            let x = 14 * (tileWidth() + 1.0) + 5.0
            label1.frame = CGRect(x: x, y: 8.0, width: 350, height: tileHeight())
            let letterPattern = maj.card.getLetterPattern(hand.getHighestMatch().letterPatternId)
            let attributedText = NSMutableAttributedString()
            attributedText.append(letterPattern.text)
            attributedText.append(NSAttributedString(string: "  "))
            attributedText.append(letterPattern.note)
            label1.attributedText = attributedText
            cell.addSubview(label1)
        } else {
            let label1 = UILabel()
            let x = 14 * (tileWidth() + 1.0) + 5.0
            label1.frame = CGRect(x: x, y: 8.0, width: 350, height: tileHeight())
            label1.text = rack.message != "" ? rack.message : rack.name
            label1.font = UIFont(name: "Chalkduster", size: 16)
            label1.textColor = UIColor.black
            cell.addSubview(label1)
        }
     }
  
}
