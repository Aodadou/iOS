
import UIKit
import RxSwift

class AoLampControlVC: AoDeviceRootVC {

    
    @IBOutlet weak var btnPower: UIButton!
    
    @IBOutlet weak var btnRemoteConfig: UIButton!
    
    @IBOutlet weak var btnTimer: UIButton!
    
    var device:SwitcherDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.rx_device.subscribe(onNext: { [weak self](device) in
            self!.device = device as! SwitcherDevice
            DispatchQueue.main.async {
                self!.title = self!.device.name!
                self!.btnPower.isSelected = self!.device.powerList.first!.on
            }
        }).disposed(by: bag)
        
        self.btnPower.rx.tap.subscribe(onNext: { [weak self] in
            
            self!.device = self!.viewModel.device as! SwitcherDevice
            if !self!.device.online {
                SVProgressHUD .showInfo(withStatus: "设备离线")
            }
            let power = self!.device.powerList.first!
            power.on = !power.on
            self!.viewModel.controlDevice(device: self!.device)
            
        }).disposed(by: bag)
        
        self.btnTimer.rx.tap.subscribe(onNext: { [weak self] in
            
            let timerVC = TimerListVC()
            timerVC.deviceId = self!.device.id
            self!.navigationController!.pushViewController(timerVC, animated: true)
            
        }).disposed(by: bag)
        
        self.btnRemoteConfig.rx.tap.subscribe(onNext: { [weak self] in
            
            self!.viewModel.sendCmd40()
            
        }).disposed(by: bag)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

}
