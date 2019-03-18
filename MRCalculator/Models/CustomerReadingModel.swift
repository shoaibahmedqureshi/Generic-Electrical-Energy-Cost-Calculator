//
//  CustomerReadingModel.swift
//  MRCalculator
//
//  Created by Shoaib Ahmed Qureshi on 2/23/19.
//  Copyright © 2019 Shoaib Ahmed Qureshi. All rights reserved.
//

import Foundation

class CustomerReadingModel {
    
    //MARK: Properties
    var serviceNumber: String = ""
    var reading : Int = 0
    
    
    
    func add() throws -> Customer? {
        do {
            return try CoreDataWrapper.saveData(obj: self, type: OperationType.SaveReadings) as? Customer
            
        }
        catch {
            print("Failed to Save Data")
            throw CoreDataExceptions.FailedToAdd
        }
    }
    
    class func getLastReadings(serviceNumber:String) throws -> CurrentReading? {
        do {
            if let customerList = try CoreDataWrapper.getData(expression:serviceNumber, type: OperationType.GetReadings) as? [Customer] {
                let customer = customerList.sorted(by:{$0.currentreading?.record_date!.compare(($1.currentreading?.record_date)!) == .orderedDescending }).first
                print("customer service number is \(String(describing: customer?.service_number))")
                print("customer reading is \(String(describing: customer?.currentreading?.reading))")
                return customer?.currentreading
            }
            else {
                return nil
            }
            
            // return list as? CurrentReading
        }
        catch {
            print("Failed to Get Data")
            throw CoreDataExceptions.FailedToGetAll
        }
    }
    
}

