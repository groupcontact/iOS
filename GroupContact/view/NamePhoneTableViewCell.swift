import UIKit

class NamePhoneTableViewCell: UITableViewCell {

    
    @IBOutlet weak var avatarLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    var user: UserAO? {
        didSet {
            if let u = user {
                phoneLabel.text = u.phone
                let name = u.name
                let color = ColorUtils.colorOf(u.name)
                nameLabel.text = name
                avatarLabel.backgroundColor = color
                avatarLabel.text = name.substringFromIndex(name.endIndex.predecessor())
            }
        }
    }
}
