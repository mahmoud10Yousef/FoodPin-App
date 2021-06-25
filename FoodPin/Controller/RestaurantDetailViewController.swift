//
//  DetailsViewController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/1/21.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    //MARK: - Properities
    
    @IBOutlet weak var tableView    : UITableView!
    @IBOutlet weak var headerView   : RestaurantDetailHeaderView!
    @IBOutlet weak var rateItButton : UIButton!{ didSet{ rateItButton.layer.cornerRadius = 25.0 } }
    override var preferredStatusBarStyle: UIStatusBarStyle{ return  .lightContent }
    @IBOutlet weak var rateImageView: UIImageView!
    
    var restaurant                  = RestaurantMO()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureTableView()
        configureHeaderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: - Setup UI
    
    private func configureTableView(){
        tableView.delegate        = self
        tableView.dataSource      = self
        tableView.separatorStyle  = .none
        tableView.contentInsetAdjustmentBehavior = .never
        
        tableView.register(UINib(nibName: "RestaurantDetailIconTextCell", bundle: nil), forCellReuseIdentifier: "RestaurantDetailIconTextCell")
        tableView.register(UINib(nibName: "RestaurantDetailTextCell", bundle: nil), forCellReuseIdentifier: "RestaurantDetailTextCell")
        tableView.register(UINib(nibName: "RestaurantDetailSeparatorCell", bundle: nil), forCellReuseIdentifier: "RestaurantDetailSeparatorCell")
        tableView.register(UINib(nibName: "MapCell", bundle: nil), forCellReuseIdentifier: "MapCell")
        
    }
    
    private func configureViewController(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage  = UIImage()
        navigationController?.navigationBar.tintColor    = .white
    }
    
    private func configureHeaderView(){
        if let restaurantImage = restaurant.image {
            headerView.headerImageView.image    = UIImage(data: restaurantImage)
        }
        headerView.typeLabel.text           = restaurant.type
        headerView.nameLabel.text           = restaurant.name
        headerView.heartImageView.isHidden  = !restaurant.isVisited
        if let restaurantRating = restaurant.rating{
            rateImageView.image = UIImage(named: restaurantRating)
        }
    }
    
    //MARK: - Navigation
    
    private func navigateToMapViewController(){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MapViewController") as! MapViewController
        vc.restaurant = self.restaurant
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func rateRestaurant(_ sender: UIButton) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ReviewViewController") as! ReviewViewController
        vc.restaurant = restaurant
        vc.modalPresentationStyle = .fullScreen
        vc.rateImageBackClosure = { rateImage in
            self.rateImageView.image = UIImage(named: rateImage)
        }
        present(vc, animated: true, completion: nil)
    }
    
}

// MARK: - Table View data source

extension RestaurantDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailIconTextCell", for: indexPath) as! RestaurantDetailIconTextCell
            cell.configureCell(icon: "phone", text: restaurant.phone)
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailIconTextCell", for: indexPath) as! RestaurantDetailIconTextCell
            cell.configureCell(icon: "map", text: restaurant.location)
            return cell
            
        case 2 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailTextCell", for: indexPath) as! RestaurantDetailTextCell
            cell.configureCell(description: restaurant.summary ?? "")
            return cell
            
        case 3 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailSeparatorCell", for: indexPath) as! RestaurantDetailSeparatorCell
            cell.configureCell(title: "HOW TO GET HERE")
            return cell
        case 4 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
            cell.configure(address: restaurant.location)
            return cell
        default:
            fatalError("error instantiate table view  cell")
        }
    }
}

// MARK: - Table View delegate

extension RestaurantDetailViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 4 {
            navigateToMapViewController()
        }
    }
}


