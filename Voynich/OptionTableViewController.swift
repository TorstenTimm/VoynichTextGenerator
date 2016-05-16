//
//  OptionTableViewController.swift
//  Voynich
//
//  Created by Torsten Timm on 19.01.15.
//  Copyright (c) 2015 Torsten Timm. All rights reserved.
//

import UIKit
import AVFoundation

let optionColorName        = "color"
let optionTwoSetsName      = "sets"
let optionFontName         = "font"
let optionInfoCounter      = "info"
let optionSearchButtonName = "search"
let optionDifferencesName  = "diffs"
let optionSoundsName       = "sounds"
let optionPseudoRandom     = "pseudo"
let optionPagesName        = "pages"
let optionSourceRowsName   = "rows"
let defaultMaxInfoCounter  = 4
let defaultDiffCount       = 1
let defaultPagesCount      = 4
let defaultSourceRowsCount = 1

class OptionTableViewController: UITableViewController, FontOptionsViewControllerDelegate {
    
    @IBOutlet weak var infoSimilarSwitch: UISwitch!
    
    @IBOutlet weak var twoSetsSwitch: UISwitch!
    
    @IBOutlet weak var colorSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var fontLabel: UILabel!
    
    @IBOutlet weak var searchButtonSwitch: UISwitch!
    
    @IBOutlet weak var differencesSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var soundsSwitch: UISwitch!
    
    @IBOutlet weak var pseudoRandomSwitch: UISwitch!
    
    @IBOutlet weak var pagesSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var sourceRowControl: UISegmentedControl!
    
    var switchAudioPlayer: AVAudioPlayer!
    var klackAudioPlayer: AVAudioPlayer!
    
    // init view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        try! switchAudioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("switch", ofType: "wav")!), fileTypeHint:nil)
        try! klackAudioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("klack", ofType: "wav")!), fileTypeHint:nil)
        
        self.navigationItem.title = "Options"
        self.tableView.rowHeight = 44
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedColor = defaults.objectForKey(optionColorName) as! String?
        if let color = storedColor {
            switch color {
            case "green":
                colorSegmentControl.selectedSegmentIndex = 1
            case "red":
                colorSegmentControl.selectedSegmentIndex = 2
            default:
                colorSegmentControl.selectedSegmentIndex = 0
            }
        } else {
            colorSegmentControl.selectedSegmentIndex = 0
        }
        
        let diffs = defaults.objectForKey(optionDifferencesName) as! Int?
        if let diff = diffs {
            switch diff {
            case 1:
                differencesSegmentControl.selectedSegmentIndex = 0
            case 3:
                differencesSegmentControl.selectedSegmentIndex = 2
            default:
                differencesSegmentControl.selectedSegmentIndex = 1
            }
        } else {
            differencesSegmentControl.selectedSegmentIndex = 1
        }
        
        let pages = defaults.objectForKey(optionPagesName) as! Int?
        if let page = pages {
            switch page {
            case 8:
                pagesSegmentControl.selectedSegmentIndex = 1
            case 12:
                pagesSegmentControl.selectedSegmentIndex = 2
            default:
                pagesSegmentControl.selectedSegmentIndex = 0
            }
        } else {
            pagesSegmentControl.selectedSegmentIndex = 0
        }
        
        let rows = defaults.objectForKey(optionSourceRowsName) as! Int?
        if let row = rows {
            switch row {
            case 1:
                sourceRowControl.selectedSegmentIndex = 0
            case 3:
                sourceRowControl.selectedSegmentIndex = 2
            default:
                sourceRowControl.selectedSegmentIndex = 1
            }
        } else {
            sourceRowControl.selectedSegmentIndex = 1
        }
        
        let storedTwoSets = defaults.objectForKey(optionTwoSetsName) as! String?
        if let enabled = storedTwoSets {
            twoSetsSwitch.setOn(enabled == "on", animated: false)
        } else {
            twoSetsSwitch.setOn(false, animated: false)
        }
        
        let introCounter = defaults.objectForKey(optionInfoCounter) as! Int?
        if let counter = introCounter {
            infoSimilarSwitch.setOn(counter < defaultMaxInfoCounter, animated: false)
        } else {
            infoSimilarSwitch.setOn(true, animated: false)
        }
        
        let soundsEnabled = defaults.objectForKey(optionSoundsName) as! String?
        if let enabled = soundsEnabled {
            soundsSwitch.setOn(enabled == "on", animated: false)
        } else {
            soundsSwitch.setOn(true, animated: false)
        }
        
        let searchEnabled = defaults.objectForKey(optionSearchButtonName) as! String?
        if let enabled = searchEnabled {
            searchButtonSwitch.setOn(enabled == "on", animated: false)
        } else {
            searchButtonSwitch.setOn(false, animated: false)
        }
        
        let pseudoRandomEnabled = defaults.objectForKey(optionPseudoRandom) as! String?
        if let enabled = pseudoRandomEnabled {
            pseudoRandomSwitch.setOn(enabled == "on", animated: false)
        } else {
            pseudoRandomSwitch.setOn(false, animated: false)
        }
        
        let storedFont = defaults.objectForKey(optionFontName) as! String?
        if let font = storedFont {
            fontLabel.text = font
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "font" {
            let destenationViewConroller = segue.destinationViewController as! FontOptionsViewController
            
            destenationViewConroller.delegate = self
        }
    }
    
    @IBAction func colorChanged(sender: AnyObject) {
        if playSounds {
            klackAudioPlayer!.play()
        }
        
        var color = "blue"
        switch colorSegmentControl.selectedSegmentIndex {
        case 0:
            color = "blue"
        case 1:
            color = "green"
        case 2:
            color = "red"
        default:
            break
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(color, forKey: optionColorName)
    }
    
    @IBAction func differencesChanged(sender: AnyObject) {
        if playSounds {
            klackAudioPlayer!.play()
        }
        
        var diffs = defaultDiffCount
        switch differencesSegmentControl.selectedSegmentIndex {
        case 0:
            diffs = 1
        case 1:
            diffs = 2
        case 2:
            diffs = 3
        default:
            break
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(diffs, forKey: optionDifferencesName)
    }
    
    @IBAction func highlightTwoSetsChanged(sender: AnyObject) {
        if playSounds {
            switchAudioPlayer!.play()
        }
        
        var twoSets = "off"
        if twoSetsSwitch.on {
            twoSets = "on"
        } else {
            twoSets = "off"
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(twoSets, forKey: optionTwoSetsName)
    }
    
    
    @IBAction func searchButtonChanged(sender: AnyObject) {
        if playSounds {
            switchAudioPlayer!.play()
        }
        
        var tapSearch = "off"
        if searchButtonSwitch.on {
            tapSearch = "on"
        } else {
            tapSearch = "off"
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(tapSearch, forKey: optionSearchButtonName)
    }
    
    
    @IBAction func infoSimilarChanged(sender: AnyObject) {
        if playSounds {
            switchAudioPlayer!.play()
        }
        
        var infoCounter = 0
        if infoSimilarSwitch.on {
            infoCounter = -1
        } else {
            infoCounter = defaultMaxInfoCounter
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(infoCounter, forKey: optionInfoCounter)
    }
    
    
    @IBAction func soundsChanged(sender: AnyObject) {
        if !playSounds {
            switchAudioPlayer!.play()
        }
        
        var activated = "off"
        if soundsSwitch.on {
            activated = "on"
            playSounds = true
        } else {
            activated = "off"
            playSounds = false
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(activated, forKey: optionSoundsName)
    }
    
    @IBAction func pseudoRandomChanged(sender: AnyObject) {
        if playSounds {
            switchAudioPlayer!.play()
        }
        
        var activated = "off"
        if pseudoRandomSwitch.on {
            activated = "on"
            usePseudoRandomNumbers = true
        } else {
            activated = "off"
            usePseudoRandomNumbers = false
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(activated, forKey: optionPseudoRandom)
        if !pseudoRandomSwitch.on {
            defaults.setInteger(4, forKey: optionPagesName)
        } else {
            pagesSegmentControl.enabled = true
        }
    }
    
    @IBAction func sourceRowsChanged(sender: AnyObject) {
        if playSounds {
            klackAudioPlayer!.play()
        }
        
        var rows = defaultSourceRowsCount
        switch sourceRowControl.selectedSegmentIndex {
        case 0:
            rows = 1
        case 1:
            rows = 2
        case 2:
            rows = 3
        default:
            break
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(rows, forKey: optionSourceRowsName)
        toGenerateSourceRowCount = rows
    }
    
    
    @IBAction func pagesChanged(sender: AnyObject) {
        if playSounds {
            klackAudioPlayer!.play()
        }
        
        var pages = defaultPagesCount
        switch pagesSegmentControl.selectedSegmentIndex {
        case 0:
            pages = 4
        case 1:
            pages = 8
        case 2:
            pages = 12
        default:
            break
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(pages, forKey: optionPagesName)
        toGeneratePagesCount = pages
    }
    
    func selectFont(name : String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(name, forKey: optionFontName)
        fontLabel.text = name
    }
}