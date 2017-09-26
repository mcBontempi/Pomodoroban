extension UINavigationController {
    
    
    func redWithLogo() {
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.tintColor = UIColor.white
        
        self.navigationBar.barTintColor = UIColor.red
        
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
    }
}
