

import UIKit
import RxSwift

class AoEditPlaceVC: AoBaseViewController {
    public var groupId:String!
    
    var currentGroupInfo:GroupInfo?

    @IBOutlet weak var tfRoomName: UITextField!
    
    @IBOutlet weak var imgvRoom: UIImageView!
    
    @IBOutlet weak var btnDelete: UIButton!
    
    let viewModel = AoPlaceViewModel()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let groupInfoList = MyGlobalData.getGroupInfoList()
        for groupInfo in groupInfoList!{
            if groupInfo.groupId == self.groupId{
                self.currentGroupInfo = groupInfo
                break
            }
        }
        
        if currentGroupInfo == nil{
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        self.initUI()
        self.initNotification()
    }
    
    func initUI(){
        if let _ = self.currentGroupInfo{
            self.tfRoomName.text = self.currentGroupInfo!.groupName
            self.imgvRoom.image = AoPlaceManager.getImageFromLocal(key: self.currentGroupInfo!.groupName)
        }
    }
    
    func initNotification(){
    NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_CMDCOMMON)).takeUntil(self.rx.deallocated).subscribe(onNext: { (notification) in

            
            DispatchQueue.global().async {}
            
            DispatchQueue.main.async {
                ///添加成功后根据名称存储存储照片
                let cmd = notification.object as! ServerCommand
                if cmd.getNo() == CMD78_ServerDelGroupSucc.commandConst(){
                    SVProgressHUD.show(withStatus: "正在刷新")
                    self.viewModel.sendGetAllGroupCMD()
                }
                
                if cmd.getNo() == CMD7C_ServerReturnAllGroupInfo.commandConst(){
                    self.navigationController?.popViewController(animated: true)
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: AO_NOTIFICATION_REFRESH_GROUP), object: nil)
                }
            }

        
            

            
        }).disposed(by: bag)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func actionChangeName(_ sender: Any) {
        
        if tfRoomName.text!.count == 0{
            SVProgressHUD.showError(withStatus: "请输入房间名")
            return
        }
        if tfRoomName.text!.count > 7{
            SVProgressHUD.showError(withStatus: "房间名不能多于7个字")
            return
        }
        
    }
    @IBAction func actionChangeImage(_ sender: Any) {
        
    }
    @IBAction func actionDelete(_ sender: Any) {
        
        let deviceList = MyGlobalData.getDeviceList()
        for device in deviceList!{
            if device.place == self.groupId{
                SVProgressHUD.showError(withStatus: "房间下有设备不能删")
                return
            }
        }
        
        SVProgressHUD.show(withStatus: "正在删除")
        viewModel.sendDelCMD(groupId: self.currentGroupInfo!.groupId)
    }
    @IBAction func actionModify(_ sender: Any) {
        SVProgressHUD.show(withStatus: "正在修改")
        viewModel.sendModify(groupId: self.currentGroupInfo!.groupId, groupName: self.currentGroupInfo!.groupName)
    }
    
    
}
