extension UIView {
    
    class func image(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.5)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        view.layer.render(in: ctx)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func image() -> UIImage? {
        return UIView.image(self)
    }
}
