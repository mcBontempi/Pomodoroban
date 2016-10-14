extension UIView {
    
    class func image(view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.5)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        view.layer.renderInContext(ctx)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func image() -> UIImage? {
        return UIView.image(self)
    }
}
