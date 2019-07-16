//
//  usefulTools.swift
//  iArrive
//
//  Created by Will Lam on 16/7/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import Foundation


class usefulTools {
    
    // For returning a random 32-bit string
    public func ret32bitString() -> String? {
        var retString: String = ""
        for _ in 0 ..< 32 {
            retString.append(Character(UnicodeScalar(UInt32(("A" as UnicodeScalar).value) + arc4random_uniform(26))!))
        }
        return retString
    }
    
}
