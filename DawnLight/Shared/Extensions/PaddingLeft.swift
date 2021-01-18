//
//  paddingLeft.swift
//  IncGame
//
//  Created by Martin Václavík on 07.01.2021.
//

import Foundation

extension String {
    func paddingLeft(toLength: Int, withPad: Character, encoding: String.Encoding = .utf8) -> String {
        let len = self.lengthOfBytes(using: encoding)
        if len >= toLength {
            return self
        } else {
            return String(repeating: withPad, count: toLength - len) + self
        }
    }
}
