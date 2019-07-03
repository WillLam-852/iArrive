//
//  staffMember.swift
//  iArrive
//
//  Created by Lam Wun Yin on 26/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//

import UIKit

class staffMember {
    
    // MARK: Properties
    
    var firstName: String
    var lastName: String
    var jobTitle: String
    var isCheckedIn: Bool
    
    
    // MARK: Initialization
    
    init(firstName: String, lastName: String, jobTitle: String, isCheckedIn: Bool) {
        self.firstName = firstName
        self.lastName = lastName
        self.jobTitle = jobTitle
        self.isCheckedIn = isCheckedIn
    }
}

