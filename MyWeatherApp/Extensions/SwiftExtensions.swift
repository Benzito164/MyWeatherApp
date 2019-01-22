import UIKit

//MARK:- UI VIEW EXTENSION
extension UIView {

    func setPositionOnView (top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,paddingTop: CGFloat,leftPadding: CGFloat
        , bottomPadding: CGFloat, rightPadding:CGFloat, width: CGFloat, height: CGFloat) 
     {
            
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: rightPadding).isActive = true
            
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomPadding).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    
    }
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 5.0, delay: 5.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 5.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
    
    func makeCircle(view: UIView){
      view.layer.cornerRadius = self.frame.size.height / 2
      view.layer.masksToBounds = true
      view.clipsToBounds = true

    }
}


//MARK:- UI SEARCH BAR EXTENSION
extension UISearchBar {
    
    public var textField: UITextField? {
        let subViews = subviews.flatMap { $0.subviews }
        guard let textField = (subViews.filter { $0 is UITextField }).first as? UITextField else {
            return nil
        }
        return textField
    }
    
    private var searchIcon: UIImage? {
        let subViews = subviews.flatMap { $0.subviews }
        return  ((subViews.filter { $0 is UIImageView }).first as? UIImageView)?.image
    }
    
    public var activityIndicator: UIActivityIndicatorView? {
        return textField?.leftView?.subviews.compactMap{ $0 as? UIActivityIndicatorView }.first
    }
    
    var isLoading: Bool {
        get {
            return activityIndicator != nil
        } set {
            let _searchIcon = searchIcon
            if newValue {
                if activityIndicator == nil {
                    let newActivityIndicator = UIActivityIndicatorView(style: .white)
                    newActivityIndicator.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                    newActivityIndicator.startAnimating()
                    self.setImage(UIImage(), for: .search, state: .normal)
                    textField?.leftView?.addSubview(newActivityIndicator)
                    let leftViewSize = textField?.leftView?.frame.size ?? CGSize.zero
                    newActivityIndicator.center = CGPoint(x: leftViewSize.width/2, y: leftViewSize.height/2)
                }
            } else {
                self.setImage(_searchIcon, for: .search, state: .normal)
                activityIndicator?.removeFromSuperview()
            }
        }
    }
}
