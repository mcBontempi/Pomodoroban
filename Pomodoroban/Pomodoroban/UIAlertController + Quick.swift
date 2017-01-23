import TSMessages

extension UIAlertController {
    class func quickMessage(message:String, vc:UIViewController) {
     
      
        TSMessage.showNotificationInViewController(vc, title:"POMODOROBAN", subtitle: message, type: .Message)
  }
  
  
}
