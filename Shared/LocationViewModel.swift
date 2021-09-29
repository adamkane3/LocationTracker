//
//  LocationViewModel.swift
//  LocationTracker
//
//  Created by Adam Kane on 29/09/2021.
//

import Foundation
import Combine
import MapKit


class LocationViewModel: ObservableObject {
    @Published var locations: [Location] = []
    @Published var mapRegion: MKCoordinateRegion
    
    private var cancellable: AnyCancellable?
    private var locationUpdater: LocationPublisher!
    
    init(locationDataPublisher: AnyPublisher<[Location], Never> = LocationDataStorage.shared.locations.eraseToAnyPublisher()) {
        locationUpdater = LocationPublisher()
        mapRegion = MKCoordinateRegion(center: locationUpdater.lastLocation?.coordinate ?? CLLocationCoordinate2D(), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        cancellable = locationDataPublisher.sink(receiveValue: { locations in
            self.locations = locations
        })
        
        
    }
}
