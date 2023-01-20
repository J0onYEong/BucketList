//
//  ContentView.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/10.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()
    @State var selectedLocation: Location?
    @State private var center = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.5437411, longitude: 129.2562843)
                                                   , span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
    var body: some View {
        ZStack {
            if viewModel.isUnlocked {
                Map(coordinateRegion: $center, annotationItems: viewModel.locations) { location in
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
                            selectedLocation = location
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
                            viewModel.addLocation()
                        } label: {
                            Image(systemName: "plus")
                                .border(.red)
                                .padding()
                                .background(.gray.opacity(0.5))
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .padding(.trailing)
                        }

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
            else {
                Button("authenticate") {
                    viewModel.authenticate()
                }
                .frame(width: 200, height: 100)
                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
            }
        }
        .sheet(item: $selectedLocation) { item in
            EditView(location: item) {
                guard let unwrappedValue = selectedLocation else {
                    print("selectedLocation is nil")
                    return
                }
                viewModel.updateLocations(oldValue: unwrappedValue, newValue: $0)
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showingAlert) {
            HStack {
                Button("닫기") {}
                Button("재시도") { viewModel.authenticate() }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
