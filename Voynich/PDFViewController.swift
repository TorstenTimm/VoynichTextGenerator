//
//  ImpressumViewController.swift
//  Voynich
//
//  Created by Torsten Timm on 07.01.15.
//  Copyright (c) 2015 Torsten Timm. All rights reserved.
//

import Foundation

import UIKit
import MessageUI

class PDFViewController: UIViewController {
    
    var fileName_pdf: String!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    /// init view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        automaticallyAdjustsScrollViewInsets = false
    }
    
    /// handle viewDidAppear
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        activity.startAnimating()
        showPdfFile()
        activity.stopAnimating()
    }
    
    /// show the generated pdf file
    func showPdfFile() {

        let pdfFileName = NSBundle.mainBundle().pathForResource(fileName_pdf, ofType: "pdf")!
        
        let webView     = UIWebView(frame: view.bounds)
        let url         = NSURL(fileURLWithPath: pdfFileName)
        let request     = NSURLRequest(URL: url)

        webView.scalesPageToFit = true
        webView.contentMode = UIViewContentMode.ScaleAspectFill;
        webView.loadRequest(request)
        view.addSubview(webView)
    }
}