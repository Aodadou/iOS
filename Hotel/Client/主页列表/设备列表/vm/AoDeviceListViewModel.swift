//
//  AoDeviceListViewModel.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/26.
//  Copyright © 2018年 fortune. All rights reserved.
//

import UIKit
import RxSwift

class AoDeviceListViewModel: AoBaseViewModel {

    let sm:SessionManager! = SessionManager.share()
    public var deviceListPS = PublishSubject<[CommonDevice]>()
    
    override init() {
        super.init()
        
    }
    
    func getGroupDeviceList(index:NSInteger){
        
        let groupInfos = MyGlobalData.getGroupInfoList()
        guard groupInfos!.count > 0 && index < groupInfos!.count else{
            self.deviceListPS.onNext([CommonDevice]())
            return
        }
        let deviceList = MyGlobalData.getDeviceList()
        let groupId = groupInfos![index].groupId
        
        guard deviceList!.count > 0 else{
            self.deviceListPS.onNext([CommonDevice]())
            return
        }
        var array = [CommonDevice]()
        for device in deviceList!{
            if device.place == groupId{
                array.append(device)
            }
            if device.place == "" && index == 0{
                array.append(device)
            }
        }
        
        self.deviceListPS.onNext(array)
    }
    
    func getPlaceModelWith(index:NSInteger) -> AoPlaceModel?{
        let groupInfos = MyGlobalData.getGroupInfoList()
        guard groupInfos!.count > 0 && index < groupInfos!.count else{
            self.deviceListPS.onNext([CommonDevice]())
            return nil
        }
        let groupInfo = groupInfos![index]
        let model = AoPlaceModel(placeName: groupInfo.groupName, placeImageId: groupInfo.groupId)
        return model
    }
    
    
    func refreshList(){
        let cmd04 = CMD04_GetAllDeviceList()
        self.sm.sendCmd(cmd04)
    }
}
