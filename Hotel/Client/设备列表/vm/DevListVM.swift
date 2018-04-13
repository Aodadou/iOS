
import UIKit

class DevListVM: NSObject,NotificationDelegate {
    weak var target:DeviceListVC?
    let notificationVM = NotificationVM()
    
    override init() {
        super.init()
        self.notificationVM.delegate = self
    }
    
    
    func actionToConfig(){
        
    }
    
    func receiveCMD(notification:NSNotification){
        
    }
    
    func getAllDevice(notification:NSNotification){
        self.target?.deviceListTBV.reloadData()
    }
    
    func receiveFF(notification:NSNotification){
        
    }
}
