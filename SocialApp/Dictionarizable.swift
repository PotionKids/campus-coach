//
//  Dictionarizable.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/5/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

typealias Label             = String
typealias Key               = String
typealias Fragment          = String
typealias Fragments         = [Fragment]
typealias Value             = Any
typealias Keys              = [Key]
typealias Labels            = [Label]
typealias Values            = [Value]
typealias StringDictionary  = [String : String]
typealias TimeObject        = StringDictionary
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
            if description.contains(fragment.description)
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

protocol Dictionarizable: Persisting
{
    
}

extension Dictionarizable
{
    func save() -> Bool
    {
        UserDefaults.standard.setValuesForKeys(anyDictionaryOfSaveKeys)
        return UserDefaults.standard.synchronize()
    }
    
    func retrieveAnyDictionary() -> AnyDictionary
    {
        return UserDefaults.standard.dictionaryWithValues(forKeys: keys.save)
    }
    
    var anyDictionary: [Key : Value]
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
    
    var stringDictionary: StringDictionary
    {
        return anyDictionary.forcedStringLiteral
    }
    
    var allKeys: Keys
    {
        return anyDictionary.allKeys
    }
    
    var privateKeys: Keys
    {
        return anyDictionary.privateKeys
    }
    
    var nonPrivateKeys: Keys
    {
        return allKeys.complementOf(elements: privateKeys)
    }
    
    var firebaseKeys: Keys
    {
        return anyDictionary.firebaseKeys
    }
    
    var setKeys: Keys
    {
        return privateKeys
    }
    
    var keys: KeysType
    {
        return KeysType(set: setKeys)
    }
    
    var valuesForPrivateKeys: Values
    {
        return anyDictionary.valuesForPrivateKeys
    }
    
    var valuesForNonPrivateKeys: Values
    {
        return anyDictionary.valuesForNonPrivateKeys
    }
    
    var anyDictionaryOfNonPrivateKeys: [Key : Value]
    {
        return anyDictionary.filterWith(keys: nonPrivateKeys)
    }
    
    var stringDictionaryOfNonPrivateKeys: StringDictionary
    {
        return anyDictionaryOfNonPrivateKeys.forcedStringLiteral
    }
    
    var anyDictionaryOfFirebaseKeys: AnyDictionary
    {
        return self.toAnyDictionaryForSpecific(keys: keys.firebase)
    }
    
    var anyDictionaryOfSaveKeys: AnyDictionary
    {
        return self.toAnyDictionaryForSpecific(keys: keys.save)
    }

    var stringDictionaryOfFirebaseKeys: StringDictionary
    {
        return self.toStringDictionaryForSpecific(keys: keys.firebase)
    }
    
    var superSetKeys: Keys
    {
        return anyDictionary.superSetKeys
    }
    
    var allValues: Values
    {
        return anyDictionary.allValues
    }
    
    func toAnyDictionaryForSpecific(keys: [Key]) -> AnyDictionary
    {
        var anyDictionaryForKeys    = AnyDictionary()
        
        // Key validity check
        
        let commonKeysFound         = superSetKeys.filter() {keys.contains($0)}
        let dictionary              = anyDictionary
        
        for key in commonKeysFound
        {
            anyDictionaryForKeys.updateValue(dictionary[key]!, forKey: key)
        }
        
        return anyDictionaryForKeys
    }
    
    func toStringDictionaryForSpecific(keys: [Key]) -> StringDictionary
    {
        var stringDictionaryForKeys = StringDictionary()
        
        // Key validity check
        
        let commonKeysFound         = superSetKeys.filter() {keys.contains($0)}
        let dictionary              = stringDictionary
        
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
    
    func getValuesForKeys(keys: Keys) -> Values
    {
        return anyDictionary.getValuesForKeys(keys: keys)
    }
    
    func getKeysContaining(fragments: Fragments) -> Keys
    {
        return anyDictionary.getKeysContaining(fragments: fragments)
    }
    
    func getValuesForKeysContaining(fragments: Fragments) -> Values
    {
        return anyDictionary.getValuesFoKeysContaining(fragments: fragments)
    }
    
    func getKeysContaining(fragment: Fragment) -> Keys
    {
        return anyDictionary.allKeys.filter
            {
                key in return key.contains(fragment)
            }
    }
    
    func getValuesForKeysContaining(fragment: Fragment) -> Values
    {
        return anyDictionary.getValuesForKeysContaining(fragment: fragment)
    }
}

extension Dictionary
{
    var keysShreddedFromSaveToFirebase: AnyDictionary
    {
        var dictionary = AnyDictionary()
        for (key, value) in self
        {
            let components = "\(key)".components(separatedBy: Constants.Literal.Underscore)
            if let shredded = components.last
            {
                dictionary.updateValue(value, forKey: shredded)
            }
            else
            {
                print("KRIS: Save Keys not Found. Save Keys are of the form \"firebaseID_path_email\" \n KRIS: Please check the dictionary and try again.")
            }
        }
        return dictionary
    }
    var forcedStringLiteral: StringDictionary
    {
        var stringLiteralDictionary = StringDictionary()
        for (key, value) in self
        {
            stringLiteralDictionary.updateValue("\(value)", forKey: "\(key)")
        }
        return stringLiteralDictionary
    }
    
    var allKeys: Keys
    {
        var keys = Keys()
        for (key, _) in self
        {
            keys.append("\(key)")
        }
        return keys
    }
    
    var superSetKeys: Keys
    {
        return addArray(first: allKeys, with: firebaseKeys)
    }
    
    var allValues: Values
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
        return allKeys.containsMultiple(fragments)
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
        return allKeys.filter {$0.contains(fragment)}
    }
    
    func getValuesForKeysContaining(fragment: Fragment) -> Values
    {
        return self.getValuesForKeys(keys: self.getKeysContaining(fragment: fragment))
    }
    
    var privateKeys: Keys
    {
        return allKeys.containsMultiple    (
            [
                Constants.Dictionary.Key.privateSmalls,
                Constants.Dictionary.Key.privateCapitalized
            ]
                                                )
    }
    
    var firebaseKeys: Keys
    {
        return privateKeys.chopFromSelf(fragment: Constants.Dictionary.Key.privateSmalls).lowercaseFirst
    }
    
    var saveKeys: Keys
    {
        return firebaseKeys
    }
    
    var valuesForPrivateKeys: Values
    {
        return self.getValuesForKeys(keys: privateKeys)
    }
    
    var nonPrivateKeys: Keys
    {
        return allKeys.complementOf(elements: privateKeys)
    }
    
    var valuesForNonPrivateKeys: Values
    {
        return self.getValuesForKeys(keys: nonPrivateKeys)
    }
}
