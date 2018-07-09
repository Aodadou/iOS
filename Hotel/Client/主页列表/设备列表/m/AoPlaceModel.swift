

import UIKit

class AoPlaceModel :NSObject{
    
    var placeName:String?
    var placeImageId:String?
    
    init(placeName:String,placeImageId:String) {
        super.init()
        self.placeName = placeName
        self.placeImageId = placeImageId
    }
    
}
