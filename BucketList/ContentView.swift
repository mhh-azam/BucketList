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

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion)
                .ignoresSafeArea()

            Circle()
                .foregroundColor(.blue.opacity(0.3))
                .frame(width: 44, height: 44)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
