//
//  Settings.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 8/25/23.
//

import UIKit

class SettingsController: NarrowViewController  {
    private var maj: Maj!
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Init
    //
    // -----------------------------------------------------------------------------------------
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate, backgroundColor: UIColor) {
        self.maj = maj
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
        view.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func addControls() {
        maxWidth = 700
        narrowView()
        xOffset = (Int(view.frame.width) - maxWidth) / 2
        addCloseButton()
    }
    
    // -----------------------------------------------------------------------------------------
    //
    //  Close Button
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
    
    @objc override func closeButtonAction(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
