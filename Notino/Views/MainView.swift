//
//  MainView.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var errorHandling: ErrorHandling
    @ObservedObject var model = MainViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                switch model.state {
                case .idle:
                    Color.clear.onAppear(perform: {
                        model.loadItems { error in
                            errorHandling.handle(error: error)
                        }
                    })
                case .loaded, .loading:
                    ZStack {
                        ScrollView() {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(model.dataSource, id: \.productId) { item in
                                    let model = ItemViewModel(item: item)
                                    ItemView(model: model)
                                        .frame(idealHeight: 420)
                                        .withErrorHandling()
                                }
                            }
                            .padding(.horizontal)
                        }
                        .toolbar {
                            ToolbarItem(placement: .principal) {
                                Text("Notino").font(.headline)
                            }
                        }
                        if model.state == .loading {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
