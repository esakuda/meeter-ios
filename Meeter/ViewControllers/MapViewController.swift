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
    
    @IBOutlet weak var mapView: GMSMapView!
    var viewModel : MapViewModel = MapViewModel();
    
    let minZoom : Float = 12
    let maxZoom : Float = 15
    let startingZoom : Float = 13
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeGoogleMaps()
        self.initializeLocationManager()
        self.registerForNotifications()
    }
    
    // MARK: - Initializers
    
    func initializeLocationManager() {
        self.viewModel.mapBoundsDelegate = self
        self.viewModel.enableMyLocation({ self.mapView.myLocationEnabled = true }, failure: { self.mapView.myLocationEnabled = false })
    }
    
    func initializeGoogleMaps() {
        self.mapView.delegate = self
        self.mapView.setMinZoom(minZoom, maxZoom: maxZoom)
//        self.mapView.settings.scrollGestures = false;
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
        NSNotificationCenter.defaultCenter().addObserverForName(viewModel.didUpdateUserLocations, object: nil, queue: NSOperationQueue.mainQueue(), usingBlock: { notification in
            for markerViewModel in self.viewModel.markers {
                markerViewModel.marker.map = self.mapView
            }
        })
    }
    
    func getSouthWest() -> CLLocationCoordinate2D {
        return self.mapView.projection.visibleRegion().nearLeft
    }
    
    func getNorthEast() -> CLLocationCoordinate2D {
        return self.mapView.projection.visibleRegion().farRight
    }

}
