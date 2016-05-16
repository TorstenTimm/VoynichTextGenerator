//
//  EVATools.swift
//  Voynich
//
//  Created by Torsten Timm on 16.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import UIKit

protocol FontTools {
    func replace(word: String) -> String
    func reverseReplace(word: String) -> String
}

let fontEva                      = "EVA-Hand1"   // "EVA Hand 1.ttf"

/// EVATools
/// prepares the text for viewing with the font EVA Hand 1.ttf
class EVATools: FontTools {
    
    let ligatureDictionary: Dictionary<String, String> = [
        "sh" : "Sh",
        "ckh": "cKh",
        "cth": "cTh",
        "cph": "cPh",
        "cfh": "cFh",
        "ikh": "IKh",
        "ith": "ITh",
        "iph": "IPh",
        "ifh": "IFh",
        "qkh": "qKh",
    ]
    
    let finalDictionary: Dictionary<String, String> = [
        "hh" : "Hh"
    ]
    
    let reverseDictionary: Dictionary<String, String> = [
        "Sh" : "sh",
        "cKh": "ckh",
        "cTh": "cth",
        "cPh": "cph",
        "cFh": "cfh",
        "IKh": "ikh",
        "ITh": "ith",
        "IPh": "iph",
        "IFh": "ifh",
        "qKh": "qkh",
    ]
    
    let reverseFinalDictionary: Dictionary<String, String> = [
        "Hh": "hh"
    ]
    
    /// returns the `word` printable in fontEva ('shedy' --> 'Shedy')
    func replace(word: String) -> String {
        var ret = word

        for (key, value) in ligatureDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        for (key, value) in finalDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        return ret
    }
    
    /// returns the `word` in EVA notation ('Shedy' --> 'shedy')
    func reverseReplace(word: String) -> String {
        var ret = word
        
        for (key, value) in reverseFinalDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        for (key, value) in reverseDictionary {
            ret = ret.stringByReplacingOccurrencesOfString(key, withString: value, options:
                NSStringCompareOptions.LiteralSearch )
        }
        
        return ret
    }
}

