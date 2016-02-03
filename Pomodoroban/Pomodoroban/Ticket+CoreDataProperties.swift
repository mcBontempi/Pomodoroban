//
//  Ticket+CoreDataProperties.swift
//  Pomodoroban
//
//  Created by Daren taylor on 03/02/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ticket {

    @NSManaged var desc: String?
    @NSManaged var name: String?
    @NSManaged var pomodoroEstimate: Int32
    @NSManaged var section: Int32
    @NSManaged var row: Int32

}
