//
//  MapViewController.swift
//  FoodPin
//
//  Created by Mahmoud Ghoneim on 2/2/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    //MARK: - properities
    
    var restaurant = RestaurantMO()
    @IBOutlet weak var mapview: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRstaurantLocation()
        configureMapView()
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Setup UI
    
    private func configureMapView(){
        mapview.delegate     = self
        mapview.showsScale   = true
        mapview.showsTraffic = true
        mapview.showsCompass = true
    }
    
    private func configureAnnotation(for location: CLLocation){
        let annotation        = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title      = restaurant.name
        annotation.subtitle   = restaurant.type
        mapview.showAnnotations([annotation], animated: true)
        mapview.selectAnnotation(annotation, animated: true)
    }
    
    //MARK: - Helper
    
    
    @IBAction func backbuttonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getRstaurantLocation(){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location ?? "") { [self] placemarks, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let placemarks = placemarks{
                let placemark = placemarks[0]
                if let location = placemark.location{
                    configureAnnotation(for: location)
                }
            }
        }
    }
}

extension MapViewController : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if  annotation.isKind(of: MKUserLocation.self) { return nil }
        let identifier = "annotation"
        
        var annotationview: MKMarkerAnnotationView? = mapview.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if annotationview == nil {
            annotationview = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationview!.markerTintColor = UIColor.orange
        annotationview!.glyphText = "😋"
        
        return annotationview
    }
}
