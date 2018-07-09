//
//  SceneDeviceListVC+DeviceCell.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/7/9.
//  Copyright © 2018年 fortune. All rights reserved.
//

import Foundation


extension SceneDeviceListVC:AoDeviceCellDelegate{
    func AoDeviceCell(_ cell: AoDeviceCell, didClickAt index: NSInteger) {
        let sceneDeviceInfo = self.arr_SDeviceList[index]
        let device = sceneDeviceInfo.ctrlinfo
        self.device_currentSet = device
        
        print("要修改的设备信息：\(device)")
        
        if cell.deviceType == 0x01 || cell.deviceType == 0x03{//灯控 插座
            
            //灯控、插座
            if (device! as! SwitcherDevice).powerList.count <= 1{
                let viewW = screenWidth * (542.0 / 750)
                let viewH = viewW * (340.0 / 542)
                let viewX = (screenWidth - viewW) / 2.0
                let viewY:CGFloat = (screenHeight - viewH) / 2.0
                sceneLampPlugView = nil
                sceneLampPlugView = SceneLampPlugView(frame: CGRect(x: viewX,y: viewY,width: viewW,height: viewH))
                sceneLampPlugView?.delegate = self
                sceneLampPlugView?.setDictWithPower((device! as! SwitcherDevice).powerList[0].on)
                sceneLampPlugView?.setBtnSureSaveTitle()
                sceneLampPlugView?.setTitle("CW设备")
                MyGlobalMethod.showAlert(sceneLampPlugView!)
                
            }else{
                //多路
                let viewW = screenWidth * (542.0 / 750)
                let viewH = viewW * (616.0 / 542)
                let viewX = (screenWidth - viewW) / 2.0
                let viewY:CGFloat = (screenHeight - viewH) / 2.0
                sceneMPathPlugView = SceneMPathPlugView(frame: CGRect(x: viewX,y: viewY,width: viewW,height: viewH))
                sceneMPathPlugView?.delegate = self
                sceneMPathPlugView?.setDictByMPlug(device! as! SwitcherDevice)
                sceneMPathPlugView?.setBtnSureSaveTitle()
                MyGlobalMethod.showAlert(sceneMPathPlugView!)
                
            }
            return
        }
        //
        //        }else if cell.deviceType == 0x04{//冷白
        //
        //
        //            return
        //        }else if cell.deviceType == 0x05 || cell.deviceType == 0x0A || cell.deviceType == 254{//空调
        //
        //            //空调
        //            let viewW = screenWidth * (542.0 / 750)
        //            let viewH = viewW * (768.0 / 542)
        //            let viewX = (screenWidth - viewW) / 2.0
        //            let viewY:CGFloat = (screenHeight - viewH) / 2.0
        //            sceneAirConditionView = SceneAirConditionView(frame: CGRect(x: viewX,y: viewY,width: viewW,height: viewH))
        //            sceneAirConditionView?.delegate = self
        //            sceneAirConditionView?.setDictByDevice(device_currentSet!)
        //            sceneAirConditionView?.setBtnSureSaveTitle()
        //            MyGlobalMethod.showAlert(sceneAirConditionView!)
        //
        //            return
        //
        //        }else if cell.deviceType == 0x0B || cell.deviceType == 0x0C{//
        //
        //            //RGB + CW
        //            //RGB + CW
        //            let viewW1 = screenWidth * (542.0 / 750)
        //            let viewH1 = viewW1 * (990.0 / 542)
        //            let viewX1 = (screenWidth - viewW1) / 2.0
        //            let viewY1:CGFloat = (screenHeight - viewH1) / 2.0
        //
        //            sceneRgbCwView = SceneRgbCwView(frame: CGRect(x: viewX1,y: viewY1,width: viewW1,height: viewH1))
        //            sceneRgbCwView!.delegate = self
        //            sceneRgbCwView?.setDictWithLightRGBDevice(device_currentSet as! LightRGBDevice)
        //            MyGlobalMethod.showAlert(sceneRgbCwView!)
        //            sceneRgbCwView?.setBtnSureSaveTitle()
        //
        //            return
        //        }else if cell.deviceType == 0x0D{//冷暖白灯
        //
        //            //纯CW
        //            let viewW = screenWidth * (542.0 / 750)
        //            let viewH = viewW * (520.0 / 542)
        //            let viewX = (screenWidth - viewW) / 2.0
        //            let viewY:CGFloat = (screenHeight - viewH) / 2.0
        //            sceneCWView = SceneCwView(frame: CGRect(x: viewX,y: viewY,width: viewW,height: viewH))
        //            sceneCWView!.delegate = self
        //            sceneCWView!.setDictWithLightCWDevice(device as! LightCWDevice)
        //            sceneCWView?.setBtnSureSaveTitle()
        //            MyGlobalMethod.showAlert(sceneCWView!)
        //
        //            return
        //
        //        }else if cell.deviceType == 0x0E{//
        //
        //
        //            return
        //        }else if cell.deviceType == 0x0F{//纯RGB
        //
        //            //纯RGB
        //            let viewW = screenWidth * (542.0 / 750)
        //            let viewH = viewW * (830.0 / 542)
        //            let viewX = (screenWidth - viewW) / 2.0
        //            let viewY:CGFloat = (screenHeight - viewH) / 2.0
        //            sceneRGBView = SceneRgbView(frame: CGRect(x: viewX,y: viewY,width: viewW,height: viewH))
        //            sceneRGBView!.delegate = self
        //            sceneRGBView!.setDictWithLightRGBDevice(device as! LightRGBDevice)
        //            sceneRGBView?.setBtnSureSaveTitle()
        //            MyGlobalMethod.showAlert(sceneRGBView!)
        //
        //            return
        //        }else if cell.deviceType == 0x10{//窗帘
        //            let viewW = screenWidth * (542.0 / 750)
        //            let viewH = viewW * (380.0 / 542)
        //            let viewX = (screenWidth - viewW) / 2.0
        //            let viewY:CGFloat = (screenHeight - viewH) / 2.0
        //            sceneLampPlugView = nil
        //            sceneLampPlugView = SceneLampPlugView(frame: CGRect(x: viewX,y: viewY,width: viewW,height: viewH))
        //            sceneLampPlugView?.delegate = self
        //            sceneLampPlugView?.setDictWithPower((device_currentSet as! DeviceStatus).power[0].on)
        //            sceneLampPlugView?.setCloseBtnTitle()
        //            sceneLampPlugView?.setBtnSureSaveTitle()
        //            sceneLampPlugView?.setTitle("窗帘设备")
        //            MyGlobalMethod.showAlert(sceneLampPlugView!)
        //
        //
        //            return
        //        }
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, motifyAt index: NSInteger) {
        
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, deleteAt index: NSInteger) {
        let sceneDeviceInfo = self.arr_SDeviceList[index]
        let device = sceneDeviceInfo.ctrlinfo
        
        let cmd38 = CMD38_DelSceneDevice(sceneid: sceneDeviceInfo.scenedev.sceneid, devid: device!.id)
        sm?.sendCmd(cmd38)
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, addNormalAt index: NSInteger) {
        
    }
    
    func AoDeviceCell(_ cell: AoDeviceCell, didCloseAt index: NSInteger) {
        
    }

    
}

