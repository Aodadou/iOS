

import UIKit

class SettingVC: RootViewController {
    
    var tableView:UITableView!
    let vm = SettingTbvVM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        
        vm.target = self
        self.initUI()
        
    }
    
    func initUI(){
        
        self.tableView = UITableView()
        self.tableView.backgroundColor = backColor
        self.tableView.delegate = self.vm
        self.tableView.dataSource = self.vm
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "SettingCell")
        self.view.addSubview(self.tableView)
        self.tableView.mas_makeConstraints { (make) in
            make?.width.equalTo()(screenWidth)
            make?.height.equalTo()(screenHeight)
            make?.top.equalTo()(0)
            make?.left.equalTo()(0)
        }
        
    }
    
}
