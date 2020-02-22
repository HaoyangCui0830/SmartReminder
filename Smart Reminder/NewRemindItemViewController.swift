//
//  NewRemindItemViewController.swift
//  Smart Reminder
//
//  Created by Penguin on 2020/1/17.
//  Copyright © 2020 haoyang. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import CoreLocation

class NewRemindItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    
    // Mark - Outlet
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addShouldBeFinishedInDays: UITextView!
    @IBOutlet weak var addMustBeFinishedInDays: UITextView!
    @IBOutlet weak var addEssentailTaskorNot: UITextView!
    @IBOutlet weak var addIsPreTask: UITextView!
    
    
    
    
    @IBAction func tapDone(_ sender: UIBarButtonItem) {
        if textView.text.isEmpty{
            
        }
        else{
            let item = RemindItem(descrip: textView.text)
            RemindItem.remindItems.append(item)
            RemindItem.remindItemDescription.append(item.description)
            RemindItem.remindItemDescription.sort(by: <)
            //model.remindItem.append(item)
            //model.test.append("321")
        }
        let _ = navigationController?.popToRootViewController(animated: true)
        saveEntry()
    }
    @IBAction func tapDoneButton(_ sender: UIBarButtonItem) {
        
        if textView.text.isEmpty{
            
        }
        else{
            let item = RemindItem(descrip: textView.text)
            RemindItem.remindItems.append(item)
            RemindItem.remindItemDescription.append(item.description)
            RemindItem.remindItemDescription.sort(by: <)
            //model.remindItem.append(item)
            //model.test.append("321")
        }
        
        let _ = navigationController?.popToRootViewController(animated: true)
        saveEntry()
    }
    
    func saveEntry(){
        
        if textView.text.isEmpty{
        }

        else{
            var shouldBeFlag = 0
            var mustBeFlag = 0
            var essentialFlag = 0
            var preFlag = 0
            
            let app_Delegate = UIApplication.shared.delegate as! AppDelegate
            let context = app_Delegate.persistentContainer.viewContext
            let entries = NSEntityDescription.insertNewObject(forEntityName:"RemindItemEntity", into: context) as! RemindItemEntity
             entries.itemDescription = textView.text
            
            if addShouldBeFinishedInDays.text.isEmpty{
                entries.shouldBeFinished = "1000"
                print("ok")
            }
            else {
                entries.shouldBeFinished = addShouldBeFinishedInDays.text
                let description = addShouldBeFinishedInDays.text
                var i = (description as! NSString).integerValue
                if i != 0{
                    shouldBeFlag = 1000 - i
                }
            }

            if addMustBeFinishedInDays.text.isEmpty{
                entries.mustBeFinished = "1000"
            }
            else{
                entries.mustBeFinished = addMustBeFinishedInDays.text
                let description = addMustBeFinishedInDays.text
                var i = (description as! NSString).integerValue
                if i != 0{
                    mustBeFlag = 1000 - (description as! NSString).integerValue
                }
                
            }

            if addEssentailTaskorNot.text.isEmpty{
                entries.essentialTask = "false"
            }
            else{
                entries.essentialTask = addEssentailTaskorNot.text
                let description = addEssentailTaskorNot.text
                if description == "T" {
                    essentialFlag = 1
                }
            }

            if addIsPreTask.text.isEmpty{
                entries.preTask = "false"
            }
            else{
                entries.preTask = addIsPreTask.text
                let description = addIsPreTask.text
                if description == "T" {
                    preFlag = 1
                }
            }
            
//            let doubleNum = Double( Double(shouldBeFlag) * RemindItem.shouldBeWeight) +
//                Double( Double(mustBeFlag) * RemindItem.mustBeWeight) +
//                Double( RemindItem.essentialWeight * Double(essentialFlag) ) +
//                Double( RemindItem.preWeight * Double(preFlag) )
            let doubleNum = Double( 1.0 * Double(shouldBeFlag) ) +
                Double( 1.0 * Double(mustBeFlag) ) +
                Double( 10.0 * Double(essentialFlag) ) +
                Double( 20.0 * Double(preFlag) )
            let decimalNum = Decimal(doubleNum)
            entries.priorityPoint = NSDecimalNumber(decimal: decimalNum)
            
            entries.startDate = NSDate.now
            print(entries.startDate)
            print(entries.priorityPoint?.doubleValue)
            
            // save to core data
            app_Delegate.saveContext()
            
            //let entries = NSEntityDescription.insertNewObject(forEntityName: "ItemEntity", into: context) as! Entity
            //let itemEntity = NSEntityDescription.insertNewObjectForEntityForName("ItemEntity", inManagedObjectContext: managedObjectContext) as! ItemEntity
        }
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("core data path: \(path)")
    }
    
    /*
    // MARK: - Navigation
    
     
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
