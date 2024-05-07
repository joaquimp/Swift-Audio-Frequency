//
//  Note.swift
//  MainFrequency
//
//  Created by Joaquim Pessoa Filho on 07/05/24.
//

import Foundation

enum NoteIcon: String {
    case C
    case CSharp
    case D
    case DSharp
    case E
    case F
    case FSharp
    case G
    case GSharp
    case A
    case ASharp
    case B
    case Undefined
    
    init(rawValue: String) {
        switch rawValue {
        case "C": self = .C
        case "C#": self = .CSharp
        case "D": self = .D
        case "D#": self = .DSharp
        case "E": self = .E
        case "F": self = .F
        case "F#": self = .FSharp
        case "G": self = .G
        case "G#": self = .GSharp
        case "A": self = .A
        case "A#": self = .ASharp
        case "B": self = .B
        default: self = .Undefined
        }
    }
}
