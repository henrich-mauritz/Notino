//
//  MainViewModel.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import Foundation
import Combine

class MainViewModel: ObservableObject {
    @Published private(set) var state: State = .idle
    @Published private(set) var dataSource: [Item] = []
    
    private let productsFetcher: ProductFetchable = ProductFetcher()
    private var cancellable = Set<AnyCancellable>()
    
    enum State {
        case idle
        case loading
        case loaded
    }
    
    func loadItems(completion: @escaping (_ error: Error) -> Void) {
        self.state = .loading
        productsFetcher.items()
            .map(\.vpProductByIds)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] error in
                guard let self = self else { return }
                self.state = .loaded
                switch error {
                case .failure(let error):
                    completion(error)
                    self.dataSource = []
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.state = .loaded
                self.dataSource = value
            })
            .store(in: &cancellable)
    }
}

