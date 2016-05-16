//
//  Random.swift
//  Voynich
//
//  Created by Torsten Timm on 16.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import Foundation

protocol RandomNumberGenerator {
    func rand(max: Int) -> Int
}

class RealRandomNumberGenerator:  RandomNumberGenerator {
    
    /// generate a random number between 0 and `max`
    class func random(max: Int) -> Int {
        return Int(arc4random_uniform(UInt32(max)))
    }
    
    func rand(max: Int) -> Int {
        return RealRandomNumberGenerator.random(max)
    }
}

class PseudoRandomNumberGenerator: RandomNumberGenerator {
    
    var seedValue: UInt32 = 90
    
    func seed() {
        srandom(seedValue)
    }
    
    func seed(seed: UInt32) {
        seedValue = seed
        srandom(seed)
    }
    
    /// generate a random number between 0 and `max`
    func rand(max: Int) -> Int {
        if max == 0 {
            return 0
        }
        return Int(random()) % max
    }
}
