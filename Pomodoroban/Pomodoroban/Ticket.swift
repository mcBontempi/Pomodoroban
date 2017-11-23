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
    
    
    class func countForSection(_ moc:NSManagedObjectContext, section: String) -> Int {
        let tickets = Ticket.allForSection(moc, section: section)
        var count = 0
        for ticket in tickets {
            count = count + Int(ticket.pomodoroEstimate)
        }
        return count
    }
    
    class func sections(_ moc:NSManagedObjectContext) -> [String] {
        let tickets = self.all(moc)
        
        var sections = [String]()
        
        for ticket in tickets {
            
            if !sections.contains(ticket.section) {
                sections.append(ticket.section)
            }
        }
        
        return sections
    }
    
    
    class func ticketForIdentifier(identifier:String, moc:NSManagedObjectContext) -> Ticket? {
        let tickets = Ticket.all(moc)
        
        for ticket in tickets {
            
            if ticket.identifier == identifier {
                return ticket
            }
        }
        return nil
            
    }
    
    
    class func allForToday(_ moc:NSManagedObjectContext) -> [Ticket] {
        return try! moc.fetch(self.fetchRequestForSection("Backlog")) as! [Ticket]
    }
    
    class func all(_ moc:NSManagedObjectContext) -> [Ticket] {
        return try! moc.fetch(self.fetchRequestAll()) as! [Ticket]
    }
    
    class func allWithoutControl(_ moc:NSManagedObjectContext) -> [Ticket] {
        return try! moc.fetch(self.fetchRequestAllWithoutControl()) as! [Ticket]
        
    }
    
    
    class func fetchRequestForSection(_ section:String) -> NSFetchRequest<NSFetchRequestResult> {
        
        let weekday = section
        
        let predicate = NSPredicate(format: "section = %@ && row != 999999 && removed = false", weekday)
        
        return self.fetchRequestWithPredicate(predicate)
        
    }
    
    class func allForSection(_ moc:NSManagedObjectContext, section:String) -> [Ticket] {
        
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
    
    
    class func insertTicket(_ ticket: Ticket, row:Int, section:String, moc:NSManagedObjectContext) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Ticket.entityName)
        
        var predicate:NSPredicate?
        
        if ticket.section == section {
            predicate = NSPredicate(format: "section = %@ && row != %d && removed = false", section, ticket.row)
        }
        else {
            predicate = NSPredicate(format: "section = %@ && removed = false", section)
        }
        
        let primarySortDescriptor = NSSortDescriptor(key: Ticket.attributeRow, ascending: true)
        request.sortDescriptors = [primarySortDescriptor]
        
        
        request.predicate = predicate
        let tickets = try! moc.fetch(request) as! [Ticket]
        
        var newRowIndex = 0
        var found  = false
        for iteratingTicket in tickets {
            
            
            if row == newRowIndex {
                ticket.row = Int32(newRowIndex)
                
                newRowIndex = newRowIndex + 1
                
                ticket.section = section
                
                iteratingTicket.row = Int32(newRowIndex)
                
                newRowIndex = newRowIndex + 1
                
                found = true
            }
            else {
                iteratingTicket.row = Int32(newRowIndex)
                
                newRowIndex = newRowIndex + 1
            }
        }
        
        if !found {
            ticket.row = Int32(newRowIndex)
        }
        
        print(ticket)
        
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
    
    
    
    
    
    class func delete(_ moc:NSManagedObjectContext, identifier: String) {
        if let entity = self.fetch(moc, identifier: identifier) {
            
            moc.delete(entity)
        }
    }
    
    class func spareRowForSection(_ section: String, moc: NSManagedObjectContext) -> Int{
        let predicate = NSPredicate(format: "section = %@ && removed = false", section)
        let fetchRequest =  Ticket.fetchRequestWithPredicate(predicate)
        let currentSection = try! moc.fetch(fetchRequest)
        var row:Int = 0
        let rowCountForSection = currentSection.count
        if let objects = currentSection as? [Ticket]{
            if rowCountForSection > 0 {
                let ticket = objects[rowCountForSection-1]
                row = Int(ticket.row) + 1
            }
            else {
                row = 0
                
            }
        }
        return Int(row)
    }
}
