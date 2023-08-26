//
//  Settings.swift
//  MahjongPractice
//
//  Created by Ray Meyer on 8/25/23.
//

import UIKit

class SettingsController: NarrowViewController  {
    private var maj: Maj!
    var tileImages: [UIImageView] = []
        
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
        addScrollView()
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
        addTitle("Tile Images", y: 20)
           
        let switchOffset = 75
        let items = ["Classic", "Light", "Large", "Dark", "Solid"]
        
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = getTileSegment()
        segment.frame = setOriginWithOffset(segment.frame, x: 0, y: switchOffset)
        segment.addTarget(self, action: #selector(changeTileImages), for: .valueChanged)
        scrollView.addSubview(segment)
        // view.addSubview(segment)
        
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
               
        //let tilesBottom = tilesOffset + tileHeight + 50
        //let line  = addLine(x: xOffset, y: tilesBottom + 30)
        // tilesBottom = Int(line.frame.origin.y + line.frame.height)
    }
    
    private func getTileSegment() -> Int {
        switch(maj.dotTileStyle) {
        case TileStyle.classic: return 0
        //case TileStyle.designer: return 1
        case TileStyle.largeFont: return 2
        //case TileStyle.designerLargeFont: return 2
        //case TileStyle.darkModeLargeFont: return 3
        //case TileStyle.solidDesigner: return 4
        //case TileStyle.argon: return 5
        default: return 0
        }
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
        //settingsDelegate.changeTileImages()
        //settingsDelegate.updateViews()
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
