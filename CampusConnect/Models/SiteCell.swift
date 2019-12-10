//
//

import UIKit


/**
    Cell that holds the name data in the chat list.
    - Author: Laura Gonzalez
*/
class SiteCell: UITableViewCell {

    @IBOutlet var primaryLabel : UILabel!

    /**
        UITableViewCell inherited method awakeFromNib.
    */
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    /**
        UITableViewCell inherited method setSelected.
        - Parameter selected: Boolean of whether the cell is selected.
        - Parameter animated: Boolean of whether to animate the cell.
    */
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
