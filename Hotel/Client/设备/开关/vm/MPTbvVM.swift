

import UIKit

class MPTbvVM: NSObject,UITableViewDelegate,UITableViewDataSource,ToolBarView2Delegate {
    
    
    
    weak var target:MultiPathListVC?{
        willSet{
           mpCellVM.target = newValue
        }
    }
    let mpCellVM = MPCellVM()
    
    override init() {
        super.init()
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let _ = self.target!.plugDevice!.powerList{
            return self.target!.plugDevice!.powerList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "multiPath", for: indexPath) as! MultiPathCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.delegate = mpCellVM
        cell.position = indexPath.row
        
        let power = self.target!.plugDevice!.powerList[indexPath.row]
        cell.pathLabel.text = "第\(power.way + 1)路"
        cell.powerSwitch.isOn = power.on
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * (69 / 75) * (17 / 69)
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.target!.plugDevice!.powerList != nil){
            return (screenWidth - 40) * (130/320)
        }
        return 0
    }

    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.target!.plugDevice!.powerList.count > 0{
            let array = Bundle.main.loadNibNamed("ToolBarView2", owner: nil, options: nil)
            let toolBarView = array![0] as! ToolBarView2
            toolBarView.frame = CGRect(x: 20, y: 0, width: screenWidth - 40, height: screenWidth * (69 / 75) * (16 / 69))
            toolBarView.delegate = self
            //view.addSubview(toolBarView)
            return toolBarView
        }
        return nil
    }
    
    //mark:ToolBar Delegate
    func setTime(_ view: ToolBarView2) {
        
    }
    
    func deviceInfo(_ view: ToolBarView2) {
        
    }
}
