//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/4/21.
//

import UIKit
import CoreData
class ReviewViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet var rateButtons: [UIButton]!
    var restaurant          = RestaurantMO()
    var delay:TimeInterval  = 0.1
    var rateImageBackClosure:((_ imageName:String)->())?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let restaurantImage = restaurant.image{
          backgroundImageView.image = UIImage(data: restaurantImage)
        }
        hideAllButtons()
        applyBackgroundBlurEffect()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateButtons()
    }
    
    //MARK: - Setup UI
    
    private func applyBackgroundBlurEffect(){
        let blurEffect       = UIBlurEffect(style: .dark)
        let blurEffectView   = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
    
    private func animateButtons(){
        for rateButton in rateButtons{
            animateSingleButton(sender: rateButton)
        }
    }
    
    private func hideAllButtons(){
        let rightTransform = CGAffineTransform(translationX: 1000, y: 0)
        for rateButton in self.rateButtons{
            rateButton.alpha = 0
            rateButton.transform = rightTransform
        }
    }
    
    // MARK: - Actions
    
    @IBAction func dismissViewController(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func rateButtontapped(_ sender: UIButton) {
        rateImageBackClosure?(sender.titleLabel!.text!)
        saveRating(rating:sender.titleLabel!.text!)
        dismiss(animated: true)
    }
    
    
    private func saveRating(rating:String){
        let fetch:NSFetchRequest = RestaurantMO.fetchRequest()
        do {
            let results = try context.fetch(fetch)
            for result in results{
                if result.name == restaurant.name{
                    result.rating = rating
                    print(result.rating!)
                    break
                }
            }
           try context.save()
            
        } catch{
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Helper
    
    private func animateSingleButton(sender: UIButton ){
        UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
            sender.alpha = 1
            sender.transform = .identity
        }, completion: nil)
        delay += 0.1
    }
}




