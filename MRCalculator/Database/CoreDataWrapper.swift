//
//  CoreDataWrapper.swift
//  MRCalculator
//
//  Created by Shoaib Ahmed Qureshi on 2/23/19.
//  Copyright © 2019 Shoaib Ahmed Qureshi. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataExceptions: Error {
    case ContextNotAvailable
    case FailedToAdd
    case FailedToRead
    case FailedToUpdate
    case FailedToDelete
    case FailedToSearch
    case FailedToGetAll
}

enum OperationType : Int {
    case SaveSlabs
    case GetSlabs
    case GetReadings
    case SaveReadings
}

public class CoreDataWrapper {
    
    //MARK: Properties
    //MARK: Constructor (if Any)
    private init() {
        
    }
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MRCalculator")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                // DDLogDebug("Unresolved error \(error)")
            }
        })
        return container
    }()
    static var context: NSManagedObjectContext? {
        return persistentContainer.viewContext
    }
    
    
    class func getData(expression exp: String, type: OperationType) throws -> [Any]? {
        if (type == OperationType.GetSlabs) {
            do {
                let fetchRequest: NSFetchRequest<Slabs> = Slabs.fetchRequest()
                let list = try context?.fetch(fetchRequest)
                if list != nil && list?.count != nil && (list?.count)! > 0 {
                    return list!
                }
            }
            catch {
                print("Failed to read data: \(error)")
                throw CoreDataExceptions.FailedToRead
            }
        }
            
        else if (type == OperationType.GetReadings) {
            do {
                let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
                if !Validator.isNilOrEmpty(string: exp) {
                    fetchRequest.predicate = NSPredicate(format:"service_number == %@",exp)
                }
                let list = try context?.fetch(fetchRequest)
                if list != nil && list?.count != nil && (list?.count)! > 0 {
                    return list!
                }
            }
            catch {
                print("Failed to read data: \(error)")
                throw CoreDataExceptions.FailedToRead
            }
        }
        
        return nil
    }
    
    class func saveData(obj: Any, type: OperationType) throws -> AnyObject? {
        
        var objReturn: AnyObject? = nil
        do {
            if (type == OperationType.SaveSlabs) {
                if let objT = obj as? SlabsModel {
                    let objToSave = Slabs(context: context!)
                    objToSave.start_unit = Int64(objT.startUnit)
                    objToSave.end_unit = Int64(objT.endUnit)
                    objToSave.rate_per_unit = Int64(objT.ratePerUnit)
                    objReturn = objToSave
                    try context?.save()
                }
            }
            else if (type == OperationType.SaveReadings) {
                if let objT = obj as? CustomerReadingModel {
                    let objToSave = Customer(context: context!)
                    objToSave.service_number = objT.serviceNumber
                    
                    let cReading = CurrentReading(context:context!)
                    cReading.reading = Int64(objT.reading)
                    cReading.record_date = Date()
                    objToSave.currentreading = cReading
                    objReturn = objToSave
                    try context?.save()
                }
            }
        }
        catch {
            print("Failed to save data: \(error)")
            throw CoreDataExceptions.FailedToAdd
        }
        
        return objReturn
        
    }

}
