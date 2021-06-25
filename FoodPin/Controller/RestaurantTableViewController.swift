//
//  RestaurantTableViewController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 1/31/21.
//

import UIKit
import CoreData

class RestaurantTableViewController: UITableViewController {
    
    //MARK: - Properites
    
    @IBOutlet var emptyView: UIView!
    let cellIdentifier = "RestaurantTableViewCell"
    var searchController: UISearchController!
    var searchResults:[RestaurantMO] = []
    var restaurants:[RestaurantMO] = []
    var fetchResultController: NSFetchedResultsController<RestaurantMO>!
    //MARK: - App Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureViewController()
        configureTableView()
        fetchRestaurants()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = true
    }
    
    //MARK: - Setup UI
    
    private func configureTableView(){
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.backgroundView  = emptyView
        emptyView.isHidden        = true
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    private func configureViewController(){
        // make navigation bar transparent
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        // customize nav bar large title
        let customFont = UIFont(name: "Rubik-Medium", size: 40.0)
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.init(red: 231, green: 76, blue: 60) , NSAttributedString.Key.font: customFont!]
    }
    
    func configureSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater      = self
        searchController.searchBar.placeholder     = "Search restaurant..."
        searchController.searchBar.tintColor       = UIColor(red: 231, green: 76, blue: 60)
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor    = .white
        navigationItem.searchController            = searchController
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        emptyView.isHidden = restaurants.count > 0
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchController.isActive ? searchResults.count : restaurants.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RestaurantTableViewCell
        let restaurant = searchController.isActive ? searchResults[indexPath.row] : restaurants[indexPath.row]
        cell.configureCell(restaurant: restaurant)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !searchController.isActive
    }
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = searchController.isActive ? searchResults[indexPath.row] : restaurants[indexPath.row]
        navigationToDetailVC(for: restaurant)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            
            let restaurantToDelete = fetchResultController.object(at: indexPath)
            context.delete(restaurantToDelete)
            do{
                try context.save()
            }catch{
                print(error.localizedDescription)
            }
            completion(true)
        }
        
        let shareAction        = UIContextualAction(style: .normal, title: "Share") { (action, view, completion) in
            let defaultText        = "just checking in at " + self.restaurants[indexPath.row].name!
            let activityController:UIActivityViewController!
            
            if let restaurantImage = self.restaurants[indexPath.row].image ,let imageToShare  = UIImage(data: restaurantImage as Data){
                activityController = UIActivityViewController(activityItems: [defaultText , imageToShare], applicationActivities: nil)
            }else{
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            self.present(activityController, animated: true, completion: nil)
            completion(true)
        }
        
        deleteAction.backgroundColor = UIColor.init(red: 231, green: 76, blue: 60)
        deleteAction.image           = UIImage(systemName: "trash")
        
        shareAction.backgroundColor  = UIColor.init(red: 254, green: 149, blue: 38)
        shareAction.image            = UIImage(systemName: "square.and.arrow.up")
        
        let SwipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction , shareAction])
        SwipeConfiguration.performsFirstActionWithFullSwipe = false
        
        return SwipeConfiguration
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let checkInAction = UIContextualAction(style: .normal, title: nil) { (action, view, completion) in
            
            self.configureCheckIn(for: indexPath)
            completion(true)
        }
        let checkInIcon = restaurants[indexPath.row].isVisited ? "arrow.uturn.left" : "checkmark"
        checkInAction.backgroundColor = UIColor.init(red: 38, green: 162, blue: 78)
        checkInAction.image = UIImage(systemName: checkInIcon)
        
        let leadingSwipe = UISwipeActionsConfiguration(actions: [checkInAction])
        leadingSwipe.performsFirstActionWithFullSwipe = false
        return leadingSwipe
    }
    
    //MARK: - Helper
    
    private func configureCheckIn(for indexPath:IndexPath){
        let cell      = tableView.cellForRow(at: indexPath) as! RestaurantTableViewCell
        let isVisited = self.restaurants[indexPath.row].isVisited
        cell.heartImageView.isHidden              = isVisited
        self.restaurants[indexPath.row].isVisited = !isVisited
    }
    
    
    private func fetchRestaurants(){
        let fetchrequest:NSFetchRequest = RestaurantMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchrequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        do{
            try fetchResultController.performFetch()
            if let fetchedObjects =  fetchResultController.fetchedObjects{
                self.restaurants = fetchedObjects
             }
            }catch{
                print("error fetching data \(error.localizedDescription)")
            }
        }
        
    //MARK: - Navigation
    
    private func navigationToDetailVC(for restaurant:RestaurantMO){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RestaurantDetailViewController") as! RestaurantDetailViewController
        vc.restaurant = restaurant
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func navigateToNewRestaurant(_ sender: UIBarButtonItem) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewRestaurantController")
        present(vc, animated: true)
    }
}

//MARK: - Search Bar Delegates

extension RestaurantTableViewController : UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            searchResults = restaurants.filter({ $0.name!.localizedCaseInsensitiveContains(searchText)})
            tableView.reloadData()
        }
    }
}

//MARK: - fetch controller delegate

extension RestaurantTableViewController: NSFetchedResultsControllerDelegate{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            if let indexPath = indexPath{
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .insert:
            if let newIndexPath = newIndexPath{
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath{
                tableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            tableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects{
            self.restaurants = fetchedObjects as! [RestaurantMO]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
