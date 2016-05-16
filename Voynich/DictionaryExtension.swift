//
//  DictionaryExtension.swift
//  Voynich
//
//  Created by Torsten Timm on 19.11.14.
//  Copyright (c) 2014 Torsten Timm. All rights reserved.
//

import Foundation

extension Dictionary {
    
    func filter(predicate: (key: Key, value: Value) -> Bool) -> Dictionary {
        var filteredDictionary = Dictionary()
        
        for (key, value) in self {
            if predicate(key: key, value: value) {
                filteredDictionary.updateValue(value, forKey: key)
            }
        }
        
        return filteredDictionary
    }
    
    /// Example: dict.sortedKeys(<) dict.sortedKeys(>)
    func sortedKeys(isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
        var array = Array(self.keys)
        array.sortInPlace(isOrderedBefore)
        return array
    }
    
    /// Example: dict.sortedKeysByValue(<) dict.sortedKeysByValue(>)
    func sortedKeysByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        var array = Array(self)
        array.sortInPlace {
            let (_, lv) = $0
            let (_, rv) = $1
            return isOrderedBefore(lv, rv)
        }
        return array.map {
            let (k,_) = $0
            return k
        }
    }
}