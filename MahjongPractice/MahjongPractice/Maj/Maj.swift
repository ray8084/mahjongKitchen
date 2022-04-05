//
//  Maj.swift
//  Mahjong2017
//
//  Created by Ray on 12/7/16.
//  Copyright © 2017 EightBam LLC. All rights reserved.
//

import Foundation

class State {
    static let east = 0
    static let south = 1
    static let west = 2
    static let north = 3
    static let wall = 4
}

class Year {
    static let uninitialized = 0
    static let y2018 = 1
    static let y2019 = 2
    static let y2020 = 3
    static let y2017 = 4
    static let y2021 = 5
    static let y2022 = 6
}

class YearSegment {
    static let segment2017 = 0
    static let segment2018 = 1
    static let segment2019 = 2
    static let segment2020 = 3
    static let segment2021 = 4
    static let segment2022 = 5
}

class TileStyle {
    static let classic = 0
    static let largeFont = 1
}

class SortStyle {
    static let suits = 0
    static let num = 1
}

class Maj {
    var override2020 = false   // make this false for release
    var override2021 = false   // make this false for release
    var unlockedWarning = false // warning when barryOverride default is true
    var winBotEnabled = false
    var state = State.east
    var lastState = 0
    var charlestonState = 0
    var letterPatternRackFilterPending = false
    var tileMatchesRackFilterPending = false
    var enableRules = true
    var disableUndo = false
    var viewOpponentHands = false
    var opponentPatternsLoaded = false
    var showLosses = false
    var year = Year.uninitialized
    var enable2020 = false
    var enable2021 = false
    var enable2022 = false
    var shuffleWithSeed = false
    var shuffleSeed = ""
    var disableAutomaj = false
    var disableTapToDiscard = false
    var sortStyle = SortStyle.suits
    var hideSortMessage = false
    var techSupportDebug = false
    var hideAutomajMessage = false
            
    var wall = Deck()
    var replayWall = Deck()
    var card: Card = Card()
    var unsortedLetterPatterns: [LetterPattern] = []
    
    // var lastRacked = Hand("LastRacked")
    var charleston = Hand("Charleston")
    var east = Hand("East")
    var south = Hand("South")
    var west = Hand("West")
    var north = Hand("North")
    var replayHand = Hand("EastReplay")
    var replaySouth = Hand("SouthReplay")
    var replayWest = Hand("WestReplay")
    var replayNorth = Hand("NorthReplay")
    var bots: [Hand] = []

    var discardTile: Tile!
    var lastDiscard: Tile!
    var discardCalled = false
    var lastHandName = ""
    var previousHandName = ""
    var discardTable = DiscardTable()
    
    let maxHand = 14
    let maxCharleston = 3

    let defaults = UserDefaults.standard
    var crakTileStyle = TileStyle.classic
    var flowerTileStyle = TileStyle.classic
    var windTileStyle = TileStyle.classic
    var dotTileStyle = TileStyle.classic
    var bamTileStyle = TileStyle.classic
    var alternateRedDragon = false
    
    // --------------------------------------------------------------
    //  copy
    
    func copy(_ copy: Maj) {
        state = copy.state
        lastState = copy.lastState
        charlestonState = copy.charlestonState
        letterPatternRackFilterPending = copy.letterPatternRackFilterPending
        tileMatchesRackFilterPending = copy.tileMatchesRackFilterPending
        enableRules = copy.enableRules
        disableUndo = copy.disableUndo
        viewOpponentHands = copy.viewOpponentHands
        opponentPatternsLoaded = copy.opponentPatternsLoaded
        wall.copy(copy.wall)
        east.copy(copy.east)
        south.copy(copy.south)
        west.copy(copy.west)
        north.copy(copy.north)
        if copy.discardTile == nil {
            discardTile = nil
        } else {
            discardTile = Tile(copy.discardTile)
        }
        if copy.lastDiscard == nil {
            lastDiscard = nil
        } else {
            lastDiscard = Tile(copy.lastDiscard)
        }
        discardCalled = copy.discardCalled
        lastHandName = copy.lastHandName
        previousHandName = copy.previousHandName
        discardTable.copy(discardTable)
        winBotEnabled = copy.winBotEnabled
        year = copy.year
        card.showLosses = copy.showLosses
        enable2020 = copy.enable2020
        enable2021 = copy.enable2021
        enable2022 = copy.enable2022
        override2020 = copy.override2020
        override2021 = copy.override2021
        crakTileStyle = copy.crakTileStyle
        windTileStyle = copy.windTileStyle
        flowerTileStyle = copy.flowerTileStyle
        dotTileStyle = copy.dotTileStyle
        bamTileStyle = copy.bamTileStyle
        shuffleSeed = copy.shuffleSeed
        shuffleWithSeed = copy.shuffleWithSeed
        disableTapToDiscard = copy.disableTapToDiscard
        techSupportDebug = copy.techSupportDebug
        hideSortMessage = copy.hideSortMessage
        alternateRedDragon = copy.alternateRedDragon
        hideAutomajMessage = copy.hideAutomajMessage
     }
    
  
    // --------------------------------------------------------------
    //  init
    
    init() {
        bots = [south, west, north]
        state = State.east
        east.rack = Rack("East")
        south.rack = Rack("South")
        west.rack = Rack("West")
        north.rack = Rack("North")
        if override2020 { defaults.set(override2020, forKey: "barryOverride") }
        if override2021 { defaults.set(override2021, forKey: "override2021") }
        loadSavedValues()
        setYearSegment(segment: getYearSegment())
        deal()
    }
    
    init(_ maj: Maj) {
        bots = [south, west, north]
        self.copy(maj)
    }
   
    func isGameOver() -> Bool {
        return  wall.tiles.count == 0 || eastWon()
    }
      
    func eastWon() -> Bool {
        // return east.rack!.tiles.count == 14
        return east.getHighestMatch().matchCount == 14
    }
    
    func loadSavedValues() {
        year = defaults.integer(forKey: "year")
        if year == Year.uninitialized {year = Year.y2017}
        if override2021 { year = Year.y2021 }
        winBotEnabled = defaults.bool( forKey: "winBotEnable" )
        showLosses = defaults.bool( forKey: "showLosses" )
        east.filterOutYears = defaults.bool( forKey: "filterYears" )
        east.filterOut2468 = defaults.bool( forKey: "filter2468" )
        east.filterOutLikeNumbers = defaults.bool( forKey: "filterLikeNumbers" )
        east.filterOutAdditionHands = defaults.bool( forKey: "filterAddition" )
        east.filterOutQuints = defaults.bool( forKey: "filterQuints" )
        east.filterOutRuns = defaults.bool( forKey: "filterRuns" )
        east.filterOut13579 = defaults.bool( forKey: "filter13579" )
        east.filterOutWinds = defaults.bool( forKey: "filterWinds" )
        east.filterOut369 = defaults.bool( forKey: "filter369" )
        east.filterOutPairs = defaults.bool( forKey: "filterPairs" )
        east.filterOutConcealed = defaults.bool( forKey: "filterConcealed" )
        card.loadSavedValues()
        card.showLosses = showLosses
        override2020 = defaults.bool( forKey: "barryOverride" )
        override2021 = defaults.bool(forKey: "override2021")
        crakTileStyle = defaults.integer(forKey: "crakTileStyle")
        flowerTileStyle = defaults.integer(forKey: "flowerTileStyle")
        windTileStyle = defaults.integer(forKey: "windTileStyle")
        dotTileStyle = defaults.integer(forKey: "dotTileStyle")
        bamTileStyle = defaults.integer(forKey: "bamTileStyle")
        alternateRedDragon = defaults.bool(forKey: "alternateRedDragon")
        shuffleSeed = defaults.string(forKey: "shuffleSeed") ?? ""
        shuffleWithSeed = defaults.bool(forKey: "shuffleWithSeed")
        disableTapToDiscard = defaults.bool(forKey: "disableTapToDiscard")
        techSupportDebug = defaults.bool(forKey: "techSupportDebug")
        hideSortMessage = defaults.bool(forKey: "hideSortMessage")
        hideAutomajMessage = defaults.bool(forKey: "hideAutomajMessage")
    }
    
    func loadPatterns(_ letterPatterns: [LetterPattern]) {
        print("maj.loadPatterns")
        east.tileMatches.loadPatterns(letterPatterns)
        loadOpponentPatterns()
        unsortedLetterPatterns = letterPatterns
    }
    
    func loadOpponentPatterns() {
        if (opponentPatternsLoaded == false) {
            print("maj.loadOpponentPatterns")
            north.tileMatches.loadOpponentPatterns(card.letterPatterns)
            south.tileMatches.loadOpponentPatterns(card.letterPatterns)
            west.tileMatches.loadOpponentPatterns(card.letterPatterns)
            opponentPatternsLoaded = true
        }
    }
    
    func saveHideAutomajMessage() {
        hideAutomajMessage = true
        defaults.set(true, forKey: "hideAutomajMessage")
    }
    
    
    // --------------------------------------------------------------
    //  get methods
    
    func getHand(state: Int) -> Hand {
        switch state {
        case State.east: return east
        case State.south: return south
        case State.west: return west
        case State.north: return north
        default: return Hand("")
        }
    }

    func getRack(state: Int) -> Rack {
        switch state {
        case State.east: return east.rack!
        case State.south: return south.rack!
        case State.west: return west.rack!
        case State.north: return north.rack!
        default: return Rack("")
        }
    }
    
    func getLetterPatternByIndex(_ index: Int) -> NSAttributedString {
        return unsortedLetterPatterns[index].text
    }
    
    func getLetterPatternNoteByIndex(_ index: Int) -> NSAttributedString {
        return unsortedLetterPatterns[index].note
    }
    
    func getMessages() -> [String]{
        return [south.rack!.message, west.rack!.message, north.rack!.message]
    }
    
    func clearMessages() {
        west.rack?.message = ""
        north.rack?.message = ""
        south.rack?.message = ""
    }
    
    // --------------------------------------------------------------
    //  switches
  
    func toggleLosses(){
        showLosses = !showLosses
        defaults.set(showLosses, forKey: "showLosses")
        card.showLosses = showLosses
    }
    
    func toggleWinBot(){
        winBotEnabled = !winBotEnabled
        defaults.set(winBotEnabled, forKey: "winBotEnable")
    }
    
    func toggleQuintFilter(){
        east.filterOutQuints = !east.filterOutQuints
        defaults.set(east.filterOutQuints, forKey: "filterQuints")
    }
    
    func togglePairFilter() {
        east.filterOutPairs = !east.filterOutPairs
        defaults.set(east.filterOutPairs, forKey: "filterPairs")
    }
    
    func toggleConcealedFilter() {
        east.filterOutConcealed = !east.filterOutConcealed
        defaults.set(east.filterOutConcealed, forKey: "filterConcealed")
    }

    func toggleYearsFilter() {
        east.filterOutYears = !east.filterOutYears
        defaults.set(east.filterOutYears, forKey: "filterYears")
    }

    func toggleWindsFilter() {
        east.filterOutWinds = !east.filterOutWinds
        defaults.set(east.filterOutWinds, forKey: "filterWinds")
    }

    func toggle2468Filter() {
        east.filterOut2468 = !east.filterOut2468
        defaults.set(east.filterOut2468, forKey: "filter2468")
    }
    
    func toggleLikeNumbersFilter() {
        east.filterOutLikeNumbers = !east.filterOutLikeNumbers
        defaults.set(east.filterOutLikeNumbers, forKey: "filterLikeNumbers")
    }

    func toggleAdditionFilter() {
        east.filterOutAdditionHands = !east.filterOutAdditionHands
        defaults.set(east.filterOutAdditionHands, forKey: "filterAddition")
    }

    func toggleRunsFilter() {
        east.filterOutRuns = !east.filterOutRuns
        defaults.set(east.filterOutRuns, forKey: "filterRuns")
    }

    func toggle13579Filter() {
        east.filterOut13579 = !east.filterOut13579
        defaults.set(east.filterOut13579, forKey: "filter13579")
    }

    func toggle369Filter() {
        east.filterOut369 = !east.filterOut369
        defaults.set(east.filterOut369, forKey: "filter369")
    }
    
    func setYearSegment(segment: Int) {
        print("Maj.setYearSegment \(segment)")
        let showLosses = card.showLosses
        switch segment {
        case YearSegment.segment2017:
            year = Year.y2017
            card = Card2017()
        case YearSegment.segment2018:
            year = Year.y2018
            card = Card2018()
        case YearSegment.segment2019:
            year = Year.y2019
            card = Card2019()
        case YearSegment.segment2020:
            year = Year.y2020
            card = Card2020()
        case YearSegment.segment2021:
            year = Year.y2021
            card = Card2021()
        case YearSegment.segment2022:
            year = Year.y2022
            card = Card2022()
        default:
            year = Year.y2017
            card = Card2017()
        }
        opponentPatternsLoaded = false
        card.loadSavedValues()
        card.showLosses = showLosses
        defaults.set(year, forKey: "year")
    }
    
    func getYearSegment() -> Int {
        var segment = 0
        switch year {
        case Year.y2017: segment = YearSegment.segment2017
        case Year.y2018: segment = YearSegment.segment2018
        case Year.y2019: segment = YearSegment.segment2019
        case Year.y2020: segment = YearSegment.segment2020
        case Year.y2021: segment = YearSegment.segment2021
        case Year.y2022: segment = YearSegment.segment2022
        default: segment = YearSegment.segment2017
        }
        print("maj.getYearSegment \(segment)")
        return segment
    }
    
    func getYearText() -> String {
        switch year {
        case Year.y2017: return "2017"
        case Year.y2018: return "2018"
        case Year.y2019: return "2019"
        case Year.y2020: return "2020"
        case Year.y2021: return "2021"
        case Year.y2022: return "2022"
        default: return ""
        }
    }
    
    func setCrakTileStyle(style: Int) {
        crakTileStyle = style
        defaults.set(crakTileStyle, forKey: "crakTileStyle")
    }
    
    func setFlowerTileStyle(style: Int) {
        flowerTileStyle = style
        defaults.set(flowerTileStyle, forKey: "flowerTileStyle")
    }
    
    func setWindTileStyle(style: Int) {
        windTileStyle = style
        defaults.set(windTileStyle, forKey: "windTileStyle")
    }
    
    func setDotTileStyle(style: Int) {
        dotTileStyle = style
        defaults.set(dotTileStyle, forKey: "dotTileStyle")
    }
    
    func setBamTileStyle(style: Int) {
        bamTileStyle = style
        defaults.set(bamTileStyle, forKey: "bamTileStyle")
    }
    
    func setShuffleSeed(_ seed: String) {
        shuffleSeed = seed
        defaults.set(shuffleSeed, forKey: "shuffleSeed")
    }

    func setShuffleWithSeed(_ enable: Bool) {
        shuffleWithSeed = enable
        defaults.set(shuffleWithSeed, forKey: "shuffleWithSeed")
    }
    
    func setDisableTapToDiscard(_ disable: Bool) {
        disableTapToDiscard = disable
        defaults.set(disableTapToDiscard, forKey: "disableTapToDiscard")
    }
    
    func setDisableAutomaj(_ disable: Bool) {
        disableAutomaj = disable
        defaults.set(disableAutomaj, forKey: "disableAutomaj")
    }
    
    func setAlternateRedDragon(_ enable: Bool) {
        alternateRedDragon = enable
        defaults.set(alternateRedDragon, forKey: "alternateRedDragon")
    }
    
    func setTechSupportDebug(_ enable: Bool) {
        techSupportDebug = enable
        defaults.set(techSupportDebug, forKey: "techSupportDebug")
    }
    
    // --------------------------------------------------------------
    //  dealing
    
    func deal() {
        wall.shuffle(withSeed: shuffleWithSeed, seedString: shuffleSeed)
        east.tiles = wall.pullTiles(count: 14)
        south.tiles = wall.pullTiles(count: 13)
        west.tiles = wall.pullTiles(count: 13)
        north.tiles = wall.pullTiles(count: 13)
        east.sort()
        south.sort()
        west.sort()
        north.sort()
        replayHand.tiles = east.tiles
        replaySouth.tiles = south.tiles
        replayWest.tiles = west.tiles
        replayNorth.tiles = north.tiles
        replayWall.tiles = wall.tiles
    }
    
    func replay() {
        wall.tiles = replayWall.tiles
        east.tiles = replayHand.tiles
        south.tiles = replaySouth.tiles
        west.tiles = replayWest.tiles
        north.tiles = replayNorth.tiles
        charlestonState = 0
        state = State.east
        discardTile = nil
        charleston.tiles = []
        east.rack?.tiles = []
        south.rack?.tiles = []
        west.rack?.tiles = []
        north.rack?.tiles = []
        clearMessages()
        // winBot.replay(maj: self)
        // selectWinBot()
    }
    
    
    // --------------------------------------------------------------
    //  Sorting
    
    func userSort() {
        switch(sortStyle) {
            case SortStyle.suits:
                east.sortNumbers()
                sortStyle = SortStyle.num
            case SortStyle.num:
                east.sort()
                sortStyle = SortStyle.suits
            default: break
        }
        hideSortMessage = true
        defaults.set(hideSortMessage, forKey: "hideSortMessage")
    }
     
    
    // --------------------------------------------------------------
    //  charleston
    
    func isCharlestonActive() -> Bool {
        return charlestonState < 7
    }
    
    func isBlindPass() -> Bool {
        return charlestonState == 2 || charlestonState == 5
    }
    
    func isCharlestonOutDone() -> Bool {
        return (charleston.tiles.count == maxCharleston) || (charlestonState == 6) || ((charleston.tiles.count == 0) && (charlestonState == 3) || isBlindPass())
    }

    func charleston(hand: Hand, rack: Rack) {
        let set = hand.getCharlestonSet(maj: self, rack: rack, count: charleston.tiles.count)
        for tile in set.tiles {
            east.tiles.append(tile)
        }
        for tile in charleston.tiles {
            hand.tiles.append(tile)
        }
        charleston.tiles = []
        hand.tileMatches.countMatches(hand: hand, rack: rack)
        hand.tileMatches.sort()
    }
    
    func nextCharleston(){
        charlestonState += 1
        switch charlestonState {
        case 0: break
        case 1: charleston(hand: south, rack: south.rack!)
        case 2: charleston(hand: west, rack: west.rack!)
        case 3: charleston(hand: north, rack: north.rack!)
        case 4:
            if charleston.tiles.count == 0 {
                charlestonState = 7
            } else {
                charleston(hand: north, rack: north.rack!)
            }
        case 5: charleston(hand: west, rack: west.rack!)
        case 6: charleston(hand: south, rack: south.rack!)
        case 7: charleston(hand: west, rack: west.rack!)
        default: break
        }
        
        if (charlestonState == 7) && isWinBotEnabled() {
             botCharleston()
        }
    }

    func botCharleston() {
        // dumpBots()
        let southMatchCount = south.getBestBotHand().matchCount
        let westMatchCount = west.getBestBotHand().matchCount
        let northMatchCount = north.getBestBotHand().matchCount
        var bestBot = southMatchCount > westMatchCount ? south : west
        bestBot = northMatchCount > bestBot.getBestBotHand().matchCount ? north : bestBot
        switch(bestBot.name) {
          case "South":
              botCharlestonSwapTiles(source: west, dest: south)
              botCharlestonSwapTiles(source: north, dest: south)
              break
          case "West":
              botCharlestonSwapTiles(source: south, dest: west)
              botCharlestonSwapTiles(source: north, dest: west)
              break
          case "North":
              botCharlestonSwapTiles(source: south, dest: north)
              botCharlestonSwapTiles(source: west, dest: north)
              break
          default:
              break
        }
    }
  
    func botCharlestonSwapTiles(source: Hand, dest: Hand) {
        var tiles: [Tile] = []
        for tile in source.tiles {
          tiles.append(Tile(tile))
        }
        for tile in tiles {
            if !tile.isJoker() || (tile.isJoker() && (dest.jokerCount() < 1))  {
                let count = dest.getBestBotHand().matchCount
                dest.tiles.append(tile)
                dest.tileMatches.countMatches(hand: dest, rack: dest.rack!)
                dest.tileMatches.sort()
                let newCount = dest.getBestBotHand().matchCount
                if newCount > count {
                source.removeTile(tile)
                let discard = dest.getBestDiscard(maj: self, rack: dest.rack!, withFlowers: true)
                source.tiles.append(discard)
                } else {
                  dest.removeTile(tile)
                }
            }
        }
        // print(dest.getBestBotHand().matchCount)
    }
    
    // --------------------------------------------------------------
    //  game state
    
    func nextState() -> String {
        lastState = state
        lastDiscard = discardTile
        switch state {
        case State.north:
            state = State.east
            takeTurnEast()
            previousHandName = lastHandName
            lastHandName = east.name
            break
        case State.east:
            if south.call(maj: self, rack: south.rack!) {
                state = State.south
                break
            }
            if west.call(maj: self, rack: west.rack!) {
                state = State.west
                break
            }
            if north.call(maj: self, rack: north.rack!) {
                state = State.north
                break
            }
            state = State.south
            takeTurn(hand: south, rack: south.rack!)
            if south.declareMahjong() {
                break
            }
            if west.call(maj: self, rack: west.rack!) {
                state = State.west
                break
            }
            if north.call(maj: self, rack: north.rack!) {
                state = State.north
                break
            }
            break
        case State.south:
            state = State.west
            takeTurn(hand: west, rack: west.rack!)
            if west.declareMahjong() {
                break
            }
            if north.call(maj: self, rack: north.rack!) {
                state = State.north
                break
            }
            break
        case State.west:
            if south.call(maj: self, rack: south.rack!) {
                state = State.south
                break
            }
            state = State.north
            takeTurn(hand: north, rack: north.rack!)
            break
        default:
            break
        }
                       
        return stateLabel()
    }
    
    func takeTurnEast() {
        // print("Turn \(east.name)")
        discardTable.countTile(discardTile, increment: 1)
        discardTile = nil
        east.draw(self)
    }
    
    func takeTurn(hand: Hand, rack: Rack) {
        if isWinBotEnabled() {
            hand.draw(self)
            if hand.onCall() {
                hand.tileMatches.countMatches(hand: hand, rack: rack)
            }
            if hand.declareMahjong() {
                south.rackAllTiles()
                west.rackAllTiles()
                north.rackAllTiles()
                print("\(hand.name) mahjong")
            } else {
                finishTurn(hand: hand, rack: rack)
            }
        } else {
            hand.draw(self)
            finishTurn(hand: hand, rack: rack)
        }
    }
    
    func finishTurn(hand: Hand, rack: Rack) {
        replaceRackJokers(hand)
        if (hand.tileMatches.list[0].matchCount == 0) {
            hand.tileMatches.countMatches(hand: hand, rack: rack)
            hand.tileMatches.sort()
        }
        discardTable.countTile(discardTile, increment: 1)
        discardTile = hand.getDiscard(maj: self, rack: rack, withFlowers: wall.tiles.count < 50)
        hand.tileMatches.countMatches(hand: hand, rack: rack)
        hand.tileMatches.sort()
    }
            
    func botWon() -> Bool {
        return isWinBotEnabled() && (south.declareMahjong() || west.declareMahjong() || north.declareMahjong())
    }
    
    func getWinningBot() -> Hand? {
        var hand: Hand? = nil
        if botWon() {
            south.rack?.message = south.name
            west.rack?.message = west.name
            north.rack?.message = north.name
        }
        if south.declareMahjong() { hand = south }
        if west.declareMahjong() { hand = west }
        if north.declareMahjong() { hand = north }
        if hand != nil { hand!.rack?.message = ("\(hand!.name) declared Mahjong") }
        return hand
    }
    
    func getWinningBotPattern() -> String {
        var pattern = ""
        let bot = getWinningBot()
        if bot != nil {
            let tileMatchItem = bot!.getHighestMatch()
            pattern = getLetterPatternByIndex(tileMatchItem.letterPatternId).string
        }
        return pattern
    }
    
    func getWinningBotPatternNote() -> String {
        var note = ""
        let bot = getWinningBot()
        if bot != nil {
            let tileMatchItem = bot!.getHighestMatch()
            note = getLetterPatternNoteByIndex(tileMatchItem.letterPatternId).string
        }
        return note
    }
    
    func stateLabel() -> String {
        var text = ""
        if isCharlestonActive() {
            switch(charlestonState) {
            case 0:
                if charleston.tiles.count == 3 {
                    text = "Charleston right (South) >\nDrag right to pass now"
                } else {
                    text = "Charleston right (South) >\nDrag 3 tiles here to pass"
                }
            case 1:
                if charleston.tiles.count == 3 {
                    text = "Across (West) >\nDrag right to pass now"
                } else {
                    text = "Across (West) >\nDrag 3 tiles here to pass"
                }
            case 2:
                if charleston.tiles.count == 0 {
                    text = "First left (North) >\nBlind Pass option"
                } else if charleston.tiles.count == 3 {
                    text = "First left (North) >\nDrag right to pass now"
                } else {
                    text = "First left (North) >\nPass now or Drag more tiles"
                }
            case 3:
                if charleston.tiles.count == 0 {
                      text = "Second left (North) >\nOr drag right to stop Charleston"
                } else if charleston.tiles.count == 3 {
                     text = "Second left (North) >\nDrag right to pass now"
                } else {
                    text = "Second left (North) >\nDrag 3 tiles here to pass"
                }
            case 4: text = "Across (West) >\n"
            case 5: text = "Last right (South) >\nBlind Pass option"
            case 6: text = "Across (West) >\nCourtesy Pass"
            case 7: text = "Discard >"
            default: break
            }
        } else {
            switch(state) {
            case State.east: text = "Discard >"
            case State.south: text = "Discard from South"
            case State.west: text = "Discard from West"
            case State.north: text = "Discard from North"
            default: break
            }
        }
        if isWinBotEnabled() && botWon() {
            text = ""
        }
        // print(charleston.tiles.count)
        return text
    }
    
    func unrecognizedHandDeclared() -> Bool {
        var unrecognizedHand = false
        let message = card.winningHand(maj: self)
        if (east.rack?.tiles.count == 14) && (message.count == 0) {
            unrecognizedHand = true
        }
        return unrecognizedHand
    }
    
    func isWinBotEnabled() -> Bool {
        return winBotEnabled
    }
    
    // --------------------------------------------------------------
    //  rack

    func rackTiles() -> [Tile] {
        return east.rack!.tiles
    }
 
    func replaceRackJokers(_ hand: Hand) {
        east.rack?.replaceJokers(hand)
        south.rack?.replaceJokers(hand)
        west.rack?.replaceJokers(hand)
        north.rack?.replaceJokers(hand)
    }
    
    func validateRack() -> String{
        return enableRules ? east.rack!.validate() : ""
    }
    
    func rackOpponentHands() {
        south.rack?.rackAll(south)
        west.rack?.rackAll(west)
        north.rack?.rackAll(north)
        south.rack?.sort()
        west.rack?.sort()
        north.rack?.sort()
    }
 
    func discardLastDiscard(){
        if discardTile != nil {
            discardTable.countTile(discardTile, increment: 1)
            discardTile = nil
        }
    }
    
    // --------------------------------------------------------------
    //  opponent racks
    
    func stealJoker(tile: Tile) -> Bool {
        var found = false
        if (south.rack?.replaceJoker(tile))! {
            found = true
        }
        else if (west.rack?.replaceJoker(tile))! {
            found = true
        }
        else if (north.rack?.replaceJoker(tile))! {
            found = true
        }
        
        if found {
            east.removeTile(tile)
            east.addJoker()
        }
        return found
    }
}
