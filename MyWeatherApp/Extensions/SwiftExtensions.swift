import UIKit

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
    
    func makeCircle(view: UIView){
      view.layer.cornerRadius = self.frame.size.height / 2
      view.layer.masksToBounds = true
        view.clipsToBounds = true
        view.backgroundColor = .cyan
    }
}
