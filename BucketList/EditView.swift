//
//  EditView.swift
//  BucketList
//
//  Created by 최준영 on 2023/01/16.
//

import SwiftUI

struct EditView: View {
    @StateObject var viewModel = ViewModel()
    var onSave: (Location) -> ()
    var location: Location
    @Environment(\.dismiss) var dismiss
    
    init(location: Location, onSave: @escaping (Location) -> ()) {
        self.onSave = onSave
        self.location = location
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Edit location name", text: $viewModel.name)
                        .autocorrectionDisabled(true)
                    TextField("Edit location description", text: $viewModel.description)
                        .autocorrectionDisabled(true)
                }
                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
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
                    onSave(viewModel.updatedLocation())
                    dismiss()
                }
            }
            .task {
                await viewModel.setLocation(location: location)
            }
            .navigationTitle("Place details")
        }
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.exampleIns) { _ in
        }
    }
}
