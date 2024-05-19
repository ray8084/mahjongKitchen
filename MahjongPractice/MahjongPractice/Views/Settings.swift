//
//  Settings.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 8/25/23.
//

import UIKit

protocol SettingsDelegate {
    func showGame()
}

class SettingsController: NarrowViewController  {
    private var maj: Maj!
    private var settingsDelegate: SettingsDelegate!
    var tileImages: [UIImageView] = []
        
    // -----------------------------------------------------------------------------------------
    //
    //  Init
    //
    // -----------------------------------------------------------------------------------------
    
    init(maj: Maj, frame: CGRect, narrowViewDelegate: NarrowViewDelegate, settingsDelegate: SettingsDelegate, backgroundColor: UIColor) {
        self.maj = maj
        self.settingsDelegate = settingsDelegate
        super.init(frame: frame, narrowViewDelegate: narrowViewDelegate)
        view.backgroundColor = backgroundColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func addControls() {
        maxWidth = 700
        narrowView()
        xOffset = (Int(view.frame.width) - maxWidth) / 2 + 40
        addScrollView()
        // addOptions()
        addTileImages()
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
    
    
    // -----------------------------------------------------------------------------------------
    //
    //  Options
    //
    // -----------------------------------------------------------------------------------------
       
    private func addOptions() {
        var top = 20
        addTitle("Settings", y: top)
        top = top + 55
        let items = ["Use Your Card", "Suggested Hands"]
        let segmentControl = UISegmentedControl(items: items)
        segmentControl.selectedSegmentIndex = maj.cardSettings
        segmentControl.frame = CGRect(x: xOffset, y: top, width: 300, height: Int(segmentControl.frame.height))
        segmentControl.addTarget(self, action: #selector(changeCardSettings), for: .valueChanged)
        scrollView.addSubview(segmentControl)
                
        if #available(iOS 13.0, *) {
            // default
        } else {
            segmentControl.tintColor = .black
        }
    }
    
    @objc private func changeCardSettings(sender: UISegmentedControl) {
        maj.setCardSettings(segment: sender.selectedSegmentIndex)
        settingsDelegate.showGame()
    }
    
    // -----------------------------------------------------------------------------------------
    //
    //  Tile Images
    //
    // -----------------------------------------------------------------------------------------
    
    private func setOriginWithOffset(_ frame: CGRect, x: Int, y: Int) -> CGRect {
        var f = frame
        f.origin.x = CGFloat(xOffset + x)
        f.origin.y = CGFloat(y)
        return f
    }
    
    private func addTileImages() {
        let top = 40
        addTitle("Tiles", y: top)
           
        let switchOffset = top + 55
        let items = ["Classic", "Light", "Large", "Dark", "Solid"]
        
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = getTileSegment()
        segment.frame = setOriginWithOffset(segment.frame, x: 0, y: switchOffset)
        segment.addTarget(self, action: #selector(changeTileImages), for: .valueChanged)
        scrollView.addSubview(segment)
        
        if #available(iOS 13.0, *) {
            // default
        } else {
            segment.tintColor = .black
        }
        
        let tilesOffset = switchOffset + 45
        addTile(Tile.getImage(id: 1, maj: maj), x: 0, y: tilesOffset)
        addTile(Tile.getImage(id: 2, maj: maj), x: 54, y: tilesOffset)
        addTile(Tile.getImage(id: 11, maj: maj), x: 54*2, y: tilesOffset)
        addTile(Tile.getImage(id: 12, maj: maj), x: 54*3, y: tilesOffset)
        addTile(Tile.getImage(id: 21, maj: maj), x: 54*4, y: tilesOffset)
        addTile(Tile.getImage(id: 22, maj: maj), x: 54*5, y: tilesOffset)
        addTile(Tile.getImage(id: 31, maj: maj), x: 54*6, y: tilesOffset)
        addTile(Tile.getImage(id: 35, maj: maj), x: 54*7, y: tilesOffset)
        addTile(Tile.getImage(id: 30, maj: maj), x: 54*8, y: tilesOffset)
    }
    
    private func getTileSegment() -> Int {
        switch(maj.dotTileStyle) {
        case TileStyle.classic: return 0
        case TileStyle.light: return 1
        case TileStyle.largeFont: return 2
        case TileStyle.dark: return 3
        case TileStyle.solid: return 4
        default: return 0
        }
        //view.backgroundColor = settingsDelegate.getBackgroundColor()
    }
    
    @objc private func changeTileImages(sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
            case 0: maj.setDotTileStyle(style: TileStyle.classic)
            case 1: maj.setDotTileStyle(style: TileStyle.light)
            case 2: maj.setDotTileStyle(style: TileStyle.largeFont)
            case 3: maj.setDotTileStyle(style: TileStyle.dark)
            case 4: maj.setDotTileStyle(style: TileStyle.solid)
            default: break
        }
        settingsDelegate.showGame()
        updateTileImages()
    }
    
    private func addTile(_ named: String, x: Int, y: Int) {
        let tile = UIImageView(frame:CGRect(x: xOffset + x, y: y, width: tileWidth, height: tileHeight))
        tile.contentMode = .scaleAspectFit
        tile.layer.masksToBounds = true
        tile.layer.cornerRadius = CGFloat(tileWidth / 8)
        tile.image = UIImage(named: named)
        scrollView.addSubview(tile)
        tileImages.append(tile)
    }
    
    func updateTileImages() {
        if tileImages.count == 9 {
            tileImages[0].image = UIImage(named: Tile.getImage(id: 1, maj: maj) )
            tileImages[1].image = UIImage(named: Tile.getImage(id: 2, maj: maj) )
            tileImages[2].image = UIImage(named: Tile.getImage(id: 11, maj: maj) )
            tileImages[3].image = UIImage(named: Tile.getImage(id: 12, maj: maj) )
            tileImages[4].image = UIImage(named: Tile.getImage(id: 21, maj: maj) )
            tileImages[5].image = UIImage(named: Tile.getImage(id: 22, maj: maj) )
            tileImages[6].image = UIImage(named: Tile.getImage(id: 31, maj: maj) )
            tileImages[7].image = UIImage(named: Tile.getImage(id: 35, maj: maj) )
            tileImages[8].image = UIImage(named: Tile.getImage(id: 30, maj: maj) )
        }
    }
}
