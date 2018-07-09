//
//  AoDeviceListVC+Notification.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/27.
//  Copyright © 2018年 fortune. All rights reserved.
//

import Foundation
import RxSwift

extension AoDeviceListVC{
    
    func registerNotification(){
        //获取所有设备通知，这里用来刷新列表
        NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_GETALLDEVICE))
            .takeUntil(self.rx.deallocated).subscribe(onNext: { (notification) in
                
                DispatchQueue.global().async {
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.refreshPlaceView()
                    }
                }
                
            }).disposed(by: bag)
        
        
        NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_CMDCOMMON))
            .takeUntil(self.rx.deallocated).subscribe(onNext: { (notification) in
                
                DispatchQueue.global().async {
                    let cmd = notification.object as! ServerCommand
                    if cmd.getNo() == CMD09_ServerControlResult.commandConst(){
                        let cmd09 = cmd as! CMD09_ServerControlResult
                        let device = cmd09.device
                        guard device != nil else{
                            return
                        }
                        
                        var deviceList = MyGlobalData.getDeviceList()
                        for i in 0 ..< deviceList!.count{
                            let d = deviceList![i]
                            if d.id == device!.id{
                                deviceList!.replaceSubrange(Range(i ..< i+1), with: [device!])
                                break
                            }
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.actionChangePlace(page: self.getCurrentPage())//刷新当前房间下设备状态
                        SVProgressHUD.dismiss()
                    }
                }
                
            }).disposed(by: bag)
        
        
        NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_CMDFFCOMMON))
            .takeUntil(self.rx.deallocated).subscribe(onNext: { (notification) in
                
                DispatchQueue.global().async {
                    let info = notification.object as! NSDictionary
                    let infoMessage = info.value(forKey: "info") as! String;
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        SVProgressHUD.showError(withStatus: infoMessage)
                    }
                }
            }).disposed(by: bag)
        
        
        NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_REFRESH_GROUP))
            .takeUntil(self.rx.deallocated).subscribe(onNext: { (notification) in
                
                SVProgressHUD.dismiss()
                self.refreshPlaceView()
                
            }).disposed(by: bag)
    }
    
}
