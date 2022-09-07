//
//  OptionCel.swift
//  templates1
//
//  Created by Igor Jovcevski on 17.7.22.
//

import UIKit

class OptionCel: UITableViewCell {

    @IBOutlet weak var optionTitleLabel: UILabel!
    @IBOutlet weak var optionTitleBtn: UIButton!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
