//
//  NarrowViewController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/11/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

protocol NarrowViewDelegate {
    func getBackgroundColor() -> UIColor
}

class NarrowViewController: UIViewController {
    var xOffset = 0
    var yOffset = 0
    var tileHeight = Int(72 * 0.8)
    var tileWidth = Int(54 * 0.8)
    var parentWidth = 0
    var parentHeight = 0
    var maxWidth = 430
    var scrollView = UIScrollView()
    var scrollViewHeight = CGFloat(1000)
    var narrowViewDelegate: NarrowViewDelegate
    var bottom = 0

    
    // -----------------------------------------------------------------------------------------
    //
    //  Init
    //
    // -----------------------------------------------------------------------------------------
    
    init(frame: CGRect, narrowViewDelegate: NarrowViewDelegate) {
        self.parentWidth = Int(frame.width)
        self.parentHeight = Int(frame.height)
        self.narrowViewDelegate = narrowViewDelegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = narrowViewDelegate.getBackgroundColor()
            setBackgroundImage()
        }
    }

    func narrowView() {
        if #available(iOS 13.0, *) {
            if parentWidth == Int(view.frame.width) {
                let width = maxWidth + 160
                let narrow = parentWidth - width
                if narrow >= 20 {
                    view.frame = CGRect(x:narrow/2, y:10, width:parentWidth - narrow, height: parentHeight)
                    view.layer.cornerRadius = 10
                }
            }
        }
        print("narrowView \(view.frame.width)")
    }
    
    func setBackgroundImage(){
        let background = UIImage(named: "TRANS-ICON-WHITE.png")
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.contentMode =  UIView.ContentMode.scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.image = background
        backgroundImageView.center = view.center
        backgroundImageView.alpha = 0.15
        view.addSubview(backgroundImageView)
        // view.sendSubview(toBack: backgroundImageView)
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
    
    // derived classes should override this
    func addControls() {
        narrowView()
        addScrollView()
        xOffset = (Int(scrollView.frame.width) - maxWidth) / 2
        addCloseButton()
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Scroll View
    //
    // -----------------------------------------------------------------------------------------
    
    func addScrollView() {
        if #available(iOS 13.0, *) {
            let height = view.frame.height
            let width = view.frame.width
            scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        } else {
            scrollView.backgroundColor = .white
            let width = maxWidth + 160
            let narrow = parentWidth - width
            print("addScrollView \(width) \(narrow)")
            if narrow >= 20 {
                scrollView.frame = CGRect(x:narrow/2, y:10, width:parentWidth - narrow, height: parentHeight - 20)
                scrollView.layer.cornerRadius = 10
                setBackgroundImage()
            } else {
                let height = view.frame.height
                let width = view.frame.width
                scrollView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        }
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollViewHeight)
        view.addSubview(scrollView)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Section Title
    //
    // -----------------------------------------------------------------------------------------
         
    func addTitle(_ text: String, y: Int) {
        let title = UILabel(frame: CGRect(x: xOffset, y: y, width: maxWidth, height: 55))
        title.text = text
        title.font = UIFont.boldSystemFont(ofSize: 22)
        scrollView.addSubview(title)
        bottom = Int(title.frame.origin.y + 40)
    }
    
    func addLabel(_ text: String, y: Int) -> UITextView {
        let label = UITextView(frame: CGRect(x: xOffset, y: y, width: maxWidth, height: 21))
        label.text = text
        label.isScrollEnabled = false
        label.isEditable = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        scrollView.addSubview(label)
        bottom = Int(label.frame.origin.y + label.frame.height)
        return label
    }
    
    func addLabelItalic(_ text: String, y: Int) {
        let label = UITextView(frame: CGRect(x: xOffset, y: y, width: maxWidth, height: 21))
        label.text = text
        label.isScrollEnabled = false
        label.isEditable = false
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.sizeToFit()
        scrollView.addSubview(label)
        bottom = Int(label.frame.origin.y + label.frame.height)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Buttons
    //
    // -----------------------------------------------------------------------------------------
     
    func addCloseButton() {
        let x = scrollView.frame.origin.x + scrollView.frame.width - 50
        let y = scrollView.frame.origin.y + 20
        let closeButton = UIButton(frame: CGRect(x: x, y: y, width: 30, height: 30))
        let image = UIImage(named: "iconfinder_circle-02_600789.png")
        closeButton.setImage(image, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        self.view.addSubview(closeButton)
    }
    
    @objc func closeButtonAction(sender: UIButton!) {
         self.dismiss(animated: true, completion: nil)
    }
  
    
    // -----------------------------------------------------------------------------------------
    //
    //  Add Line
    //
    // -----------------------------------------------------------------------------------------
    
    func addLine(x: Int, y: Int) -> UIView {
        let line = UIView(frame: CGRect(x: x, y: y, width: maxWidth, height: 1))
        if #available(iOS 13.0, *) {
            line.backgroundColor = .quaternaryLabel
        } else {
            line.backgroundColor = .lightGray
        }
        scrollView.addSubview(line)
        return line
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Add Images
    //
    // -----------------------------------------------------------------------------------------
    
    func addScreenShot(_ named: String, y: Int) {
        let width = Int(Double(maxWidth) * 0.9)
        let height = Int(Double(maxWidth * 1170 / 2532) * 0.9)
        let v = UIImageView(frame:CGRect(x: xOffset, y: y, width: width, height: height))
        v.contentMode = .scaleAspectFit
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 10
        v.image = UIImage(named: named)
        scrollView.addSubview(v)
        bottom = Int(v.frame.origin.y + v.frame.height)
    }

    func addTile(_ named: String, index: Int, y: Int) -> UIImageView {
        let x = xOffset + (index * tileWidth) + 5
        let tile = UIImageView(frame:CGRect(x: x, y: y, width: tileWidth, height: tileHeight))
        tile.contentMode = .scaleAspectFit
        tile.layer.masksToBounds = true
        tile.layer.cornerRadius = CGFloat(tileWidth / 8)
        tile.image = UIImage(named: named)
        scrollView.addSubview(tile)
        return tile
    }
    
}
