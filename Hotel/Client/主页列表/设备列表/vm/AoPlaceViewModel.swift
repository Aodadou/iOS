//
//  AoPlaceViewModel.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/7/4.
//  Copyright © 2018年 fortune. All rights reserved.
//

import UIKit
import RxSwift

class AoPlaceViewModel: AoBaseViewModel {

    let sm:SessionManager! = SessionManager.share()
    var index:NSInteger = 0
    var btnValid:Observable<Bool>!
    
    override init() {
        super.init()
    }
    
    init(placeName:Observable<String>) {
        
        btnValid = placeName
            .map { $0.count > 0 }
            .share(replay: 1)
        
        
    }
    
    func sendAddCmd(placeName:String){
        let cmd75 = CMD75_AddGroup(groupName: placeName)
        sm.sendCmd(cmd75)
    }
    
    func sendGetAllGroupCMD(){
        let cmd7b = CMD7B_GetAllGroupInfo()
        sm.sendCmd(cmd7b)
    }
    
    func sendDelCMD(groupId:String){
        let cmd77 = CMD77_DelGroup(groupId: groupId)
        sm.sendCmd(cmd77)
    }
    
    func sendModify(groupId:String,groupName:String){
        let cmd = CMD79_ModifyGroup(groupId: groupId, groupName: groupName)
        sm.sendCmd(cmd)
    }
    
    
    
}
