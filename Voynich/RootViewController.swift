//
//  RootViewController.swift
//  Voynich
//
//  Created by Torsten Timm on 05.01.15.
//  Copyright (c) 2015 Torsten Timm. All rights reserved.
//

import UIKit
import AVFoundation

/// enables debug output and the buttons for the samples for Currier A and Currier B
let debug = false

/// determines if the processor has a 64-bit architecture
let is64bit = sizeof(Int) == sizeof(Int64) ? true : false

/// enables sounds
var playSounds = true

/// use a pseudo random number generator to ensure that the same start line will always result in the same generated text
var usePseudoRandomNumbers = false

/// number of pages to create
var toGeneratePagesCount = 4
/// number of source lines
var toGenerateSourceRowCount = 2

/// Currier A sample
let CurrierAText = "fachys ykal ar ataiin shol shory cthres y kor sholdy"
let CurrierAName = "<f1r.P1.1>"
let CurrierALineCount    = 850
let CurrierASeed: UInt32 = 63

/// Currier B sample
let CurrierBText = "polchedy qokeol okain checthy oteey lshedy okain qokain qokalshedy oteys"
let CurrierBName = "<f103r.P.18>"
let CurrierBLineCount    = 1250
let CurrierBSeed: UInt32 = 90

class RootViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    /// field showing the selected line
    @IBOutlet weak var lineTextField: UITextView!
    
    /// field showing the name of the selected line
    @IBOutlet weak var taskTextField: UITextField!
    
    /// picker view for pages
    @IBOutlet weak var pickerView: UIPickerView!
    
    /// text view used for the naimation
    @IBOutlet weak var animationTextView: UITextView!
    
    /// label "Initial line:"
    @IBOutlet weak var initialLineLabel: UILabel!
    
    /// label "Choose page:"
    @IBOutlet weak var choosePageLabel: UILabel!
    
    /// navigation bar
    @IBOutlet weak var navItem: UINavigationItem!
    
    /// menu button on navigation bar
    @IBOutlet weak var btnMenu: UIBarButtonItem!
    
    /// button "Generate text"
    @IBOutlet weak var generateActionButton: UIBarButtonItem!
    
    // button "Similarities"
    @IBOutlet weak var similarActionButton: UIBarButtonItem!
    
    /// audio player for page turn sound
    var pageTurnAudioPlayer: AVAudioPlayer!
    
    // default menu dialog
    var menuDialog: UIAlertController!
    // alternative menu dialog
    var menuDialog2: UIAlertController!
    
    var confirmDialogA: UIAlertController!
    var confirmDialogB: UIAlertController!
    
    /// font size for similarity
    var fontSizeSimilarities: CGFloat = 14.0

    // button for stopping thhe animaption
    var stopAnimationButton: UIBarButtonItem!
    var initAnimationButton: UIBarButtonItem!
    
    // define colors for animation
    let redColor       = UIColor(red: 0.88, green: 0.21, blue: 0.1, alpha: 1.0)
    let blackColor     = UIColor.blackColor()
    let darkGreenColor = UIColor(red: 0.17, green: 0.6, blue: 0.1, alpha: 1.0)
    let greenColor     = UIColor(red: 0.58, green: 0.82, blue: 0.16, alpha: 1.0)
    let blueColor      = UIColor(red: 0.0, green: 0.4, blue: 0.9, alpha: 1.0)
    let lightBlueColor = UIColor(red: 0.1, green: 0.71, blue: 0.85, alpha: 1.0)
    let lightGrayColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    
    /// animation text length
    var textLength = 0
    /// line thickness for underlining
    let underlineThickness = 2
    /// font size used for Voynich text
    var fontSizeVoynich:      CGFloat = 14.0
    /// font size used for normal text
    var fontSizeText:         CGFloat = 14.0
    
    var timer: NSTimer?
    var timerStep         = 1.0
    var counter           = -1
    var initial           = true
    var swipeIsRunning    = false
    var pageCurlAnimation = true
    
    // first paragrah used in animation
    let f1rP1_lines: [String] = ["fachys ykal ar ytaiin Shol Shory cThres y kor Sholdy",
                                 "sory cKhar or y kair chtaiin Shar air cThar cThar dan",
                                 "syaiir Sheky or ykaiin Shod cThoary cThes daraiin sy",
                                 "doiin oteey oteor roloty cT*ar daiin otaiin or okan",
                                 "sairy chear cThaiin cPhar cFhaiin            ydaraiShy"
    ]
    
    // differences to transcription of Takeshi Takahashi
    //<f1r.P1.1;H>       fachys ykal ar a#taiin shol shory cthres y kor sholdy     # a --> y
    //<f1r.P1.2;H>       sory ckhar or y kair chtaiin shar ar#e# cthar cthar dan   # are --> air
    //<f1r.P1.3;H>       syaiir sheky or ykaiin shod cthoary cthes daraiin sa#     # sa --> sy
    //<f1r.P1.4;H>       o#oiin oteey oteos# roloty cth#*ar daiin otaiin or okan   # ooiin --> daiin / oteos --> oteor / cth*ar --> ct*ar
    //<f1r.P1.5;H>       d#air #y chear cthaiin cphar cfhaiin                      # dair y --> sairy
    //<f1r.T1.6;H>       ydaraishy
    
    var useOriginalVoynichLoader = false
    var originalVoynichLoader: OriginalVonyichLoader?
    var fontTools: FontTools = EVATools()
    
    let backgroundImage = "f1r.png"
    
    // default line
    let defaultLineName        = CurrierAName // "<f1r.P1.1>"
    
    // line names for line picker
    var lineNames: [String]!
    
    /// determine which sample should be generated
    var generateSample = 0
    
    /// init view
    override func viewDidLoad() {
        super.viewDidLoad()
        lineTextField.editable = false
        taskTextField.delegate = self
        
        try! pageTurnAudioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("page_turn", ofType: "wav")!), fileTypeHint:nil)
        
        var nameArray: [String] = [String]()
        for pageName in voynichPages {
            let initialLineTypeName = OriginalVonyichLoader.readableCurrierType(currierPageTypes[pageName]!)
            
            let name = "\(pageName) (\(initialLineTypeName))"
            nameArray.append(name)
        }
        self.lineNames = nameArray
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        var image = UIImage(named: backgroundImage)!
        let originalSize = image.size
        let bounds = self.view.bounds
        let x = originalSize.height / bounds.height
        let newSize = CGSize(width: originalSize.width / x, height: originalSize.height / x)
        
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        image.drawInRect(rect)
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.view.backgroundColor = UIColor(patternImage: image)

        taskTextField.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.89, alpha: 0.8)
        taskTextField.keyboardType = .NumberPad
        lineTextField.backgroundColor = UIColor.clearColor()
        
        animationTextView.layer.cornerRadius = 8.0
        animationTextView.backgroundColor = UIColor(red: 0.94, green: 0.89, blue: 0.82, alpha: 0.8)
        animationTextView.delegate = self
        
        stopAnimationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "finishAnimation")
        initAnimationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "initAnimation")
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "forwardAnimation")
        leftSwipe.direction = UISwipeGestureRecognizerDirection.Left
        view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "backwardAnimation")
        rightSwipe.direction = UISwipeGestureRecognizerDirection.Right
        view.addGestureRecognizer(rightSwipe)
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: "forwardAnimation")
        upSwipe.direction = UISwipeGestureRecognizerDirection.Up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: "backwardAnimation")
        downSwipe.direction = UISwipeGestureRecognizerDirection.Down
        view.addGestureRecognizer(downSwipe)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let soundsEnabled = defaults.objectForKey(optionSoundsName) as! String?
        if let enabled = soundsEnabled {
            playSounds = enabled == "on"
        }
        
        let pseudoRandomEnabled = defaults.objectForKey(optionPseudoRandom) as! String?
        if let enabled = pseudoRandomEnabled {
            usePseudoRandomNumbers = enabled == "on"
        }
        
        let pages = defaults.objectForKey(optionPagesName) as! Int?
        if let page = pages {
            toGeneratePagesCount = page
        }
        
        let rows = defaults.objectForKey(optionSourceRowsName) as! Int?
        if let row = rows {
            toGenerateSourceRowCount = row
        }
        
        initMenuDialog()
        initAnimation()
    }
    
    /// handle viewDidAppear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // adjust font size
        
        //println("bounds.width=\(view.bounds.width) bounds.height=\(view.bounds.height)")
        // 4s 320 x 480
        // 5  320 x 568
        // 6  375 x 667
        // iPad 768 x 1024
        
        if view.bounds.height < 500 { // iPhone 4s
            let t0: CGAffineTransform = CGAffineTransformMakeTranslation(0, pickerView.bounds.size.height*2/3)
            let s0 = CGAffineTransformMakeScale(1.0, 0.7)
            let t1 = CGAffineTransformMakeTranslation(0, -pickerView.bounds.size.height*2/3)
            pickerView.transform = CGAffineTransformConcat(t0, CGAffineTransformConcat(s0, t1))
        }
        
        if view.bounds.width < 450 { // iPhone 6+
            fontSizeVoynich = 12.0
            fontSizeText = 16.0
            fontSizeSimilarities = 11.0
            taskTextField.keyboardType = .Default
        }
        if view.bounds.width < 400 { // iPhone 6
            fontSizeVoynich = 10.0
            fontSizeText = 14.0
            fontSizeSimilarities = 10.0
            taskTextField.keyboardType = .Default
        }
        if view.bounds.width < 330 { // iPhone 4s 5 5s
            fontSizeVoynich = 9.0
            fontSizeText = 14.0
            fontSizeSimilarities = 8.0
            taskTextField.keyboardType = .Default
            taskTextField.frame.size.height = 50.0
        }
        if view.bounds.width > 600 { // iPad
            fontSizeVoynich = 20.0
            fontSizeText = 22.0
            fontSizeSimilarities = 18.0
        }
        
        lineTextField.font = UIFont(name: "EVA-Hand1", size: fontSizeVoynich)!
        
        // start animation
        if !animationTextView.hidden {
            step(0)
        }
        
        // init originalVoynichLoader (load original text)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            self.originalVoynichLoader = OriginalVonyichLoader(linesToCreate: 0, lineLengthToCreate: 0, initialLines: [String](), currierType: CURRIER.UNKNOWN)
            if debug {
                for pageName in voynichPages {
                    let array = self.originalVoynichLoader?.getLineNamesForPage(pageName)
                    if let nameArray = array {
                        if nameArray.count == 0 {
                            print("ERROR: getLinesNamesForPage(\(pageName)) returns empty array")
                        }
                    } else {
                        print("ERROR: getLinesNamesForPage(\(pageName)) returns nil")
                    }
                }
            }
            
        })
        
        updatePickerView()
    }
    
    /// show menu
    @IBAction func btnMenuCklicked(sender: AnyObject) {
        if is64bit && usePseudoRandomNumbers {
            //We need to provide a popover sourceView when using it on iPad
            menuDialog2.popoverPresentationController?.sourceView = self.view
            
            self.presentViewController(menuDialog2, animated: true, completion: nil)
        } else {
            //We need to provide a popover sourceView when using it on iPad
            menuDialog.popoverPresentationController?.sourceView = self.view
        
            self.presentViewController(menuDialog, animated: true, completion: nil)
        }
    }
    
    /// taskTextField end edit
    @IBAction func editDidEnd(sender: AnyObject) {
        updatePickerView()
    }
    
    /// update selected page in pickerView
    func updatePickerView() {
        if originalVoynichLoader != nil {
            let lineName = taskTextField.text
            let text = originalVoynichLoader?.voynichTextMap[lineName!]
            if var _ = text {
                updateLineText(lineName!)
                
                var partArray = lineName!.componentsSeparatedByString(".")
                //<f79v.P.37> --> //<f79v
                var pageString = partArray[0]
                let length = pageString.characters.count
                //<f79v--> //f79v
                pageString = pageString[1..<length]
                // select page in picker view
                var count = 0
                var found = false
                for line in lineNames {
                    if !found {
                        if line.contains(pageString) {
                            found = true
                        } else {
                            count++
                        }
                    }
                }
                pickerView.selectRow(count, inComponent: 0, animated: true)
            } else {
                // if no page was found select default page
                updateLineText(defaultLineName)
                taskTextField.text = defaultLineName
                pickerView.selectRow(0, inComponent: 0, animated: true)
            }
        }
    }
    
    
    /// init segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // generate text
        if segue.identifier == "generate" {
            if playSounds {
                pageTurnAudioPlayer!.play()
            }
            let pdfViewController = (segue.destinationViewController as! GeneratePdfViewController)
            let lineName = taskTextField.text
            let text = originalVoynichLoader?.voynichTextMap[lineName!]
            if let _ = text {
                pdfViewController.originalVoynichLoader = originalVoynichLoader
                pdfViewController.isSample        = false
                pdfViewController.initialLineName = lineName!
                pdfViewController.lineLength      = 55
                switch generateSample {
                case 1:
                    generateSample = 0
                    pdfViewController.isSample        = true
                    pdfViewController.initialLineName = CurrierAName
                    pdfViewController.linesToCreate   = CurrierALineCount
                case 2:
                    generateSample = 0
                    pdfViewController.isSample        = true
                    pdfViewController.initialLineName = CurrierBName
                    pdfViewController.linesToCreate   = CurrierBLineCount
                default:
                    pdfViewController.linesToCreate   = (29 * toGeneratePagesCount) - toGenerateSourceRowCount - 4
                }

                pdfViewController.useOriginalVoynichLoader = useOriginalVoynichLoader
                if useOriginalVoynichLoader {
                    pdfViewController.textGenerator = originalVoynichLoader
                }
                
                let defaults = NSUserDefaults.standardUserDefaults()
                let fontName = defaults.objectForKey(optionFontName) as! String?
                if let font = fontName {
                    pdfViewController.fontName = font
                }
            } else {
                pdfViewController.initialLineName = defaultLineName
            }
        }
        
        // search for similarities
        if segue.identifier == "similar" {
            if playSounds {
                pageTurnAudioPlayer!.play()
            }
            let lineName = taskTextField.text
            let similarViewController = (segue.destinationViewController as! SimilarViewController)
            
            similarViewController.fontSize = fontSizeSimilarities
            let pageName = OriginalVonyichLoader.getPageName(lineName!)
            similarViewController.pageName = pageName
            if let voynichLoader = originalVoynichLoader {
                similarViewController.textLines = voynichLoader.getLinesForPage(pageName)
            }
        }
        
        // show paper
        if segue.identifier == "paper" {
            if playSounds {
                pageTurnAudioPlayer!.play()
            }
            let pdfViewController = (segue.destinationViewController as! PDFViewController)
            pdfViewController.fileName_pdf = "How_the_Voynich_Manuscript_was_created"
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        if stopAnimationButton.enabled {
            if counter < 62 {
                finishAnimation()
            }
        }
    }
 
    /// show selected line in lineTextField
    func updateLineText(lineName: String) {
        let textLine = originalVoynichLoader?.voynichTextMap[lineName]
        if let text = textLine {
            lineTextField.text = fontTools.replace(text)
        } else {
            print("Error: textLine == nil for lineName='\(lineName)'")
            lineTextField.text = ""
        }
    }
    
    /// returns the number of `columns` to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// returns the number of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lineNames.count
    }
    
    /// returns the name for the row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lineNames[row]
    }
    
    /// called for a selected row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let nameArray = lineNames[row].componentsSeparatedByString(" ")
        let availableLines = originalVoynichLoader?.getLineNamesForPage(nameArray[0])
        if let array = availableLines {
            let rand = RealRandomNumberGenerator.random(array.count)
            let line = array[rand]
            let lineName = "<\(nameArray[0]).\(line)>"
            taskTextField.text = lineName
            updateLineText(lineName)
        } else {
            updateLineText(defaultLineName)
            taskTextField.text = defaultLineName
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    /// show alert dialog
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) { action -> Void in
            
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    // initialize the menu dialog
    func initMenuDialog() {
        
        menuDialog = UIAlertController(title: "Menu", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        menuDialog2 = UIAlertController(title: "Menu", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        confirmDialogA = UIAlertController(title: "Confirm long running task", message: "Task will generate 30 pages of text.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        confirmDialogB = UIAlertController(title: "Confirm long running task", message: "Task will generate 44 pages of text.", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Load Transcription by Takahashi
        let showOrginalAction = UIAlertAction(title: "Load original text", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            self.useOriginalVoynichLoader = true
            self.performSegueWithIdentifier("generate", sender: self)
        }
        
        let generateSampleA_Action = UIAlertAction(title: "Generate sample A", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            self.confirmDialogA.popoverPresentationController?.sourceView = self.view
            
            self.presentViewController(self.confirmDialogA, animated: true, completion: nil)
//            // <f1r.P1.1>
//            self.useOriginalVoynichLoader = false
//            self.generateSample = 1
//            self.performSegueWithIdentifier("generate", sender: self)
        }
        
        let generateSampleB_Action = UIAlertAction(title: "Generate sample B", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            self.confirmDialogB.popoverPresentationController?.sourceView = self.view
            
            self.presentViewController(self.confirmDialogB, animated: true, completion: nil)
//            // <f103r.P.32>
//            self.useOriginalVoynichLoader = false
//            self.generateSample = 2
//            self.performSegueWithIdentifier("generate", sender: self)
        }
    
        let okSampleA_Action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            // <f1r.P1.1>
            self.useOriginalVoynichLoader = false
            self.generateSample = 1
            self.performSegueWithIdentifier("generate", sender: self)
        }
        
        let okSampleB_Action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            // <f103r.P.32>
            self.useOriginalVoynichLoader = false
            self.generateSample = 2
            self.performSegueWithIdentifier("generate", sender: self)
        }
        
        // contact info
        let contactAction = UIAlertAction(title: "Contact", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            self.showAlert("Torsten Timm", message: "http://www.kereti.de")
        }

        // options
        let optionsAction = UIAlertAction(title: "Options", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
            self.performSegueWithIdentifier("options", sender: self)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        if debug {
            let distanceAction = UIAlertAction(title: "_distance", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
                //var distance = Levenshtein.getDistanceOptimized("ckhol", t: "chol")
                //println("distance=\(distance)")
                //distance = Levenshtein.getDistance("ckhol", t: "chol", damerau: true )
                //println("distance=\(distance)")
                if let voynichLoader = self.originalVoynichLoader {
                    SimilarResults.calcDistances("chol", voynichLoader: voynichLoader)
                }
            }
            let topAction = UIAlertAction(title: "_top", style: UIAlertActionStyle.Default) { (alert: UIAlertAction) -> Void in
                if let voynichLoader = self.originalVoynichLoader {
                    SimilarResults.calcTopWords(voynichLoader)
                }
            }

            menuDialog.addAction(distanceAction)
            menuDialog.addAction(topAction)
        }
        
        menuDialog.addAction(optionsAction)
        menuDialog.addAction(showOrginalAction)
        menuDialog.addAction(contactAction)
        menuDialog.addAction(cancelAction)
        
        menuDialog2.addAction(optionsAction)
        menuDialog2.addAction(showOrginalAction)
        menuDialog2.addAction(generateSampleA_Action)
        menuDialog2.addAction(generateSampleB_Action)
        menuDialog2.addAction(contactAction)
        menuDialog2.addAction(cancelAction)
        
        confirmDialogA.addAction(okSampleA_Action)
        confirmDialogA.addAction(cancelAction)
        
        confirmDialogB.addAction(okSampleB_Action)
        confirmDialogB.addAction(cancelAction)
    }
    
    
    /// action for "Generate text"-button
    @IBAction func generateAction(sender: AnyObject) {
        self.useOriginalVoynichLoader = false
        self.performSegueWithIdentifier("generate", sender: self)
    }

    /// action for "Similarities"-button
    @IBAction func similarAction(sender: AnyObject) {
        self.performSegueWithIdentifier("similar", sender: self)
    }
    
    /// initialize intro animation
    func initAnimation() {
        
        counter = -20
        textLength = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(timerStep, target: self, selector: "updateTimer", userInfo: nil, repeats: true)

        lineTextField.hidden = true
        taskTextField.hidden = true
        pickerView.hidden = true
        initialLineLabel.hidden = true
        choosePageLabel.hidden = true
        animationTextView.hidden=true

        navItem.rightBarButtonItem = stopAnimationButton
        btnMenu.enabled = false
        generateActionButton.enabled = false
        similarActionButton.enabled = false
        if let _ = originalVoynichLoader {
            stopAnimationButton.enabled = true
        } else {
            stopAnimationButton.enabled = false
        }
    }
    
    /// next animation step
    func updateTimer() {
        if !stopAnimationButton.enabled {
            if let _ = originalVoynichLoader {
                stopAnimationButton.enabled = true
            } else {
                stopAnimationButton.enabled = false
            }
        }
        if !swipeIsRunning {
            switch counter {
            case -20:
                if pageCurlAnimation {
                    animationTextView.hidden = false
                }
                animation("in", astep: counter)
            case -10:
                animation("outin", astep:counter)
            case 0:
                animation("outin", astep: 0)
            case 2...37:
                step(counter)
                animationTextView.setNeedsDisplay()
            case 41:
                animation("outin", astep: counter)
            case 50:
                animation("outin", astep: counter)
            case 62...70:
                finishAnimation()
            default:
                break
            }
        }
        
        counter++
    }
    
    /// invalidate animation and show application controls
    func finishAnimation() {
        timer?.invalidate()
        timer = nil
        counter = 62

        if initial {
            initial=false
            taskTextField.text = defaultLineName
            updateLineText(defaultLineName)
            pickerView.selectRow(0, inComponent: 0, animated: true)
        }

        lineTextField.hidden       = false
        taskTextField.hidden       = false
        pickerView.hidden          = false
        initialLineLabel.hidden    = false
        choosePageLabel.hidden     = false
        btnMenu.enabled              = true
        generateActionButton.enabled = true
        similarActionButton.enabled  = true
        
        navItem.rightBarButtonItem = initAnimationButton
        
        animation("out", astep: -40)
        self.navigationItem.title="Voynich text generator"
    }
    
    /// handle swipe left
    func forwardAnimation() {
        if counter < 62 {
            if stopAnimationButton.enabled && counter > 50 {
                finishAnimation()
            } else if stopAnimationButton.enabled && counter > 41 {
                counter = 50
                animation("outin", astep: counter)
            } else if stopAnimationButton.enabled && counter > 0 {
                counter = 41
                animation("outin", astep: counter)
            } else if counter > -10 {
                counter = 0
                animation("outin", astep: counter)
            } else {
                counter = -10
                animation("outin", astep: counter)
            }
        }
    }
    
    /// handle swipe right
    func backwardAnimation() {
        if counter < 62 {
            if counter > 50 {
                counter = 41
                animation("reverse", astep: counter)
            } else if counter > 41 {
                counter = 0
                animation("reverse", astep: counter)
            } else if counter > 0 {
                counter = -10
                animation("reverse", astep: counter)
            } else if counter > -10 {
                counter = -20
                animation("reverse", astep: counter)
            }
        }
    }
    
    /// returns the position of searchString in animationTextView
    func calcPos(searchString: String) -> Int{
        let startIndex = animationTextView.text.rangeOfString(searchString)?.startIndex
        
        if let index = startIndex {
            return animationTextView.text.startIndex.distanceTo(index)
        }
        
        return 0
    }
    
    /// update animation after the animation has finished
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        let nameKey = anim.valueForKey("name") as? String
        if let name = nameKey {
            switch name {
            case "in":
                let layer : CALayer = anim.valueForKey("layer")! as! CALayer
                layer.position.x = view.bounds.width/2
                anim.setValue(nil, forKey: "layer")
                swipeIsRunning = false
            case "out":
                let layer : CALayer = anim.valueForKey("layer")! as! CALayer
                layer.position.x = -view.bounds.width/2
                animationTextView.hidden = true
                anim.setValue(nil, forKey: "layer")
            case "outin":
                let layer : CALayer = anim.valueForKey("layer")! as! CALayer
                layer.position.x = -view.bounds.width/2
                animationTextView.hidden = true
                let step : Int = anim.valueForKey("step")! as! Int
                animation("in", astep: step)
            case "reverse":
                let layer : CALayer = anim.valueForKey("layer")! as! CALayer
                layer.position.x = view.bounds.width/2
                animationTextView.hidden = true
                let step : Int = anim.valueForKey("step")! as! Int
                animation("inleft", astep: step)
            default:
                break
            }
        }
    }
    
    /// start animation
    func animation(name: String, astep: Int) {
        
        if pageCurlAnimation {
            // curl animation
            // set a transition style
            let transitionOptions = name == "reverse" ? UIViewAnimationOptions.TransitionCurlDown : UIViewAnimationOptions.TransitionCurlUp
            if astep == -20 && name != "reverse" {
                self.animationTextView.alpha = 0.0
                self.step(-40)
            }
            if playSounds {
                pageTurnAudioPlayer!.play()
            }
            swipeIsRunning = true
            UIView.transitionWithView(self.animationTextView, duration: 1.0, options: transitionOptions, animations: {
                
                switch name {
                case "in":
                    self.animationTextView.hidden = false
                case "out":
                    self.animationTextView.hidden = true
                default:
                    self.animationTextView.hidden = false
                }
                self.step(astep)
                if astep == -20 && name != "reverse" {
                    self.animationTextView.alpha = 0.3
                }
            }, completion: { finished in
                // any code entered here will be applied
                // .once the animation has completed
                if astep == -20 {
                   self.animationTextView.alpha = 1.0
                }
                self.swipeIsRunning = false
                    
            })
            
        } else {
            // swipe animation
            switch name {
            case "in":
                step(astep)
                animationTextView.layer.position.x = view.bounds.size.width + view.bounds.size.width/2
                animationTextView.hidden = false
                
                let flyLeft = CABasicAnimation(keyPath: "position.x")
                flyLeft.fromValue = view.bounds.size.width + view.bounds.size.width/2
                flyLeft.toValue = view.bounds.size.width/2
                flyLeft.duration = 0.5
                flyLeft.delegate = self
                flyLeft.setValue("in", forKey: "name")
                flyLeft.setValue(animationTextView.layer, forKey: "layer")
                
                flyLeft.beginTime = CACurrentMediaTime()
                animationTextView.layer.addAnimation(flyLeft, forKey: "animation")
            case "inleft":
                step(astep)
                animationTextView.layer.position.x = -view.bounds.size.width
                animationTextView.hidden = false
                
                let flyLeft = CABasicAnimation(keyPath: "position.x")
                flyLeft.fromValue = -view.bounds.size.width
                flyLeft.toValue = view.bounds.size.width/2
                flyLeft.duration = 0.5
                flyLeft.delegate = self
                flyLeft.setValue("in", forKey: "name")
                flyLeft.setValue(animationTextView.layer, forKey: "layer")
                
                flyLeft.beginTime = CACurrentMediaTime()
                animationTextView.layer.addAnimation(flyLeft, forKey: "animation")
            case "out":
                let flyLeft = CABasicAnimation(keyPath: "position.x")
                flyLeft.fromValue = view.bounds.size.width
                flyLeft.toValue = -view.bounds.size.width/2
                flyLeft.duration = 0.5
                flyLeft.delegate = self
                flyLeft.removedOnCompletion = false
                flyLeft.fillMode = kCAFillModeForwards
                flyLeft.setValue("out", forKey: "name")
                flyLeft.setValue(animationTextView.layer, forKey: "layer")
                
                flyLeft.beginTime = CACurrentMediaTime()
                animationTextView.layer.addAnimation(flyLeft, forKey: "animation")
            case "outin":
                if playSounds {
                    pageTurnAudioPlayer!.play()
                }
                swipeIsRunning = true
                let flyLeft = CABasicAnimation(keyPath: "position.x")
                flyLeft.fromValue = view.bounds.size.width
                flyLeft.toValue = -view.bounds.size.width/2
                flyLeft.duration = 0.5
                flyLeft.delegate = self
                flyLeft.removedOnCompletion = false
                flyLeft.fillMode = kCAFillModeForwards
                flyLeft.setValue("outin", forKey: "name")
                flyLeft.setValue(astep, forKey: "step")
                flyLeft.setValue(animationTextView.layer, forKey: "layer")
                
                flyLeft.beginTime = CACurrentMediaTime()
                animationTextView.layer.addAnimation(flyLeft, forKey: "animation")
            case "reverse":
                if playSounds {
                    pageTurnAudioPlayer!.play()
                }
                swipeIsRunning = true
                let flyRight = CABasicAnimation(keyPath: "position.x")
                flyRight.fromValue = view.bounds.size.width
                flyRight.toValue = view.bounds.size.width+view.bounds.size.width/2
                flyRight.duration = 0.5
                flyRight.delegate = self
                flyRight.removedOnCompletion = false
                flyRight.fillMode = kCAFillModeForwards
                flyRight.setValue("reverse", forKey: "name")
                flyRight.setValue(astep, forKey: "step")
                flyRight.setValue(animationTextView.layer, forKey: "layer")
                
                flyRight.beginTime = CACurrentMediaTime()
                animationTextView.layer.addAnimation(flyRight, forKey: "animation")
            default:
                break;
            }
        }
    }
    
    /// animation steps
    func step(step: Int) {
        //println("step=\(step)")
        animationTextView.textStorage.removeAttribute(NSUnderlineStyleAttributeName, range: NSMakeRange(0, textLength))
        switch step {
        case -40:
            animationTextView.text = ""
            textLength = 0
        case -20:
            animationTextView.font = UIFont(name: "Helvetica", size: fontSizeText)!
            animationTextView.text = "\nThe Voynich manuscript is a medieval book written in an unknown script. Even after 100 years of research it is still unknown if the text within the manuscript contains a message in an unknown language, an encoded message in an unknown cipher system or whether it is a pseudo text in an unknown or constructed language."
            textLength = animationTextView.text.characters.count
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(0, textLength))
        case -10:
            self.navigationItem.title="Voynich text generator"
            animationTextView.font = UIFont(name: "Helvetica", size: fontSizeText)!
            animationTextView.text = "\nThis app simulates a text generation method for the Voynich manuscript. This method is based on the observation that similarly spelled words occur frequently above each other. The following animation will illustrate this feature of the manuscript."
            textLength = animationTextView.text.characters.count
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(0, textLength))
        case 0:
            self.navigationItem.title="f1r.P1"
            animationTextView.font = UIFont(name: "EVA-Hand1", size: fontSizeVoynich)!
            
            var paragraph1 = ""
            for line in f1rP1_lines {
                if paragraph1 == "" {
                    paragraph1 = line
                } else {
                    paragraph1 = paragraph1 + "\n" + line
                }
            }
            animationTextView.text = paragraph1
            
            textLength = paragraph1.characters.count
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: UIColor.grayColor(), range: NSMakeRange(0, textLength))
        case 2:
            let pos = calcPos("ar ytaiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+3, 6))
            
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos+3, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blueColor, range: NSMakeRange(pos+4, 5))
        case 3:
            let pos = calcPos("or y kair")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+3, 1))
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+5, 4))
            
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos + 3, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blueColor, range: NSMakeRange(pos + 5, 4))
        case 4:
            let pos = calcPos("or ykaiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+3, 6))
            
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos + 3 , 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blueColor, range: NSMakeRange(pos + 4, 5))
        case 5:
            let pos = calcPos("or roloty")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
        case 6:
            let pos = calcPos("ar cThaiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
        case 7:
            var pos = calcPos("ory cKhar")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            
            pos = calcPos("ar or y")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
        case 8:
            let pos = calcPos("syaiir")+2
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 4))
        case 9:
            let pos = calcPos("sairy")+1
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 3))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 3))
        case 10:
            var pos = calcPos("Shory")+2
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            pos = calcPos("or Sholdy")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
        case 11:
            var pos = calcPos("ar air")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+3, 3))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos+3, 3))
            
            pos = calcPos("ar cThar")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+6, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos+6, 2))
        case 12:
            var pos = calcPos("ary cThes")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            
            pos = calcPos("araiin sy")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
        case 13:
            var pos = calcPos("ar daiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            
            pos = calcPos("or okan")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
        case 14:
            var pos = calcPos("ar cFhaiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
            
            pos = calcPos("araiShy")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(pos, 2))
        case 15:
            var pos = calcPos("Shol Shory")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: darkGreenColor, range: NSMakeRange(pos, 4))
            
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos + 5, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: darkGreenColor, range: NSMakeRange(pos + 5, 4))
            
            pos = calcPos("Sholdy")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: darkGreenColor, range: NSMakeRange(pos, 4))
        case 16:
            let pos = calcPos("Shar air")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: darkGreenColor, range: NSMakeRange(pos, 4))
        case 17:
            let pos = calcPos("Shod cThoary")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: darkGreenColor, range: NSMakeRange(pos, 4))
        case 18:
            let pos = calcPos("chear cThaiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: darkGreenColor, range: NSMakeRange(pos, 5))
        case 19:
            let pos = calcPos("cThres y")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos, 4))
        case 20:
            var pos = calcPos("cKhar or")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos, 5))
            
            pos = calcPos("cThar cThar")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos, 5))
            
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+6, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos+6, 5))
        case 21:
            let pos = calcPos("cThoary cThes")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 6))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos, 6))
            
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+8, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos+8, 5))
        case 22:
            let pos = calcPos("cT*ar")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos, 5))
        case 23:
            let pos = calcPos("cThaiin cPhar cFhaiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 7))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos, 7))
            
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+8, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos+8, 5))
            
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+14, 7))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: greenColor, range: NSMakeRange(pos+14, 7))
        case 24:
            let pos = calcPos("taiin Shar")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blueColor, range: NSMakeRange(pos, 5))
        case 25:
            var pos = calcPos("taiin or")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blueColor, range: NSMakeRange(pos, 5))
            pos = calcPos("kan")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 3))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blueColor, range: NSMakeRange(pos, 3))
        case 26:
            let pos = calcPos("dan")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 3))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: lightBlueColor, range: NSMakeRange(pos, 3))
        case 27:
            let pos = calcPos("daraiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: lightBlueColor, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+3, 4))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: lightBlueColor, range: NSMakeRange(pos+3, 4))
        case 28:
            var pos = calcPos("doiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: lightBlueColor, range: NSMakeRange(pos, 5))
            pos = calcPos("daiin")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 5))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: lightBlueColor, range: NSMakeRange(pos, 5))
        case 29:
            let pos = calcPos("ys ykal")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 2))
        case 30:
            let pos = calcPos("sory")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+3, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos+3, 1))
        case 31:
            let pos = calcPos("syaiir")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 2))
        case 32:
            let pos = calcPos("sairy")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos+4, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos+4, 1))
        case 33:
            var pos = calcPos("y cThres")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
            
            pos = calcPos("y cThes")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
        case 34:
            var pos = calcPos("y cThres")+7
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
            pos += 2
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
            pos = calcPos("Sholdy")+4
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 2))
        case 35:
            let pos = calcPos("aiin sy")+5
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 2))
        case 36:
            var pos = calcPos("ydaraiShy")
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 2))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 2))
            pos += 6
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
            pos += 2
            animationTextView.textStorage.addAttribute(NSUnderlineStyleAttributeName, value: underlineThickness, range: NSMakeRange(pos, 1))
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: redColor, range: NSMakeRange(pos, 1))
        case 37...40:
            break
        case 41:
            self.navigationItem.title="Voynich text generator"
            animationTextView.font = UIFont(name: "Helvetica", size: fontSizeText)!
            animationTextView.text = "\n\nThe text generation method is using words already written to generate new words. By copying and modifying words already written it is possibly to generate a text with features similar to that of the Voynich manuscript."
            textLength = animationTextView.text.characters.count
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(0, textLength))
        case 41...49:
            break
        case 50:
            animationTextView.font = UIFont(name: "Helvetica", size: fontSizeText)!
            animationTextView.text = "\n\nTo generate a pseudo text using this method select an initial source line and tap on \"Generate text\". To explore the similarities within the original manuscript select a page of the manuscript and tap on \"Similarities\"."
            textLength = animationTextView.text.characters.count
            animationTextView.textStorage.addAttribute(NSForegroundColorAttributeName, value: blackColor, range: NSMakeRange(0, textLength))
        default:
            print("ERROR: unexpected step(\(step))")
        }
    }
    
    /// handle return for editing taskTextField
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    // animationTextView is not editable
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}