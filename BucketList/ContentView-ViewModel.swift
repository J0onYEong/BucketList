//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/17.
//

import MapKit
import LocalAuthentication

extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        // ulsan Univ  35.5437411, 129.2562843
        @Published var center = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.5437411, longitude: 129.2562843)
                                                       , span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        @Published private(set) var locations: [Location]
        // Boolean value for state of authentication
        @Published private(set) var isUnlocked = false
        // They will show alert widow when authentication fails
        @Published var showingAlert = false
        @Published private(set) var alertTitle = ""
        @Published private(set) var alertMessage = ""
        
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
        
        func updateLocations(oldValue: Location, newValue: Location) {
            if let index = locations.firstIndex(of: oldValue) {
                locations[index] = newValue
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
        
        // biometric authentication
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                // reason for Touch ID
                let reason = "We need it to unlock places data"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                    // Authentication success
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        // authentication fails
                    }
                    // 기타 오류
                    if let unwrappedError = error {
                        Task { @MainActor in
                            self.alertTitle = "인증 오류"
                            self.alertMessage = unwrappedError.localizedDescription
                            self.showingAlert = true
                        }
                    }
                }
            } else {
                // Device isn't capable of biometric authentication
                Task { @MainActor in
                    self.alertTitle = "생체 인증 사용불가"
                    self.alertMessage = "생체 인증을 사용할 수 없는 기기입니다."
                    self.showingAlert = true
                }
            }
        }
    }
}
