

import Foundation


extension UIViewController{
    
    class func instantiateViewControllerWitnStoryBoard(name:String) -> UIViewController{
        let story = UIStoryboard(name: name, bundle: nil)
        let controler = story.instantiateViewController(withIdentifier: String(describing: self.classForCoder()))
        return controler
    }
    
}
