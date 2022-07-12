//
//  TableViewCell.swift
//  Eat Now
//
//  Created by Meet on 07/07/22.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var descriptionLabel : UILabel!
    @IBOutlet var productImageView : UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet var addToCartButton : UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
