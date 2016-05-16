//
//  StringExtension.swift
//  Voynich
//
//  Created by Torsten Timm on 16.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import Foundation

extension String {
    
    /// Example "Test"[3]
    subscript (i: Int) -> String {
        if i < 0 {
            return ""
        }
        //return String(Array(self.utf16)[i])
        return String(Array(self.characters)[i])
    }
    
    /// Example "Test"[1...3] or "Test"[1..<3]
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end   = startIndex.advancedBy(r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }
    
    /// Example: "Test".contains("substring")
    func contains(search: String) -> Bool {
        if self == "" {
            return false
        }
        
       var start = startIndex
        
        repeat {
            let subString = self[start++..<endIndex]
            if subString.hasPrefix(search) {
                return true
            }
        } while start != endIndex
        
        return false
    }
    
    /// Example: "Test".containsPos("es")
    func containsPos(search: String) -> Int {
        if self == "" {
            return -1
        }
        
        var start = startIndex
        var count = 0
        repeat {
            let subString = self[start++..<endIndex]
            if subString.hasPrefix(search) {
                return count
            }
            count++
        } while start != endIndex
        
        return -1
    }
    
    /// Example: "Test".containsPos("s", 2)
    func containsPos(search: String, startPos: Int) -> Int {
        if self == "" {
            return -1
        }
        
        var start = startIndex.advancedBy(startPos)
        var count = startPos
        repeat {
            let subString = self[start++..<endIndex]
            if subString.hasPrefix(search) {
                return count
            }
            count++
        } while start != endIndex
        
        return -1
    }
}