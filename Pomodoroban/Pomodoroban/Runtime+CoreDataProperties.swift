import Foundation
import CoreData

extension Ticket {

    @NSManaged var order: Int32
    @NSManaged var type: Int32
    @NSManaged var length: Int32
    @NSManaged var ticket: Ticket

}
