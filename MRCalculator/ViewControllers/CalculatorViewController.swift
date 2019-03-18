//
//  ViewController.swift
//  MRCalculator
//
//  Created by Shoaib Ahmed Qureshi on 2/23/19.
//  Copyright © 2019 Shoaib Ahmed Qureshi. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController , UITextFieldDelegate {
    
    @IBOutlet weak var txtfieldServiceNumber: UITextField!
    @IBOutlet weak var txtfieldUnitReading: UITextField!
    @IBOutlet weak var lblCostValue: UILabel!
    @IBOutlet weak var lblLastReadingValue: UILabel!
    @IBOutlet weak var lblLastReading: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtfieldServiceNumber.delegate = self
        txtfieldUnitReading.delegate = self

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtfieldServiceNumber {
            txtfieldUnitReading.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    
    @IBAction func didClickRecordButton() {
        if Validator.isNilOrEmpty(string: txtfieldServiceNumber.text) {
            Validator.messageAlert(message:SERVICE_NUMBER_EMPTY_MSG, viewController: self, navCheck: false)
            return
        }
        else if Validator.isNilOrEmpty(string:txtfieldUnitReading.text ) {
            Validator.messageAlert(message:UNITS_EMPTY_MSG, viewController: self, navCheck: false)
            return
        }
        else if !Validator.shouldHaveLength(string:txtfieldServiceNumber.text, length:SERVICE_NUMBER_LENGTH) {
            Validator.messageAlert(message:SERVICE_NUMBER_LENGTH_MSG, viewController: self, navCheck: false)
            return
        }
        else if !Validator.isAlphaNumeric(string:txtfieldServiceNumber.text) {
            Validator.messageAlert(message:SERVICE_NUMBER_ALPHANUMERIC_MSG, viewController: self, navCheck: false)
            return
        }
        
       checkCustomerRecord()
        
    }
    
    func checkCustomerRecord() {
        let customerReadingModel = CustomerReadingModel.init()
        customerReadingModel.serviceNumber = txtfieldServiceNumber.text!
        var lastReadingCost = 0
        if let readingData = try? CustomerReadingModel.getLastReadings(serviceNumber:txtfieldServiceNumber.text!) {
            if let reading = readingData?.reading {
                lblLastReadingValue.text = String(describing: reading)
                lastReadingCost = calculateMeterConsumptionCostByReadings(units:Int(reading))
            }
            else {
                lblLastReadingValue.text = "-"
                print("Previous record of customer does not exist.")
            }
        }
        
        let cost = calculateMeterConsumptionCostByReadings(units: Int(txtfieldUnitReading.text!)!)
        customerReadingModel.reading = Int(txtfieldUnitReading.text!)!
        _ = try? customerReadingModel.add()
        lblCostValue.text = "\(cost - lastReadingCost)"
        
    }
    
    func calculateMeterConsumptionCostByReadings(units:Int) -> Int {
        /// Calculations according to Slabs which can be configured/changed in database.
        var slabs = try! SlabsModel.getAllSlabs()
        var billAmount = 0
        slabs = slabs?.filter({$0.start_unit < units }) //filtering only the slabs applicable
        slabs = slabs?.sorted(by: { $0.start_unit < $1.start_unit })
        
        for slab in slabs! {
            print("unit rate is \(slab.rate_per_unit)")
            let unitsForThisSlab = (slab.end_unit > units  || slab.end_unit == 0 ) ? (Int64(units) - (slab.start_unit-1)) : (slab.end_unit - (slab.start_unit-1)) //finding units to calculate cost as per slab.
            billAmount += Int(unitsForThisSlab)*Int(slab.rate_per_unit)
            print("bill amount with unit :\(unitsForThisSlab) is \(Int(unitsForThisSlab)*Int(slab.rate_per_unit))")
        }
        print("Total amount is \(billAmount)")
        return billAmount
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

