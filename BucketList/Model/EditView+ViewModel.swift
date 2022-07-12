//
//  EditView+ViewModel.swift
//  BucketList
//
//  Created by QBUser on 12/07/22.
//

import Foundation

extension EditView {
    @MainActor class ViewModel: ObservableObject {

        enum LoadingState {
            case loading, loaded, failed
        }

        var location: Location
        let onSave: (Location) -> Void

        @Published var name: String
        @Published var description: String

        @Published var pages = [Page]()
        @Published var loadingState = LoadingState.loading


        init(location: Location, onSave: @escaping (Location) -> Void) {
            self.location = location
            self.onSave = onSave

            _name = Published(initialValue: location.name)
            _description = Published(initialValue: location.description)
        }

        func findNearbyPlaces() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"

            guard let url = URL(string: urlString) else {
                print("Bad Url for String: \(urlString)")
                loadingState = .failed
                return
            }

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let places = try JSONDecoder().decode(Result.self, from: data)
                pages = places.query.pages.values.sorted()
                loadingState = .loaded
            } catch {
                print(error.localizedDescription)
                loadingState = .failed
            }
        }

        func updateLocation() {
            let updateLocation = Location(name: name, description: description, longitude: location.longitude, latitude: location.latitude)
            onSave(updateLocation)
        }
    }
}
