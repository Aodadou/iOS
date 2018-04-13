
import UIKit

@objc
protocol NotificationDelegate:NSObjectProtocol {
    
    @objc func receiveCMD(notification:NSNotification)
    
    @objc func getAllDevice(notification:NSNotification)
    
    @objc func receiveFF(notification:NSNotification)
    
}

class NotificationVM: NSObject {
    weak var delegate:NotificationDelegate?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.delegate?.receiveCMD(notification:)), name: NSNotification.Name(rawValue: kReceiveCMD), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.delegate?.getAllDevice(notification:)), name: NSNotification.Name(rawValue: "getAllDevice"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.delegate?.receiveFF(notification:)), name: NSNotification.Name(rawValue: "Receive_FF"), object: nil)

        
    }
    
    
}
