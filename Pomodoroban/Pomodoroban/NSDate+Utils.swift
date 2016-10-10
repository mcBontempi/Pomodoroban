import UIKit

extension NSDate {
    func getDayOfWeek()->Int {
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.NSWeekdayCalendarUnit, fromDate: self)
        let weekDay = myComponents.weekday
        return ((weekDay + 5) % 7) + 1
    }
}
