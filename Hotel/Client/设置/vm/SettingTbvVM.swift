

import UIKit

class SettingTbvVM: NSObject,UITableViewDelegate,UITableViewDataSource {
    private let titles = ["配置设备","切换房间","常见问题","关于我们","当前版本"]
    weak var target:UIViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "SettingCell")
        }
        
        cell!.textLabel?.textColor = backColor
        cell!.textLabel?.text = titles[indexPath.row]
        cell!.accessoryType = .disclosureIndicator
        cell!.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let configVC = ConfigVC()
            if let _ = self.target{
                self.target?.hidesBottomBarWhenPushed = true
                self.target?.navigationController?.pushViewController(configVC, animated: true)
            }
        }
        
    }
}
