import UIKit
import Alamofire

var cache = NSCache<AnyObject, UIImage>()

//MARK: Visual Constraints
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func center_X(item: UIView) {
        center_X(item: item, constant: 0)
    }
    
    func center_X(item: UIView, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: constant))
    }
    
    func center_Y(item: UIView, constant: CGFloat) {
        self.addConstraint(NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: constant))
    }
    
    func center_Y(item: UIView) {
        center_Y(item: item, constant: 0)
    }
}

//MARK: Image Extensions
extension UIImageView {
    func loadImage(_ url: String, completion: (() -> Void)? = nil) {
        if let image = cache.object(forKey: url as AnyObject) {
            self.image = image
            return
        }
        Alamofire.request(url).responseData { response in
            if let data = response.data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                    if let image = image {
                        cache.setObject(image, forKey: url as AnyObject)
                    }
                    completion?()
                }
            }
        }
    }
}




//MARK: Colors Used
extension UIColor {
    
    //MARK: function
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
    
    //MARK: Colors
    static let background = UIColor(r: 39, g: 38, b: 44)
    static let rating = UIColor(r: 68, g: 68, b: 67)
    static let lightWhite = UIColor(white: 0.50, alpha: 1.0)
    static let search = UIColor(r: 61, g: 60, b: 66)
}

extension Int {
    func toTime() -> String {
        var time = ""
        let hrs = self/60
        if hrs > 0 {
            time += String(hrs) + " h "
        }
        time += String(self%60) + " min"
        return time
    }
}
