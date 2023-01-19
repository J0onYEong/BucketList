//
//  EditView.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/16.
//

import SwiftUI

struct EditView: View {
    // native
    enum LoadingState {
        case loading, loaded, failed
    }
    // parameter
    var location: Location
    var onSave: (Location) -> ()
    //
    @Environment(\.dismiss) var dismiss
    @State private var name: String
    @State private var description: String
    @State private var pages = [Page]()
    @State private var loadingState: LoadingState = .loading

    
    init(target: Location, onSave: @escaping (Location) -> ()) {
        location = target
        _name = State(initialValue: target.name)
        _description = State(initialValue: target.description)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Edit location name", text: $name)
                        .autocorrectionDisabled(true)
                    TextField("Edit location description", text: $description)
                        .autocorrectionDisabled(true)
                }
                
                Section("Nearby…") {
                    switch loadingState {
                    case .loaded:
                        ForEach(pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .loading:
                        Text("Loading…")
                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .toolbar {
                Button("Save") {
                    var loc = location
                    loc.id = UUID()
                    loc.name = name
                    loc.description = description
                    onSave(loc)
                    dismiss()
                }
            }
            .task {
                await fetchNearbyPlace()
            }
            .navigationTitle("Place details")
        }
    }
    
    func fetchNearbyPlace() async {
        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.coordinate.latitude)%7C\(location.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
        
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

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(target: Location.exampleIns) { _ in
        }
    }
}
