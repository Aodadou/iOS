
import UIKit

class DeviceListVC: RootViewController {

    let tbvVM = DevTbvVM()
    var deviceListTBV:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        
        tbvVM.target = self
        deviceListTBV.delegate = tbvVM
        deviceListTBV.dataSource = tbvVM
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initUI(){
        
        self.setNavTitle(title:"设备列表")
        //self.tabBarController.navigationController?.setLeftItem(image: nil, title: "Config", target: self.vm, action: #selector(vm.actionToConfig))
        self.deviceListTBV = UITableView()
        self.view.addSubview(self.deviceListTBV)
        self.deviceListTBV.mas_makeConstraints { (make) in
            make!.width.equalTo()(screenWidth)
            make!.height.equalTo()(screenHeight)
            make!.top.equalTo()(0)
            make!.left.equalTo()(0)
        }
        
        self.deviceListTBV.backgroundColor = backColor
        self.deviceListTBV.tableHeaderView = UIView()
        
        
    }

}
