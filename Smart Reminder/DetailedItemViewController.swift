//
//  DetailedItemViewController.swift
//  Smart Reminder
//
//  Created by Penguin on 2020/1/17.
//  Copyright © 2020 haoyang. All rights reserved.
//

import UIKit

class DetailedItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //RemindItem.remindItems.sort(by: RemindItem.remindItems.description)
        //print(selectedIndexItem.row)
        //print(RemindItem.remindItemDescription)
        detailedItem.text = detailedItemDescription
        shouldBeFinishedInDays.text = String(shouldBeFinishedIn)
        mustBeFinishedInDays.text = String(mustBeFinishedIn)
        essentailTaskorNot.text = String(essentialTask)
        isPreTask.text = String(isPre)
        

        // Do any additional setup after loading the view.
    }
    //var selectedIndexItem = IndexPath()
    var detailedItemDescription:String = ""
    var shouldBeFinishedIn: Int = 1000
    var mustBeFinishedIn: Int = 1000
    var essentialTask: Bool = false
    var isPre: Bool = false

    
    @IBOutlet weak var detailedItem: UITextView!
    @IBOutlet weak var shouldBeFinishedInDays: UITextView!
    @IBOutlet weak var mustBeFinishedInDays: UITextView!
    @IBOutlet weak var essentailTaskorNot: UITextView!
    @IBOutlet weak var isPreTask: UITextView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
