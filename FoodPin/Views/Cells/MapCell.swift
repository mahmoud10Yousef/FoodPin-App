//
//  MapCell.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/2/21.
//

import UIKit
import MapKit
class MapCell: UITableViewCell {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(address: String?){
        guard let address = address else{return}
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString( address) { (placemarks, error) in
            
            if let error = error{
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks{
                
                let placemark = placemarks[0]
                
                if let location = placemark.location{
                    // add annotation
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    // set region
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
                    self.mapView.setRegion(region, animated: true)
                }
                
            }
        }
    }
    
}
