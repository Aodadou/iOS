
import UIKit
import RxSwift

class AoDeviceListVC: AoBaseViewController {
    var deviceList = [CommonDevice]()
    var bag = DisposeBag()
    
    @IBOutlet weak var svPlaceView: UIScrollView!
    @IBOutlet weak var tbvDeviceList: UITableView!
    let viewModel = AoDeviceListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func initUI(){
        self.setNavTitle(title:"设备列表")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "刷新", style: .plain, target: self, action: #selector(self.actionReloadData))
        
        self.tbvDeviceList.separatorStyle = .none
        
        self.initPlaceView()
    }
    
    func initPlaceView(){
        let groupInfo = MyGlobalData.getGroupInfoList()
        self.svPlaceView.contentSize = CGSize(width: CGFloat(groupInfo!.count + 1) * svPlaceView.frame.width, height: 0)
        for index in 0 ... groupInfo!.count {
            let placeView:AoPlaceView = Bundle.main.loadNibNamed("AoPlaceView", owner: self, options: nil)!.first as! AoPlaceView
            placeView.index = index
            placeView.delegate = self
            self.svPlaceView.addSubview(placeView)
            if index == groupInfo!.count{
                placeView.setForLastView()
            }
            placeView.mas_makeConstraints({ (make) in
                make?.height.mas_equalTo()(self.svPlaceView)
                make?.width.mas_equalTo()(self.svPlaceView)
                make?.top.mas_equalTo()(0)
                make?.left.mas_equalTo()(CGFloat(index) * self.svPlaceView.frame.width)
            })
            placeView.setStatuWith(placeModel: viewModel.getPlaceModelWith(index: index))
        }
    }
    
    
    func loadData(){
        
        
        viewModel.deviceListPS.subscribe { [weak self](event) in
            DispatchQueue.main.async {
                self!.deviceList = event.element!
                self!.tbvDeviceList.reloadData()
            }
            
        }.disposed(by: bag)
        self.viewModel.getGroupDeviceList(index: 0)
        
    }
}

extension AoDeviceListVC{
    
    func actionReloadData(){
        SVProgressHUD .show(withStatus: "正在刷新")
        self.viewModel.refreshList()
    }
    
    func actionChangePlace(page:NSInteger){
        viewModel.getGroupDeviceList(index: page)
    }
    

}




