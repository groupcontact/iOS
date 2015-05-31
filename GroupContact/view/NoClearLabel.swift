import UIKit

/*
 * 避免当UILabel高亮时没有了背景颜色
 */
class NoClearLabel: UILabel {

    override var backgroundColor: UIColor? {
        set {
            // 什么都不做
        }
        get {
            return super.backgroundColor
        }
    }
    
    var myBackgroundColor: UIColor? {
        set {
            super.backgroundColor = newValue
        }
        get {
            return super.backgroundColor
        }
    }

}
