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
    
    static let addRowControl:Int32 = 999999
    
    static let entityName = "Ticket"
    static let attributeName = "name"
    static let attributeDesc = "desc"
    static let attributePomodoroEstimate = "pomodoroEstimate"
    static let attributeSection = "section"
    static let attributeRow = "row"
    
    class func count(_ moc:NSManagedObjectContext) -> Int {
        let objects = try! moc.fetch(Ticket.fetchRequestAll())
        return objects.count
    }
    
    class func createInMoc(_ moc:NSManagedObjectContext) -> Ticket {
    
        
        let ticket = NSEntityDescription.insertNewObject(forEntityName: Ticket.entityName, into: moc) as! Ticket
        ticket.identifier = UUID().uuidString
        ticket.desc = ""
        
     
        return ticket
    }
    
    class func fetchRequestAllIncludingDeleted() -> NSFetchRequest<NSFetchRequestResult> {
        return self.fetchRequestWithPredicate(nil)
    }
    
    class func fetchRequestAll() -> NSFetchRequest<NSFetchRequestResult> {
        return self.fetchRequestWithPredicate(NSPredicate(format: "removed = false"))
    }
    
    class func fetchRequestAllWithoutControl() -> NSFetchRequest<NSFetchRequestResult> {
        return self.fetchRequestWithPredicate(NSPredicate(format: "row != 999999"))
    }
    
    class func fetchRequestWithPredicate(_ predicate: NSPredicate?) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Ticket.entityName)
        let primarySortDescriptor = NSSortDescriptor(key: Ticket.attributeSection, ascending: true)
        let secondarySortDescriptor = NSSortDescriptor(key: Ticket.attributeRow, ascending: true)
        request.sortDescriptors = [primarySortDescriptor,secondarySortDescriptor]
        
        request.predicate = predicate
        return request
    }
    
    class func fetch(_ managedObjectContext: NSManagedObjectContext, identifier: String) -> Ticket?{
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.predicate = NSPredicate(format: "identifier = %@", identifier)
        return try! managedObjectContext.fetch(request).first as? Ticket
    }
    
    class func createOrUpdate( _ managedObjectContext: NSManagedObjectContext, identifier: String) -> Ticket? {
        
        if let entity = self.fetch(managedObjectContext, identifier: identifier) {
            return entity
        }
        else {
            return self.createInMoc(managedObjectContext)
        }
    }
    
    
    class func countForSection(_ moc:NSManagedObjectContext, section: Int) -> Int {
      
        let tickets = Ticket.allForSection(moc, section: section)
        
        var count = 0
        
        for ticket in tickets {
            
            count = count + Int(ticket.pomodoroEstimate)
            
        }
        
        return count
        
    }
    

    class func allForToday(_ moc:NSManagedObjectContext) -> [Ticket] {
        
         let weekday = Date().getDayOfWeek()
        
        return try! moc.fetch(self.fetchRequestForSection(weekday)) as! [Ticket]
    }
    
    class func all(_ moc:NSManagedObjectContext) -> [Ticket] {
        return try! moc.fetch(self.fetchRequestAll()) as! [Ticket]
    }
    
    class func allWithoutControl(_ moc:NSManagedObjectContext) -> [Ticket] {
        return try! moc.fetch(self.fetchRequestAllWithoutControl()) as! [Ticket]
        
    }
    
    
    class func fetchRequestForSection(_ section:Int) -> NSFetchRequest<NSFetchRequestResult> {
        
        let weekday = section
        
        let predicate = NSPredicate(format: "section == %d && row != 999999 && pomodoroEstimate > 0 && removed = false", weekday)
        
        return self.fetchRequestWithPredicate(predicate)
        
    }
    
    class func allForSection(_ moc:NSManagedObjectContext, section:Int) -> [Ticket] {
        
        return try! moc.fetch(self.fetchRequestForSection(section)) as! [Ticket]
    }
    
    
    
    
    class func ticketForTicket(_ ticket:Ticket, moc:NSManagedObjectContext) -> Ticket {
        return moc.object(with: ticket.objectID) as! Ticket
    }
    
    class func removeAllEntities(_ moc: NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Ticket.entityName)
        let objects = try! moc.fetch(request) as! [NSManagedObject]
        for object in objects {
            moc.delete(object)
        }
    }
    
    
    class func insertTicket(_ ticket: Ticket, toIndexPath: IndexPath, moc:NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Ticket.entityName)
        
        var predicate:NSPredicate?
        
        if ticket.section == Int32(toIndexPath.section) {
            predicate = NSPredicate(format: "section == %d && row != %d && removed = false", toIndexPath.section, ticket.row)
        }
        else {
            predicate = NSPredicate(format: "section == %d && removed = false", toIndexPath.section)
        }
        
        let primarySortDescriptor = NSSortDescriptor(key: Ticket.attributeRow, ascending: true)
        request.sortDescriptors = [primarySortDescriptor]
        
        
        request.predicate = predicate
        let tickets = try! moc.fetch(request) as! [Ticket]
        
        var newRowIndex = 0
        
        for iteratingTicket in tickets {
            
            
            if toIndexPath.row == newRowIndex {
                ticket.row = Int32(newRowIndex)
                
                newRowIndex = newRowIndex + 1
                
                ticket.section = Int32(toIndexPath.section)
                
                if iteratingTicket.row != addRowControl {
                    iteratingTicket.row = Int32(newRowIndex)
                    
                    newRowIndex = newRowIndex + 1
                }
            }
            else {
                if iteratingTicket.row != addRowControl {
                    iteratingTicket.row = Int32(newRowIndex)
                    
                    newRowIndex = newRowIndex + 1
                }
            }
        }
        
        try! moc.save()
        
    }
    
    
    
    
    
    class func removeAllAddTickets(_ moc:NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Ticket.entityName)
        
        let objects = try! moc.fetch(request) as! [Ticket]
        
        for object in objects {
            
            if object.name == "" {
                moc.delete(object)
            }
        }
    }
    

    
    class func createAllAddTickets(_ moc:NSManagedObjectContext) {
        var ticket: Ticket!
        
        for section in 0...8 {
            
            ticket = Ticket.createInMoc(moc)
            ticket.name = ""
            ticket.section = Int32(section)
            ticket.row = addRowControl
            
        }
    }
    
    class func delete(_ moc:NSManagedObjectContext, identifier: String) {
        if let entity = self.fetch(moc, identifier: identifier) {
            
            moc.delete(entity)
        }
    }
    
    class func spareRowForSection(_ section: Int, moc: NSManagedObjectContext) -> Int{
        
        
        
        let predicate = NSPredicate(format: "section == %d && removed = false", section)
        
        let fetchRequest =  Ticket.fetchRequestWithPredicate(predicate)
        
        let currentSection = try! moc.fetch(fetchRequest)
        
        
        var row:Int = 0
        
        let rowCountForSection = currentSection.count
        
        if rowCountForSection == 1 {
            row = 0
        }
        else {
            
            if let objects = currentSection as? [Ticket]{
                
                let ticket = objects[rowCountForSection - 2]
                row = Int(ticket.row) + 1
            }
        }
        
        return Int(row)
    }
}
