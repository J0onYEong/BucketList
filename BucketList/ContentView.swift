//
//  ContentView.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/10.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    // ulsan Univ  35.5437411, 129.2562843
    @State private var center = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.5437411, longitude: 129.2562843)
                                                   , span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @State private var locations = [Location]()
    // Sheet
    @State private var sheetItem: Location?
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $center, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                        Text(location.name)
                            .font(.caption)
                            .fixedSize()
                    }
                    .onTapGesture {
                        sheetItem = location
                    }
                }
            }
            .ignoresSafeArea()
            .zIndex(0)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        // test
                        locations.append(Location.exampleIns)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.gray.opacity(0.5))
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .padding(.trailing)

                }
            }
            .zIndex(1)
            // Center cross head
            ZStack {
                Rectangle()
                    .frame(width: 1.5, height: 30)
                Rectangle()
                    .frame(width: 30, height: 1.5)
            }
            .opacity(0.75)
            .foregroundColor(.gray)
            .zIndex(2)
        }
        .sheet(item: $sheetItem) { item in
            EditView(target: item) { loc in
                if let index = locations.firstIndex(of: item) {
                    locations[index] = loc
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
