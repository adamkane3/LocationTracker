//
//  ContentView.swift
//  Shared
//
//  Created by Adam Kane on 29/09/2021.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    
    
    @ObservedObject private var viewModel = LocationViewModel()

    var body: some View {
        VStack{
            Map(coordinateRegion: $viewModel.mapRegion,
                interactionModes: .all,
                showsUserLocation: true,
                userTrackingMode: .constant(.none),
                annotationItems: viewModel.locations) { location in
                
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                    Circle().fill(Color.blue).frame(width: 10, height: 10)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
