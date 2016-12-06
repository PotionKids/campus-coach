//
//  DataStructure.swift
//  SocialApp
//
//  Created by Kris Rajendren on Dec/6/16.
//  Copyright © 2016 Campus Coach. All rights reserved.
//

import Foundation

struct DataStructure
{
    indirect enum OfType: CustomStringConvertible
    {
        case Bool
        case Int
        case Double
        case String
        case Array(element: OfType)
        case Dictionary(key: OfType, value: OfType)
        case Index(name: String, type: OfType)
        case Tuple(variables: [OfType])
        case Set(variables: [OfType])
        case Struct(variables: [OfType])
        case Object(variables: [OfType])
        case IndexedObject(names: [String], types: [OfType])
        case Optional(type: OfType)
        case IUOptional(type: OfType)
        
        var description: String
        {
            switch self
            {
            case .Bool:
                return "Bool"
            case .Int:
                return "Int"
            case .Double:
                return "Double"
            case .String:
                return "String"
            case .Array(let element):
                return "Array of \(element.description)"
            case .Dictionary(let key, let value):
                return "Dictionary with keys of type \(key.description) and values of type \(value.description)"
            case .Tuple:
                return "Tuple\(self.typeOfTypeDescription)"
            case .Set:
                return "Set\(self.typeOfTypeDescription)"
            case .Struct:
                return "Struct\(self.typeOfTypeDescription)"
            case .Object:
                return "Object\(self.typeOfTypeDescription)"
            case .Optional(let type):
                return "Optional(\(type.description))"
            case .IUOptional(let type):
                return "Implicitly Unwrapped Optional(\(type.description))"
            default:
                return "Type could not be inferred."
            }
        }
        var typeOfTypeDescription: String
        {
            switch self
            {
            case .Tuple(let variables), .Set(let variables), .Struct(let variables), .Object(let variables):
                var output = ""
                for i in 1...variables.count
                {
                    if i != variables.count
                    {
                        output = "\(output)\(variables[i - 1].description), "
                    }
                    else
                    {
                        output = "\(output)\(variables[i - 1].description)"
                    }
                }
                return "(\(output))"
            default:
                return ""
            }
        }
    }
    
    static let bool:        OfType = .Bool
    static let int:         OfType = .Int
    static let double:      OfType = .Double
    static let string:      OfType = .String
    
    //MARK: Optional Types
    static let oBool:       OfType = .Optional(type: .Bool)
    static let oInt:        OfType = .Optional(type: .Int)
    static let oDouble:     OfType = .Optional(type: .Double)
    static let oString:     OfType = .Optional(type: .String)
    
    //MARK: Implicitly Unwrapped Optional Types
    static let iuBool:      OfType = .IUOptional(type: .Bool)
    static let iuInt:       OfType = .IUOptional(type: .Int)
    static let iuDouble:    OfType = .IUOptional(type: .Double)
    static let iuString:    OfType = .IUOptional(type: .String)
}
