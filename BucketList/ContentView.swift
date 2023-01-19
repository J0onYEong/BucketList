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
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewModel.center, annotationItems: viewModel.locations) { location in
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
                        viewModel.updateSelectedLocation(location: location)
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
        .sheet(item: $viewModel.selectedLocation) { item in
            EditView(target: item) {
                viewModel.updateLocations(location: $0)
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
