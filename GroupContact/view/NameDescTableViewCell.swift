import UIKit

class NameDescTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    
    var group: GroupAO? {
        didSet {
            if let g = group {
                descLabel.text = g.desc
                let name = g.name
                let color = ColorUtils.colorOf(name)
                nameLabel.text = name
                avatarLabel.backgroundColor = color
                avatarLabel.text = name.substringToIndex(name.startIndex.successor())
            }
        }
    }
}
