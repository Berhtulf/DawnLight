//
//  LeftPad.swift
//  IncGame
//
//  Created by Martin Václavík on 07.01.2021.
//

import Foundation

func leftPad(string: String, padding: Int, char: Character) -> String {
    let len = string.lengthOfBytes(using: String.Encoding.utf8)
    
    if len >= padding {
        return string
    } else {
        return String(repeating: char, count: padding - len) + string
    }
}
