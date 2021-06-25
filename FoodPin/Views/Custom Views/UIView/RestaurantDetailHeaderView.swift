//
//  RestaurantDetailHeaderView.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/1/21.
//

import UIKit

class RestaurantDetailHeaderView: UIView {
    
    @IBOutlet var headerImageView : UIImageView!
    @IBOutlet var nameLabel       : UILabel!{didSet{nameLabel.numberOfLines = 0}}
    @IBOutlet var heartImageView  : UIImageView!{
        didSet{
            // change tint color of image view
            heartImageView.image     = UIImage(named: "heart-tick")?.withRenderingMode(.alwaysTemplate)
            heartImageView.tintColor = .white
        }
    }
    
    @IBOutlet var typeLabel: UILabel!{
        didSet{
            typeLabel.layer.cornerRadius = 5
            typeLabel.clipsToBounds      = true
        }
    }
}
