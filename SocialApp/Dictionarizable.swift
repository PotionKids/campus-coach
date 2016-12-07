//
//  Dictionarizable.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/5/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase

typealias Label             = String
typealias Key               = String
typealias Fragment          = String
typealias Fragments         = [Fragment]
typealias Value             = Any
typealias Keys              = [Key]
typealias Labels            = [Label]
typealias Values            = [Value]
typealias StringDictionary  = [String : String]
typealias AnyDictionary     = [Key : Value]

extension Array where Element: Equatable
{
    func complementOf(elements: [Element]) -> [Element]
    {
        var array = [Element]()
        for element in self
        {
            if !elements.contains(element)
            {
                array.append(element)
            }
        }
        return array
    }
}

extension CustomStringConvertible
{
    func containsMultiple(_ fragments: [CustomStringConvertible]) -> Bool
    {
        var isTrue = false
        for fragment in fragments
        {
            if self.description.contains(fragment.description)
            {
                isTrue = true
            }
        }
        return isTrue
    }
}

extension Array where Element: CustomStringConvertible
{
    func containsMultiple(_ fragments: [Element]) -> [Element]
    {
        var result = [Element]()
        for element in self
        {
            if element.description.containsMultiple(fragments)
            {
                result.append(element)
            }
        }
        return result
    }
}

protocol Dictionarizable {}

extension Dictionarizable
{
    var dictionary: [Key : Value]
    {
        return self.toDictionary()
    }
    
    var stringDictionary: StringDictionary
    {
        return dictionary.forceConvertToStringLiteral()
    }
    
    var keysAll: Keys
    {
        return self.getAllKeys()
    }
    
    var keysNonPrivate: Keys
    {
        return self.getNonPrivateKeys()
    }
    
    var dictionaryOfNonPrivateKeys: [Key : Value]
    {
        return self.dictionary.filterWith(keys: self.keysNonPrivate)
    }
    
    var stringDictionaryOfNonPrivateKeys: StringDictionary
    {
        return dictionaryOfNonPrivateKeys.forceConvertToStringLiteral()
    }
    
    func toStringDictionaryForSpecific(keys: [Key]) -> StringDictionary
    {
        var stringDictionaryForKeys = StringDictionary()
        
        // Key validity check
        
        let allKeys                 = self.getKeysSuperSet()
        print("KRIS: allKeys are \(allKeys)")
        let commonKeysFound         = allKeys.filter() {keys.contains($0)}
        print("KRIS: commonKeysFound are \(commonKeysFound)")
        let dictionary              = self.stringDictionary
        
        for key in commonKeysFound
        {
            stringDictionaryForKeys.updateValue(dictionary[key]!, forKey: key)
        }
        
        return stringDictionaryForKeys
    }
    
    func pushValuesToFirebase(forKeys keys: [Key], at ref: FIRDatabaseReference)
    {
        let stringDictionary        = self.toStringDictionaryForSpecific(keys: keys)
        ref.updateChildValues(stringDictionary)
    }
    
    func toDictionary() -> [Key : Value]
    {
        var dictionary = [Key : Value]()
        let otherSelf = Mirror(reflecting: self)
        for child in otherSelf.children
        {
            if let key = child.label
            {
                dictionary.updateValue(child.value, forKey: key)
                dictionary.updateValue(child.value, forKey: key.replacingOccurrences(of: Constants.Dictionary.Key.privateSmalls, with: Constants.Literal.Empty).lowercaseFirst)
            }
        }
        return dictionary
    }
    
    func getAllKeys() -> Keys
    {
        return self.toDictionary().getAllKeys()
    }
    
    func getKeysSuperSet() -> Keys
    {
        return self.toDictionary().getKeysSuperSet()
    }
    
    func getAllValues() -> Values
    {
        return self.toDictionary().getAllValues()
    }
    
    func getValuesForKeys(keys: Keys) -> Values
    {
        return self.toDictionary().getValuesForKeys(keys: keys)
    }
    
    func getKeysContaining(fragments: Fragments) -> Keys
    {
        return self.toDictionary().getKeysContaining(fragments: fragments)
    }
    
    func getValuesForKeysContaining(fragments: Fragments) -> Values
    {
        return self.toDictionary().getValuesFoKeysContaining(fragments: fragments)
    }
    
    func getKeysContaining(fragment: Fragment) -> Keys
    {
        return self.toDictionary().getAllKeys().filter
            {
                key in return key.contains(fragment)
        }
    }
    
    func getValuesForKeysContaining(fragment: Fragment) -> Values
    {
        return self.toDictionary().getValuesForKeysContaining(fragment: fragment)
    }
    
    func getPrivateKeys() -> Keys
    {
        return self.toDictionary().getPrivateKeys()
    }
    
    func getFirebaseKeys() -> Keys
    {
        return self.toDictionary().getFirebaseKeys()
    }
    
    func getValuesForPrivateKeys() -> Values
    {
        return self.toDictionary().getValuesForPrivateKeys()
    }
    
    func getNonPrivateKeys() -> Keys
    {
        return self.getAllKeys().complementOf(elements: self.getPrivateKeys())
    }
    
    func getValuesForNonPrivateKeys() -> Values
    {
        return self.getValuesForKeys(keys: self.getNonPrivateKeys())
    }
}

extension Dictionary
{
    func forceConvertToStringLiteral() -> StringDictionary
    {
        var stringLiteralDictionary = StringDictionary()
        for (key, value) in self
        {
            stringLiteralDictionary.updateValue("\(value)", forKey: "\(key)")
        }
        return stringLiteralDictionary
    }
    
    func getAllKeys() -> Keys
    {
        var keys = Keys()
        for (key, _) in self
        {
            keys.append("\(key)")
        }
        return keys
    }
    
    func getKeysSuperSet() -> Keys
    {
        return addArray(first: self.getAllKeys(), with: self.getFirebaseKeys())
    }
    
    func getAllValues() -> Values
    {
        var values = Values()
        for (_, value) in self
        {
            values.append(value)
        }
        return values
    }
    
    func getValuesForKeys(keys: Keys) -> Values
    {
        var values = Values()
        for (key, value) in self
        {
            if keys.contains("\(key)")
            {
                values.append(value)
            }
        }
        return values
    }
    
    func getKeysContaining(fragments: Fragments) -> Keys
    {
        return self.getAllKeys().containsMultiple(fragments)
    }
    
    func getValuesFoKeysContaining(fragments: Fragments) -> Values
    {
        return self.getValuesForKeys(keys: self.getKeysContaining(fragments: fragments))
    }
    
    func filterWith(keys: Keys) -> [Key : Value]
    {
        var filteredDictionary = [Key : Value]()
        for (key, value) in self
        {
            if keys.contains("\(key)")
            {
                filteredDictionary.updateValue(value, forKey: key)
            }
        }
        return filteredDictionary
    }
    
    func getKeysContaining(fragment: Fragment) -> Keys
    {
        return self.getAllKeys().filter {$0.contains(fragment)}
    }
    
    func getValuesForKeysContaining(fragment: Fragment) -> Values
    {
        return self.getValuesForKeys(keys: self.getKeysContaining(fragment: fragment))
    }
    
    func getPrivateKeys() -> Keys
    {
        return self.getAllKeys().containsMultiple([
            Constants.Dictionary.Key.privateSmalls,
            Constants.Dictionary.Key.privateCapitalized
            ])
    }
    
    func getFirebaseKeys() -> Keys
    {
        return self.getPrivateKeys().chopFromSelf(fragment: Constants.Dictionary.Key.privateSmalls).lowercaseFirst
    }
    
    func getValuesForPrivateKeys() -> Values
    {
        return self.getValuesForKeys(keys: self.getPrivateKeys())
    }
    
    func getNonPrivateKeys() -> Keys
    {
        return self.getAllKeys().complementOf(elements: self.getPrivateKeys())
    }
    
    func getValuesForNonPrivateKeys() -> Values
    {
        return self.getValuesForKeys(keys: self.getNonPrivateKeys())
    }
}
