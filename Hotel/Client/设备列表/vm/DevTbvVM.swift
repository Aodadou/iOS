

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
        return deviceList!.count
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
            cell!.deviceId = device.id
            cell!.position = indexPath.row
            cell!.delegate = cellVM
            
            
//            if device.online{
//                if device.type != 0x1A && device.type < 0x20{
//                    cell!.headerImage.image = DeviceUtil.getDeviceIconByType(Int(device.type))
//                }else{
//                    cell!.headerImage.image = UIImage(named: "中控")
//                }
//            }else{
//                if device.type != 0x1A && device.type < 0x20{
//                    cell!.headerImage.image = DeviceUtil.getDeviceOffLineIconByType(Int(device.type))
//                }else{
//                    cell!.headerImage.image = UIImage(named: "中控")
//                }
//            }
            let statuString = DeviceUtil.getDevStatuWithDev(device: device)
            
            if device.online == true{
                cell?.onlineLabel.textColor = selectTfColor

            }else{
                cell!.onlineLabel.text = statuString
                if cell?.deviceType == 255 || cell?.deviceType == 0x08{
                    cell!.onlineLabel.isHidden = true
                }
                if  cell?.deviceType == 0x15 ||
                    cell?.deviceType == 0x16 || cell?.deviceType == 0x19 || cell?.deviceType == 0x1A{
                    cell!.onlineLabel.isHidden = true;
                }
                return cell!
            }
            
            cell!.onlineLabel.text = statuString
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
}
