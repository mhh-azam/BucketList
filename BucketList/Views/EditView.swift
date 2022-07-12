//
//  EditView.swift
//  BucketList
//
//  Created by QBUser on 11/07/22.
//

import SwiftUI

struct EditView: View {

    @Environment(\.dismiss) var dismiss
    var location: Location
    let onSave: (Location) -> Void

    @State private var name: String
    @State private var description: String

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter Name", text: $name)
                    TextField("Enter description", text: $description)
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
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave

        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { _ in }
    }
}
