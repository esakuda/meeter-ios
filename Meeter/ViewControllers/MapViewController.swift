//
//  MapViewController.swift
//  Meeter
//
//  Created by Damian on 8/1/15.
//  Copyright © 2015 Meeter. All rights reserved.
//

import UIKit
import GoogleMaps

protocol MapBoundsDelegate {
    func getNorthEast() -> CLLocationCoordinate2D
    func getSouthWest() -> CLLocationCoordinate2D
}

class MapViewController: UIViewController, GMSMapViewDelegate, MapBoundsDelegate {
    
    @IBOutlet weak var friendView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var mapView: GMSMapView!
    var viewModel : MapViewModel = MapViewModel()
    
    let minZoom : Float = 12
    let maxZoom : Float = 15
    let startingZoom : Float = 13
    var userViewModel : UserViewModel? = nil
    var selectedMarker : GMSMarker? = nil;
    var markersHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBarHidden = true
        self.view.layoutIfNeeded()
        self.friendView.alpha = 0
        self.friendView.layer.cornerRadius = 6
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.masksToBounds = true
        
        self.initializeGoogleMaps()
        self.initializeLocationManager()
        self.registerForNotifications()
        self.view.layoutIfNeeded()
        self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2
        self.settingsButton.backgroundColor = UIColor(red: 30/255.0, green: 139/255.0, blue: 216/255.0, alpha: 0.6)
        self.friendView.backgroundColor = UIColor(red: 98/255.0, green: 88/255.0, blue: 177/255.0, alpha: 0.6).colorWithAlphaComponent(0.7)
        self.friendView.addSubview(FacebookRepository().feedShareButton())
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.viewModel.stopUpdating()
    }
    
    override func viewWillAppear(animated: Bool) {
        if(self.viewModel.timer != nil) {
            self.viewModel.startUpdating()
        }
    }

    // MARK: - Initializers
    
    func initializeLocationManager() {
        self.viewModel.mapBoundsDelegate = self
        self.viewModel.enableMyLocation({ self.mapView.myLocationEnabled = true }, failure: { self.mapView.myLocationEnabled = false })
    }
    
    func initializeGoogleMaps() {
        self.mapView.delegate = self
        self.mapView.setMinZoom(minZoom, maxZoom: maxZoom)
        self.mapView.settings.scrollGestures = false
    }
    
    func registerForNotifications() {
        NSNotificationCenter.defaultCenter().addObserverForName(viewModel.firstLocationNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            let location : CLLocation = notification.userInfo!["location"] as! CLLocation
            self.mapView.camera = GMSCameraPosition.cameraWithTarget(location.coordinate, zoom: self.startingZoom)
        })
        NSNotificationCenter.defaultCenter().addObserverForName(viewModel.noAuthorizationNotification, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            let errorMessage : String = notification.userInfo!["message"] as! String
            print(errorMessage)
            self.view.makeToast(errorMessage, duration: 2.0, position: CSToastPositionBottom)
        })
        NSNotificationCenter.defaultCenter().addObserverForName(viewModel.nearFriends, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            if(!self.markersHidden) {
                print(notification.userInfo!["data"]!)
                let users : [User] = notification.userInfo!["data"]! as! [User]
                let publicity : String = notification.userInfo!["publicity"] as! String
                self.viewModel.markers = MarkerViewModel.mapToMarkers(users, publicity: publicity)
                for markerViewModel in self.viewModel.markers {
                    markerViewModel.marker.map = self.mapView
                }
            }
        })
    }
    
    func getSouthWest() -> CLLocationCoordinate2D {
        return self.mapView.projection.visibleRegion().nearLeft
    }
    
    func getNorthEast() -> CLLocationCoordinate2D {
        return self.mapView.projection.visibleRegion().farRight
    }
    
    func mapView(mapView: GMSMapView!, didTapMarker marker: GMSMarker!) -> Bool {
        self.selectedMarker = marker
        
        for savedMarker in self.viewModel.markers {
            if (savedMarker.marker.position.latitude  == marker.position.latitude && savedMarker.marker.position.longitude == marker.position.longitude) {
                self.nameLabel.text = savedMarker.user.name
                self.getReverseGeocoding(marker.position.latitude, longitude: marker.position.longitude, success: { (placemark : CLPlacemark) in
                    UIView.animateWithDuration(1.0, animations: {
                        self.friendView.alpha = 1
                    })
                })
            }
        }
        return true;
    }
    
    func mapView(mapView: GMSMapView!, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        self.selectedMarker = nil
        UIView.animateWithDuration(1.0, animations: {
            self.friendView.alpha = 0
        })
    }

    @IBAction func didPressFakeButton(sender: AnyObject) {
        for marker in self.viewModel.markers {
            marker.marker.map = markersHidden ? nil : self.mapView;
        }
        markersHidden = !markersHidden
    }
    
    func getReverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees, success: ((CLPlacemark) -> ())?) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print("Reverse geocoder failed")
                return
            }
            
            if placemarks != nil && placemarks!.count > 0 {
                let pm = placemarks![0]
                print(pm.locality)
                if success != nil {
                    success!(pm)
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
}
