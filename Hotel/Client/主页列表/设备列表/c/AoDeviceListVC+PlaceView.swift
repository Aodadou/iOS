//
//  AoDeviceListVC+PlaceView.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/27.
//  Copyright © 2018年 fortune. All rights reserved.
//

import Foundation

extension AoDeviceListVC:AoPlaceViewDelegate{
    func PlaceView(placeView: AoPlaceView, DidEditAt index: NSInteger) {
        let editPlaceVC = AoEditPlaceVC.instantiateViewControllerWitnStoryBoard(name: "Main") as! AoEditPlaceVC
        
        let groupInfoList = MyGlobalData.getGroupInfoList()
        editPlaceVC.groupId = groupInfoList![index].groupId
        editPlaceVC.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(editPlaceVC, animated: true)
    }
    
    func PlaceView(placeView: AoPlaceView, DidAddDeviceAt index: NSInteger) {
        
        let scanVC = QRScanVC()
        scanVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(scanVC, animated: true)
        
    }
    
    func PlaceViewDidAddplace(placeView: AoPlaceView) {
        
        let addPlaceVC = AoAddPlaceVC.instantiateViewControllerWitnStoryBoard(name: "Main")
        addPlaceVC.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(addPlaceVC, animated: true)
    }
    
    func refreshPlaceView(){
        //把所有子元素移除掉
        for view in self.svPlaceView.subviews{
            if view.isKind(of: AoPlaceView.classForCoder()){
                view.removeFromSuperview()
            }
        }
        //重新创建子元素
        self.initPlaceView()
        //获取当前页数据
        self.viewModel.getGroupDeviceList(index: self.getCurrentPage())
    }

}
