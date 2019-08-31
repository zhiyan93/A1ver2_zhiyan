//
//  SightEntity+CoreDataProperties.swift
//  A1ver2_zhiyan
//
//  Created by steven liu on 31/8/19.
//  Copyright © 2019 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension SightEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SightEntity> {
        return NSFetchRequest<SightEntity>(entityName: "SightEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var image: NSData?
    @NSManaged public var icon: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?

}
