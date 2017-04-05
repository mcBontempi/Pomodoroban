import TSMessages

extension UIAlertController {
    class func quickMessage(_ message:String, vc:UIViewController) {
     
      
        TSMessage.showNotification(in: vc, title:"POMODOROBAN", subtitle: message, type: .message)
  }
  
  
}
