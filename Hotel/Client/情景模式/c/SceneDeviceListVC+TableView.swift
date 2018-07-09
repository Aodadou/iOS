//
//  SceneDeviceListVC+TableView.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/7/9.
//  Copyright © 2018年 fortune. All rights reserved.
//

import Foundation

extension SceneDeviceListVC:UITableViewDelegate,UITableViewDataSource{
    
    //MARK:UITableView代理和数据源
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0,y: 0,width: screenWidth,height: 70)
        view.backgroundColor = backColor
        let btnWidth:CGFloat = 40
        let btn_addScene:UIButton = UIButton(frame: CGRect(x: (screenWidth - btnWidth) / 2 , y: 15 , width: btnWidth, height: btnWidth))
        
        btn_addScene.setBackgroundImage(UIImage(named: "添加定时按钮"), for: UIControlState())
        btn_addScene.setBackgroundImage(UIImage(named: "添加定时按钮按下"), for: UIControlState.highlighted)
        btn_addScene.addTarget(self, action: #selector(SceneDeviceListVC.addSceneDevice(_:)), for: UIControlEvents.touchUpInside)
        view.addSubview(btn_addScene)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * (150 / 1134)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "dev") as? AoDeviceCell
        
        if cell == nil{
            cell = ((Bundle.main.loadNibNamed("AoDeviceCell", owner: self, options: nil))![0] as? AoDeviceCell)!
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        //在此判断设备类型
        
                if self.arr_SDeviceList .count > 0{
                    let sceneDeviceInfo = self.arr_SDeviceList[(indexPath as NSIndexPath).row]
                    let device = sceneDeviceInfo.ctrlinfo
                    for d in MyGlobalData.getDeviceList(){
                        if d.id == device!.id{
                            device!.name = d.name!
                            device!.place = d.place
                            device!.online = d.online
                            device!.place = d.place
                            break
                        }
                    }
        
                    cell!.addGesture()
                    cell!.deviceName = ("\(device!.name!)一一\(device!.place!)")
                    cell!.deviceType = Int(device!.type)
                    cell!.deviceId = device!.id!
                    cell!.btnModifyName.isHidden = true
                    cell!.btnAddToCommond.isHidden = true
                    cell!.position = (indexPath as NSIndexPath).row
                    cell!.headerImage.image = DeviceUtil.getDeviceIconByType(Int(device!.type))
                    cell!.delegate = self
                    cell!.groupId = device!.place
        
                    var statuString:String = ""
        
        
                    if device!.online == true{
                        statuString += "在线"
                        cell?.onlineLabel.textColor = selectTfColor
                    }else{
                        statuString += "离线"
                        cell!.onlineLabel.text = statuString
                    }
        
                    if cell!.deviceType == 0x03{
        
                        //灯控
                        let d = device! as! SwitcherDevice
                        if d.powerList.count != 0{
                            if d.powerList[0].on {
                                statuString += " 开"
                            }else{
                                statuString += " 关"
                            }
                        }
        
                    }else if cell!.deviceType == 0x01{
                        //插座
                        let d = device! as! SwitcherDevice
        
                        if d.powerList.count > 1{
                            for (index,power) in d.powerList.enumerated(){
                                if power.on == true{
                                    statuString += " \(index + 1)开"
                                }else{
                                    statuString += " \(index + 1)关"
                                }
                            }
                        }
                    }
        //                }else{
        //                    if d.power.count != 0{
        //                        if d.power.last!.on == true{
        //                            statuString += " 开"
        //                        }else{
        //                            statuString += " 关"
        //                        }
        //                    }else{
        //                        statuString += " 关"
        //                    }
        //
        //                }
        //
        //            }else if cell!.deviceType == 0x0B || cell!.deviceType == 0x0C{
        //                //RGB冷暖白
        //                let lightRGBDevice = device as! LightRGBDevice
        //                let powerList = lightRGBDevice.power
        //                if powerList![0].on == true{
        //                    statuString += " 白灯开"
        //                    statuString += " 亮度\(lightRGBDevice.brightness1)"
        //                    if cell!.deviceType == 0x0B{
        //                        statuString += " 色温\(lightRGBDevice.colortemp)"
        //                    }
        //                }else if powerList![1].on == true{
        //                    statuString += " 彩灯开"
        //                    statuString += " 亮度\(lightRGBDevice.brightness2)"
        //                    statuString += " 速度\(lightRGBDevice.freq)"
        //                    statuString += " 模式\(lightRGBDevice.mode)"
        //                }else{
        //                    statuString += " 关"
        //                }
        //            }else if cell!.deviceType == 0x0D{
        //                //冷暖白灯
        //                let lightCWDevice = device as! LightCWDevice
        //                if lightCWDevice.power.last?.on == true{
        //                    statuString += " 开 亮度\(lightCWDevice.brightness) 色温\(lightCWDevice.colortemp)"
        //                }else{
        //                    statuString += " 关"
        //                }
        //            }else if cell!.deviceType == 0x0F{
        //                //纯RGB灯
        //                let lightRGBDevice = device as! LightRGBDevice
        //                if lightRGBDevice.power.last?.on == true{
        //                    statuString += " 开 亮度\(lightRGBDevice.brightness2) 速度\(lightRGBDevice.freq) 模式\(lightRGBDevice.mode)"
        //                }else{
        //                    statuString += " 关"
        //                }
        //            }else if cell!.deviceType == 0x04{
        //                //冷白灯
        //                let lightCDevice = device as! LightCDevice
        //                if lightCDevice.power.last?.on == true{
        //                    statuString += " 开 亮度\(lightCDevice.light)"
        //                }else{
        //                    statuString += " 关"
        //                }
        //            }else if cell!.deviceType == 254{
        //                //空调
        //                if device is TranDevice{
        //                    let data = Util.data(fromStringHex: (device as! TranDevice).devdata)
        //                    if data!.count == 32{
        //
        //                        var byteArray:[UInt8] = [UInt8]()
        //                        for i in 0..<32{
        //                            var temps:UInt8 = 0;
        //
        //                            let s = data!.startIndex.advanced(by: i)
        //                            let e = data!.startIndex.advanced(by: i + 1)
        //                            let r = Range<Data.Index>(s ..< e)
        //
        //                            data?.copyBytes(to: &temps, from: r)
        //
        //                            byteArray.append(temps)
        //                        }
        //
        //                        let temp:Int = Int(byteArray[8]) + 16;
        //                        let on:Int = Int(byteArray[17])
        //                        let mode:Int = Int(byteArray[7])
        //                        let speed:Int = Int(byteArray[9])
        //
        //                        if ((on & 0x01) == 1){
        //                            var modeString:String?
        //                            if mode == 0{
        //                                modeString = "自动"
        //                            }else if mode == 1{
        //                                modeString = "制冷"
        //                            }else if mode == 2{
        //                                modeString = "除湿"
        //                            }else if mode == 3{
        //                                modeString = "送风"
        //                            }else if mode == 4{
        //                                modeString = "制热"
        //                            }
        //
        //                            var speedString:String?
        //                            if speed == 0{
        //                                speedString = "自动"
        //                            }else if speed == 1{
        //                                speedString = "低"
        //                            }else if speed == 2{
        //                                speedString = "中"
        //                            }else if speed == 3{
        //                                speedString = "高"
        //                            }
        //
        //                            statuString += " 开 \(temp)℃ \(modeString!) 风速\(speedString!)"
        //                        }else{
        //                            statuString += " 关"
        //                        }
        //                    }
        //                    if data!.count == 17{
        //
        //                        var byteArray:[UInt8] = [UInt8]()
        //                        for i in 0..<17{
        //                            var temps:UInt8 = 0;
        //                            let s = data!.startIndex.advanced(by: i)
        //                            let e = data!.startIndex.advanced(by: i + 1)
        //                            let r = Range<Data.Index>(s ..< e)
        //
        //                            data?.copyBytes(to: &temps, from: r)
        //
        //                            byteArray.append(temps)
        //                        }
        //
        //                        let temp:Int = Int(byteArray[4]) + 16;
        //                        let on:Int = Int(byteArray[13])
        //                        let mode:Int = Int(byteArray[3])
        //                        let speed:Int = Int(byteArray[5])
        //
        //                        if ((on & 0x01) == 1){
        //                            var modeString:String?
        //                            if mode == 0{
        //                                modeString = "自动"
        //                            }else if mode == 1{
        //                                modeString = "制冷"
        //                            }else if mode == 2{
        //                                modeString = "除湿"
        //                            }else if mode == 3{
        //                                modeString = "送风"
        //                            }else if mode == 4{
        //                                modeString = "制热"
        //                            }
        //
        //                            var speedString:String?
        //                            if speed == 0{
        //                                speedString = "自动"
        //                            }else if speed == 1{
        //                                speedString = "低"
        //                            }else if speed == 2{
        //                                speedString = "中"
        //                            }else if speed == 3{
        //                                speedString = "高"
        //                            }
        //
        //                            statuString += " 开 \(temp)℃ \(modeString!) 风速\(speedString!)"
        //                        }else{
        //                            statuString += " 关"
        //                        }
        //                    }
        //                }
        //
        //            }else if cell!.deviceType == 0x05 || cell!.deviceType == 0x0A{
        //                //2.4G空调
        //                let airConditionDevice = device as! AirConditionDevice
        //
        //                if airConditionDevice.power.last?.on == true{
        //                    var modeString:String?
        //                    if airConditionDevice.mode == 0{
        //                        modeString = "自动"
        //                    }else if airConditionDevice.mode == 1{
        //                        modeString = "制冷"
        //                    }else if airConditionDevice.mode == 2{
        //                        modeString = "除湿"
        //                    }else if airConditionDevice.mode == 3{
        //                        modeString = "送风"
        //                    }else if airConditionDevice.mode == 4{
        //                        modeString = "制热"
        //                    }
        //
        //                    var speedString:String?
        //                    if airConditionDevice.speed == 0{
        //                        speedString = "自动"
        //                    }else if airConditionDevice.speed == 1{
        //                        speedString = "低"
        //                    }else if airConditionDevice.speed == 2{
        //                        speedString = "中"
        //                    }else if airConditionDevice.speed == 3{
        //                        speedString = "高"
        //                    }
        //
        //                    statuString += " 开 \(airConditionDevice.temp + 16)℃ \(modeString!) 风速\(speedString!)"
        //                }else{
        //                    statuString += " 关"
        //                }
        //            }else if cell!.deviceType == 0x10{
        //                let curtainDevice = device
        //                if curtainDevice?.power.last?.on == true{
        //                    statuString += " 合"
        //                }else{
        //                    statuString += " 开"
        //                }
        //
        //            }
        //
        
                    cell!.onlineLabel.text = statuString
                }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_SDeviceList.count
    }
    
    
}
