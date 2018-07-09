

import Foundation

extension AoDeviceListVC:AoDeviceCellDelegate{
    func AoDeviceCell(_ cell: AoDeviceCell, didClickAt index: NSInteger) {
        
        if cell.deviceType! == 0x01 || cell.deviceType! == 0x02{
            
            let multiVC = AoMultiPathListVC()
            multiVC.deviceId = cell.deviceId
            
            for device in MyGlobalData.getDeviceList(){
                if (device as! CommonDevice).id == cell.deviceId!{
                    let power = (device as! SwitcherDevice).powerList
                    if power == nil || power!.count == 0{
                        GlobalMethod.toast("请等待设备上传状态")
                        return
                    }
                }
            }
            self.navigationController!.pushViewController(multiVC, animated: true)
            
        }else if cell.deviceType! == 0x03{
            
            let lampControllerVC:AoLampControlVC = AoLampControlVC.instantiateViewControllerWitnStoryBoard(name: "Main") as! AoLampControlVC
            lampControllerVC.hidesBottomBarWhenPushed = true
            lampControllerVC.deviceId = cell.deviceId
            self.navigationController!.pushViewController(lampControllerVC, animated: true)
            
        }else if cell.deviceType! == 0x09{
            let deviceinfoVC = AoDeviceInfoVC()
            deviceinfoVC.deviceId = cell.deviceId
            deviceinfoVC.deviceType = 9
            self.navigationController!.pushViewController(deviceinfoVC, animated: true)
        }
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, motifyAt index: NSInteger) {
        
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, deleteAt index: NSInteger) {
        
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, addNormalAt index: NSInteger) {
        
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, didCloseAt index: NSInteger) {
        
    }
    
    
}
