
import UIKit

class DeviceListVC: RootViewController {

    let tbvVM = DevTbvVM()
    var deviceListTBV:UITableView!
    let devListVM = DevListVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initUI()
        
        tbvVM.target = self
        deviceListTBV.delegate = tbvVM
        deviceListTBV.dataSource = tbvVM
        
        devListVM.target = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initUI(){
        
        self.setNavTitle(title:"设备列表")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self.devListVM, action: #selector(self.devListVM.actionRefresh))
        self.deviceListTBV = UITableView()
        self.deviceListTBV.separatorStyle = .none
        self.deviceListTBV.showsVerticalScrollIndicator = false
        
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
