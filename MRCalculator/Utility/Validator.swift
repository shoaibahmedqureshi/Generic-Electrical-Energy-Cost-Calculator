//
//  Validator.swift
//  MRCalculator
//
//  Created by Shoaib Ahmed Qureshi on 2/23/19.
//  Copyright © 2019 Shoaib Ahmed Qureshi. All rights reserved.
//

import Foundation

import Foundation
import UIKit


let SERVICE_NUMBER_EMPTY_MSG = "Service Number cannot be empty."
let UNITS_EMPTY_MSG = "Unit Reading cannot be empty."
let SERVICE_NUMBER_LENGTH_MSG = "Length of Service Number should be 10 characters."
let SERVICE_NUMBER_ALPHANUMERIC_MSG = "Service Number should be only be alphanumeric values."
let SERVICE_NUMBER_LENGTH = 10

struct Validator {
    
    /**
     Determine whether Optional NSString is nil or an empty string
     :param: string Optional NSString
     :returns: true if string is nil or if it is an empty string, false otherwise
     */
    static func isNilOrEmpty(string: String?) -> Bool {
        return string!.isEmpty || string?.uppercased() == "NULL" || string == "\"\""
    }
    
    static func shouldHaveLength(string: String?,length:Int) -> Bool {
        return string!.characters.count == length
    }
    
    static func isAlphaNumeric(string: String?) -> Bool {
        return string?.range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }

    static func messageAlert(message:String, viewController : UIViewController , navCheck : Bool)  {
        
        
        let alertController = UIAlertController(title: "", message: message , preferredStyle: UIAlertControllerStyle.alert)
        
        let defaultAction = UIAlertAction(title: "OK", style:.default , handler: { action in
            if navCheck{

            }
 
        })
        alertController.addAction(defaultAction)
        viewController.present(alertController, animated:  true, completion: nil)
        
        
    }
    
    
    
}

