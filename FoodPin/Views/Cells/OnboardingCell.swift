//
//  OnboardingCell.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/6/21.
//

import UIKit

class OnboardingCell: UICollectionViewCell {
     
    
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var heading            : UILabel!
    @IBOutlet weak var subHeading         : UILabel!
    
    
    func configureCell(for onboarding: Onboarding){
        onboardingImageView.image = UIImage(named: onboarding.imageFile)
        heading.text              = onboarding.heading
        subHeading.text           = onboarding.subHeading
    }
    
}
