import Foundation
import CoreData

extension Runtime {

    
    @NSManaged var part: Int32
    @NSManaged var order: Int32
    @NSManaged var type: Int32
    @NSManaged var length: Int32
    @NSManaged var ticket: Ticket!

}
