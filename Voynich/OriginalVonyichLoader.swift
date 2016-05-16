//
//  VoynichTextLoader.swift
//  Voynich
//
//  Created by Torsten Timm on 16.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import Foundation

/// TextGenerator to load the original text of the Voynich manuscript
class OriginalVonyichLoader: TextGenerator {
    
    var voynichText: [String] = [String]()
    var voynichPage: [String] = [String]()
    
    var voynichTextMap        = Dictionary<String, String>()
    var pageToLineFilteredMap = Dictionary<String, [String]>()
    var pageToLineNameMap     = Dictionary<String, [String]>()
    var pageToLineFullMap     = Dictionary<String, [String]>()
    
    required init(linesToCreate: Int, lineLengthToCreate: Int, initialLines: [String], currierType: CURRIER) {
        let templateFile = NSBundle.mainBundle().pathForResource("voynich", ofType: "txt")
        let templateData = try? NSString(contentsOfFile: templateFile!, encoding: NSUTF8StringEncoding)
        
        let allLines : [String] = (templateData?.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()))!
        
        for line in allLines {
            let textline = line
            let length = textline.characters.count
            
            var name = textline[0...18]
            name = name.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            name = name.stringByReplacingOccurrencesOfString(";H", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            let text = textline[19..<length]
            voynichText.append(text)
            voynichTextMap[name]=text
            
            let tuple = OriginalVonyichLoader.determineLine(name)
            voynichPage.append(tuple.page)
            
            if var array = pageToLineFullMap[tuple.page] {
                array.append(text)
                pageToLineFullMap[tuple.page] = array
            } else {
                var array = [String]()
                array.append(text)
                pageToLineFullMap[tuple.page] = array
            }
            
            if var array = pageToLineNameMap[tuple.page] {
                array.append(tuple.line)
                pageToLineNameMap[tuple.page] = array
            } else {
                var array = [String]()
                array.append(tuple.line)
                pageToLineNameMap[tuple.page] = array
            }
            
            if length - 19 > lineLengthToCreate - 10 && length - 19 < lineLengthToCreate + 5 && !textline.contains("*") {
                if var array = pageToLineFilteredMap[tuple.page] {
                    array.append(tuple.line)
                    pageToLineFilteredMap[tuple.page] = array
                } else {
                    var array = [String]()
                    array.append(tuple.line)
                    pageToLineFilteredMap[tuple.page] = array
                }
            }
        }
    }
    
    /// returns a list of available line names for a page
    func getLineNamesForPage(pageName: String) -> [String]? {
        var availableLines = pageToLineFilteredMap[pageName]
        if let lineArray = availableLines {
            return lineArray
        }
        availableLines = pageToLineNameMap[pageName]
        if let lineArray = availableLines {
            return lineArray
        } else {
            //print("Error: No lines found for page=\(page)")
            return nil
        }
    }
    
    /// returns `count` lines starting with `lineName`
    func getAdditionalLinesForLineName(lineName: String, count: Int) -> [String] {
        
        // <f1r.P1.1> (Currier A) --> <f1r.P1.1>
        let partArray = lineName.componentsSeparatedByString(" ")
        let lineName = partArray[0]
        
        // <f1r.P1.1> --> {f1r, P1.1}
        let tuple = OriginalVonyichLoader.determineLine(lineName)
        let pageName = tuple.page
        let compareName = tuple.line
        
        var counter = 0
        var returnArray = [String]()
        let pageLineNames = pageToLineNameMap[pageName]
        for name in pageLineNames! {
            if name == compareName {
                let searchName = "<\(pageName).\(name)>"
                let text = voynichTextMap[searchName]
                if let lineText = text {
                    returnArray.append(lineText)
                }
                counter++
            } else {
                if counter > 0 && counter < count {
                    let searchName = "<\(pageName).\(name)>"
                    let text = voynichTextMap[searchName]
                    if let lineText = text {
                        returnArray.append(lineText)
                    }
                    counter++
                }
            }
        }
        if returnArray.count == 0 {
            _ = returnArray[1]
        }
        
        return returnArray
    }
    
    /// returns the text lines for a page
    func getLinesForPage(page: String) -> [String] {
        let lines = pageToLineFullMap[page]
        if let lineArray = lines {
            return lineArray
        } else {
            //println("Error: No lines found for page=\(page)")
            return [String]()
        }
    }
    
    /// returns true if the line starts a new page and false otherwise
    func isNewPage(count: Int) -> Bool {
        if count < 1 {
            return false
        }
        
        return voynichPage[count] != voynichPage[count-1]
    }
    
    /// returns the page name for a line
    func getPageName(count: Int) -> String {
        var name = voynichPage[count]
        let length = name.characters.count
        let nextToLastChar = name[length-2]
        if nextToLastChar == "r" || nextToLastChar == "v" {
            // f102v2 -> 102
            name = name[1..<length-2]
        } else {
            // f79v -> 79
            name = name[1..<length-1]
        }
        return name
    }
    
    /// extracts the page name for a `lineName`
    ///<f79v.P.37> --> f79v
    class func getPageName(lineName: String) -> String {
        let tuple = determineLine(lineName)
        return tuple.page
    }
    
    /// extracts a tuple {page, line} for a `lineName`
    class func determineLine(lineName: String) -> (page: String, line: String) {
        let partArray = lineName.componentsSeparatedByString(".")
        //<f79v.P.37> --> <f79v
        var pageString = partArray[0]
        let length = pageString.characters.count
        //<f79v --> f79v
        pageString = pageString[1..<length]
        
        let nameLength = lineName.characters.count
        //<f79v.P.37> --> P.37
        let lineString = lineName[length+1..<nameLength-1]
        // return (page: "f79v", line: "P.37")
        return (page: pageString, line: lineString)
    }
    
    /// returns the Currier type for a `lineName`
    class func determineCurrierType(lineName: String) -> CURRIER {
        var partArray = lineName.componentsSeparatedByString(".")
        //<f79v.P.37> --> <f79v
        var pageString = partArray[0]
        let length = pageString.characters.count
        //<f79v--> f79v
        pageString = pageString[1..<length]
        
        let type = currierPageTypes[pageString]
        
        if let returnType = type {
            return returnType
        }
        
        return CURRIER.UNKNOWN
    }
    
    /// returns a human readable name for the given `type`
    class func readableCurrierType(type: CURRIER) -> String {
        switch type {
        case .A:
            return "Currier A"
        case .B:
            return "Currier B"
        case .UNKNOWN:
            return "Unknown"
        }
    }
}