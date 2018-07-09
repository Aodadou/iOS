
//
//  AoLampViewModel.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/27.
//  Copyright © 2018年 fortune. All rights reserved.
//

import UIKit
import RxSwift

class AoDeviceViewModel: AoBaseViewModel {
    var mac:String!
    let sm = SessionManager.share()

    var dataVariable: BehaviorSubject<CommonDevice>?
    
    //let devicePublishSubject = PublishSubject<CommonDevice>()
    
    
    var rx_device:Observable<CommonDevice>{
        //return devicePublishSubject.asObservable()
        return dataVariable!.asObservable()
    }
    var device:CommonDevice?{
        willSet{
            dataVariable?.onNext(newValue!)
            //devicePublishSubject.onNext(newValue!)
        }
    }
    
    init(mac:String) {
        super.init()
        self.mac = mac
        self.getDeviceWithMacId()
        self.dataVariable = BehaviorSubject(value: self.device!)
    }
    
    func getDeviceWithMacId(){
        let deviceList = MyGlobalData.getDeviceList()
        for index in 0 ..< deviceList!.count {
            let d = deviceList![index]
            if d.id == self.mac{
                self.device = d
                break
            }
        }
    }
    
    func refreshData(){
        self.getDeviceWithMacId()
    }
    
    //发送控制
    func controlDevice(device:CommonDevice){
        let cmd08 = CMD08_ControlDevice(device: device)
        sm!.sendCmd(cmd08)
    }
    //遥控匹配
    func sendCmd40(){
        let cmd40 = CMD40_SetMatchStatus()
        cmd40.pairInfo = 0x80;
        cmd40.sn = self.device!.id
        self.sm!.sendCmd(cmd40)
    }
}
