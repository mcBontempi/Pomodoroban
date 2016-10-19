extension UIAlertController {
    class func quickMessage(message:String, vc:UIViewController) {
        let alert = UIAlertController(title: "POMODOROBAN", message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        vc.presentViewController(alert, animated: true, completion: nil)
    }
}
