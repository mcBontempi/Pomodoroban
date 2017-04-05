import UIKit

extension Date {
    func getDayOfWeek()->Int {
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = (myCalendar as NSCalendar).components(.NSWeekdayCalendarUnit, from: self)
        let weekDay = myComponents.weekday
        return ((weekDay! + 5) % 7) + 1
    }
}
