//
//  ConetntView+ViewModel.swift
//  BucketList
//
//  Created by QBUser on 12/07/22.
//

import MapKit
import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))

        @Published private(set) var locations = [Location]()
        @Published var selectedLocation: Location?

        func addLocation() {
            let newLocation = Location(name: "New Location", description: "", longitude: mapRegion.center.longitude, latitude: mapRegion.center.latitude)
            locations.append(newLocation)
        }

        func updateLocation(_ location: Location) {
            guard let selectedLocation = selectedLocation else { return }

            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
            }
        }
    }
}
