//
//  Ticket.swift
//  Pomodoroban
//
//  Created by Daren taylor on 30/01/2016.
//  Copyright © 2016 LondonSwift. All rights reserved.
//

import Foundation
import CoreData


class Ticket: NSManagedObject {
  
  static let entityName = "Ticket"
  static let attributeName = "name"
  static let attributeDesc = "desc"
  static let attributePomodoroEstimate = "pomodoroEstimate"
  static let attributeSection = "section"
  static let attributeRow = "row"
  
  
  
  class func createInMoc(moc:NSManagedObjectContext) -> Ticket {
    return NSEntityDescription.insertNewObjectForEntityForName(Ticket.entityName, inManagedObjectContext: moc) as! Ticket
  }
  
  class func fetchRequestAll() -> NSFetchRequest {
    return self.fetchRequestWithPredicate(nil)
  }
  
  class func fetchRequestWithPredicate(predicate: NSPredicate?) -> NSFetchRequest {
    let request = NSFetchRequest(entityName: Ticket.entityName)
    let primarySortDescriptor = NSSortDescriptor(key: Ticket.attributeSection, ascending: true)
    let secondarySortDescriptor = NSSortDescriptor(key: Ticket.attributeRow, ascending: true)
    request.sortDescriptors = [primarySortDescriptor,secondarySortDescriptor]
    
    request.predicate = predicate
    return request
  }
  
  
  class func removeAllEntities(moc: NSManagedObjectContext) {
    
    let request = NSFetchRequest(entityName: Ticket.entityName)
    
    let objects = try! moc.executeFetchRequest(request) as! [NSManagedObject]
    
    for object in objects {
      moc.deleteObject(object)
    }
    
    try! moc.save()
    
    
  }
  
  
  class func insertTicket(ticket: Ticket, toIndexPath: NSIndexPath, moc:NSManagedObjectContext) {
    let request = NSFetchRequest(entityName: Ticket.entityName)
   
    var predicate:NSPredicate?
    
    if ticket.section == Int32(toIndexPath.section) {
      predicate = NSPredicate(format: "section == %d && row != %d", toIndexPath.section, ticket.row)
    }
    else {
      predicate = NSPredicate(format: "section == %d", toIndexPath.section)
    }
    
    let primarySortDescriptor = NSSortDescriptor(key: Ticket.attributeRow, ascending: true)
    request.sortDescriptors = [primarySortDescriptor]
    
    
    request.predicate = predicate
    let tickets = try! moc.executeFetchRequest(request) as! [Ticket]
    
    var newRowIndex = 0
    
    print(toIndexPath)
    
    print("---------------")
    
    for iteratingTicket in tickets {
      
      
      if toIndexPath.row == newRowIndex {
        ticket.row = Int32(newRowIndex++)
        ticket.section = Int32(toIndexPath.section)
    
        print(ticket)
        
        
        iteratingTicket.row = Int32(newRowIndex++)
        print(iteratingTicket)
      }
      else {
        iteratingTicket.row = Int32(newRowIndex++)
        print(iteratingTicket)
        
      }
    }
 
    try! moc.save()
    
  }
  
}
