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
    
    override func addControls() {
        maxWidth = 620
        narrowView()
        xOffset = (Int(view.frame.width) - maxWidth) / 2
        addChapters()
        addTableView()
        addCloseButton()
    }
    
    func addChapters() {
        addYear()
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
    //  Year
    //
    // -----------------------------------------------------------------------------------------
    
    private func addYear() {
        let year = HelpChapter("2023", xOffset: xOffset, yOffset: 30, width: view.frame.width)
        year.addLabel("test")
        year.expand()
        chapters.append(year)
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
