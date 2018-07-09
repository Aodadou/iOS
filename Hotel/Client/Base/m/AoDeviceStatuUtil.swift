import UIKit

class AoDeviceStatuUtil: NSObject {
    
    static func getDeviceStatuString(device:Device){
        
        var statuString:String = ""
        let type = device.type
        let online = device.online
        
        if online {
            statuString += "在线"
        }else{
            statuString += "离线"
        }
        
        switch type {
        case 0x01:
            fallthrough
        case 0x02:
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
            
            break
        case 0x03://灯控
            let d = device as! SwitcherDevice
            if d.powerList.count != 0{
                if d.powerList[0].on {
                    statuString += " 开"
                }else{
                    statuString += " 关"
                }
            }
            break
            
        default:
            break
        }

       
        
        
        
        
        //else if cell!.deviceType == 0x0B || cell!.deviceType == 0x0C{
//            //RGB冷暖白
//            let lightRGBDevice = device as! LightRGBDevice
//            let powerList = lightRGBDevice.power
//            if powerList?[0].on == true{
//                statuString += " 白灯开"
//                statuString += " 亮度\(lightRGBDevice.brightness1)"
//                if cell!.deviceType == 0x0B{
//                    statuString += " 色温\(lightRGBDevice.colortemp)"
//                }
//            }else if powerList?[1].on == true{
//                statuString += " 彩灯开"
//                statuString += " 亮度\(lightRGBDevice.brightness2)"
//                statuString += " 速度\(lightRGBDevice.freq)"
//                statuString += " 模式\(lightRGBDevice.mode)"
//            }else{
//                statuString += " 关"
//            }
//        }else if cell!.deviceType == 0x0D{
//            //冷暖白灯
//            let lightCWDevice = device as! LightCWDevice
//            if lightCWDevice.power.last?.on == true{
//                statuString += " 开 亮度\(lightCWDevice.brightness) 色温\(lightCWDevice.colortemp)"
//            }else{
//                statuString += " 关"
//            }
//        }else if cell!.deviceType == 0x0F{
//            //纯RGB灯
//            let lightRGBDevice = device as! LightRGBDevice
//            if lightRGBDevice.power.last?.on == true{
//                statuString += " 开 亮度\(lightRGBDevice.brightness2) 速度\(lightRGBDevice.freq) 模式\(lightRGBDevice.mode)"
//            }else{
//                statuString += " 关"
//            }
//        }else if cell!.deviceType == 0x04{
//            //冷白灯
//            let lightCDevice = device as! LightCDevice
//            if lightCDevice.power.last?.on == true{
//                statuString += " 开 亮度\(lightCDevice.light)"
//            }else{
//                statuString += " 关"
//            }
//        }else if cell!.deviceType == 254{
//            //空调
//            if device is TranDevice{
//                let data = Util.data(fromStringHex: (device as! TranDevice).devdata)
//                if data?.count == 32{
//
//                    var byteArray:[UInt8] = [UInt8]()
//                    for i in 0..<32{
//                        var temps:UInt8 = 0;
//                        data?.copyBytes(to: &temps, from: NSRange(location: i, length: 1).toRange()!)
//                        byteArray.append(temps)
//                    }
//
//                    let temp:Int = Int(byteArray[8]) + 16;
//                    let on:Int = Int(byteArray[17])
//                    let mode:Int = Int(byteArray[7])
//
//                    if ((on & 0x01) == 1){
//                        var modeString:String?
//                        if mode == 0{
//                            modeString = "自动"
//                        }else if mode == 1{
//                            modeString = "制冷"
//                        }else if mode == 2{
//                            modeString = "除湿"
//                        }else if mode == 3{
//                            modeString = "送风"
//                        }else if mode == 4{
//                            modeString = "制热"
//                        }
//
//                        statuString += " 开 温度\(temp) \(modeString!)模式"
//                    }else{
//                        statuString += " 关"
//                    }
//                }
//            }
//
//        }else if cell!.deviceType == 0x05 || cell!.deviceType == 0x0A{
//            //2.4G空调
//            let airConditionDevice = device as! AirConditionDevice
//
//            if airConditionDevice.power.last?.on == true{
//                var modeString:String?
//                if airConditionDevice.mode == 0{
//                    modeString = "自动"
//                }else if airConditionDevice.mode == 1{
//                    modeString = "制冷"
//                }else if airConditionDevice.mode == 2{
//                    modeString = "除湿"
//                }else if airConditionDevice.mode == 3{
//                    modeString = "送风"
//                }else if airConditionDevice.mode == 4{
//                    modeString = "制热"
//                }
//                statuString += " 开 温度\(airConditionDevice.temp + 16) \(modeString!)模式"
//            }else{
//                statuString += " 关"
//            }
//
//        }
//
    }
    
}
