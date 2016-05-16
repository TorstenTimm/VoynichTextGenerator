//
//  GlyphGroup.swift
//  Voynich
//
//  Created by Torsten Timm on 22.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import UIKit

enum GENERATE_TYPE: Int {
    case INITIAL = 1, ADD = 2, DELETE = 3, REPLACE = 4, COMBINE = 5, SPLIT = 6, SHORTEN = 7
}

/// implementation of Comparable - Return true if `lhs` is equal to `rhs`.
func ==(lhs: GlyphGroup, rhs: GlyphGroup) -> Bool {
    return lhs.glyphGroup == rhs.glyphGroup
}

/// implementation of Comparable <=
func <=(lhs: GlyphGroup, rhs: GlyphGroup) -> Bool {
    return lhs.glyphGroup <= rhs.glyphGroup
}

/// implementation of Comparable >
func >(lhs: GlyphGroup, rhs: GlyphGroup) -> Bool {
    return lhs.glyphGroup > rhs.glyphGroup
}

/// implementation of Comparable <
func <(lhs: GlyphGroup, rhs: GlyphGroup) -> Bool {
    return lhs.glyphGroup < rhs.glyphGroup
}

/// implementation of Comparable >=
func >=(lhs: GlyphGroup, rhs: GlyphGroup) -> Bool {
    return lhs.glyphGroup >= rhs.glyphGroup
}


/// class to represent one glyph group
class GlyphGroup: Hashable, Comparable, CustomStringConvertible {
    
    // implementation Printable
    var description: String {
        return glyphGroup
    }
    
    // implementation Hashable
    var hashValue: Int {
        get {
            return glyphGroup.hashValue
        }
    }
    
    // the `glyphGroup`
    var glyphGroup: String! {
        didSet {
            parse()
        }
    }
    
    // stores the tokens of the `glyphGroup`
    var tokens: [String] = [String]()
    
    // returns the number of tokens within the `glyphGroup`
    var count: Int {
        get {
            return tokens.count
        }
    }
    
    // returns the number of glyphs within the `glyphGroup`
    var length: Int {
        get {
            return glyphGroup.characters.count
        }
    }
    
    var generateType: GENERATE_TYPE!

    /// used to access a token of the group
    subscript (i: Int) -> String {
        return tokens[i]
    }
    
    /// Construct an instance containing the given `glyphGroup`.
    init(glyphGroup: String, generateType: GENERATE_TYPE) {
        if glyphGroup.isEmpty {
            _ = tokens[0]
        }
        self.generateType = generateType
        self.glyphGroup = glyphGroup
        parse()
    }
    
    /// Construct an instance for a `glyphGroup` determined by the given `tokens`.
    init(var tokens: [String], generateType: GENERATE_TYPE) {
        if tokens.count == 0 {
            _ = tokens[0]
        }
        self.generateType = generateType
        self.tokens = tokens
        var temp: String = ""
        for token in tokens {
            temp += token
        }
        glyphGroup = temp
    }
    
    /// initialize the `tokens`-Array
    func parse() {
        let length = glyphGroup.characters.count
        var temp = glyphGroup
        var pos = 0
        tokens.removeAll(keepCapacity: true)
        
        while pos < length {
            let ligature = Glyph.determineStartLigature(temp)
            if let lig = ligature {
                tokens.append(lig)
                pos+=lig.characters.count
            } else {
                tokens.append(temp[0])
                pos++
            }

            if pos < length {
                temp = glyphGroup[pos..<length]
            }
        }
    }
    
    /// returns the tokens within the `glyphGroup` as human readable string
    /// used for debugging
    func tokensAsString() -> String {
        var ret: String = ""
        for token in tokens {
            ret += "{\(token)}"
        }
        
        return ret
    }
    
    /// returns a copy of the `tokens`
    func copyElements() -> [String] {
        var newTokens = [String]()
        for token in tokens {
            newTokens.append(token)
        }
        
        return newTokens
    }
    
    /// returns true is a glpyh starts with a gallow glyph (k,t,p,f)
    func startsWithGallow() -> Bool {
        return Glyph.startsWithGallow(glyphGroup)
    }
    
    /// returns true if the `glyphGroup` ends with a glyph typical at the end of a line (m,g)
    func endWithEndGlpyh() -> Bool {
        return Glyph.endsWithEndGlyph(glyphGroup)
    }
    
    /// returns true if the `glyphGroup` starts with a typical line inital glyph (o,y,d,s)
    func startsWithLineInitialGlyph() -> Bool {
        return Glyph.startsWithLineInitialGlyph(glyphGroup)
    }
    
    /// returns true if the `glyphGroup` starts with the `prefix` given
    func hasPrefix(prefix: String) -> Bool {
        return prefix == tokens[0]
    }
    
    /// returns true if the `glyphGroup` ends  with the `suffix` given
    func hasSuffix(suffix: String) -> Bool {
        return suffix == tokens[tokens.count-1]
    }
    
    // starts with 'ol', 'al', 'ar' or 'or'
    func startsWithCombinableLigature() -> Bool {
        for ligature in combinableLigature.keys {
            if ligature == tokens[0] {
                return true
            }
        }
        return false
    }
    
    // contains 'ol', 'al', 'ar' or 'or'
    func containsCombinableLigature() -> Bool {
        for ligature in combinableLigature.keys {
            for var i = 1; i < tokens.count; i++ {
                if ligature == tokens[i] {
                    return true
                }
            }
        }
        return false
    }
    
    // returns 'ol', 'al', 'ar' or 'or'
    func getCombinableLigature() -> String? {
        for ligature in combinableLigature.keys {
            for var i = 1; i < tokens.count; i++ {
                if ligature == tokens[i] {
                    return tokens[i]
                }
            }
        }
        return nil
    }
    
    /// returns true if all tokens can follow to each other
    func isValid() -> Bool {
        if generateType == GENERATE_TYPE.INITIAL {
            return true
        }
        for var i = 1; i < tokens.count; i++ {
            let previousToken = tokens[i-1]
            let nextToken = tokens[i]
            let lastOk = Glyph.canFollowEachOther(group1: previousToken, glyphToAdd: nextToken)
            let nextOk = Glyph.canFollowEachOther(glyphToAdd: previousToken, group2: nextToken)
            
            if !lastOk || !nextOk {
                //println("INVALID: \(description) i=\(i) [\(previousToken), \(nextToken)] \(lastOk) \(nextOk)")
                return false
            }
        }
        
        return true
    }
    
    /// returns true if `search` is part of `glyphGroup`
    func contains(search: String) -> Bool {
        for token in tokens {
            if search == token {
                return true
            }
        }
        
        return false
    }
    
    /// returns true if the glpyhGroup contains a gallow glyph
    func containsGallow() -> Bool {
        return Glyph.containsGallow(description)
    }
    
    /// returns true if the glpyhGroup contains a 'i'
    func isTypeI() -> Bool {
        return description.rangeOfString(iGlyph) != nil
    }
    
    /// returns true if the glpyhGroup contains a 'ol', 'or', 'al' or 'ar'
    func isTypeOl() -> Bool {
        for search in olGlyphs {
            for token in tokens {
                if search == token {
                    return true
                }
            }
        }
        
        return false
    }
    
    /// returns true if the glpyhGroup contains 'dy' or ends with 'y' or 'd'
    func isTypeDy() -> Bool {
        for token in tokens {
            if dyGlyph == token {
                return true
            }
        }
        
        let lastChar =  description.characters.last!
        return lastChar == yGlyph || lastChar == dGlyph
    }
}