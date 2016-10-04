import UIKit

extension NSDate {
    func getDayOfWeek()->Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: self)
        let weekDay = myComponents.weekday
        return weekDay
    }
}
