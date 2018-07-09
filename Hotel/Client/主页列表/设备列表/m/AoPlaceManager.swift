//
//  AoPlaceManager.swift
//  Hotel
//
//  Created by 吴杰平 on 2018/6/26.
//  Copyright © 2018年 fortune. All rights reserved.
//

import Foundation

class AoPlaceManager: NSObject {
    
    //获取沙盒文件夹路径
    public class func documentsDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentationDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let documentsDirectory:String = paths.first!
        return documentsDirectory
    }
    //获取数据文件地址
    public class func dataFilePath ()->String{
        return AoPlaceManager.documentsDirectory().appending("Data.plist")
    }
    
    public class func getImagePath(key:String)->String{
        return AoPlaceManager.documentsDirectory() + "/Documents/" + key + ".png"
    }
    
    public class func saveImageToLocal(image:UIImage,key:String){

        let imgData = UIImageJPEGRepresentation(image, 0.5)! as NSData
        imgData.write(toFile: self.getImagePath(key: key), atomically: true)

    }
    
    public class func getImageFromLocal(key:String) -> UIImage?{
        if key == ""{
            return nil
        }
        let img = UIImage(contentsOfFile: AoPlaceManager.getImagePath(key: key))
        return img
    }
    
    public class func removeImageWithLocalKeys(key:String){
        do{
            try FileManager.default.removeItem(atPath: self.getImagePath(key: key))
        }catch{
            print(error)
        }
        
    }
}
