
import UIKit

class DevListVM: NSObject,NotificationDelegate {
    weak var target:DeviceListVC?
    var notificationVM:NotificationVM?
    
    override init() {
        super.init()
        notificationVM = NotificationVM(target:self as AnyObject)
        self.notificationVM!.delegate = self
    }
    
    
    func actionToConfig(){
        
    }
    
    func actionRefresh(){
        
    }
    
    func receiveCMD(notification:NSNotification){
        print("aaaaaaaaa")
    }
    
    func getAllDevice(notification:NSNotification){
        self.target?.deviceListTBV.reloadData()
    }
    
    func receiveFF(notification:NSNotification){
        
    }
}
