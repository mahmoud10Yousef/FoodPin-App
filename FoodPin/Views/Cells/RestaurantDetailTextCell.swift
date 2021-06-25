//
//  RestaurantDetailTextCell.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/1/21.
//

import UIKit

class RestaurantDetailTextCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!{ didSet {descriptionLabel.numberOfLines = 0 }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(description:String){
        self.descriptionLabel.text = description
        selectionStyle             = .none
    }
    
}
