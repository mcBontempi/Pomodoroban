import TSMessages

extension UIAlertController {
    class func quickMessage(message:String, vc:UIViewController) {
     
      
      TSMessage.showNotificationWithTitle("POMODOROBAN", subtitle: message, type: .Message)
  }
  
  
}
