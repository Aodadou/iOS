import UIKit

class AoDeviceInfoVC: AoBaseViewController {
    var deviceId:String?
    var deviceType:Int?
    var device1aDevdata:String?
    var backImageView:UIImageView!
    var deviceIcon:UIImageView!
    var deviceName:UILabel!
    var deviceMac:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设备信息"
        self.view.backgroundColor = backColor
     
        self.backImageView = UIImageView()
        self.deviceIcon = UIImageView()
        self.deviceName = UILabel()
        self.deviceMac = UILabel()
        self.backImageView.frame = CGRect(x: 20, y: 30, width: screenWidth - 40, height: (screenWidth - 40) * (4 / 17))
        
        
        self.backImageView.image = UIImage(named: "灯光路数白框")
        
        let deviceIconWH:CGFloat = self.backImageView.frame.height * (2/3)
        let deviceIconX:CGFloat = 40
        let deviceIconY:CGFloat = (self.backImageView.frame.height - deviceIconWH) / 2 + 30 - 3
        self.deviceIcon.frame = CGRect(x: deviceIconX, y: deviceIconY, width: deviceIconWH, height: deviceIconWH)
        
        
        for device in MyGlobalData.getDeviceList(){
            if (device as! Device).id == self.deviceId!{
                self.deviceType = Int((device as! Device).type)
                break
            }
        }
        
        if self.deviceType == nil{
            self.deviceType = 254
        }
        
    
        let deviceNameX = deviceIconX + deviceIconWH
        let deviceNameY = deviceIconY
        
        let labelW = self.backImageView.frame.width - deviceIconX - deviceIconWH
        let labelH = deviceIconWH / 2
        
        if self.deviceType != 255 {
            self.deviceName.text = DeviceUtil.getDeviceDesName(self.deviceType!)
            
        }else{
            self.deviceName.text = "Wifi设备 固件版本xxxxxx"
        }
        
        if self.deviceType != 0x1A{
            self.deviceIcon.image = DeviceUtil.getDeviceIconByType(self.deviceType!)
        }else{
            let data = Util.data(fromStringHex: self.device1aDevdata!)
            
            var byteArray:[UInt8] = [UInt8]()
            for i in 0..<8{
                var temps:UInt8 = 0;
                data?.copyBytes(to: &temps, from: NSRange(location: i, length: 1).toRange()!)
                byteArray.append(temps)
            }
            
            if byteArray[1] == 0x01 {
                //红外
                self.deviceIcon.image = UIImage(contentsOfFile: Bundle.main.resourcePath! + "/红外感应")
                self.deviceName.text = "红外报警器"
            }else if byteArray[1] == 0x02 {
                //水浸
                self.deviceIcon.image = UIImage(contentsOfFile: Bundle.main.resourcePath! + "/水浸")
                self.deviceName.text = "水浸报警器"
            }else if byteArray[1] == 0x03 {
                //燃气
                self.deviceIcon.image = UIImage(contentsOfFile: Bundle.main.resourcePath! + "/燃气")
                self.deviceName.text = "燃气报警器"
            }else if byteArray[1] == 0x04 {
                //医疗呼叫
            }else if byteArray[1] == 0x05 {
                //sos紧急呼叫器
            }else if byteArray[1] == 0x06 {
                //布防遥控器
            }
        }
        
        
        self.deviceName.textAlignment = NSTextAlignment.right
        self.deviceName.frame = CGRect(x: deviceNameX, y: deviceNameY, width: labelW, height: labelH)
        self.deviceName.textColor = selectTfColor
        
        
        self.deviceMac.text = "SN \(deviceId!)"
        self.deviceMac.textAlignment = NSTextAlignment.right
        self.deviceMac.frame = CGRect(x: deviceNameX, y: deviceNameY + labelH, width: labelW, height: labelH)
        self.deviceMac.textColor = selectTfColor
        
        self.view.addSubview(self.backImageView)
        self.view.addSubview(self.deviceIcon)
        self.view.addSubview(self.deviceName)
        self.view.addSubview(self.deviceMac)
        
    }
    
    deinit{
        print("设备信息销毁了")
    }
}
