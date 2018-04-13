

import UIKit

class DevTbvVM: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    lazy var sm = SessionManager.share()
    weak var target:UIViewController?
    let cellVM = DevCellVM()
    
    //MARK:UITableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let deviceList = MyGlobalData.getDeviceList()
        if deviceList == nil{
            return 0
        }
        return MyGlobalData.getDeviceList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "dev") as? DeviceCell
        if cell == nil{
            cell = ((Bundle.main.loadNibNamed("DeviceCell", owner: self, options: nil))![0] as? DeviceCell)!
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        
        let deviceList = MyGlobalData.getDeviceList()
        
        if let _ = deviceList , deviceList!.count > 0{
            let device = deviceList!.object(at: indexPath.row) as! Device
            
            cell!.addGesture()
            cell!.deviceName = ("\(device.name!)")
            cell!.deviceType = Int(device.type)
            cell!.deviceId = device.id!
            cell!.position = indexPath.row
            cell!.delegate = cellVM
            
    
            
            var statuString:String = ""
            if device.online == true{
                statuString += "在线"
                cell?.onlineLabel.textColor = selectTfColor

            }else{
                statuString += "离线"
                cell!.onlineLabel.text = statuString

                if cell?.deviceType == 255 || cell?.deviceType == 0x08{
                    cell!.onlineLabel.isHidden = true
                }
                if  cell?.deviceType == 0x15 ||
                    cell?.deviceType == 0x16 || cell?.deviceType == 0x19 || cell?.deviceType == 0x1A{
                    cell!.onlineLabel.isHidden = false;
                    //cell!.onlineLabel.text = strAlarm
                }

                return cell!
            }
            
            if cell!.deviceType == 0x03{
                
                //灯控
                let d = device as! SwitcherDevice
                if d.powerList.count != 0{
                    if d.powerList[0].on {
                        statuString += " 开"
                    }else{
                        statuString += " 关"
                    }
                }
                
            }else if cell!.deviceType == 0x01 || cell!.deviceType == 0x02 {
                //插座
                let d = device as! SwitcherDevice
                
                if d.powerList.count > 1{
                    for (index,power) in d.powerList.enumerated(){
                        if power.on == true{
                            statuString += " \(index + 1)开"
                        }else{
                            statuString += " \(index + 1)关"
                        }
                    }
                    
                }else{
                    if d.powerList.count != 0{
                        if d.powerList.last!.on == true{
                            statuString += " 开"
                        }else{
                            statuString += " 关"
                        }
                    }else{
                        statuString += " 关"
                    }
                    
                }
                
            }else if cell!.deviceType == 0x0B || cell!.deviceType == 0x0C{
                //RGB冷暖白
//                let lightRGBDevice = device as! LightRGBDevice
//                let powerList = lightRGBDevice.power
//                if powerList?[0].on == true{
//                    statuString += " 白灯开"
//                    statuString += " 亮度\(lightRGBDevice.brightness1)"
//                    if cell!.deviceType == 0x0B{
//                        statuString += " 色温\(lightRGBDevice.colortemp)"
//                    }
//                }else if powerList?[1].on == true{
//                    statuString += " 彩灯开"
//                    statuString += " 亮度\(lightRGBDevice.brightness2)"
//                    statuString += " 速度\(lightRGBDevice.freq)"
//                    statuString += " 模式\(lightRGBDevice.mode)"
//                }else{
//                    statuString += " 关"
//                }
            }else if cell!.deviceType == 0x0D{
                //冷暖白灯
//                let lightCWDevice = device as! LightCWDevice
//                if lightCWDevice.power.last?.on == true{
//                    statuString += " 开 亮度\(lightCWDevice.brightness) 色温\(lightCWDevice.colortemp)"
//                }else{
//                    statuString += " 关"
//                }
            }else if cell!.deviceType == 0x0F{
                //纯RGB灯
//                let lightRGBDevice = device as! LightRGBDevice
//                if lightRGBDevice.power.last?.on == true{
//                    statuString += " 开 亮度\(lightRGBDevice.brightness2) 速度\(lightRGBDevice.freq) 模式\(lightRGBDevice.mode)"
//                }else{
//                    statuString += " 关"
//                }
            }else if cell!.deviceType == 0x04{
                //冷白灯
//                let lightCDevice = device as! LightCDevice
//                if lightCDevice.power.last?.on == true{
//                    statuString += " 开 亮度\(lightCDevice.light)"
//                }else{
//                    statuString += " 关"
//                }
            }else if cell!.deviceType == 0x05 || cell!.deviceType == 0x0A{
                //2.4G空调
                let airConditionDevice = device as! AirConditionDevice
                
                if airConditionDevice.on == true{
                    var modeString:String?
                    if airConditionDevice.mode.rawValue == 0{
                        modeString = "自动"
                    }else if airConditionDevice.mode.rawValue == 1{
                        modeString = "制冷"
                    }else if airConditionDevice.mode.rawValue == 2{
                        modeString = "除湿"
                    }else if airConditionDevice.mode.rawValue == 3{
                        modeString = "送风"
                    }else if airConditionDevice.mode.rawValue == 4{
                        modeString = "制热"
                    }
                    statuString += " 开 温度\(airConditionDevice.temperature + 16) \(modeString!)模式"
                }else{
                    statuString += " 关"
                }
                
            }else if cell!.deviceType == 255{
                
                cell!.onlineLabel.isHidden = true
                
            }
            
            
            cell!.onlineLabel.text = statuString
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
}
