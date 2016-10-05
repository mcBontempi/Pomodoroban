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
  
  class func count(moc:NSManagedObjectContext) -> Int {
    let objects = try! moc.executeFetchRequest(Ticket.fetchRequestAll())
    return objects.count
  }
  
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
    
    class func fetchRequestForToday() -> NSFetchRequest {
     
        let weekday = NSDate().getDayOfWeek()
        
        let predicate = NSPredicate(format: "section == %d", weekday)
        
        return self.fetchRequestWithPredicate(predicate)
        
    }
  
    class func allForToday(moc:NSManagedObjectContext) -> [Ticket] {
        
        let objects = try! moc.executeFetchRequest(self.fetchRequestForToday())
        
        
        return try! moc.executeFetchRequest(self.fetchRequestForToday()) as! [Ticket]
    }
    
  
    class func ticketForTicket(ticket:Ticket, moc:NSManagedObjectContext) -> Ticket {
        return moc.objectWithID(ticket.objectID) as! Ticket
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
    
    for iteratingTicket in tickets {
      
      
      if toIndexPath.row == newRowIndex {
        ticket.row = Int32(newRowIndex++)
        ticket.section = Int32(toIndexPath.section)
        
        iteratingTicket.row = Int32(newRowIndex++)
      }
      else {
        iteratingTicket.row = Int32(newRowIndex++)
        
      }
    }
 
    try! moc.save()
    
  }
  
    
    
    
    
    class func removeAllAddTickets(moc:NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: Ticket.entityName)
        
        let objects = try! moc.executeFetchRequest(request) as! [Ticket]
        
        for object in objects {
          
            if object.name == "" {
            moc.deleteObject(object)
        }
        }
    }
    
    
    class func printAll(moc:NSManagedObjectContext) {
        let request = NSFetchRequest(entityName: Ticket.entityName)
        
        let objects = try! moc.executeFetchRequest(request) as! [Ticket]
        
        for object in objects {
     
            print(object)
        }
        
    }
    
    class func createAllAddTickets(moc:NSManagedObjectContext) {
        var ticket: Ticket!
        
        for section in 0...8 {
      
            
            
            ticket = Ticket.createInMoc(moc)
            ticket.name = ""
            ticket.section = Int32(section)
            ticket.row = 999999
            
        }
    }

    
}
