//
//  AoPacleView.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/26.
//  Copyright © 2018年 fortune. All rights reserved.
//

import UIKit
import RxSwift


protocol AoPlaceViewDelegate:NSObjectProtocol {
    
    func PlaceView(placeView:AoPlaceView,DidEditAt index:NSInteger)
    func PlaceView(placeView:AoPlaceView,DidAddDeviceAt index:NSInteger)
    func PlaceViewDidAddplace(placeView:AoPlaceView)
    
}


class AoPlaceView: AoBaseView {

    @IBOutlet weak var imgvplace: UIImageView!
    
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var btnAddDevice: UIButton!
    
    @IBOutlet weak var lbPlaceName: UILabel!
    
    @IBOutlet weak var btnAddNewPlace: UIButton!
    
    var index:NSInteger?
    
    let bag = DisposeBag()
    
    weak var delegate:AoPlaceViewDelegate?
    
    
    override func awakeFromNib() {
     
        self.btnEdit.rx.tap.subscribe  { [weak self](event : Event<()>) in
            print("Edit")
            self?.delegate?.PlaceView(placeView: self!, DidEditAt:  self!.index!)
            }.disposed(by: bag)
        self.btnAddDevice.rx.tap.subscribe  { [weak self](event : Event<()>) in
            print("AddDevice")
            self?.delegate?.PlaceView(placeView: self!, DidAddDeviceAt: self!.index!)
            }.disposed(by: bag)
        
        self.btnAddNewPlace.rx.tap.subscribe  { [weak self](event : Event<()>) in
            print("AddPlace")
            self?.delegate?.PlaceViewDidAddplace(placeView: self!)
            }.disposed(by: bag)
    }
    
    func setForLastView(){
        self.btnAddNewPlace.isHidden = false
        self.btnAddDevice.isHidden = true
        self.btnEdit.isHidden = true
        self.lbPlaceName.isHidden = true
    }
    func setForAddView(){
        self.btnAddNewPlace.isHidden = true
        self.btnAddDevice.isHidden = true
        self.btnEdit.isHidden = true
    }
    
    func setStatuWith(placeModel:AoPlaceModel?){
        if let _ = placeModel{
            self.lbPlaceName.text = placeModel!.placeName
            //根据房间名称取存本地的图片
            let image = AoPlaceManager.getImageFromLocal(key: placeModel!.placeName!)
            if let _ = image{
                self.imgvplace.image = image!
            }
        }
    }
    
    func setDefault(index:NSInteger){
        self.imgvplace.image = UIImage(named:AO_PLACE_IMAGE_NAME[index])
        self.lbPlaceName.text = AO_PLACE_DEFAULT_NAME[index]
    }
    
    deinit {
        print("房间视图销毁")
    }
}
