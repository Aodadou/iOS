

import UIKit
import RxSwift

class AoDeviceRootVC: AoBaseViewController {
    
    var deviceId:String?
    var bag = DisposeBag()
    var viewModel:AoDeviceViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        let rightItem = UIBarButtonItem(title: "设备信息", style: .plain, target: self, action: #selector(self.actionDeviceInfo))
        self.navigationItem.rightBarButtonItem = rightItem
        
        if deviceId == nil {
            SVProgressHUD .showError(withStatus: "设备不存在")
            return
        }
        viewModel = AoDeviceViewModel(mac: deviceId!)
        
        self.initNotification()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initData(){
        
    }

    func initNotification(){
        NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_CMDCOMMON))
            .takeUntil(self.rx.deallocated).subscribe(onNext: { (notification) in

                DispatchQueue.global().async {
                    let cmd = notification.object as! ServerCommand
                    if cmd.getNo() == CMD09_ServerControlResult.commandConst(){
                        let cmd09:CMD09_ServerControlResult = cmd as! CMD09_ServerControlResult
                        let device = cmd09.device
                        if device == nil{
                            return
                        }
                        var deviceList = MyGlobalData.getDeviceList()
                        
                        for i in 0 ..< deviceList!.count{
                            let d = deviceList![i]
                            if d.id == device!.id{
                                deviceList!.replaceSubrange(Range(i ..< i+1), with: [device!])
                                break
                            }
                        }
                        for i in 0 ..< deviceList!.count{
                            let d = deviceList![i]
                            if d.id == self.deviceId{
                                self.viewModel.refreshData()
                                break
                            }
                        }
                        
                    }
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
                
            }).disposed(by: bag)
        

        
    }
    
    
    func actionDeviceInfo(){
        
        if let _ = self.deviceId{
            let deviceinfoVC = AoDeviceInfoVC()
            deviceinfoVC.deviceId = self.deviceId
            self.navigationController?.pushViewController(deviceinfoVC, animated: true)
        }
        
    }
    
}
