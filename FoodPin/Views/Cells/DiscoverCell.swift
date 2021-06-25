//
//  DiscoverCell.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/17/21.
//

import UIKit

class DiscoverCell: UITableViewCell {
    
    
    
 
    @IBOutlet weak var discoverImageView: UIImageView!{didSet{discoverImageView.layer.cornerRadius = 10.0}}
    @IBOutlet weak var name    : UILabel!
    @IBOutlet weak var type    : UILabel!
    @IBOutlet weak var address : UILabel!
    @IBOutlet weak var details : UILabel!
    @IBOutlet weak var phone   : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
    func configureCell(restaurant:Restaurant)  {
        discoverImageView.image = UIImage(named: restaurant.image)
        name.text    = restaurant.name
        type.text    = restaurant.type
        address.text = restaurant.location
        phone.text   = restaurant.phone
        details.text = restaurant.description
    }
}
