//
//  OnboardingViewController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/6/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    //MARK: - Properities
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!{ didSet{ nextButton.layer.cornerRadius = 25.0 } }
    @IBOutlet weak var skipButton: UIButton!
    var currentIndex = 0
    let onboardingData:[Onboarding] = [
        Onboarding(imageFile: "onboarding-1", heading: "CREATE YOUR OWN FOOD GUIDE", subHeading:"Pin your favorite restaurants and create your own food guide") ,
        Onboarding(imageFile: "onboarding-2", heading: "SHOW YOU THE LOCATION", subHeading: "Search and locate your favourite restaurant on Maps") ,
        Onboarding(imageFile: "onboarding-3", heading: "DISCOVER GREAT RESTAURANTS", subHeading: "Find restaurants shared by your friends and other foodies")
    ]
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate   = self
        collectionView.dataSource = self
        pageControl.currentPage   = currentIndex
        pageControl.numberOfPages = onboardingData.count
    }
    
    private func updateUI(){
        
    }
    
    //MARK: - Actions
    
    @IBAction func showNextView(_ sender: UIButton) {
        currentIndex += 1
        if currentIndex == 3 {
            navigateToHomeScreen()
            return
        }
        collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func skipOnbardingScreen(_ sender: UIButton) {
       navigateToHomeScreen()
    }
    
    //MARK: - Navigation
    
    private func navigateToHomeScreen(){
        seeOnboarding()
        let mainTabBar = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainTabBarController")
        mainTabBar.modalPresentationStyle = .fullScreen
        mainTabBar.modalTransitionStyle   = .flipHorizontal
        present(mainTabBar, animated: true)
    }
    
    private func seeOnboarding(){
        UserDefaults.standard.setValue(true, forKey: "isOnboardingSeen")
        UserDefaults.standard.synchronize()
    }
}

//MARK: - Collection view Delegates

extension OnboardingViewController : UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCell
        cell.configureCell(for: onboardingData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        pageControl.currentPage = currentIndex
        
        switch currentIndex {
        case 0...1:
            nextButton.setTitle("NEXT", for: .normal)
            skipButton.isHidden = false
        case 2:
            nextButton.setTitle("GET STARTED", for: .normal)
            skipButton.isHidden = true
        default:
            break
        }
    }
}

extension OnboardingViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
