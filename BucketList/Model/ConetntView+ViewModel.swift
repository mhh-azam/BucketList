//
//  ConetntView+ViewModel.swift
//  BucketList
//
//  Created by QBUser on 12/07/22.
//

import MapKit
import LocalAuthentication
import Foundation

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))

        @Published private(set) var locations = [Location]()
        @Published var selectedLocation: Location?
        @Published var isUnlocked = false

        @Published private(set) var alertTitle = ""
        @Published private(set) var alertMessage = ""
        @Published var showAlert = false

        let savePath = FileManager.default.documentsDirectory.appendingPathComponent("SavedPlaces")

        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch  {
                locations = []
            }
        }

        func addLocation() {
            let newLocation = Location(name: "New Location", description: "", longitude: mapRegion.center.longitude, latitude: mapRegion.center.latitude)
            locations.append(newLocation)
            save()
        }

        func updateLocation(_ location: Location) {
            guard let selectedLocation = selectedLocation else { return }

            if let index = locations.firstIndex(of: selectedLocation) {
                locations[index] = location
                save()
            }
        }

        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic,.completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }

        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    }
                    else {
                        Task { @MainActor in
                            self.alertTitle = "Authentication Failed!"
                            self.alertMessage = "Biometric authentication failed."
                            self.showAlert = true
                        }
                    }
                }
            } else {
                print("No biometrics")
            }
        }
    }
}
