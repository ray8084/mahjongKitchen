//
//  HelpTableController.swift
//  Mahjong2018
//
//  Created by Ray Meyer on 12/15/20.
//  Copyright © 2020 EightBam. All rights reserved.
//

import UIKit

class HandsController: NarrowViewController  {

    private var maj: Maj!
    private var handView = HandView()
    private var filterSegmentControl: UISegmentedControl!
    
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
        
        addFilterSegmentControl()
        addCloseButton()
        
        handView.showCard(self, x: 30, y: 60, width: view.frame.width - 50, height: view.frame.height - 150, bgcolor: .black, maj: maj)
        handView.isHidden = false
        view.addSubview(handView.cardView)
        handView.update(maj)
    }
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Buttons
    //
    // -----------------------------------------------------------------------------------------
     
    override func addCloseButton() {
        let x = view.frame.width - 50
        let closeButton = UIButton(frame: CGRect(x: x, y: 20, width: 30, height: 30))
        let image = UIImage(named: "iconfinder_circle-02_600789.png")
        closeButton.setImage(image, for: .normal)
        closeButton.imageView?.contentMode = .scaleAspectFit
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        view.addSubview(closeButton)
    }

    func addFilterSegmentControl() {
        let items = ["2023", "2468", "Like", "Add", "Quints", "Runs", "13579", "W&D", "369", "S&P"]
        filterSegmentControl = UISegmentedControl(items: items)
        filterSegmentControl.selectedSegmentIndex = 0
        filterSegmentControl.frame = CGRect(x: 25, y: 20, width: maxWidth - 50, height: Int(filterSegmentControl.frame.height))
        filterSegmentControl.addTarget(self, action: #selector(changeFilter), for: .valueChanged)
        view.addSubview(filterSegmentControl)
    }
    
    @objc private func changeFilter(sender: UISegmentedControl) {
        switch( sender.selectedSegmentIndex ) {
            case 0: filter2023()
            case 1: filter2468()
            default: print("here")
        }
    }
    
    func filter2023() {
        maj.toggleYearsFilter()
        maj.toggleLikeNumbersFilter()
        handView.update(maj)
    }
    
    func filter2468() {
        
    }

}
