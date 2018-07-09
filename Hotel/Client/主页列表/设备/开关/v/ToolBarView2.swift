
import UIKit

protocol ToolBarView2Delegate:NSObjectProtocol{
    
    func setTime(_ view:ToolBarView2)
    func deviceInfo(_ view:ToolBarView2)
}

class ToolBarView2: UIView {
    weak var delegate:ToolBarView2Delegate?
    
    
    @IBAction func setTime(_ sender: AnyObject) {
        self.delegate?.setTime(self)
    }
    
    @IBAction func deviceInfo(_ sender: AnyObject) {
        self.delegate?.deviceInfo(self)
    }
}
