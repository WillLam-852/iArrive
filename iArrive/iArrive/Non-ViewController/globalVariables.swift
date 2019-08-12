//
//  globalVariables.swift
//  iArrive
//
//  Created by Lam Wun Yin on 26/6/2019.
//  Copyright © 2019 Lam Wun Yin. All rights reserved.
//
//
//  iPad Air (3rd generation):  2224 x 1668
//  iPad Pro (9.7-inch):        2048 x 1536     (iPad, iPad mini)
//  iPad Pro (11-inch):         2388 x 1668
//  iPad Pro (12.9-inch):       2732 x 2048

import UIKit


// MARK: Global Variables

// For Storing the Staff Member List Data
var staffNameList = [staffMember] ()

// For selecting language
var engChinStatus = 0   // 0 for English, 1 for Chinese

// Login Information (For Section B)
var companyName: String?

// Staff Member Information (For Section B1)
var currentCheckingInOutFirstName: String?
var currentCheckingInOutLastName: String?
var currentCheckingInOutJobTitle: String?
var currentCheckingInOutDate: String?
var currentCheckingInOutTime: String?
//var currentCheckingInOutPhoto: UIImage?
var currentCheckingInOutPhoto = UIImage(named: "lion")

// Staff Member Information (For Section C)
var currentRegisteringFirstName: String?
var currentRegisteringLastName: String?
var currentRegisteringJobTitle: String?

// For sending and retriving JSON data to/from database
var token: String?
var orgID: String?

// For animation
var isLoadedLoginPage = false

// For avoiding loading the EngChinSegmentedControl repeatedly
var isengChinSegmentedControl = false

// For layout
let screenHeight = UIScreen.main.bounds.height
let screenWidth = UIScreen.main.bounds.width
let screenCentreX = screenWidth/2
let screenCentreY = screenHeight/2

// For Loading Sample Data and Debugging (Deleted after deployment)
var isLoadSampleStaff = true
var isLoadSampleDetectedData = true



// MARK: Global Constants

// URL for Term of Service, Privacy Policy, and Forgot Password (to be changed)
let termOfServiceLink = "https://www.google.com/search?q=term+of+service"
let privacyPolicyLink = "https://www.google.com/search?q=privacy+policy"
let forgotPasswordLink = "https://www.google.com/search?q=forgot+password"

// Position for Toast View (determined by Screen Size)
let toast_x = UIScreen.main.bounds.width / 2
let toast_y = UIScreen.main.bounds.height * 3/4
let toast_postion = CGPoint(x: toast_x, y: toast_y)

// For sending and retriving data to/from database
let baseURL = "https://iarrive.apptech.com.hk/api"



