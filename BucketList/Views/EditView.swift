//
//  EditView.swift
//  BucketList
//
//  Created by QBUser on 11/07/22.
//

import SwiftUI

struct EditView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: ViewModel

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter Name", text: $viewModel.name)
                    TextField("Enter description", text: $viewModel.description)
                }

                Section("Near by places") {
                    switch viewModel.loadingState {
                        case .loading:
                            Text("Loading...")
                        case .loaded:
                            ForEach(viewModel.pages, id: \.pageid) { page in
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
                    viewModel.updateLocation()
                    dismiss()
                }
            }
            .task {
                await viewModel.findNearbyPlaces()
            }
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void) {
        _viewModel = StateObject(wrappedValue: ViewModel(location: location, onSave: onSave))
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
