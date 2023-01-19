//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/17.
//

import MapKit

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        // ulsan Univ  35.5437411, 129.2562843
        @Published var center = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.5437411, longitude: 129.2562843)
                                                       , span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        @Published private(set) var locations: [Location]
        @Published var selectedLocation: Location?
        
        let savePath = FileManager.documentDirectory.appendingPathComponent("Locations")
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func addLocation() {
            locations.append(Location.exampleIns)
            // save
            save()
        }
        
        func updateSelectedLocation(location: Location) {
            selectedLocation = location
        }
        
        func updateLocations(location updatedLocation: Location) {
            guard let selectedLoc = selectedLocation else {
                print("there is no selected location")
                return
            }
            if let index = locations.firstIndex(of: selectedLoc) {
                locations[index] = updatedLocation
            }
            
            // save
            save()
        }
        
        private func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
    }
}
