//
//  LocationStorage.swift
//  LocationTracker
//
//  Created by Adam Kane on 29/09/2021.
//

import Foundation
import CoreData
import Combine

class LocationDataStorage: NSObject, ObservableObject {
    var locations = CurrentValueSubject<[Location], Never>([])
    private let locationFetchController: NSFetchedResultsController<Location>
    
    static let shared: LocationDataStorage = LocationDataStorage()
    
    private override init() {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        locationFetchController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                             managedObjectContext: PersistenceController.shared.container.viewContext,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        
        super.init()
        
        locationFetchController.delegate = self
        
        do {
            try locationFetchController.performFetch()
            locations.value = locationFetchController.fetchedObjects ?? []
        } catch {
            print("error fetching locations")
        }
    }
}

extension LocationDataStorage: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let locations = controller.fetchedObjects as? [Location] else { return }
        self.locations.value = locations
    }
}
