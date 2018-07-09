
import UIKit


class AoAlertView: AoBaseView {
    private let alertViewTintColor = UIColor(red: 100/255.0, green: 147/255.0, blue: 235/255.0, alpha: 1.0)
    
    var alertView:UIView!
    var titleLabel:UILabel!
    var contentLabel:UILabel!
    var btnCancel:UIButton!
    var btnOk:UIButton!
    var textFields:[UITextField]!
    
    init() {
        super.init(frame:UIScreen.main.bounds)
        self.backgroundColor = .black
        self.alpha = 0.5
        
        alertView = UIView()
        titleLabel = UILabel()
        contentLabel = UILabel()
        btnCancel = UIButton()
        btnOk = UIButton()
        alertView = UIView()
        contentLabel.backgroundColor = .white
        alertView.backgroundColor = .white
        btnOk.backgroundColor = .white
        btnOk.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnOk.setTitleColor(alertViewTintColor, for: UIControlState())
        btnCancel.backgroundColor = .white
        btnCancel.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btnCancel.setTitleColor(alertViewTintColor, for: UIControlState())
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title:String,message:String,handler:@escaping (_ info:String)->Void){
        self.init()
        
        
        titleLabel.text = "提示"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentLabel.textAlignment = .center
        contentLabel.numberOfLines = 0
        contentLabel.text = message
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        btnCancel.setTitle("取消", for: UIControlState())
        btnOk.setTitle("确定", for: UIControlState())
        btnCancel.addTarget(self, action: #selector(self.cancel), for: UIControlEvents.touchUpInside)
        btnOk.addTarget(self, action: #selector(self.sure), for: UIControlEvents.touchUpInside)
        
        let topLayer = CALayer()
        topLayer.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width * 0.375, height: 0.5)
        topLayer.backgroundColor = UIColor.gray.cgColor
        btnCancel.layer.addSublayer(topLayer)
        let topLayer2 = CALayer()
        topLayer2.frame = CGRect(x: 0.0, y: 0.0, width: self.frame.width * 0.375, height: 0.5)
        topLayer2.backgroundColor = UIColor.gray.cgColor
        btnOk.layer.addSublayer(topLayer2)
        
        let leftLayer = CALayer()
        leftLayer.frame = CGRect(x: self.frame.width * 0.0, y: 0.0, width: 0.5, height: self.frame.height * 0.3)
        leftLayer.backgroundColor = UIColor.gray.cgColor
        btnOk.layer.addSublayer(leftLayer)
        
        self.alertView.layer.cornerRadius = 10
        self.alertView.clipsToBounds = true
        self.addSubview(alertView)
        alertView.addSubview(titleLabel)
        alertView.addSubview(contentLabel)
        alertView.addSubview(btnCancel)
        alertView.addSubview(btnOk)
        
        
        alertView.mas_makeConstraints { (make) in
            make!.width.equalTo()(self.frame.width * 0.75)
            make!.height.equalTo()(self.alertView.mas_width)!.multipliedBy()(0.50)
            make!.centerX.equalTo()(self)
            make!.centerY.equalTo()(self)
        }
        
        
        btnCancel.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.alertView)
            make?.width.equalTo()(self.alertView.mas_width)?.multipliedBy()(0.5)
            make?.height.equalTo()(self.alertView.mas_height)?.multipliedBy()(0.30)
            make?.left.equalTo()(0)
        }
        
        
        btnOk.mas_makeConstraints { (make) in
            make?.bottom.equalTo()(self.alertView)
            make?.width.equalTo()(self.btnCancel.mas_width)
            make?.height.equalTo()(self.btnCancel.mas_height)
            make?.left.equalTo()(self.btnCancel.mas_right)
        }
        
        contentLabel.mas_makeConstraints { (make) in
            make!.bottom.equalTo()(self.btnCancel.mas_top)
            make!.width.equalTo()(self.alertView.mas_width)
            make!.height.equalTo()(self.alertView.mas_height)?.multipliedBy()(0.40)
            make!.centerX.equalTo()(self.alertView)
        }
        
        
        titleLabel.mas_makeConstraints { (make) in
            make!.top.equalTo()(self.alertView)?.offset()(20)
            make!.bottom.equalTo()(self.contentLabel.mas_top)
            make!.width.equalTo()(self.alertView.mas_width)
            make!.centerX.equalTo()(self.alertView)
        }
        
    }
    
    func sure(){
        
    }
    func cancel(){
        
    }
}
