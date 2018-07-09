import UIKit

class TimerListVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var deviceId:String?
    var device:CommonDevice?
    lazy var timerList = NSArray()
    var timerTableView:UITableView?
    var Timer_timeOut:Timer?

    lazy var sm:SessionManager = SessionManager.share()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "定时列表"

        let views = UIView()
        views.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 10)
        views.backgroundColor = UIColor.clear

        let barItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: #selector(TimerListVC.back))
        self.navigationItem.backBarButtonItem = barItem

        let rightItem = UIBarButtonItem(title: "编辑", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TimerListVC.edit))
        self.navigationItem.rightBarButtonItem = rightItem

        self.timerTableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableViewStyle.plain)
        self.timerTableView!.backgroundColor = backColor
        self.timerTableView!.register(UINib(nibName: "TimerCell", bundle: nil), forCellReuseIdentifier: "timer")
        self.timerTableView!.separatorStyle = .none
        self.timerTableView!.delegate = self
        self.timerTableView!.dataSource = self
        self.timerTableView!.showsVerticalScrollIndicator = false
        self.timerTableView!.tableHeaderView = views
        self.view.addSubview(self.timerTableView!)
        self.timerTableView!.autoresizingMask = UIViewAutoresizing.flexibleWidth.union(UIViewAutoresizing.flexibleHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(TimerListVC.receiveCMD(_:)), name: NSNotification.Name(rawValue: kReceiveCMD), object: nil)


        if self.device != nil{
            self.deviceId = self.device!.id
        }else{

            for device in MyGlobalData.getDeviceList(){
                let dev = device
                if dev.id == self.deviceId {
                    self.device = dev
                    break
                }
            }

        }
        let cmd24 = CMD24_QueryTimer(devid: self.device!.id)
        sm.sendCmd(cmd24)

//        for cell in self.timerTableView!.visibleCells {
//            cell.hidden = true
//            cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//        }

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func receiveCMD(_ notification:Notification){
        let cmd = notification.object as! ServerCommand

        if cmd.getNo() == CMD25_ServerQueryTimerResult.commandConst(){

            let cmd25 = cmd as! CMD25_ServerQueryTimerResult
            self.timerList = cmd25.timerList as NSArray

            self.timerTableView!.reloadData()

        }

        if cmd.getNo() == CMD21_ServerModifyTimerResult.commandConst(){
            let cmd21 = cmd as! CMD21_ServerModifyTimerResult
            if cmd21.result == true{

                var timerInfo:TimerInfo?

                let timerArr = NSMutableArray(array: self.timerList)
                let timerTask = cmd21.schedinfo

                var arrIndex:Int?
                for (index,timer) in timerArr.enumerated(){
                    if (timer as! TimerInfo).schedinfo.id == timerTask?.id{
                        timerInfo = timer as? TimerInfo
                        timerInfo!.ctrlinfo = (timer as! TimerInfo).ctrlinfo
                        timerInfo!.schedinfo = timerTask
                        arrIndex = index
                    }
                }

                timerArr.replaceObject(at: arrIndex!, with: timerInfo!)
                self.timerList = timerArr

                self.timerTableView!.reloadData()
            }
        }

    }

    func receiveFF(_ notification:Notification){
        let dict = notification.object as! NSDictionary
        let info = dict.object(forKey: "info") as! String
        GlobalMethod.toast("\(info)")
    }

    func timeOut(){
        self.cancelTomeOutTimer()
        GlobalMethod.toast("连接超时")
    }

    func cancelTomeOutTimer(){
        if let _ = self.Timer_timeOut{
            self.Timer_timeOut?.invalidate()
        }
    }

    func edit(){
        if self.navigationItem.rightBarButtonItem?.title == "编辑"{
            self.navigationItem.rightBarButtonItem?.title = "取消"
            for cell in self.timerTableView!.visibleCells{
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    (cell as! TimerCell).btn_detail.alpha = 1
                    (cell as! TimerCell).switchBottomImg.alpha = 0
                    (cell as! TimerCell).timerSwitch.alpha = 0
                })
            }
        }else{
            self.navigationItem.rightBarButtonItem!.title = "编辑"
            for cell in self.timerTableView!.visibleCells{
                UIView.animate(withDuration: 0.5, animations: { () -> Void in
                    (cell as! TimerCell).btn_detail.alpha = 0
                    (cell as! TimerCell).switchBottomImg.alpha = 1
                    (cell as! TimerCell).timerSwitch.alpha = 1
                })
            }
        }
    }

    func back(){
        self.navigationController?.popViewController(animated: true)
    }


    //代理数据源
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.timerList.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenHeight * (360 / 1334)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return screenWidth * (690 / 750) * (100/690)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.frame = CGRect(x: 0,y: 0,width: screenWidth,height: screenWidth * (690 / 750) * (130/690))
        view.backgroundColor = backColor
        let btnWidth = screenWidth * (690 / 750) * (100/690)
        let addTimerBtn:UIButton = UIButton(frame: CGRect(x: screenWidth / 2 - btnWidth / 2 + 5, y: 0 , width: btnWidth, height: btnWidth))

        addTimerBtn.setBackgroundImage(UIImage(named:"添加定时按钮"), for: UIControlState())
        addTimerBtn.setBackgroundImage(UIImage(named:"添加定时按钮按下"), for: UIControlState.highlighted)
        addTimerBtn.addTarget(self, action: #selector(TimerListVC.addTimer(_:)), for: UIControlEvents.touchUpInside)
        addTimerBtn.tag = 100
        view.addSubview(addTimerBtn)
        return view
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "timer", for: indexPath) as! TimerCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        let timerTask = (self.timerList.object(at: indexPath.row) as! TimerInfo).schedinfo
        let timerDevice = (self.timerList.object(at: indexPath.row) as! TimerInfo).ctrlinfo.device
        let hour = timerTask?.value(forKey: "hour") as! Int
//        hour += 8
//        if hour >= 24{
//            hour -= 24
//        }
        let minute = timerTask?.value(forKey: "minute") as! Int

        var powerArr:[Power]?
        var turnStr = ""



        var pathStr = ""
        print("设备类型\(device!.type)")
        if device!.type == 3 {
            let dd = timerDevice as! SwitcherDevice
            powerArr = dd.powerList
            cell.pathLabel.isHidden = true
        }else if device!.type == 0x0C || device!.type == 0x0B{
            turnStr = ""
            for (index,p) in (powerArr?.enumerated())!{
                if index == 0{
                    if p.on == true{
                        pathStr = "白灯开"
                    }else{
                        pathStr = "关"
                    }

                }else if index == 1{
                    if p.on == true{
                        pathStr = "彩灯开"
                    }
                }
                cell.pathLabel.text = pathStr
            }

        }else if device!.type == 1{
            
            for p in powerArr!{
                pathStr += " \(p.way + 1)路"
            }

            cell.pathLabel.text = pathStr
        }else{
            cell.pathLabel.isHidden = true
        }

        
        if timerDevice!.type != 254 && timerDevice!.type != 0x17{
            if powerArr?[0].on == true{
                turnStr += "开"
            }else{
                
                if device!.type == 0x10{
                    turnStr += "合"
                }else{
                    turnStr += "关"
                }
                
            }
        }


        var hourStr:String = ""
        var minuteStr:String = ""
        if hour < 10{
            hourStr += "0\(hour)"
        }else{
            hourStr += "\(hour)"
        }
        if minute < 10{
            minuteStr += "0\(minute)"
        }else{
            minuteStr += "\(minute)"
        }

        cell.btn_back.setBackgroundImage(DeviceUtil.getTimerTimeImage(hour), for: UIControlState())
        cell.timerLabel.text = "\(hourStr):\(minuteStr) \(turnStr)"

        let day = timerTask?.value(forKey: "day") as! [Bool]
        var repeatCount = 0
        var repeatStr = ""
        for (index,d) in day.enumerated(){
            if d == true{
                repeatStr += DeviceUtil.getDayByInt(index)
            }else{
                repeatCount += 1
            }
        }

        if repeatCount == 7{
            cell.weekLabel.text = "不重复"
        }else{
            cell.weekLabel.text = repeatStr
        }

        cell.btn_back.addTarget(self, action: #selector(TimerListVC.detailClick(_:)), for: UIControlEvents.touchUpInside)
        cell.btn_back.tag = (indexPath as NSIndexPath).row
        cell.btn_detail.addTarget(self, action: #selector(TimerListVC.detailClick(_:)), for: UIControlEvents.touchUpInside)
        cell.btn_detail.tag = (indexPath as NSIndexPath).row

        cell.timerSwitch.isOn = timerTask?.value(forKey: "enabled") as! Bool


        self.navigationItem.rightBarButtonItem!.title = "编辑"
        cell.timerSwitch.alpha = 1
        cell.switchBottomImg.alpha = 1

        cell.timerSwitch.addTarget(self, action: #selector(TimerListVC.turnTimerStatu(_:)), for: UIControlEvents.valueChanged)
        cell.timerSwitch.tag = (indexPath as NSIndexPath).row

        return cell
    }

    //添加定时器   传要添加定时器的设备给下个界面
    func addTimer(_ sender:UIButton){
//        if self.device?.type == 254 {
//            let airConditionTimerVC = AirTranDeviceTimerVC()
//            airConditionTimerVC.ctrlinfo = self.device!
//            self.navigationController?.pushViewController(airConditionTimerVC, animated: true)
//            return
//        }
//
//
//        if self.device?.type == 0x0A || self.device?.type == 0x05 {
//            let airConditionTimerVC = Air24GDeviceTimerVC()
//            airConditionTimerVC.ctrlinfo = self.device!
//            self.navigationController?.pushViewController(airConditionTimerVC, animated: true)
//            return
//        }
//
//
//        if self.device?.type == 0x17{
//
//        }
//
//
//        if (self.device!.type == 1 || self.device!.type == 0x0B || self.device!.type == 0x0C) && self.device!.power.count > 1 && self.device!.type != 0x10{
//            let setTimerVC = SetTimerVC()
//            setTimerVC.powerCount = self.device!.power.count
//            setTimerVC.ctrlInfo = self.device!
//            self.navigationController!.pushViewController(setTimerVC, animated: true)
//
//        }else{
//            let story = UIStoryboard(name: "Main", bundle: nil)
//            let setTimerVC2 = story.instantiateViewController(withIdentifier: "setTimer2") as! SetTimerVC2
//            setTimerVC2.ctrlinfo =  self.device
//            self.navigationController!.pushViewController(setTimerVC2, animated: true)
//        }

    }

    //修改定时器   传定时器信息给下个界面
    func detailClick(_ sender:UIButton){
        if self.navigationItem.rightBarButtonItem?.title == "编辑"{
            return
        }

//        if self.device?.type == 254 {
//            let airConditionTimerVC = AirTranDeviceTimerVC()
//            airConditionTimerVC.timerInfo = self.timerList.object(at: sender.tag) as? TimerInfo
//            let timerTask = (self.timerList.object(at: sender.tag) as! TimerInfo).schedinfo
//            airConditionTimerVC.timerId = timerTask?.value(forKey: "id") as? String
//            self.navigationController?.pushViewController(airConditionTimerVC, animated: true)
//            return
//        }
//
//        if self.device?.type == 0x0A || self.device?.type == 0x05 {
//            let airConditionTimerVC = Air24GDeviceTimerVC()
//            airConditionTimerVC.timerInfo = self.timerList.object(at: sender.tag) as? TimerInfo
//            let timerTask = (self.timerList.object(at: sender.tag) as! TimerInfo).schedinfo
//            airConditionTimerVC.timerId = timerTask?.value(forKey: "id") as? String
//            self.navigationController?.pushViewController(airConditionTimerVC, animated: true)
//            return
//        }


//        if (self.device!.type == 1 || self.device!.type == 0x0B || self.device!.type == 0x0C ) && self.device!.power.count > 1 && self.device!.type != 0x10{
//            let setTimerVC = SetTimerVC()
//            setTimerVC.timerInfo = self.timerList.object(at: sender.tag) as? TimerInfo
//            setTimerVC.powerCount = self.device!.power.count
//            self.navigationController!.pushViewController(setTimerVC, animated: true)
//        }else{
            let story = UIStoryboard(name: "Main", bundle: nil)
            let setTimerVC2 = story.instantiateViewController(withIdentifier: "setTimer2") as! SetTimerVC2
            let timerTask = (self.timerList.object(at: sender.tag) as! TimerInfo).schedinfo
            setTimerVC2.timerId = timerTask?.value(forKey: "id") as? String
            setTimerVC2.timerInfo = self.timerList.object(at: sender.tag) as? TimerInfo

            self.navigationController!.pushViewController(setTimerVC2, animated: true)
//        }
    }



    func turnTimerStatu(_ sender:UISwitch){
        let timerTask = (self.timerList.object(at: sender.tag) as! TimerInfo).schedinfo
        let ctrlinfo = (self.timerList.object(at: sender.tag) as! TimerInfo).ctrlinfo

        timerTask?.enabled = sender.isOn

        let cmd20 = CMD20_ModifyTimer(schedinfo: timerTask, ctrlinfo: ctrlinfo)
        self.sm.sendCmd(cmd20)

    }

    deinit{
        print("定时列表销毁了")
    }

}

