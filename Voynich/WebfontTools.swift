//
//  Voynich.swift
//  Voynich
//
//  Created by Torsten Timm on 16.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import UIKit

let fontWebfont                  = "Voynich-123"

/// WebfontTools
/// prepares the text for viewing with the font voynich-1.23-webfont.ttf
class WebfontTools: FontTools {
    
    let charDictionary: Dictionary<String, String> = [
        "e": "c",
        "y": "9",
        "k": "h",
        "d": "8",
        "g": "*",
        "n": "N",
        "q": "4",
        "x": "|",
    ]
    
    let ligatureDictionary: Dictionary<String, String> = [
        "ch" : "1",
        "sh" : "2",
        "ckh": "H",
        "cth": "K",
        "cph": "G",
        "cfh": "F",
        "iir": "Z",
        "p"  : "g",
    ]
    
    let finalDictionary: Dictionary<String, String> = [
        "iN" : "n",
        "iiN": "m",
        "iip": "q",
        "t"  : "k",
        "l"  : "e",
        "r"  : "y",
        "m"  : "p",
    ]
    
    let reverseCharDictionary: Dictionary<String, String> = [
        "c": "e",
        "9": "y",
        "h": "k",
        "g": "p",
        "8": "d",
        "*": "g",
        "N": "n",
        "4": "q",
        "|": "x",
    ]
    
    let reverseLigatureDictionary: Dictionary<String, String> = [
        "1": "ch",
        "2": "sh",
        "H": "ckh",
        "K": "cth",
        "G": "cph",
        "F": "cfh",
        "Z": "iir",
    ]
    
    let reverseFinalDictionary: Dictionary<String, String> = [
        "n": "iN",
        "m": "iiN",
        "q": "iip",
        "k": "t",
        "e": "l",
        "y": "r",
        "p": "m",
    ]
    
    /// returns a list with available ligatures
    func ligatures() -> [String] {
        return Array(ligatureDictionary.keys); // ligatureDictionary.keys.array;
    }
    
    /// returns a list with available chars
    func chars() -> [String] {
        return Array(charDictionary.keys); // charDictionary.keys.array;
    }
    
    /// returns the `word` printable in Webfont ('chedy' --> '1c89')
    func replace(word: String) -> String {
        var ret = word

        for (key, value) in ligatureDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        for (key, value) in charDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        for (key, value) in finalDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        return ret
    }
    
    /// returns the `word` in EVA notation ('1c89' --> 'chedy')
    func reverseReplace(word: String) -> String {
        var ret = word
        
        for (key, value) in finalDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        for (key, value) in charDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }

        for (key, value) in ligatureDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        return ret
    }
}


