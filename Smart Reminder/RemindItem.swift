//
//  RemindItem.swift
//  Smart Reminder
//
//  Created by Penguin on 2020/1/17.
//  Copyright © 2020 haoyang. All rights reserved.
//

import Foundation



class RemindItem {
    let description:String
    var shouldBeFinishedBy:Int = 1000
    var mustBeFinishedBy:Int = 1000
    var mustBeCompleted:Bool = false
    var isPreTask:Bool = false
    var priorityPoint: Double = 0.0
    var startDate:Date = Date()
    
    var learningRate = 0.00000001
    
    init(descrip:String) {
        description = descrip
    }
    
    init(descrip:String, should:String, must:String, essential:String, Pre:String, prioritypoint: Double, startdate: Date){
        description = descrip
        shouldBeFinishedBy = Int(should) ?? 1000
        mustBeFinishedBy = Int(must) ?? 1000
        if essential == "T"{
            mustBeCompleted = true
        }
        else{
            mustBeCompleted = false
        }
        
        if Pre == "T"{
            isPreTask = true
        }
        else{
            isPreTask = false
        }
        self.priorityPoint = prioritypoint
        self.startDate = startdate
        
    }
    
    static var remindItems: [RemindItem] = []
    static var remindItemDescription:[String] = []
    static var shouldBeWeight = 1.0
    static var mustBeWeight = 1.0
    static var essentialWeight = 10.0
    static var preWeight = 20.0
    
    init(desc:String){
        self.description = desc
        RemindItem.remindItems.append(self)
    }
    
    func learn(){
        let time_interval = Double(self.startDate.timeIntervalSinceNow)
        let actualPoint = ( time_interval / ( 60 * 60 * 24 ) + 1000 ) * 2
        let diff = actualPoint - self.priorityPoint
        RemindItem.shouldBeWeight += learningRate * diff * Double(1000 - self.shouldBeFinishedBy)
        RemindItem.mustBeWeight += learningRate * diff * Double(1000 - self.mustBeFinishedBy)
        if self.mustBeCompleted == true{
            RemindItem.essentialWeight += learningRate * diff * 1
        }
        else{
            RemindItem.essentialWeight += learningRate * diff * 0
        }
        
        if self.isPreTask == true{
            RemindItem.preWeight += learningRate * diff * 1
        }
        else{
            RemindItem.preWeight += learningRate * diff * 0
        }
        
        print(RemindItem.shouldBeWeight)
        print(RemindItem.mustBeWeight)
        print(RemindItem.essentialWeight)
        print(RemindItem.preWeight)
        
    }
}
