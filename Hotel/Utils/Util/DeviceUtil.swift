
import UIKit

//灯的最大亮度 1~15
let MAX_LIGHT_VALUE:Double = 15
//灯的最小亮度
let MIN_LIGHT_VALUE:Double = 1
//灯的最大速度 0~15
let MAX_SPEED_VALUE:Double = 15
//灯的最大色温 0~127
let MAX_COLOR_VALUE:Double = 127

class DeviceUtil: NSObject {
    
    static var roomNames:[String] = ["客厅","书房","卧室","阳台","厨房","餐厅"];
    
    static var deviceDesNames:[String] = ["","插座","WiFi开关","灯控盒","灯开关及调光控制","空调遥控器","RGB灯","WI-FI电视锁","情景遥控器","WI-FI控制中心","空调遥控器","RGB冷暖灯","RGB冷暖灯","冷暖灯","机顶盒控制中心","RGB灯","窗帘开关","电饭煲","环境检测仪","带计量插座","中央空调控制面板","门磁","烟雾报警器","带计量热水器插座","中继设备","智能门锁","安防设备","智能药箱","晾衣架","","","","",""]
    
    static var deviceImgNames:[String] = ["","2.4G","WiFi插座在线","灯控盒","2.4G灯开关及调光控制","空调","","WI-FI电视锁","派对模式按下","中控","空调","RGB+CW","RGB+CW","CW","灯图标","RGB","窗帘","","","","中央空调在线","门磁在线","烟感在线","热水器在线","中继","门锁在线","","","晾衣架","","","","",""]
    
    static var deviceImgOffLineNames:[String] = ["",
                                                 "2.4G插座离线",
                                                 "WiFi插座离线",
                                                 "灯控盒离线",
                                                 "","空调离线",
                                                 "",
                                                 "",
                                                 "派对模式按下",
                                                 "中控离线",
                                                 "空调离线",
                                                 "RGB+CW离线",
                                                 "RGB+CW离线",
                                                 "CW离线",
                                                 "灯图标",
                                                 "RGB离线",
                                                 "窗帘离线",
                                                 "",
                                                 "",
                                                 "",
                                                 "中央空调离线",
                                                 "门磁在线",
                                                 "烟感在线",
                                                 "热水器离线",
                                                 "中继离线",
                                                 "门锁离线",
                                                 "",
                                                 "",
                                                 "晾衣架离线",
                                                 "",
                                                 "",
                                                 "",
                                                 "",
                                                 ""]
    
    class func getTimerTimeImage(_ time:Int) -> UIImage{
        let p = Bundle.main.resourcePath
        
        if time >= 6 && time < 12{
            let path1 = p! + "/早上.png"//定时白天
            return UIImage(contentsOfFile: path1)!
        }else if time >= 12 && time < 18{
            let path2 = p! + "/中午.png"//定时中午
            return UIImage(contentsOfFile: path2)!
        }else{
            let path3 = p! + "/晚上.png"//定时晚上
            return UIImage(contentsOfFile: path3)!
        }
    }
    
    class func getDayByInt(_ day:Int) -> String{
        if day == 0{
            return "周一  "
        }else if day == 1{
            return "周二  "
        }else if day == 2{
            return "周三  "
        }else if day == 3{
            return "周四  "
        }else if day == 4{
            return "周五  "
        }else if day == 5{
            return "周六  "
        }else if day == 6{
            return "周日  "
        }
        return ""
        
    }

    class func getDeviceDesName( _ type:Int ) -> String{
        if type > deviceDesNames.count{
            if type == 254{
                return "空调"
            }
        }
        return deviceDesNames[type]
    }
    class func getDeviceDesNameBySN( _ sn:String ) -> String {
        //let r = ("00".indices.suffix(from: sn.startIndex))
        
        //let r = Range(start: sn.startIndex, end: "00".endIndex)
        let r = Range(uncheckedBounds: (lower: sn.startIndex, upper: "00".endIndex))
        let typeStr = (sn.substring(with: r))
        
        let type = GlobalMethod.hex(toInt: typeStr)
        return deviceDesNames[Int(type)]
    }
    
    class func getMainSN( _ cenCtrlScanValue:String ) -> String{
        let index = cenCtrlScanValue.characters.index(cenCtrlScanValue.startIndex, offsetBy: 12)
        let mainSN = cenCtrlScanValue.substring(from: index)
        
        return getDeviceDesNameBySN(mainSN)
    
    }
    
    class func getDeviceIconByType(_ type:Int) -> UIImage? {
        let p = Bundle.main.resourcePath
        if type > deviceImgNames.count{
            if type == 254{
                let path = p! + "/空调图标.png"
                return UIImage(contentsOfFile: path)
            }
            if type == 255{
                let path = p! + "/摄像头图标.png"
                return UIImage(contentsOfFile: path)
            }

            return nil
        }
        let path = p! + "/\(deviceImgNames[type]).png"
        
        return UIImage(contentsOfFile: path)
    }
    
    
    class func getDeviceOffLineIconByType(_ type:Int) -> UIImage? {
        let p = Bundle.main.resourcePath
        if type > deviceImgNames.count{
            if type == 254{
                let path = p! + "/空调离线.png"
                return UIImage(contentsOfFile: path)
            }
            if type == 255{
                let path = p! + "/摄像头图标.png"
                return UIImage(contentsOfFile: path)
            }
            return nil
        }
        let path = p! + "/\(deviceImgOffLineNames[type]).png"

        return UIImage(contentsOfFile: path)
    }


//    class func readDeviceStatu(_ oldDev:DeviceStatus,newDev:DeviceStatus) -> Device{
//        if oldDev.id == newDev.id{
//            oldDev.online = newDev.online
//            if newDev.power != nil && newDev.power.count > 0{
//                oldDev.power = newDev.power
//            }
//        }
//
//        return oldDev
//    }
//
//    class func readDeviceStatus(_ dev1:Device,dev2:Device){
//
//        dev1.id = dev2.id
//        dev1.pid = dev2.pid
//        dev1.online = dev2.online
//        dev1.type = dev2.type
//        dev1.name = dev2.name
//        dev1.place = dev2.place
//        dev1.subtype = dev2.subtype
//        dev1.firmver = dev2.firmver
//        dev1.groupid = dev2.groupid
//        dev1.netinfo = dev2.netinfo
//        dev1.power = dev2.power
//
//        if dev1 is TranDevice{
//            (dev1 as! TranDevice).devdata = (dev2 as! TranDevice).devdata
//        }
//
//        if (dev2.type == 0x0f || dev2.type == 0x0B || dev2.type == 0x0C){
//            let d1 = dev1 as! LightRGBDevice
//            let d2 = dev2 as! LightRGBDevice
//
//            d1.brightness1 = d2.brightness1
//            d1.brightness2 = d2.brightness2
//            d1.freq = d2.freq
//            d1.colortemp = d2.colortemp
//            d1.r = d2.r
//            d1.g = d2.g
//            d1.b = d2.b
//            d1.mode = d2.mode
//        }
//
//        if (dev2.type == 0x0D){
//            (dev1 as! LightCWDevice).brightness = (dev2 as! LightCWDevice).brightness
//            (dev1 as! LightCWDevice).colortemp = (dev2 as! LightCWDevice).colortemp
//        }
//    }
}
