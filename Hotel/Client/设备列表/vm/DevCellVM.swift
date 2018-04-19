
import UIKit

class DevCellVM: NSObject,DeviceCellDelegate {
    
    weak var target:DeviceListVC?
    
    //MARK:DeviceCellDelegate
    func detailClick(_ cell: DeviceCell, position: Int) {
        
        if cell.deviceType! == 0x01 || cell.deviceType! == 0x02{
            
            let multiVC = MultiPathListVC()
            multiVC.deviceId = cell.deviceId
            
            for device in MyGlobalData.getDeviceList(){
                if (device as! Device).id == cell.deviceId!{
                    let power = (device as! SwitcherDevice).powerList
                    if power == nil || power!.count == 0{
                        GlobalMethod.toast("请等待设备上传状态")
                        return
                    }
                }
            }
            self.target!.navigationController!.pushViewController(multiVC, animated: true)
        
        }else if cell.deviceType! == 0x03{
            
            
            
        }else if cell.deviceType! == 0x09{
            let deviceinfoVC = DeviceInfoVC()
            deviceinfoVC.deviceId = cell.deviceId
            deviceinfoVC.deviceType = 9
            self.target?.navigationController!.pushViewController(deviceinfoVC, animated: true)
        }
        
    }
    
    func modifyName(_ cell: DeviceCell, position: Int) {
        
    }
    
    func deleteDevice(_ cell: DeviceCell, position: Int) {
        
    }
    
    func addToNormal(_ cell: DeviceCell, position: Int) {
        
    }
    
    func closeSlideView(_ cell: DeviceCell, position: Int) {
        
    }
    
}
