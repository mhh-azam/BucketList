//
//  ContentView.swift
//  BucketList
//
//  Created by QBUser on 09/07/22.
//

import MapKit
import SwiftUI

struct ContentView: View {

    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))

    @State private var locations = [Location]()
    @State private var selectedLocation: Location?

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())

                        Text(location.name)
                    }
                    .onTapGesture {
                        selectedLocation = location
                    }
                }
            }
                .ignoresSafeArea()

            Circle()
                .fill(.blue.opacity(0.3))
                .frame(width: 32, height: 32)

            VStack {

                Spacer()

                HStack {

                    Spacer()

                    Button {
                        let newLocation = Location(name: "New Location", description: "desc", longitude: mapRegion.center.longitude, latitude: mapRegion.center.latitude)
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding([.horizontal, .bottom])
                }
            }
        }
        .sheet(item: $selectedLocation) { location in
            EditView(location: location) { newLocation in
                if let index = locations.firstIndex(of: location) {
                    locations[index] = newLocation
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
