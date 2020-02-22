//
//  RemindItemEntity+CoreDataProperties.swift
//  Smart Reminder
//
//  Created by Penguin on 2020/1/17.
//  Copyright © 2020 haoyang. All rights reserved.
//
//

import Foundation
import CoreData


extension RemindItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RemindItemEntity> {
        return NSFetchRequest<RemindItemEntity>(entityName: "RemindItemEntity")
    }

    @NSManaged public var itemDescription: String?
    @NSManaged public var mustBeFinished: String?
    @NSManaged public var shouldBeFinished: String?
    @NSManaged public var essentialTask: String?
    @NSManaged public var preTask: String?
    @NSManaged public var priorityPoint: NSDecimalNumber?
    @NSManaged public var startDate: Date?
}
