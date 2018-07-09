

import UIKit

class MPCellVM: NSObject,MultiPathCellDelegate {
    
    weak var target:AoMultiPathListVC?
    
    func detailClick(_ cell: MultiPathCell) {
        
    }
    
    func changePower(_ cell: MultiPathCell) {
        if(self.target!.plugDevice!.online == false){
            GlobalMethod.toast("设备离线")
            return
        }else{
            let powerList = self.target!.plugDevice!.powerList
            let power = powerList![cell.position!]

            power.setValue(cell.powerSwitch.isOn, forKey: "on")
            //let cmd08 = CMD08_ControlDevice()
            //self.target!.sm!.sendCmd(cmd08)

        }
//        self.powerIndex = cell.position!
//        self.timer_switchOn = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(MultiPathListVC.setSwitchEnable), userInfo: nil, repeats: false)
    }
    
}
