//
//  MPListVCExtension.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/4/17.
//  Copyright © 2018年 fortune. All rights reserved.
//

import Foundation

extension MultiPathListVC{
    
    func back(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func setTime(_ view:ToolBarView2) {
        
        //        let timerListVC = TimerListVC()
        //        timerListVC.device = self.plugDevice
        //        self.navigationController!.pushViewController(timerListVC, animated: true)
    }
    
    func deviceInfo(_ view:ToolBarView2) {
        //        let deviceInfoVC = DeviceInfoVC()
        //        deviceInfoVC.deviceId = self.plugDevice!.id
        //        deviceInfoVC.deviceType = Int(self.plugDevice!.type)
        //        self.navigationController?.pushViewController(deviceInfoVC, animated: true)
    }
    
    internal func setSwitchEnable(){
        let cells = self.multiTableView!.visibleCells as! [MultiPathCell]
        for cell in cells{
            cell.powerSwitch.isEnabled = true
        }
    }
    
}
