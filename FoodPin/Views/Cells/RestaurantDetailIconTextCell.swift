//
//  RestaurantDetailIconTextCell.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/1/21.
//

import UIKit

class RestaurantDetailIconTextCell: UITableViewCell {

     @IBOutlet weak var iconImageView  : UIImageView!
     @IBOutlet weak var shortTextLabel: UILabel!{didSet{ shortTextLabel.numberOfLines = 0 }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(icon:String , text:String?){
        self.iconImageView.image = UIImage(systemName: icon)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        if let text = text {
            self.shortTextLabel.text = text
        }
        selectionStyle = .none
    }
    
}
