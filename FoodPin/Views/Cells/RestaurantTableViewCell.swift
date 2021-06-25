//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 1/31/21.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!{
        didSet{
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.size.height / 2
            thumbnailImageView.clipsToBounds      = true
        }
    }
    
    @IBOutlet weak var heartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(restaurant:RestaurantMO){
        nameLabel.text           = restaurant.name
        locationLabel.text       = restaurant.location
        typeLabel.text           = restaurant.type
        heartImageView.isHidden  = !restaurant.isVisited
        if let restaurantImage   = restaurant.image{
            thumbnailImageView.image = UIImage(data: restaurantImage as Data)
        }
        
        
    }
    
    
}
