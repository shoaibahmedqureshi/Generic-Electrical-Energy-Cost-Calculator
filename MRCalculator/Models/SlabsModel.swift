//
//  SlabsModel.swift
//  MRCalculator
//
//  Created by Shoaib Ahmed Qureshi on 2/23/19.
//  Copyright © 2019 Shoaib Ahmed Qureshi. All rights reserved.
//

import Foundation

class SlabsModel {
    
    //MARK: Properties
    var ratePerUnit: Int = 0
    var startUnit : Int = 0
    var endUnit: Int = 0
    
    
    func add() throws -> Slabs? {
        do {
            return try CoreDataWrapper.saveData(obj: self, type: OperationType.SaveSlabs) as? Slabs
            
        }
        catch {
            throw CoreDataExceptions.FailedToAdd
        }
    }
    
    class func getAllSlabs() throws -> [Slabs]? {
        do {
            let list = try CoreDataWrapper.getData(expression:"", type: OperationType.GetSlabs)
            return list as? [Slabs]
        }
        catch {
            throw CoreDataExceptions.FailedToGetAll
        }
    }
    
}
