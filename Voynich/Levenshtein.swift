//
//  Levenshtein.swift
//  Voynich
//
//  Created by Torsten Timm on 11.01.15.
//  Copyright (c) 2015 Torsten Timm. All rights reserved.
//

import UIKit

let similarGlyphsMap: Dictionary<String, [String]> = [
    "o": ["y", "a"],
    "y": ["o", "a"],
    "a": ["y", "o"],
    
    "d": ["l", "m", "r"],
    "l": ["d", "m", "r"],
    "m": ["l", "d", "r"],
    "r": ["l", "m", "d", "n", "s"],
    
    "n": ["r", "s"],
    //"r": ["n", "s"],
    "s": ["r", "n", "c", "e"],
    
    "k": ["t", "p", "f"],
    "t": ["k", "p", "f"],
    "p": ["t", "k", "f"],
    "f": ["t", "p", "k"],
    
    "c": ["s", "e"],
    //"s": ["c", "e"],
    "e": ["s", "c", "h"],
    
    "h": ["e"]
    //"e": ["h"],
]

class Levenshtein {
    
    /// returns true if c1 is similar to c2
    class func isSimilar(c1: String, c2: String) -> Bool {
        let arrayList = similarGlyphsMap[c1]
        if let array = arrayList {
            for c in array {
                if c == c2 {
                    return true
                }
            }
        }
        
        return false
    }
    
    /// This implemantation is based on Chas Emerick's Java implemantation
    class func getDistance(s: String, t: String, damerau: Bool) -> Int {
        let n = s.characters.count
        let m = t.characters.count
        
        if n == 0 {
            return m
        } else {
            if m == 0 {
                return n
            }
        }
        
        var p = [Int]() // 'previous' cost array, horizontally
        var p2 = [Int]() // cost array before 'previous', horizontally
        var d = [Int]() // cost array, horizontally
        var _d: [Int]   // placeholder to assist in swapping p and d
        
        var cost = 0
        
        for var i = 0; i <= n; i++ {
            p.append(i)
            d.append(0)
            p2.append(0)
        }
        
        for var i = 1; i <= m; i++ {
            let t_i = t[i-1]
            d[0] = i
            
            for var j = 1; j <= n; j++ {
                cost = s[j-1] == t_i ? 0 : Levenshtein.isSimilar(s[j-1], c2: t_i) ? 1 : 2
                
                // minimum of cell to the left+1, to the top+1, diagonally left and up +cost
                d[j] = min(min(d[j-1], p[j])+1, p[j-1]+cost)
                
                if damerau && j > 1 && i > 1 {
                    if s[j-1] == t[i-2] && s[j-2] == t_i  {
                        d[j] = min(d[j], p2[j-2] + 1)
                    }
                }
            }
            
            if  damerau {
                _d = p2
                p2 = p
            } else {
                _d = p
            }
            p = d
            d = _d
        }
        
        return p[n]
    }
    
    
    /// only a return value <= 'maxDiff' is correct
    /// used to improve perfomance
    class func getDistanceOptimized(s: String, t: String, maxDiff: Int = 2) -> Int {
        let n = s.characters.count
        let m = t.characters.count
        
        let diff = abs(m - n)
        if diff > maxDiff {
            return diff
        }
        
        var p = [Int]() // 'previous' cost array, horizontally
        var p2 = [Int]() // cost array before 'previous', horizontally
        var d = [Int]() // cost array, horizontally
        var _d: [Int]   // placeholder to assist in swapping p and d
        
        var cost = 0
        
        for var j = 0; j <= n; j++ {
            p.append(j)
            p2.append(0)
            d.append(0)
        }
        
        //var dMinLast = 0
        for var i = 1; i <= m; i++ {
            let t_i = t[i-1]
            let t_i2 = i > 1 ? t[i-2] : " "
            d[0] = i
            
            var dMin = Int.max
            for var j = 1; j <= n; j++ {
                let s_j = s[j-1]
                
                // minimum of cell to the left+1, to the top+1, diagonally left and up +cost
                cost = s_j == t_i ? 0 : Levenshtein.isSimilar(s_j, c2: t_i) ? 1 : 2
                d[j] = min(min(d[j-1], p[j])+1, p[j-1]+cost)
                
                if j > 1 && i > 1 {
                    if s_j == t_i2 && s[j-2] == t_i  {
                        d[j] = min(d[j], p2[j-2] + 1)
                    }
                }
                
                dMin = min(dMin, d[j])
            }
            
            //var dMin = d.reduce(Int.max, {min($0,$1)})
            if dMin > maxDiff+1 {
                return dMin
            }
            
            _d = p2
            p2 = p
            p = d
            d = _d
        }
        
        return p[n]
    }
}
