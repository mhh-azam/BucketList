//
//  EditView.swift
//  BucketList
//
//  Created by QBUser on 11/07/22.
//

import SwiftUI

struct EditView: View {

    enum LoadingState {
    case loading, loaded, failed
    }

    @Environment(\.dismiss) var dismiss
    var location: Location
    let onSave: (Location) -> Void

    @State private var name: String
    @State private var description: String

    @State private var pages = [Page]()
    @State private var loadingState = LoadingState.loading

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter Name", text: $name)
                    TextField("Enter description", text: $description)
                }

                Section("Near by places") {
                    switch loadingState {
                        case .loading:
                            Text("Loading...")
                        case .loaded:
                            ForEach(pages, id: \.pageid) { page in
                                Text(page.title)
                                    .font(.headline)
                                + Text(": ")
                                + Text(page.description)
                                    .italic()
                            }
                        case .failed:
                            Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Edit Location")
            .toolbar {
                Button("Save") {
                    dismiss()
                    let updateLocation = Location(name: name, description: description, longitude: location.longitude, latitude: location.latitude)
                    onSave(updateLocation)
                }
            }
            .task {
                await findNearbyPlaces()
            }
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
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
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
