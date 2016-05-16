//
//  Substitution.swift
//  Voynich
//
//  Created by Torsten Timm on 03.12.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import Foundation

/// class to represent the available substitutions for an element
class Substitution {
    
    var elements: [String]!
    
    // returns the number of glyphs within the `glyphGroup`
    var count: Int {
        get {
            return elements.count
        }
    }
    
    var probability: Int = 100
    
    /// used to access an element at position `i`
    subscript (i: Int) -> String {
        return elements[i]
    }
    
    /// used to access the first element
    var first: String {
        get {
            return elements[0]
        }
    }
    
    /// used to access the last element
    var last: String {
        get {
            return elements[elements.count-1]
        }
    }
    
    init(var elements: [String], probability: Int) {
        if elements.count == 0 {
            _ = elements[0]
        }
        self.elements = elements
        self.probability = probability
    }
}