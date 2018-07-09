

import Foundation


extension AoDeviceListVC:UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == svPlaceView {
            let thisContentOffsetX = scrollView.contentOffset.x
            let currentPage = Int(thisContentOffsetX / (screenWidth - 30))
            
            print("停在第\(currentPage)个房间")
            self.actionChangePlace(page: currentPage)
        }
    }
    
    func getCurrentPage() ->Int{
        let thisContentOffsetX = self.svPlaceView.contentOffset.x
        let currentPage = Int(thisContentOffsetX / (screenWidth - 30))
        return currentPage
    }
}
