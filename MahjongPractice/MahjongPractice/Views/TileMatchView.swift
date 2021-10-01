//
//  TileMatchView.swift
//  Mahjong2017
//
//  Created by Ray Meyer on 12/2/17.
//  Copyright © 2017 Ray. All rights reserved.
//

import UIKit

class TileMatchView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var tableView: UITableView  = UITableView()
    var isHidden = true
    var maj: Maj?
    var root: UIViewController!
    var maxRows = 100
    var bgcolor:UIColor = UIColor.gray
    
    func tileWidth() -> CGFloat {
        return view.frame.width / 28
    }
    
    func tileHeight() -> CGFloat {
        return tileWidth() * 62.5 / 46.0
    }

    func loadPatterns(maj: Maj, letterPatterns: [LetterPattern]) {
        self.maj = maj
        maj.loadPatterns(letterPatterns)
    }
    
    func update(_ maj: Maj) {
        if isHidden == false {
            maj.east.tileMatches.countMatchesForEast(maj)
            maj.east.tileMatches.sort()
            reloadData()
        }
    }
    
    func updateRackFilter(_ maj: Maj) {
        if maj.isGameOver() {
            maj.east.tileMatches.clearRackFilter()
            maj.east.tileMatches.countMatchesForEast(maj)
            maj.east.tileMatches.sort()
            reloadData()
            maj.tileMatchesRackFilterPending = false
        } else if isHidden == false && maj.tileMatchesRackFilterPending {
            maj.east.tileMatches.rackFilter(maj.east.rack!)
            maj.east.tileMatches.countMatchesForEast(maj)
            maj.east.tileMatches.sort()
            reloadData()
            maj.tileMatchesRackFilterPending = false
        }
    }
    
    func clearRackFilter() {
        maj?.east.tileMatches.clearRackFilter()
    }

    func showView(_ rootView: UIViewController, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, bgcolor: UIColor) {
        tableView.frame        =   CGRect(x: x, y: y, width: width, height: height);
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tileMatchCell")
        //tableView.backgroundColor = bgcolor
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor(white: 0, alpha: 0)
        self.bgcolor = bgcolor
        root = rootView
        //UIView.animate(withDuration: 0.3, delay: 0.1, options: [],
        //               animations: {self.tableView.center.x -= 2000+x},
        //               completion: nil
        //)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        let title = "Error: 601 TilesView MemoryWarning"
        let message = "Contact support@eightbam.com"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
        }));
        present(alert, animated: true, completion: nil)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for tm in maj?.east.tileMatches.list ?? [] {
            if tm.matchCount > 0 {
                count+=1
            }
        }
        if count > maxRows {
            count = maxRows
        }
        if maj?.isGameOver() ?? false {
            count = 1
        }
        return(count)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tileHeight() + 4.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "tileMatchCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clear
        for v in cell.subviews {
            v.removeFromSuperview()
        }
        
        //print("index \(maj.east.tileMatches.list[indexPath.row].letterPatternId)")
     
        var tileIndex = CGFloat(0.0)
        for id in maj?.east.tileMatches.list[indexPath.row].tileIds ?? [] {
            let x = tileIndex * (tileWidth() + 1.0)
            let y: CGFloat = 0.0 + 2
            let v = UIImageView(frame:CGRect(x: x, y: y, width: tileWidth(), height: tileHeight()))
            v.contentMode = .scaleAspectFit
            v.layer.masksToBounds = true
            v.layer.cornerRadius = tileWidth() / 8
            v.image = UIImage(named: Tile.getImage(id: id, maj: maj!))
            cell.addSubview(v)
            tileIndex += 1
        }
        
        let label1 = UILabel()
        var x = tileIndex * (tileWidth() + 1.0) + 2.0
        label1.frame = CGRect(x: x, y: 8.0, width: 40, height: tileHeight())
        if maj?.east.tileMatches.list[indexPath.row].concealed ?? false {
            label1.text = "(C)"
            label1.font = UIFont(name: "Chalkduster", size: 15)
            label1.textColor = UIColor.black
            cell.addSubview(label1)
        }
        
        let label2 = UILabel()
        x = tileIndex * (tileWidth() + 1.0) + 40
        label2.frame = CGRect(x: x, y: 8.0, width: 150, height: tileHeight())
        let matchCount = String(maj?.east.tileMatches.list[indexPath.row].matchCount ?? 0)
        if indexPath.row == 0 {
            label2.text = matchCount + " matching tiles"
        } else {
            label2.text = matchCount
        }
        label2.font = UIFont(name: "Chalkduster", size: 15)
        label2.textColor = UIColor.black
        cell.addSubview(label2)
        
        return cell
    }
  
    
}
