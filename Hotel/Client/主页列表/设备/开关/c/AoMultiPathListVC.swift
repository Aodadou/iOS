import UIKit

class AoMultiPathListVC: AoBaseViewController{
    
    var plugDevice:SwitcherDevice?
    var deviceId:String?
    var multiTableView:UITableView?
    let sm = SessionManager.share()
    let mpTbvVM = MPTbvVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let barItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain,
            target: nil, action: #selector(AoMultiPathListVC.back))
        self.navigationItem.backBarButtonItem = barItem
        
        mpTbvVM.target = self
        
        self.multiTableView = UITableView(frame: self.view.frame,
            style: UITableViewStyle.plain)
        self.multiTableView!.backgroundColor = backColor
        self.multiTableView!.register(UINib(nibName: "MultiPathCell", bundle: nil),forCellReuseIdentifier: "multiPath")
        self.multiTableView!.separatorStyle = .none
        self.multiTableView!.delegate = mpTbvVM
        self.multiTableView!.dataSource = mpTbvVM
        self.multiTableView!.tableHeaderView = UIView()
        self.multiTableView!.showsVerticalScrollIndicator = false
        self.view.addSubview(self.multiTableView!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

  
        for device in MyGlobalData.getDeviceList(){
            if (device as! Device).id == self.deviceId!{
                self.plugDevice = device as? SwitcherDevice
                break
            }
        }
        
        self.title = self.plugDevice!.name
        self.multiTableView!.reloadData()
        
        print("插座设备：\(String(describing: self.plugDevice))")
        
    }
    

//    func receiveCMD(_ notification:Notification){
//        let cmd = notification.object as! ServerCommand
//        if cmd.getCMDNo() == CMD09_ServerControlResult.commandConst(){
//
//            let cmd09 = cmd as! CMD09_ServerControlResult
//            
//            let newD = cmd09.device
//            if newD?.id != self.plugDevice!.id{
//                return
//            }
//
//            self.plugDevice = DeviceUtil.readDeviceStatu(self.plugDevice!, newDev: newD!)
//
//            let cells = self.multiTableView!.visibleCells as! [MultiPathCell]
//            for (index,cell) in cells.enumerated(){
//                if index == self.powerIndex{
//                    cell.powerSwitch.isEnabled = true
//                    break
//                }
//            }
//            self.powerArray = NSMutableArray(array: self.plugDevice!.power)
//            self.multiTableView!.reloadData()
//
//
//            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//                let deviceList = MyGlobalData.getDeviceList()
//                for (index,d) in (deviceList?.enumerated())!{
//                    if (d as! DeviceStatus).id == self.plugDevice!.id{
//                        deviceList?.replaceObject(at: index, with: self.plugDevice!)
//                        MyGlobalData.setDeviceList(deviceList)
//                        break
//                    }
//                }
//            })
//        }
//
//        if cmd.getCMDNo() == CMDFC_ServerNotifiOnline.commandConst(){
//
//            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async(execute: {
//
//                let cmdfc = cmd as! CMDFC_ServerNotifiOnline
//                let deviceList = cmdfc.deviceList
//
//                for device in deviceList!{
//                    if device.id == self.deviceId{
//                        self.plugDevice = DeviceUtil.readDeviceStatu(self.plugDevice!,
//                            newDev: device)
//                        break
//                    }
//                }
//
//                if let _ = self.plugDevice{
//                    let arr = self.plugDevice!.power as [Power]
//                    self.powerArray = NSMutableArray(array: arr)
//                    DispatchQueue.main.async(execute: {
//                        self.multiTableView!.reloadData()
//                    })
//                }
//
//                let deviceLists = MyGlobalData.getDeviceList()
//                for (index,d) in (deviceLists?.enumerated())!{
//                    if (d as AnyObject).id == self.plugDevice!.id{
//                        deviceLists?.replaceObject(at: index, with: self.plugDevice!)
//                        MyGlobalData.setDeviceList(deviceLists)
//                        break
//                    }
//                }
//            })
//        }
//
//
//    }
//
//    func receiveFF(_ notification:Notification){
//        let dict = notification.object as! NSDictionary
//        let info = dict.value(forKey: "info")
//        if let _ = info{
//            GlobalMethod.toast("\(info as! String)")
//        }
//
//        let cells = self.multiTableView!.visibleCells as! [MultiPathCell]
//        for (index,cell) in cells.enumerated(){
//            if index == self.powerIndex{
//                cell.powerSwitch.isOn = !cell.powerSwitch.isOn
//                cell.powerSwitch.isEnabled = true
//            }
//        }
//    }
//

    func back(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func setTime(_ view:ToolBarView2) {
        
        //        let timerListVC = TimerListVC()
        //        timerListVC.device = self.plugDevice
        //        self.navigationController!.pushViewController(timerListVC, animated: true)
    }
    
    func deviceInfo(_ view:ToolBarView2) {
        //        let deviceInfoVC = DeviceInfoVC()
        //        deviceInfoVC.deviceId = self.plugDevice!.id
        //        deviceInfoVC.deviceType = Int(self.plugDevice!.type)
        //        self.navigationController?.pushViewController(deviceInfoVC, animated: true)
    }
    
    internal func setSwitchEnable(){
        let cells = self.multiTableView!.visibleCells as! [MultiPathCell]
        for cell in cells{
            cell.powerSwitch.isEnabled = true
        }
    }
    


    
    

    
}
