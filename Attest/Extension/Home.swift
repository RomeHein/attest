// see https://stackoverflow.com/a/54607078
// thanks to matt

import UIKit

protocol Home : class {
    func comingHome()
}
protocol Away : class {
    var home : Home? {get set}
}
extension Away where Self : UIViewController {
    func notifyComingHome() {
        if self.isBeingDismissed || self.isMovingFromParent {
            self.home?.comingHome()
        }
    }
}
