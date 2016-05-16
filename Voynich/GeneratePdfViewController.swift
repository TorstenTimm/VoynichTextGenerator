//
//  GeneratePdfViewController.swift
//  iOS-Core
//
//  Created by Torsten Timm on 16.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import UIKit
import MessageUI

class GeneratePdfViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var navItem: UINavigationItem!

    let fileName_pdf                 = "voynich_generated.pdf"
    let fileName_txt                 = "voynich_generated.txt"
    
    let marginTop         : CGFloat  = 0
    let marginBottom      : CGFloat  = 0

    let pageBorderLeft    : CGFloat  = 70
    let pageBorderTop     : CGFloat  = 70
    let pageBorderRight   : CGFloat  = 35
    let pageBorderBottom  : CGFloat  = 70
    
    let pageWidth         : CGFloat  = 595
    let pageHeight        : CGFloat  = 842
    let documentWidth                = 595 - 70 - 35
    let documentHeight               = 842 - 70 - 70
    let pageSizeA4                   = CGRectMake(0, 0, 595, 842)
    
    var pageLength                   = 29
    var posY:    CGFloat             = 842
    
    var context: CGContextRef!
    
    var fontName                     = "EVA-Hand1"
    var fontTools: FontTools!
    var fontSize: CGFloat            = 14.0
    var textGenerator: TextGenerator!
    
    var isSample                 = false
    var initialLineName          = CurrierAName // "<f1r.P1.1>"
    var useOriginalVoynichLoader = false
    var originalVoynichLoader: OriginalVonyichLoader!
    var linesToCreate: Int       = 0
    var lineLength:    Int       = 55
    
    let titleOriginalText        = "Transcription by Takahashi"
    let titeGeneratedText        = "Generated pseudo text"
    
    /// init
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.translucent = false        
        automaticallyAdjustsScrollViewInsets = false
        
        if !useOriginalVoynichLoader {
            let initialLineType = OriginalVonyichLoader.determineCurrierType(initialLineName)
            let initialLineTypeName = OriginalVonyichLoader.readableCurrierType(initialLineType)
            initialLineName = "\(initialLineName) (\(initialLineTypeName))"
            navItem.title = "Generating..."
        } else {
            navItem.title = "Loading..."
        }
    }
    
    /// handle viewDidAppear
    override func viewDidAppear(animated: Bool) {
        activity.startAnimating()

        if !useOriginalVoynichLoader {
            let currierType = OriginalVonyichLoader.determineCurrierType(initialLineName)
            let lines = originalVoynichLoader.getAdditionalLinesForLineName(initialLineName, count: isSample ? 1 : toGenerateSourceRowCount)

            textGenerator = AutoCopyTextGenerator(linesToCreate: linesToCreate, lineLengthToCreate: lineLength, initialLines: lines, currierType: currierType)
            createPdf(lines.count)
        } else {
            createPdf(0)
        }
        createTxt()
        activity.stopAnimating()
        showPdfFile()
        navItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "mail"), style: UIBarButtonItemStyle.Plain, target: self, action: "sendEmailWithAttachment")

        if !useOriginalVoynichLoader {
            navItem.title = titeGeneratedText
        } else {
            navItem.title = titleOriginalText
        }
    }
    
    /// generate TXT-File
    func createTxt() {        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName_txt)
        
        let text     = textGenerator.voynichText.reduce("") { $0.isEmpty ? $1 : "\($0)\n\($1)" }
        do {
            try text.writeToURL(fileURL, atomically: false, encoding: NSUTF8StringEncoding)
        } catch {
            print(error)
        }

        
        if debug {
            print("\(fileURL)") //.path
        }
    }
    
    /// generate PDF-File
    func createPdf(initialLineCount: Int) {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName_pdf)
        
        if fontName == fontEva {
            fontTools = EVATools()
            fontSize  = 14.0
            pageLength = 29
        } else {
            fontTools = WebfontTools()
            fontSize  = 18.0
            pageLength = 29
        }
        // Create PDF Context
        UIGraphicsBeginPDFContextToFile(fileURL.path!, pageSizeA4, nil)
        
        // Get the graphics context.
        context  = UIGraphicsGetCurrentContext()
        
        var pageNumber = 0
        var lineCount  = 0

        // Draw text
        for text in textGenerator.voynichText {
            // Open a new page if necessary
            if useOriginalVoynichLoader {
                let generator = textGenerator as! OriginalVonyichLoader
                if posY > CGFloat(pageHeight-pageBorderBottom-14) || generator.isNewPage(lineCount) {
                    UIGraphicsBeginPDFPage()
                    drawPageName(generator.getPageName(lineCount))
                    posY = pageBorderTop
                }
            } else {
                if posY > CGFloat(pageHeight-pageBorderBottom-14) || lineCount >= pageLength {
                    UIGraphicsBeginPDFPage()
                    drawPageNumber(++pageNumber)
                    posY = pageBorderTop
                    lineCount = 0
                }
                if pageNumber == 1 && lineCount == 0 {
                    drawInitialLineName("initial line \(initialLineName)")
                }
            }
            
            drawLine(fontTools.replace(text), alignment: NSTextAlignment.Left, color: pageNumber == 1 && lineCount < initialLineCount ? UIColor.grayColor() : UIColor.blackColor())
            lineCount++
        }
        
        // Close the PDF context and write the contents out.
        UIGraphicsEndPDFContext()
    }
    
    /// draw one line of text into the PDF-File
    func drawLine(text: NSString, alignment: NSTextAlignment = NSTextAlignment.Left, color: UIColor) {
        
        let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = alignment
        
        let styleAttributes = [
            NSFontAttributeName             : UIFont(name: fontName, size: fontSize)!,
            NSParagraphStyleAttributeName   : paragraphStyle,
            NSForegroundColorAttributeName  : color
        ]
        
        let contentSize = text.boundingRectWithSize(
            CGSizeMake(CGFloat(documentWidth), CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: styleAttributes, context: nil)
        
        posY = posY + marginTop
        text.drawInRect(CGRectMake(CGFloat(pageBorderLeft), CGFloat(posY), contentSize.width, contentSize.height), withAttributes: styleAttributes)
        posY = posY + contentSize.height
        posY = posY + marginBottom
        
    }

    /// load an image and draw it
    func drawImage(name: String) {
        
        let file = NSBundle.mainBundle().pathForResource(name, ofType: "jpg")
        let image : UIImage? = UIImage(contentsOfFile: file!)

        if let theImage = image {
            // Optional: CGContextDrawImage!
            // http://stackoverflow.com/questions/506622/cgcontextdrawimage-draws-image-upside-down-when-passed-uiimage-cgimage
            theImage.drawInRect(CGRectMake(50, 40, theImage.size.width, theImage.size.height))
        } else {
            print("Error: Could not load image!")
        }
        
    }
    
    /// draw the page number
    func drawPageNumber (pageNum: NSInteger) {
        let pageString = "\(pageNum)"
        drawPageName(pageString)
    }
    
    /// draw the page number
    func drawPageName(pageString: String) {
        let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let styleAttributes = [
            NSFontAttributeName             : UIFont(name: fontEva, size: 14)!,
            NSParagraphStyleAttributeName   : paragraphStyle,
            NSForegroundColorAttributeName  : UIColor.blackColor()
        ]
        
        let pageStringSize = pageString.boundingRectWithSize(
            CGSizeMake(CGFloat(documentWidth), CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: styleAttributes, context: nil)
        
        pageString.drawInRect(CGRectMake(CGFloat(pageSizeA4.width-pageStringSize.width-pageBorderRight), CGFloat(25), pageStringSize.width, pageStringSize.height), withAttributes: styleAttributes)
    }
    
    /// draw the name of the initial line
    func drawInitialLineName (name: String) {
        
        let paragraphStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.Justified
        
        let styleAttributes = [
            NSFontAttributeName             : UIFont(name: "Courier", size: 16)!,
            NSParagraphStyleAttributeName   : paragraphStyle,
            NSForegroundColorAttributeName  : UIColor.grayColor()
        ]
        
        let pageStringSize = name.boundingRectWithSize(
            CGSizeMake(CGFloat(documentWidth), CGFloat.max),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: styleAttributes, context: nil)
        
        name.drawInRect(CGRectMake(CGFloat(pageSizeA4.width/2-pageStringSize.width/2), CGFloat(45), pageStringSize.width, pageStringSize.height), withAttributes: styleAttributes)
    }
    
    /// show the generated pdf file
    func showPdfFile() {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let fileURL = documentsURL.URLByAppendingPathComponent(fileName_pdf)
        if debug {
            print("\(fileURL)")
        }
        
        let webView     = UIWebView(frame: view.bounds)
        let request     = NSURLRequest(URL: fileURL)
        
        webView.scalesPageToFit = true
        webView.loadRequest(request)
        view.addSubview(webView)
    }
    
    // send generated text as email
    func sendEmailWithAttachment() {
        var subject         = "autogenerated Voynich text"
        var messageBody     = "Generated text by using \(initialLineName) as initial line."
        var toRecipients    = ["your@email.com"]
        
        if useOriginalVoynichLoader {
            subject         = titleOriginalText
            messageBody     = "Text of the Voynich manuscript."
        }
        if debug {
            toRecipients    = ["torsten.timm@kereti.de"]
        }
        
        // attach files
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(subject)
            mail.setMessageBody(messageBody, isHTML: false)
            mail.setToRecipients(toRecipients)
            // attach files
            let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
            let pdfFileURL = documentsURL.URLByAppendingPathComponent(fileName_pdf)
            let txtFileURL = documentsURL.URLByAppendingPathComponent(fileName_txt)
            
            let pdfData  = NSData(contentsOfFile: pdfFileURL.path!)
            let txtData = NSData(contentsOfFile: txtFileURL.path!)
            
            mail.addAttachmentData(pdfData!, mimeType: "application/pdf", fileName: "voynich_generated.pdf")
            mail.addAttachmentData(txtData!, mimeType: "text/plain", fileName: "voynich_generated.txt")
            //  self.navigationController?.
            presentViewController(mail, animated: true, completion: nil)
        } else {
            showCouldNotSendEmailAlert()
        }
    }
    
    /// show error alert
    func showCouldNotSendEmailAlert() {
        
        let sendEmailAlert = UIAlertView(title: "Could not send e-mail.", message: "Please check your e-mail configuration.", delegate: self, cancelButtonTitle: "OK")
        sendEmailAlert.show()
        
    }
    
    /// show info alert if email was send
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result.rawValue {
            
        case MFMailComposeResultSent.rawValue:
            showAlert("Info", message: "Mail send.")
        case MFMailComposeResultSaved.rawValue:
            showAlert("Info", message: "Mail saved.")
        case MFMailComposeResultCancelled.rawValue:
            showAlert("Info", message: "Mail canceled.")
        default:
            showAlert("Error", message: "Unknown MFMailComposeResult")
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// alert
    func showAlert(title: String, message: String) {
        UIAlertView(title: title, message: message, delegate: self, cancelButtonTitle: "OK").show()
    }
}
