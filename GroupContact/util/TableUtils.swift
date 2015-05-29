import Foundation

struct TableUtils {
    
    static func footerView(text: String) -> UIView {
        var footer = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 30))
        footer.backgroundColor = UIColor.clearColor()
        
        var label = UILabel(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 15))
        label.backgroundColor = UIColor.clearColor()
        label.text = text
        label.textColor = Let.TIP_COLOR
        label.font = label.font.fontWithSize(Let.TIP_SIZE)
        label.textAlignment = NSTextAlignment.Center
        
        footer.addSubview(label)
        footer.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: footer, attribute: NSLayoutAttribute.Bottom, multiplier: CGFloat(1.0), constant: CGFloat(0.0)))
        return footer
    }
}