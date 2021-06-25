//
//  RestaurantDetailSeparatorCell.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/2/21.
//

import UIKit

class RestaurantDetailSeparatorCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(title:String){
        titleLabel.text = title
        selectionStyle = .none
    }
    
}
