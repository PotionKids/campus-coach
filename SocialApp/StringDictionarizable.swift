//
//  StringDictionarizable.swift
//  SocialApp
//
//  Created by Kris Rajendren on Oct/29/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation

typealias StringDictionary = [String : String]
typealias Labels = [String]
protocol StringDictionarizable {}

extension StringDictionarizable
{
    func toDictionaryAll() -> StringDictionary
    {
        var dict = StringDictionary()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children
        {
            if let key = child.label
            {
                dict[key] = "\(child.value)"
            }
        }
        return dict
    }
    
    func keysAll() -> Labels
    {
        var keys = Labels()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children
        {
            if let key = child.label
            {
                keys.append(key)
            }
        }
        return keys
    }
    
    func keysPrivate() -> Labels
    {
        let keys = self.keysAll()
        var keysPrivate = Labels()
        
        for key in keys
        {
            if key.contains("private")
            {
                keysPrivate.append(key)
            }
        }
        return keysPrivate
    }
    
    func keysNonPrivate() -> Labels
    {
        let keys = self.keysAll()
        let keysPrivate = self.keysPrivate()
        let keysNonPrivate = keys.filter { !keysPrivate.contains($0) }
        
        return keysNonPrivate
    }
    
    func toDictionaryNonPrivate() -> StringDictionary
    {
        var dictionaryNonPrivate = self.toDictionaryAll()
        let keysPrivate = self.keysPrivate()
        for (key, _) in dictionaryNonPrivate
        {
            if keysPrivate.contains(key)
            {
                dictionaryNonPrivate.removeValue(forKey: key)
            }
        }
        return dictionaryNonPrivate
    }
}
