

import Foundation

extension AoDeviceListVC:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.deviceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "dev") as? AoDeviceCell
        if cell == nil{
            cell = (Bundle.main.loadNibNamed("AoDeviceCell", owner: self, options: nil))!.first as? AoDeviceCell
        }
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        
        let deviceList = self.deviceList
        let device = deviceList[indexPath.row]
        
        cell!.addGesture()
        cell!.deviceName = ("\(device.name!)")
        cell!.deviceType = Int(device.type)
        cell!.deviceId = device.id
        cell!.position = indexPath.row
        cell!.groupId = device.place
        cell!.delegate = self
        
        if device.online{
            cell!.hImage = DeviceUtil.getDeviceIconByType(Int(device.type))
        }else{
            cell!.hImage = DeviceUtil.getDeviceOffLineIconByType(Int(device.type))
        }

        let statuString = DeviceUtil.getDevStatuWithDev(device: device)
        
        if device.online{
            cell!.onlineLabel.textColor = selectTfColor
        }else{
            cell!.onlineLabel.textColor = noSelectTfColor
            cell!.onlineLabel.text = statuString
            return cell!
        }
        cell!.onlineLabel.text = statuString
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView();
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        UIView.animate(withDuration: 0.25) {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        }
        
    }
    
}
