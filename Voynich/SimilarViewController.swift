//
//  SimilarViewController.swift
//  Voynich
//
//  Created by Torsten Timm on 13.01.15.
//  Copyright (c) 2015 Torsten Timm. All rights reserved.
//

import UIKit
import AVFoundation

class SimilarViewController: UIViewController, UISearchBarDelegate, UITextViewDelegate {
    
    /// textView to show the page
    @IBOutlet weak var textView: UITextView!
    
    /// activity indicator during calculation
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    /// navigation bar
    @IBOutlet weak var navItem: UINavigationItem!
    
    /// textView for the intro animation
    @IBOutlet weak var animationTextView: UITextView!

    // search bar
    @IBOutlet weak var searchBar: UISearchBar!
    
    // button to stop the intro
    var stopButton: UIBarButtonItem!
    
    /// button for the default action (search bar or top similarities)
    var defaultButton: UIBarButtonItem!
    
    /// the text as lines
    var textLines: [String] = [String]()
    /// the text as array of groups
    var groupArrays: [[String]] = [[String]]()
    
    /// the name of the page (set by RootViewController)
    var pageName: String!
    /// used font size (set by RootViewController)
    var fontSize: CGFloat!
    
    let fontName   = "EVA-Hand1"
    let fontTools  = EVATools()
    
    /// colors used to highlight similar groups
    let darkRedColor    = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
    let redColor        = UIColor(red: 0.6, green: 0.1, blue: 0.05, alpha: 1.0)
    let lightRedColor   = UIColor(red: 0.8, green: 0.25, blue: 0.1, alpha: 1.0)
    let fadeRedColor    = UIColor(red: 0.95, green: 0.4, blue: 0.25, alpha: 1.0)
    
    let darkGreenColor  = UIColor(red: 0.0, green: 0.4, blue: 0.0, alpha: 1.0)
    let greenColor      = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 1.0)
    let lightGreenColor = UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1.0)
    let fadeGreenColor  = UIColor(red: 0.5, green: 0.9, blue: 0.5, alpha: 1.0)
    
    let darkBlueColor   = UIColor(red: 0.0, green: 0.2, blue: 0.5, alpha: 1.0)
    let blueColor       = UIColor(red: 0.05, green: 0.25, blue: 0.7, alpha: 1.0)
    let lightBlueColor  = UIColor(red: 0.2, green: 0.5, blue: 0.8, alpha: 1.0)
    let fadeBlueColor   = UIColor(red: 0.3, green: 0.7, blue: 0.9, alpha: 1.0)

    var blueColors      = [UIColor]() // [darkBlueColor, blueColor, lightBlueColor, fadeBlueColor]
    var greenColors     = [UIColor]() // [darkGreenColor, greenColor, lightGreenColor, fadeGreenColor]
    var redColors       = [UIColor]() // [darkRedColor, redColor, lightRedColor, fadeRedColor]
    var defaultColorSet: [UIColor]!
    
    let lightGrayColor  = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
    let textColor       = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
    
    /// variables to store top similarities
    var compareGroup1 = ""
    var compareGroup2 = ""
    var compareDistanceMap1: Dictionary<String, Int>?
    var compareDistanceMap2: Dictionary<String, Int>?
    
    /// the text length
    var textLength: Int!
    
    /// variables to store similarities for tapped groups
    var tappedGroup0 = ""
    var tappedGroup1 = ""
    var tappedGroup2 = ""
    var tmpDistanceMap1: Dictionary<String, Int>?
    var tmpDistanceMap2: Dictionary<String, Int>?
    
    var calculationIsRunning = false
    var highlightTwoWords    = false
    var maxDiff = 2
    
    /// timer to check if the calclation has finished
    var timerStep = 0.2
    var timer: NSTimer?
    var infoCounter = 0
    var startTime: NSDate!
    var searchBarYPos: CGFloat!
    
    
    /// audio player for click sound
    var clickAudioPlayer: AVAudioPlayer!
    
    /// init view
    override func viewDidLoad() {
        super.viewDidLoad()
     
        try! clickAudioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("click", ofType: "wav")!), fileTypeHint:nil)

        navigationController?.navigationBar.translucent = false
        //automaticallyAdjustsScrollViewInsets = false
        self.navigationItem.title = pageName
        
        textView.font = UIFont(name: fontName, size: determineFontSize())!
        
        // init color arrays
        blueColors.append(darkBlueColor)
        blueColors.append(blueColor)
        blueColors.append(lightBlueColor)
        blueColors.append(fadeBlueColor)
        
        greenColors.append(darkGreenColor)
        greenColors.append(greenColor)
        greenColors.append(lightGreenColor)
        greenColors.append(fadeGreenColor)
        
        redColors.append(darkRedColor)
        redColors.append(redColor)
        redColors.append(lightRedColor)
        redColors.append(fadeRedColor)
        
        // load color option
        let defaults = NSUserDefaults.standardUserDefaults()
        let storedColor = defaults.objectForKey(optionColorName) as! String?
        if let color = storedColor {
            switch color {
            case "green":
                defaultColorSet = greenColors
            case "red":
                defaultColorSet = redColors
            default:
                defaultColorSet = blueColors
            }
        } else {
            defaultColorSet = blueColors
        }
        
        // load highlight two groups at the same time option
        let storedTwoSets = defaults.objectForKey(optionTwoSetsName) as! String?
        if let sets = storedTwoSets {
            highlightTwoWords = sets == "on"
        } else {
            highlightTwoWords = false
        }
        
        var searchButtonEnabled = false
        // load tap search option
        let buttonEnabled = defaults.objectForKey(optionSearchButtonName) as! String?
        if let enabled = buttonEnabled {
            searchButtonEnabled = enabled == "on"
        }
        
        // load info option
        let infoCounter = defaults.objectForKey(optionInfoCounter) as! Int?
        if var counter = infoCounter {
            if counter >= 0 && counter < defaultMaxInfoCounter {
                counter++
                defaults.setInteger(counter, forKey: optionInfoCounter)
            } else if counter >= defaultMaxInfoCounter {
                self.infoCounter = -1
            }
        } else {
            defaults.setInteger(1, forKey: optionInfoCounter)
        }
        
        let diffs = defaults.objectForKey(optionDifferencesName) as! Int?
        if let diff = diffs {
            maxDiff = diff
        }
        
        let initialLineTypeName = OriginalVonyichLoader.readableCurrierType(currierPageTypes[pageName]!)
        self.navigationItem.title = "\(pageName) (\(initialLineTypeName))"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "textTapped:")
        tapGesture.numberOfTapsRequired = 1
        textView.addGestureRecognizer(tapGesture)
        
        compareDistanceMap1 = nil
        compareDistanceMap2 = nil
        
        animationTextView.layer.cornerRadius = 8.0
        animationTextView.hidden = true
        animationTextView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
        animationTextView.delegate = self
        textView.delegate = self
        
        // init searchBar
        searchBar.delegate = self
        searchBar.hidden = true
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: "searchBarShow")
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(downSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: "searchBarHide")
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(upSwipe)
        
        if searchButtonEnabled {
            let tapGesture2 = UITapGestureRecognizer(target: self, action: "searchBarToggle")
            tapGesture2.numberOfTapsRequired = 2
            textView.addGestureRecognizer(tapGesture2)
            
            tapGesture.requireGestureRecognizerToFail(tapGesture2)
        }
        
        stopButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "stop")
        searchBar.setImage(UIImage(named: "star"), forSearchBarIcon: UISearchBarIcon.Bookmark, state: UIControlState.Normal)

        if searchButtonEnabled {
            defaultButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchBarToggle")
        } else {
            //UIBarButtonItemStyle.Bordered --> Plain
            defaultButton = UIBarButtonItem(image: UIImage(named: "star"), style: UIBarButtonItemStyle.Plain, target: self, action: "autoColorPage")
        }
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "forwardAnimation")
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipe)
    }
    
    // addjust font size for pages with longer lines
    func determineFontSize() -> CGFloat {
        var size = fontSize
        switch pageName {
        case "f116r":
            size = fontSize-1
        case "f115v":
            size = fontSize-1
        case "f115r":
            size = fontSize-3
        case "f114r":
            size = fontSize-2
        case "f114v":
            size = fontSize-1
        case "f113r":
            size = fontSize-3
        case "f113v":
            size = fontSize-3
        case "f112r":
            size = fontSize-1
        case "f111r":
            size = fontSize-2
        case "f111v":
            size = fontSize-2
        case "f108r":
            size = fontSize-2
        case "f108v":
            size = fontSize-2
        case "f107r":
            size = fontSize-2
        case "f107v":
            size = fontSize-2
        case "f106r":
            size = fontSize-2
        case "f106v":
            size = fontSize-2
        case "f105r":
            size = fontSize-2
        case "f105v":
            size = fontSize-2
        case "f104r":
            size = fontSize-2
        case "f104v":
            size = fontSize-3
        case "f103r":
            size = fontSize-2
        case "f103v":
            size = fontSize-2
        case "f89v2":
            size = fontSize-2
        case "f86v3":
            size = fontSize-2
        case "f86v6":
            size = fontSize-2
        case "f84r":
            size = fontSize-2
        case "f77r":
            size = fontSize-2
        case "f76r":
            size = fontSize-2
        case "f46r":
            size = fontSize-2
        case "f46v":
            size = fontSize-2
        default:
            size = fontSize
        }
        return max(6.0,size)
    }
    
    /// handle viewDidAppear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        activity.startAnimating()
        var text = ""
        for line in textLines {
            let replaced = fontTools.replace(line)
            let groupArray = line.componentsSeparatedByString(" ")
            groupArrays.append(groupArray)
            if text == "" {
                text = replaced
            } else {
                text = text + "\n" + replaced
            }
        }
        textView.hidden = false
        textView.text = text
        textLength = text.characters.count
        
        searchBar.hidden = true
        searchBarYPos = searchBar.center.y
        
        textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, textLength))
        
        activity.stopAnimating()
        self.view.backgroundColor = UIColor.whiteColor()
        if infoCounter >= 0 {
            initAnimation()
        } else {
            self.navigationItem.rightBarButtonItem = defaultButton
        }
    }
    
    /// back button pressed -> stop a running calculation
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stop()
        freeResources()
    }
    
    /// highlight the similarities for a tapped group
    func textTapped(recognizer: UITapGestureRecognizer) {
        if !calculationIsRunning {
            if playSounds {
                clickAudioPlayer!.play()
            }
            if let textView = recognizer.view as? UITextView {
                
                var location: CGPoint = recognizer.locationInView(textView)
                location.x -= textView.textContainerInset.left
                location.y -= textView.textContainerInset.top
                
                let layoutManager = textView.layoutManager
                let charIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
                
                let length = min(30, textView.textStorage.length-charIndex+10)
                let startPos = max(0, charIndex-10)
                let range = NSRange(location: startPos, length: length)
                var tappedPhrase = (textView.attributedText.string as NSString).substringWithRange(range)
                tappedPhrase = tappedPhrase.stringByReplacingOccurrencesOfString("\n", withString: " ", options: NSStringCompareOptions.LiteralSearch, range: nil)
                let textArray = tappedPhrase.componentsSeparatedByString(" ")
                
                var tappedGroup = ""
                var pos = startPos
                for text in textArray {
                    let length = text.characters.count
                    let newPos = pos+length+1
                    if pos <= charIndex && newPos > charIndex {
                        tappedGroup = fontTools.reverseReplace(text)
                    }
                    pos = newPos
                }
                
                highlight(tappedGroup)
            }
        }
    }
    
    /// highlight all groups similar to 'searchGroup'
    func highlight(searchGroup: String) {
        if searchGroup != "" && !calculationIsRunning {
            calculationIsRunning = true
            activity.startAnimating()
            self.navigationItem.rightBarButtonItem = stopButton
            self.view.backgroundColor = lightGrayColor
            textView.backgroundColor = lightGrayColor
            tappedGroup0 = searchGroup
            
            timer = NSTimer.scheduledTimerWithTimeInterval(self.timerStep, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.startTime = NSDate()
                var distanceMap: Dictionary<String, Int>!
                if self.tappedGroup0 == self.tappedGroup1 && self.tmpDistanceMap1 != nil {
                    // same group tapped twice
                    distanceMap = self.tmpDistanceMap1
                    self.tappedGroup1    = self.tappedGroup2
                    self.tmpDistanceMap1 = self.tmpDistanceMap2
                } else if self.tappedGroup0 == self.tappedGroup2 && self.tmpDistanceMap2 != nil {
                    // next to last group tapped again
                    distanceMap = self.tmpDistanceMap2
                } else if self.tappedGroup0 == self.compareGroup1 && self.compareDistanceMap1 != nil {
                    distanceMap = self.compareDistanceMap1
                } else if self.tappedGroup0 == self.compareGroup2 && self.compareDistanceMap2 != nil {
                    distanceMap = self.compareDistanceMap2
                } else {
                    distanceMap = self.calcDistances(self.tappedGroup0)
                }
                
                if self.calculationIsRunning {
                    self.tappedGroup2    = self.tappedGroup1
                    self.tmpDistanceMap2 = self.tmpDistanceMap1
                    self.tappedGroup1    = self.tappedGroup0
                    self.tmpDistanceMap1 = distanceMap
                    self.calculationIsRunning = false
                    self.navigationItem.rightBarButtonItem = nil
                }
            })
        }
    }
    
    /// determine the two groups for which the most similarities can be found
    func determineCompareWords() {
        let compareArray = compareMap[pageName]
        if let compareGroups = compareArray {
            compareGroup1 = compareGroups[0]
            compareGroup2 = compareGroups[1]
        } else {
            if debug {
                print("Error: compareArray == nil for page \(pageName)")
            }
            let result = SimilarResults.determineCompareWords(pageName, groupArrays: groupArrays)
            compareGroup1 = result.compareGroup1
            compareGroup2 = result.compareGroup2
        }
    }
    
    /// highlight the group with the highest number of similarities
    func autoColorPage() {
        if !calculationIsRunning {
            calculationIsRunning = true
            if playSounds {
                clickAudioPlayer!.play()
            }
            determineCompareWords()
            activity.startAnimating()
            self.view.backgroundColor = lightGrayColor
            textView.backgroundColor = lightGrayColor
            self.navigationItem.rightBarButtonItem = stopButton
            
            timer = NSTimer.scheduledTimerWithTimeInterval(self.timerStep, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.startTime = NSDate()
                if self.highlightTwoWords {
                    self.tappedGroup2 = self.compareGroup2
                    if let tmpMap = self.compareDistanceMap2 {
                        self.tmpDistanceMap2 = tmpMap
                    } else {
                        let distanceMap = self.calcDistances(self.tappedGroup2)
                        if self.calculationIsRunning {
                            self.tmpDistanceMap2 = distanceMap
                            self.compareDistanceMap2 = distanceMap
                        }
                    }
                }
                self.tappedGroup1 = self.compareGroup1
                if let tmpMap = self.compareDistanceMap1 {
                    self.tmpDistanceMap1 = tmpMap
                    self.calculationIsRunning = false
                    self.navigationItem.rightBarButtonItem = nil
                } else {
                    let distanceMap = self.calcDistances(self.tappedGroup1)
                    if self.calculationIsRunning {
                        self.tmpDistanceMap1 = distanceMap
                        self.compareDistanceMap1 = distanceMap
                        self.calculationIsRunning = false
                        self.navigationItem.rightBarButtonItem = nil
                    }
                }
            })
        }
    }
    
    /// stop the intro or a running calculation
    /// called when the stop button is pressed
    func stop() {
        if !animationTextView.hidden {
           finishAnimation()
        }
        if calculationIsRunning {
            timer?.invalidate()
            timer = nil
            textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, textLength))
            tappedGroup1 = ""
            tmpDistanceMap1 = nil
            tappedGroup2 = ""
            tmpDistanceMap2 = nil

            self.view.backgroundColor = UIColor.whiteColor()
            textView.backgroundColor = UIColor.whiteColor()
            textView.setNeedsDisplay()
            calculationIsRunning = false
            self.navigationItem.rightBarButtonItem = defaultButton
            activity.stopAnimating()
        }
    }
    
    /// check if the calculation is finished (called by 'timer')
    func updateTimer() {
        if !calculationIsRunning {
            timer?.invalidate()
            timer = nil
            
            textView.textStorage.removeAttribute(NSUnderlineStyleAttributeName, range: NSMakeRange(0, textLength))
            textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: textColor, range: NSMakeRange(0, textLength))
            
            if highlightTwoWords && tappedGroup2 != "" && !tappedGroup2.contains(tappedGroup1) {
                if let tmpMap2 = tmpDistanceMap2 {
                    color(tappedGroup2, colors: defaultColorSet == redColors ? blueColors : redColors, distances: tmpMap2)
                }
            }
            
            if tappedGroup1 != "" {
                if let tmpMap = tmpDistanceMap1 {
                    color(tappedGroup1, colors: defaultColorSet, distances: tmpMap)
                    searchBar.text = tappedGroup1
                }
            }
            
            self.view.backgroundColor = UIColor.whiteColor()
            textView.backgroundColor  = UIColor.whiteColor()
            self.navigationItem.rightBarButtonItem = defaultButton
            
            activity.stopAnimating()
            textView.setNeedsDisplay()
//            if debug {
//                let elapsedTime = NSDate().timeIntervalSinceDate(startTime) // in Seconds
//                print("elapsed time \(elapsedTime) sec")
//            }
        }
    }
    
    /// calculate the map of distances for a compareGroup
    func calcDistances(compareGroup: String) -> Dictionary<String, Int> {
        if compareGroup != "" {
            //
            var distanceMap = Dictionary<String, Int>()
            var defaultMap: Dictionary<String, Int>?
            switch compareGroup {
            case "dain":
                defaultMap = dain_distanceMap
            case "daiin":
                defaultMap = daiin_distanceMap
            case "chol":
                defaultMap = chol_distanceMap
            default:
                break
            }
            if let defaults = defaultMap {
                // use defaultMap to generate distanceMap
                for groupArray in groupArrays {
                    for group in groupArray {
                        //var distance = -1
                        
                        let tmpDistance = defaults[group]
                        if let dist = tmpDistance {
                            distanceMap.updateValue(dist, forKey: group)
                        } else {
                            if maxDiff != 3 {
                                distanceMap.updateValue(5, forKey: group)
                            } else {
                                var distance = -1
                                
                                let tmpDistance = distanceMap[group]
                                if tmpDistance == nil {
                                    distance = Levenshtein.getDistanceOptimized(group, t: compareGroup, maxDiff: maxDiff)
                                    distanceMap.updateValue(distance, forKey: group)
                                }
                            }
                        }
                    }
                }
            } else {
                // calculate distances to generate distanceMap
                for groupArray in groupArrays {
                    if calculationIsRunning {
                        for group in groupArray {
                            var distance = -1
                            
                            let tmpDistance = distanceMap[group]
                            if tmpDistance == nil {
                                distance = Levenshtein.getDistanceOptimized(group, t: compareGroup, maxDiff: maxDiff)
                                distanceMap.updateValue(distance, forKey: group)
                            }
                        }
                    }
                }
            }
            return distanceMap
        }
        
        return Dictionary<String, Int>()
    }
    
    /// highlight similar groups for a compareGroup
    func color(compareGroup: String, colors: [UIColor], distances: Dictionary<String, Int>) {
        var pos = 0
        let compareGroupLength = compareGroup.characters.count
        if compareGroup != "" {
            for groupArray in groupArrays {
                for group in groupArray {
                    let groupLength = group.characters.count
                    let distance: Int = distances[group]!
                    switch distance {
                    case 0:
                        textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: colors[distance], range: NSMakeRange(pos, groupLength))
                        textView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: 2, range: NSMakeRange(pos, groupLength))
                    case 1:
                        textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: colors[distance], range: NSMakeRange(pos, groupLength))
                    default:
                        if distance <= maxDiff {
                            textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: colors[distance], range: NSMakeRange(pos, groupLength))
                        } else  {
                            let s = group.containsPos(compareGroup)
                            if s >= 0 {
                                textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: colors[2], range: NSMakeRange(pos+s, compareGroupLength))
                                if s + 2 * compareGroupLength <= groupLength {
                                    let s2 = group.containsPos(compareGroup, startPos: s+compareGroupLength)
                                    if s2 >= s {
                                        textView.textStorage.addAttribute(NSForegroundColorAttributeName, value: colors[2], range: NSMakeRange(pos+s2, compareGroupLength))
                                    }
                                }
                            }
                        }
                    }
                    pos += 1 + groupLength
                }
            }
        }
    }
    
    /// start animation and set a timer
    func initAnimation() {
        infoCounter = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "finishAnimation", userInfo: nil, repeats: false)
        self.navigationItem.rightBarButtonItem = stopButton

        /// show the help text
        animationTextView.font = UIFont(name: "Helvetica", size: fontSize+4)!
        animationTextView.text = "\nTo start the search for similarities tap on a word. Words with one or two different glyphs will be highlighted.\nTo select the word with the most similarities tap on the \"star\"-button. The search field can be accessed by swiping down."
        let textLength = animationTextView.text.characters.count
        animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSMakeRange(0, textLength))
        
        var pos = calcPos("word.")
        animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: defaultColorSet[0], range: NSMakeRange(pos, 4))
        animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(pos, 4))
        pos = calcPos("one")
        animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: defaultColorSet[1], range: NSMakeRange(pos, 3))
        pos = calcPos("two")
        animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: defaultColorSet[2], range: NSMakeRange(pos, 3))
        
        animationTextView.hidden = false
    }
    
    /// invalidate timer and hide animationTextView
    func finishAnimation() {
        timer?.invalidate()
        timer = nil
        animationTextView.hidden=true
        self.navigationItem.rightBarButtonItem = defaultButton
    }
    
    /// handle swipe left
    func forwardAnimation() {
        if !animationTextView.hidden {
            finishAnimation()
        }
    }
    
    /// free not needed resources
    func freeResources() {
        tmpDistanceMap1     = nil
        tappedGroup1        = ""
        tmpDistanceMap2     = nil
        tappedGroup2        = ""
        compareDistanceMap1 = nil
        compareDistanceMap2 = nil
    }
    
    /// returns the position of 'searchString' in animationTextView.text
    func calcPos(searchString: String) -> Int{
        let startIndex = animationTextView.text.rangeOfString(searchString)?.startIndex
        
        if let index = startIndex {
            return animationTextView.text.startIndex.distanceTo(index)
        }
        
        return 0
    }
    
    /// search
    func searchBarSearchButtonClicked( searchBar: UISearchBar) {
        let searchString = searchBar.text!.lowercaseString

        var found = false
        for groupArray in groupArrays {
            if !found {
                for group in groupArray {
                    if searchString == group {
                        found = true
                    }
                }
            }
        }
        
        if found {
            highlight(searchString)
            searchBarHide()
        } else {
            self.showAlert("Info", message: "\'\(searchString)\' not found.")
        }
    }
    
    /// cancel search
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBarHide()
    }
    
    /// show search bar
    func searchBarShow() {
        if searchBar.hidden {
            searchBar.hidden = false
            searchBar.becomeFirstResponder()
            searchBar.center.y = searchBarYPos - 30
            searchBar.alpha = 1.0
            
            UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.searchBar.center.y = self.searchBarYPos
                }, completion: nil)
        }
    }
    
    /// hide search bar
    func searchBarHide() {
        if !searchBar.hidden {
            UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.searchBar.alpha = 0.0
                }, completion: {(finished:Bool) in
                    if (finished) {
                        self.searchBar.hidden = true
                    }
            })
            
            
            searchBar.resignFirstResponder()
        }
    }
    
    /// toggle search bar
    func searchBarToggle() {
        if searchBar.hidden {
            searchBarShow()
        } else {
            searchBarHide()
        }
    }
    
    /// search bookmarks --> highlight top similarities
    func searchBarBookmarkButtonClicked(searchBar: UISearchBar) {
        autoColorPage()
    }
    
    /// disable editing for 'animationTextView'
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
    
    /// show alert dialog
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        if !calculationIsRunning {
            freeResources()
        }
    }
}