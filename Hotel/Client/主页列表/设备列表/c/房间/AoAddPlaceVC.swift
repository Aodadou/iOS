

import UIKit
import RxSwift

class AoAddPlaceVC: AoBaseViewController,UIScrollViewDelegate {
    
    @IBOutlet weak var svPlace: UIScrollView!
    
    @IBOutlet weak var tfPlaceName: UITextField!
    
    @IBOutlet weak var btnAdd: UIButton!
    let bag = DisposeBag()
    var viewModel:AoPlaceViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = AoPlaceViewModel(placeName: self.tfPlaceName.rx.text.orEmpty.asObservable())
        self.initUI()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func initUI(){
        self.setNavTitle(title: "添加房间")
        
        self.svPlace.contentSize = CGSize(width: 6 * svPlace.frame.width, height: 0)
        for index in 0 ... 5 {
            let placeView:AoPlaceView = Bundle.main.loadNibNamed("AoPlaceView", owner: self, options: nil)!.first as! AoPlaceView
            placeView.index = index
            
            self.svPlace.addSubview(placeView)
            
            placeView.mas_makeConstraints({ (make) in
                make?.height.mas_equalTo()(self.svPlace)
                make?.width.mas_equalTo()(self.svPlace)
                make?.top.mas_equalTo()(0)
                make?.left.mas_equalTo()(CGFloat(index) * self.svPlace.frame.width)
            })
            placeView.setForAddView()
            placeView.setDefault(index:index)
        }
        
        self.viewModel!.btnValid.bind(to: self.btnAdd.rx.isEnabled).disposed(by: bag)
        
        self.btnAdd.rx.tap.subscribe(onNext: { [weak self] in
            
            SVProgressHUD.show(withStatus: "正在添加")
            let groupInfos = MyGlobalData.getGroupInfoList()
            for index in 0 ..< groupInfos!.count{
                let group = groupInfos![index]
                if group.groupName == self!.tfPlaceName.text!{
                    SVProgressHUD.showError(withStatus: "分组名已存在")
                    return
                }
            }
            
            SVProgressHUD.show(withStatus: "正在添加房间")
            let name = self!.tfPlaceName.text!
            DispatchQueue.global().async {
                self!.viewModel!.sendAddCmd(placeName: name)
            }
            
        }).disposed(by: bag)
        
    NotificationCenter.default.rx.notification(NSNotification.Name(AO_NOTIFICATION_CMDCOMMON)).takeUntil(self.rx.deallocated).subscribe(onNext: { (notification) in
        
        DispatchQueue.global().async {
            
            let cmd = notification.object as! ServerCommand
            if cmd.getNo() == CMD76_ServerAddGroupSucc.commandConst(){
                
                let cmd76 = cmd as! CMD76_ServerAddGroupSucc
                if cmd76.groupId != nil || cmd76.groupId != ""{
                    self.viewModel!.sendGetAllGroupCMD()
                }
                DispatchQueue.main.async {
                    ///添加成功后根据名称存储存储照片
                    AoPlaceManager.saveImageToLocal(image: UIImage(named:AO_PLACE_IMAGE_NAME[self.viewModel!.index])!, key: self.tfPlaceName.text!)
                    SVProgressHUD.dismiss()
                }
            }
            
            if cmd.getNo() == CMD7C_ServerReturnAllGroupInfo.commandConst(){
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
        }).disposed(by: bag)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == svPlace {
            let thisContentOffsetX = scrollView.contentOffset.x
            let currentPage = Int(thisContentOffsetX / (screenWidth - 30))
            
            print("停在第\(currentPage)个房间")
            self.viewModel!.index = currentPage
        }
        
    }
    
}
