import Foundation
import UIKit

/*
 * 关于颜色使用的一些辅助方法
 */
struct ColorUtils {
    
    private static let MATERIAL = [
        UIColor(rgba: "#e57373"),
        UIColor(rgba: "#f06292"),
        UIColor(rgba: "#ba68c8"),
        UIColor(rgba: "#9575cd"),
        UIColor(rgba: "#7986cb"),
        UIColor(rgba: "#64b5f6"),
        UIColor(rgba: "#4fc3f7"),
        UIColor(rgba: "#4dd0e1"),
        UIColor(rgba: "#4db6ac"),
        UIColor(rgba: "#81c784"),
        UIColor(rgba: "#aed581"),
        UIColor(rgba: "#ff8a65"),
        UIColor(rgba: "#d4e157"),
        UIColor(rgba: "#ffd54f"),
        UIColor(rgba: "#ffb74d"),
        UIColor(rgba: "#a1887f"),
        UIColor(rgba: "#90a4ae")
    ]
    
    // 针对字符串给出颜色
    static func colorOf(key: String) -> UIColor {
        return MATERIAL[abs(Int(key.javaHashValue)) % MATERIAL.count]
    }
    
}

extension String {
    
    // 保证和Android版本一样的颜色
    var javaHashValue: Int64 {
        get {
            var hash: Int64 = 0
            if count(self) == 0 {
                return hash
            }
            for ch in self {
                let chs = String(ch).unicodeScalars
                let signed = Int64(bitPattern: UInt64(chs[chs.startIndex].value))
                hash = 31 * hash + signed
            }
            return hash
        }
    }
    
}