
import UIKit

class DevCellVM: NSObject,DeviceCellDelegate {
    
    weak var target:DeviceCell?
    
    //MARK:DeviceCellDelegate
    func detailClick(_ cell: DeviceCell, position: Int) {
        
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
