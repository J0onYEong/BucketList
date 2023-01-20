//
//  EditView-ViewModel.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/20.
//

import Foundation

extension EditView {
    @MainActor class ViewModel: ObservableObject {
        enum LoadingState {
            case loading, loaded, failed
        }
        
        @Published var targetLocation: Location
        @Published var name: String
        @Published var description: String
        @Published private(set) var pages: [Page]
        @Published private(set) var loadingState: LoadingState
        
        
        init(location: Location) {
            targetLocation = location
            name = location.name
            description = location.description
            pages = []
            loadingState = .loading
        }
        
        func setLocation(target: Location) async {
            targetLocation = target
            name = target.name
            description = target.description
            await fetchNearbyPlace()
        }
        
        func updatedLocation() -> Location {
            var loc = targetLocation
            loc.id = UUID()
            loc.name = name
            loc.description = description
            return loc
        }
        
        func fetchNearbyPlace() async {
            let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(targetLocation.coordinate.latitude)%7C\(targetLocation.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
            
            guard let url = URL(string: urlString) else {
                print("bad url")
                return;
            }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedData = try JSONDecoder().decode(Result.self, from: data)
                pages = decodedData.query.pages.values.sorted()
                loadingState = .loaded
            }
            catch {
                loadingState = .failed
            }
        }
    }
}
