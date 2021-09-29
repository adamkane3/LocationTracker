//
//  LocationPublisher.swift
//  LocationStuff
//
//  Created by Adam Kane on 28/09/2021.
//

import Foundation
import CoreLocation
import Combine

class LocationPublisher: NSObject {
    
    private let locationManager = CLLocationManager()
    var lastLocation: CLLocation?
    typealias Output = (longtitude: Double, latitude: Double)
    typealias Failure = Never
    
    var cancellable: AnyCancellable?
    
    let wrapped = PassthroughSubject<(Output), Failure>()
    
    override init() {
        super.init()
        self.lastLocation = self.locationManager.location
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        cancellable = self.sink { [self] (longtitude: Double, latitude: Double) in
            let location = Location(context: PersistenceController.shared.container.viewContext)
            location.longitude = longtitude
            location.latitude = latitude
            location.timestamp = Date()
            
            do {
                try PersistenceController.shared.container.viewContext.save()
            } catch {
                _ = self.print("Failed to save location")
            }
        }
    }
}

extension LocationPublisher: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        wrapped.send((longtitude: location.coordinate.longitude, latitude: location.coordinate.latitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
}

extension LocationPublisher: Publisher {
    func receive<Downstream: Subscriber>(subscriber: Downstream) where Failure == Downstream.Failure, Output == Downstream.Input {
        wrapped.subscribe(subscriber)
    }
}
