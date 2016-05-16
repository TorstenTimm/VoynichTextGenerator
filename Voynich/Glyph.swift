//
//  Glyph.swift
//  Voynich
//
//  Created by Torsten Timm on 16.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import UIKit

let iGlyph : String = "i"
let dyGlyph : String = "dy"
let yGlyph : Character = "y"
let dGlyph : Character = "d"

let olGlyphs:           [String]   = ["ol", "al", "or", "ar"]
let gallowGlyphs:       [String]   = ["k", "t", "p", "f"]
let lineInitialGlyphs:  [String]   = ["o", "y", "d", "s"]
let lineFinalGlyphs:    [String]   = ["m", "g"]

// determine which glyphs can be replaced by what
let similarElements: Dictionary<String, [Substitution]> = [
    "k"   : [Substitution(elements: ["t"], probability: 77), Substitution(elements: ["p"], probability: 94), Substitution(elements: ["f"], probability: 100)],
    "t"   : [Substitution(elements: ["k"], probability: 84), Substitution(elements: ["p"], probability: 96), Substitution(elements: ["f"], probability: 100)],
    "p"   : [Substitution(elements: ["k"], probability: 59), Substitution(elements: ["t"], probability: 97), Substitution(elements: ["f"], probability: 100)],
    "f"   : [Substitution(elements: ["k"], probability: 56), Substitution(elements: ["t"], probability: 92), Substitution(elements: ["p"], probability: 100)],
    
    "in"  : [Substitution(elements: ["n"], probability: 8), Substitution(elements: ["iin"], probability: 84), Substitution(elements: ["iiin"], probability: 87), Substitution(elements: ["ir"], probability: 97), Substitution(elements: ["iir"], probability: 99), Substitution(elements: ["il"], probability: 100),],
    "iin" : [Substitution(elements: ["n"], probability: 13), Substitution(elements: ["in"], probability: 70), Substitution(elements: ["iiin"], probability: 74), Substitution(elements: ["ir"], probability: 94), Substitution(elements: ["iir"], probability: 99), Substitution(elements: ["il"], probability: 100),],
    "iiin": [Substitution(elements: ["n"], probability: 6), Substitution(elements: ["in"], probability: 31), Substitution(elements: ["iin"], probability: 90), Substitution(elements: ["ir"], probability: 98), Substitution(elements: ["iir"], probability: 100)],
    
    "ir"  : [Substitution(elements: ["r"], probability: 6), Substitution(elements: ["in"], probability: 33), Substitution(elements: ["iin"], probability: 95), Substitution(elements: ["iiin"], probability: 97), Substitution(elements: ["iir"], probability: 99), Substitution(elements: ["iiir"], probability: 100)],
    "iir" : [Substitution(elements: ["r"], probability: 6), Substitution(elements: ["in"], probability: 30), Substitution(elements: ["iin"], probability: 89), Substitution(elements: ["iiin"], probability: 91), Substitution(elements: ["ir"], probability: 99), Substitution(elements: ["iiir"], probability: 100)],
    "iiir": [Substitution(elements: ["ir"], probability: 90), Substitution(elements: ["iir"], probability: 100)],
    
    "is"  : [Substitution(elements: ["in"], probability: 50), Substitution(elements: ["iis"], probability: 100)],
    "iis" : [Substitution(elements: ["iin"], probability: 50), Substitution(elements: ["is"], probability: 100)],
    
    "il"  : [Substitution(elements: ["in"], probability: 50), Substitution(elements: ["iil"], probability: 100)],
    "iil" : [Substitution(elements: ["iin"], probability: 50), Substitution(elements: ["il"], probability: 99), Substitution(elements: ["iiil"], probability: 100)],
    "iiil": [Substitution(elements: ["il"], probability: 66), Substitution(elements: ["iil"], probability: 100)],
    
    "im"  : [Substitution(elements: ["in"], probability: 30), Substitution(elements: ["iin"], probability: 100)],
    "iim" : [Substitution(elements: ["in"], probability: 30), Substitution(elements: ["iin"], probability: 100)],
    "iiim": [Substitution(elements: ["in"], probability: 30), Substitution(elements: ["iin"], probability: 100)],
    
    "om"  : [Substitution(elements: ["ol"], probability: 45), Substitution(elements: ["or"], probability: 94), Substitution(elements: ["og"], probability: 98), Substitution(elements: ["omg"], probability: 100)],
    "am"  : [Substitution(elements: ["al"], probability: 45), Substitution(elements: ["ar"], probability: 94), Substitution(elements: ["ag"], probability: 98), Substitution(elements: ["amg"], probability: 100)],
    "og" : [Substitution(elements: ["or"], probability: 30), Substitution(elements: ["al"], probability: 63), Substitution(elements: ["ar"], probability: 100)],
    "ag" : [Substitution(elements: ["ol"], probability: 48), Substitution(elements: ["or"], probability: 72), Substitution(elements: ["ar"], probability: 100)],
    
    "ol"  : [Substitution(elements: ["or"], probability: 30), Substitution(elements: ["al"], probability: 63), Substitution(elements: ["ar"], probability: 100)],
    "or"  : [Substitution(elements: ["ol"], probability: 47), Substitution(elements: ["al"], probability: 73), Substitution(elements: ["ar"], probability: 100)],
    "al"  : [Substitution(elements: ["ol"], probability: 48), Substitution(elements: ["or"], probability: 72), Substitution(elements: ["ar"], probability: 100)],
    "ar"  : [Substitution(elements: ["ol"], probability: 49), Substitution(elements: ["or"], probability: 73), Substitution(elements: ["al"], probability: 100)],
    
    "e"   : [Substitution(elements: ["e"], probability: 50), Substitution(elements: ["ee"], probability: 99), Substitution(elements: ["eee"], probability: 100)],
    "ee"  : [Substitution(elements: ["ch"], probability: 40), Substitution(elements: ["ch", "e"], probability: 50), Substitution(elements: ["e"], probability: 98), Substitution(elements: ["eee"], probability: 100)],
    "eee" : [Substitution(elements: ["ch"], probability: 10), Substitution(elements: ["ch", "e"], probability: 20), Substitution(elements: ["ee"], probability: 65), Substitution(elements: ["e"], probability: 100)],
    
    "ch"  : [Substitution(elements: ["ee"], probability: 10), Substitution(elements: ["sh"], probability: 90), Substitution(elements: ["ckh"], probability: 97), Substitution(elements: ["cth"], probability: 100)],
    "sh"  : [Substitution(elements: ["ee"], probability: 10), Substitution(elements: ["ch"], probability: 90), Substitution(elements: ["ckh"], probability: 97), Substitution(elements: ["cth"], probability: 100)],
    
    "ckh" : [Substitution(elements: ["cth"], probability: 30), Substitution(elements: ["k", "ch"], probability: 50), Substitution(elements: ["t", "ch"], probability: 70), Substitution(elements: ["eke"], probability: 72), Substitution(elements: ["ete"], probability: 74), Substitution(elements: ["cph"], probability: 78), Substitution(elements: ["ch"], probability: 100)],
    "cth" : [Substitution(elements: ["ckh"], probability: 30), Substitution(elements: ["k", "ch"], probability: 50), Substitution(elements: ["t", "ch"], probability: 70), Substitution(elements: ["eke"], probability: 72), Substitution(elements: ["ete"], probability: 74), Substitution(elements: ["cph"], probability: 78), Substitution(elements: ["cfh"], probability: 80), Substitution(elements: ["ch"], probability: 100)],
    
    "eke" : [Substitution(elements: ["ckh"], probability: 30), Substitution(elements: ["cth"], probability: 50), Substitution(elements: ["k", "ee"], probability: 56), Substitution(elements: ["t", "ee"], probability: 60), Substitution(elements: ["ete"], probability: 65), Substitution(elements: ["ee"], probability: 100)],
    "ete" : [Substitution(elements: ["ckh"], probability: 30), Substitution(elements: ["cth"], probability: 50), Substitution(elements: ["k", "ee"], probability: 56), Substitution(elements: ["t", "ee"], probability: 60), Substitution(elements: ["eke"], probability: 65), Substitution(elements: ["ee"], probability: 100)],
    
    "cph" : [Substitution(elements: ["ckh"], probability: 40), Substitution(elements: ["cth"], probability: 75), Substitution(elements: ["cfh"], probability: 80), Substitution(elements: ["ch"], probability: 100)],
    "cfh" : [Substitution(elements: ["ckh"], probability: 40), Substitution(elements: ["cth"], probability: 75), Substitution(elements: ["cph"], probability: 80), Substitution(elements: ["ch"], probability: 100)],
    
    "ikh" : [Substitution(elements: ["ckh"], probability: 100)],
    "ith" : [Substitution(elements: ["cth"], probability: 100)],
    "iph" : [Substitution(elements: ["cph"], probability: 100)],
    "ifh" : [Substitution(elements: ["cfh"], probability: 100)],
        
    "y"   : [Substitution(elements: ["o"], probability: 100)],
    "o"   : [Substitution(elements: ["y"], probability: 100)],
    
    "n"   : [Substitution(elements: ["r"], probability: 50), Substitution(elements: ["in"], probability: 63), Substitution(elements: ["iin"], probability: 100)],
    "l"   : [Substitution(elements: ["r"], probability: 100)],
    "r"   : [Substitution(elements: ["r"], probability: 50), Substitution(elements: ["s"], probability: 100)],
    "g"   : [Substitution(elements: ["m"], probability: 100)],
    "s"   : [Substitution(elements: ["r"], probability: 75), Substitution(elements: ["d"], probability: 100)],
    "d"   : [Substitution(elements: ["d"], probability: 50), Substitution(elements: ["s"], probability: 100)],
    "a"   : [Substitution(elements: ["d", "a"], probability: 98), Substitution(elements: ["d", "o"], probability: 100)],
    "qo"  : [Substitution(elements: ["o"], probability: 100)],
]

// determines if a gallow glyph occurs mainly in the first line of a paragraph
let gallowGlyphDictionary: Dictionary<String, Bool> = [
    "k" : false,
    "t" : false,
    "p" : true,
    "f" : true,
]

// deletable
let deletableGlyphs: Dictionary<String, Bool> = [
    "e" : true,
    "o" : true,
    "a" : true,
    "d" : true,
    "y" : true,
    "l" : true,
]

// glyphs typically used as group initial glyphs 
// list of elements to which a prefix can be added 
let prefixGlyphs: Dictionary<String, [String]> = [
    "l": ["k", "t", "p", "f", "d", "ch", "o", "a", "e", "i", "o"],
    "o": ["k", "t", "p", "f", "d", "ch"],
   "ch": ["k", "t", "p", "f", "d", "ol", "or", "al", "ar"],
    "q": [],
    "d": ["a"],
    "x": ["ol", "or", "al", "ar"],
]

// glyphs used as ligature
let ligature: Dictionary<String, Bool> = [
    "ol"   : true,
    "or"   : true,
    "al"   : true,
    "ar"   : true,
    "dy"   : true,
    "qo"   : true,
    "ch"   : true,
    "sh"   : true,
    "eee"  : true,
    "ee"   : true,
    "cth"  : true,
    "ckh"  : true,
    "cph"  : true,
    "cfh"  : true,
    "ith"  : true,
    "ikh"  : true,
    "iph"  : true,
    "ifh"  : true,
    "eke"  : true,
    "ete"  : true,
    "in"   : true,
    "iin"  : true,
    "iiin" : true,
    "ir"   : true,
    "iir"  : true,
    "iiir" : true,
    "is"   : true,
    "iis"  : true,
    "iiis" : true,
    "il"   : true,
    "iil"  : true,
    "iiil" : true,
    "im"   : true,
    "iim"  : true,
    "iiim" : true,
    "om"   : true,
    "am"   : true,
    "og"   : true,
    "ag"   : true,
]

// combinable ligature - determine which glyphs should be deleted after adding a `combinableLigature`
let combinableLigature: Dictionary<String, [String]> = [
    "ol": ["l", "r", "s"],
    "al": ["l", "r", "s"],
    "or": ["l", "r", "s"],
    "ar": ["l", "r", "s"],
]

// determine which glyphs can follow to a glyph
let allowedFollowerGlyphs: Dictionary<String, [String]> = [
    "k": ["a", "o",  "y",  "e", "ch", "sh"],
    "t": ["a", "o",  "y",  "e", "ch", "sh"],
    "p": ["a", "o",  "y", "ch", "sh"],
    "f": ["a", "o",  "y", "ch", "sh"],
   "ol": ["", "a", "o",  "y", "ch", "sh", "al", "ar", "ol", "ar", "t", "k", "p", "f", "d", "dy"],
   "or": ["", "a", "o",  "y", "ch", "al", "ar", "ol", "ar"],
   "al": ["", "a", "o",  "y", "ch", "sh", "al", "ar", "ol", "ar", "t", "k", "p", "f", "dy"],
   "ar": ["", "a", "o",  "y", "ch", "al", "ar", "ol", "ar"],
    "r": ["", "a", "o",  "y",  "ch"],
    "s": ["", "a", "o",  "y",  "e", "ee", "ch"],
    "d": ["", "a", "o",  "l",  "e", "ee", "ch", "sh" ],
    "m": [""],
    "e": ["d", "o", "y", "a", "s", "k", "t", "p", "f", "ch", "ckh", "cth", "cph", "cfh", ""],
   "ee": ["d", "o", "y", "a", "s", "k", "t", "p", "f", "ch", "ckh", "cth", "cph", "cfh", ""],
  "eee": ["d", "o", "y", "a", "s", "k", "t", "p", "f", "ch", "ckh", "cth", "cph", "cfh", ""],
]

// determine which glyphs can follow to line inital glyphs
let allowedInitialFollowerGlyphs: Dictionary<String, [String]> = [
    "s": ["a", "o", "y", "e", "ch", "sh"],
    "d": ["a", "o", "y", "ch" ],
    "y": ["d", "s", "ch", "sh", "k", "t", "p", "f"],
    "o": ["d", "s", "ch", "sh", "k", "t", "p", "f"],
]

// determine which glyphs can stand in front of other glyphs
let allowedPrecursorGlyphs: Dictionary<String, [String]> = [
    "k": ["", "o",  "qo", "y",  "l", "e", "ch", "sh", "ol", "al"],
    "t": ["", "o",  "qo", "y",  "l", "e", "ch", "sh", "ol", "al"],
    "p": ["", "o",  "qo", "y",  "l", "e", "ch", "sh", "ol", "al"],
    "f": ["", "o",  "qo", "y",  "l", "e", "ch", "sh", "ol", "al"],
   "dy": ["", "o",  "qo", "y",  "l", "e", "ch", "ckh", "cth", "cph", "cfh", "sh", "l", "ol", "al"],
    "d": ["", "o",  "qo", "y",  "l", "e", "ch", "ckh", "cth", "cph", "cfh", "sh", "l", "ol", "al"],
   "sh": ["", "l", "ol", "al", "d",  "t",  "k", "p", "f", "o", "y", "s", "e", "ee", "eee"], // prevent ash, arsh and orsh
  "ckh": ["", "o", "y", "e", "ch", "sh"],
  "cth": ["", "o", "y", "e", "ch", "sh"],
  "cph": ["", "o", "y", "e", "ch", "sh"],
  "cfh": ["", "o", "y", "e", "ch", "sh"],
    "e": ["", "t",  "k", "ch", "sh", "ckh", "cth", "cph", "cfh", "q", "o", "l", "s", "d"],
   "ee": ["", "t",  "k", "ch", "sh", "ckh", "cth", "cph", "cfh", "q", "o", "l", "s", "d"],
  "eee": ["", "t",  "k", "ch", "sh", "ckh", "cth", "cph", "cfh", "q", "o", "l", "s", "d"],
]

// glyphs typical in line final position
let finalGlyphReplacements: Dictionary<String, String> = [
    "ol"  : "om",
    "or"  : "om",
    "al"  : "am",
    "ar"  : "am",
    "iin" : "im",
    "in"  : "n",
    "iiin": "im",
    "om"  : "og",
    "am"  : "ag",
    "im"  : "mg"
]

// determine which glyphs can stand in front of other glyphs
let selfIngroupGlyphReplacements: Dictionary<String, String> = [
    "y"  : "o",
    "m"  : "r",
    "g"  : "r",
    "n"  : "r",
    "in" : "ir",
    "iin": "iir",
    "dy" : "da"
]

let selfFinalGlyphReplacements: Dictionary<String, String> = [
    "o": "y",
    "a": "y",
    "k": "t",
    "t": "k",
    "p": "f",
    "f": "p",
]

// function for glyphs
class Glyph {
    
    /// returns true if a `glyphGroup` starts with a gallow glyph (k,t,p,f)
    class func startsWithGallow(glyphGroup: String) -> Bool {
        for gallow in gallowGlyphs {
            if glyphGroup.hasPrefix(gallow) {
                return true
            }
        }
        
        return false
    }
    
    /// returns true if a `glyphGroup` ends with a gallow glyph (k,t,p,f)
    class func endsWithGallow(glyphGroup: String) -> Bool {
        for gallow in gallowGlyphs {
            if glyphGroup.hasSuffix(gallow) {
                return true
            }
        }
        
        return false
    }
    
    /// returns true if a `glyphGroup` starts with a glyph typical used line initialy (o,y,d,s)
    class func startsWithLineInitialGlyph(glyphGroup: String) -> Bool {
        for glyph in lineInitialGlyphs {
            if glyphGroup.hasPrefix(glyph) {
                return true
            }
        }
        
        return false
    }
    
    /// returns a `element` with the final glyph replaced if such a replacement is possible
    class func replaceFinalGlyph(element: String) -> String {
        let replacement = finalGlyphReplacements[element]
        if let ret = replacement {
            return ret
        }
        
        return element
    }
    
    /// returns a `element` with the final glyph replaced if such a replacement is possible
    class func replaceSelfFinalGlyph(element: String) -> String {
        let replacement = selfFinalGlyphReplacements[element]
        if let ret = replacement {
            return ret
        }
        
        return element
    }
    
    /// returns a `element` with the final glyph replaced if such a replacement is possible
    class func replaceSelfIngroupGlyph(element: String) -> String {
        let replacement = selfIngroupGlyphReplacements[element]
        if let ret = replacement {
            return ret
        }
        
        return element
    }
    
    /// returns true if a `glyphGroup` ends with a glyph typical at the end of a line (m,g)
    class func endsWithEndGlyph(glyphGroup: String) -> Bool {     
        for glyph in lineFinalGlyphs {
            if glyphGroup.hasSuffix(glyph) {
                return true
            }
        }
        
        return false
    }
    
    /// returns true if a `glyphGroup` contains a gallow preffered in paragraph initial lines (p,f)
    class func containsFirstLineGallow(glyphGroup: String) -> Bool {
        for gallow in gallowGlyphs {
            if gallowGlyphDictionary[gallow]! && glyphGroup.rangeOfString(gallow) != nil {
                return true
            }
        }
        
        return false
    }
    
    /// returns a `glyphGroup` with the initial gallows replaced by a `newGallow` [p,f]--> [k,t]
    class func replaceFirstLineGallow(glyphGroup: String, newGallow: String) -> String {
        var ret = glyphGroup
        for gallow in gallowGlyphs {
            if gallowGlyphDictionary[gallow]! && glyphGroup.rangeOfString(gallow) != nil {
                ret = ret.stringByReplacingOccurrencesOfString(gallow, withString: newGallow, options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
        }
        
        return ret
    }
    
    /// replaced all gallows in `glypGroup` with `newGallow`
    class func replaceGallows(glyphGroup: String, newGallow: String) -> String {
        var ret = glyphGroup
        for gallow in gallowGlyphs {
            if glyphGroup.rangeOfString(gallow) != nil {
                ret = ret.stringByReplacingOccurrencesOfString(gallow, withString: newGallow, options: NSStringCompareOptions.LiteralSearch, range: nil)
            }
        }
        
        return ret
    }
    
    /// returns true if the `glyphGroup` contains a gallow (k,t,p,f)
    class func containsGallow(glyphGroup: String) -> Bool {
        for gallow in gallowGlyphs {
            if glyphGroup.rangeOfString(gallow) != nil {
                return true
            }
        }
        
        return false
    }
    
    /// returns true if one of the `glyphGroups` contains a gallow (k,t,p,f)
    class func containsGallow(glyphGroups: [String]) -> Bool {
        for glyphGroup in glyphGroups {
            if containsGallow(glyphGroup) {
                return true
            }
        }
        
        return false
    }
    
    /// returns the initial group for a `glyphGroup` if this is a ligaure or nil
    class func determineStartLigature(glyphGroup: String) -> String? {
        // make sure 'eee' is not mixed up with 'ee'
        if glyphGroup.hasPrefix("eee") {
            return "eee"
        }
        for lig in Array(ligature.keys) {
            if glyphGroup.hasPrefix(lig) {
                return lig
            }
        }
        
        return nil
    }
    
    /// returns true if `element2` can follow to `element1`
    class func canFollowEachOther(element1 element1: String, element2: String) -> Bool {
        let x1 = canFollowEachOther(glyphToAdd: element1, group2: element2)
        let x2 = canFollowEachOther(group1: element1, glyphToAdd: element2)
        
        return x1 && x2
    }
    
    /// returns true if `glyphToAdd` can be used in front of `group2`
    class func canFollowEachOther(glyphToAdd glyphToAdd: String, group2: String) -> Bool {
        let allowedFollowerArray = allowedFollowerGlyphs[glyphToAdd]
        if let allowedArray = allowedFollowerArray {
            for allowedGlyph in allowedArray {
                if ((allowedGlyph.isEmpty && group2.isEmpty) || group2.hasPrefix(allowedGlyph)) {
                    return true
                }
            }
            return false
        }
        
        if group2.hasPrefix("q") {
            return false
        }
        
        return !group2.hasPrefix(glyphToAdd)
    }
    
    /// returns true if `glyphToAdd` can follow to `group1`
    class func canFollowEachOther(group1 group1: String, glyphToAdd: String) -> Bool {
        let allowedPreArray = allowedPrecursorGlyphs[glyphToAdd]
        if let allowedArray = allowedPreArray {
            for allowedGlyph in allowedArray {
                if ((allowedGlyph.isEmpty && group1.isEmpty ) || group1.hasSuffix(allowedGlyph)) {
                    return true
                }
            }
            
            return false
        }
        
        if glyphToAdd.hasPrefix("q") {
            return false
        }
        
        return !group1.hasSuffix(glyphToAdd)
    }
    
    /// returns true if `glyphToAdd` can follow to `group1` as initial glyph
    class func canFollowToInitalGlyph(glyphToAdd glyphToAdd: String, group2: String) -> Bool {
        let allowedFollowerArray = allowedInitialFollowerGlyphs[glyphToAdd]
        if let allowedArray = allowedFollowerArray {
            for allowedGlyph in allowedArray {
                if ((allowedGlyph.isEmpty && group2.isEmpty) || group2.hasPrefix(allowedGlyph)) {
                    return true
                }
            }
            return false
        }
        
        return false
    }
    
    /// returns an array with similar elements or nil
    class func similarGlyph(glyph: String) -> [Substitution]? {
        return similarElements[glyph]
    }
    
    /// determines if a `glyph` is a gallow glyph (k,t,p,f)
    class func isGallow(glyph: String) -> Bool {
        return gallowGlyphDictionary.indexForKey(glyph) != nil
    }
    
    /// determines if a `glyph` is deletable
    class func isDeletable(glyph: String) -> Bool {
        return deletableGlyphs.indexForKey(glyph) != nil
    }
    
    class func isCombinableLigature(element: String) -> Bool {
        return combinableLigature.indexForKey(element) != nil
    }
    
    /// try to find a shorter replacement for a `token`
    class func searchShorterGlyph(token: String) -> Substitution? {
        let glyphLength = token.characters.count
        
        var returnSubLength = glyphLength
        var returnSub: Substitution?
        if glyphLength > 1 {
            let elements = similarElements[token]

            if let substitutions = elements {
                for substitution in substitutions {
                    if substitution.count == 1 {
                        let substitutionLength = substitution[0].characters.count
                        if substitutionLength < returnSubLength {
                            returnSubLength = substitutionLength
                            returnSub = substitution
                        }
                    }
                }
            }
        }
        
        return returnSub
    }
    
    /// returns a random line initial `glyph`
    class func randomLineInitalGlyph(randomNumberGenerator: RandomNumberGenerator) -> String {
        let rand = randomNumberGenerator.rand(100)
        
        switch rand {
        case  0...45:
            return lineInitialGlyphs[0]
        case 46...75:
            return lineInitialGlyphs[1]
        case 76...90:
            return lineInitialGlyphs[2]
        case 91...99:
            return lineInitialGlyphs[3]
        default:
            return lineInitialGlyphs[0]
        }
    }
    
    /// returns a random gallow glyph
    /// if `firstLine` is true it returns all gallows and if it is set to false only 'k' (gallowGlyphs[0]) and 't' (gallowGlyphs[1])
    class func randomGallow(firstLine firstLine: Bool, randomNumberGenerator: RandomNumberGenerator) -> String {
        let rand = randomNumberGenerator.rand(100)
        
        switch rand {
        case  0...34:
            return gallowGlyphs[0]
        case 35...49:
            return gallowGlyphs[1]
        case 50...89:
            if firstLine {
                return gallowGlyphs[2]
            } else {
                return gallowGlyphs[0]
            }
        case 90...99:
            if firstLine {
                return gallowGlyphs[3]
            } else {
                return gallowGlyphs[1]
            }
        default:
            return gallowGlyphs[0]
        }
    }
}