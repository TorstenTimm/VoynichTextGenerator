//
//  FontOptionsViewController.swift
//  Voynich
//
//  Created by Torsten Timm on 19.01.15.
//  Copyright (c) 2015 Torsten Timm. All rights reserved.
//

import UIKit

protocol FontOptionsViewControllerDelegate {
    func selectFont(name : String)
}

class FontOptionsViewController: UITableViewController {
    
    var delegate : FontOptionsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 44
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let font = cell.reuseIdentifier!
        
        delegate?.selectFont(font)
        
        navigationController?.popViewControllerAnimated(true)
    }
}