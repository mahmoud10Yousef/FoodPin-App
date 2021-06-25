//
//  AboutTableViewController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/17/21.
//

import UIKit
import SafariServices

class AboutTableViewController: UITableViewController {
    
    // MARK: - Properities
    
    var sectionTitles = ["Feedback", "Follow Us"]
    
    var sectionContent = [
        [(image:"store" , text:"Rate us on App Store" , link:"https://www.apple.com/ios/app-store/") , (image: "chat" , text: "Tell us your feedback" , link: "http://www.appcoda.com/contact")
        ] ,
        [(image: "twitter" , text: "Twitter" , link:"https://twitter.com/appcodamobile" ),(image: "facebook" , text: "facebook" , link:"https://facebook.com/appcodamobile"),(image: "instagram" , text: "Instagram" , link:"https://www.instagram.com/appcodadotcom")
        ] ]
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigationBar()
    }
    
    // MARK: - Setup UI
    
    private func configureTableView(){
        tableView.tableFooterView = UIView()
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    private func configureNavigationBar(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        if let customFont = UIFont(name: "Rubik-Medium", size: 40.0) {
            navigationController?.navigationBar.largeTitleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor(red: 231, green: 76, blue: 60), NSAttributedString.Key.font: customFont ]
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContent[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell" ,for: indexPath)
        let cellData = sectionContent[indexPath.section][indexPath.row]
        
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cellData.text
        cell.imageView?.image = UIImage(named: cellData.image)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    // MARK: - Table view Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let link = sectionContent[indexPath.section][indexPath.row].link
        guard let url = URL(string: link) else {return}
        
        presentSafariVC(url: url)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation
    private func presentSafariVC(url:URL){
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    
}
