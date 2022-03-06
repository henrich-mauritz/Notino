//
//  ProductFetcher.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import Foundation
import Combine

protocol ProductFetchable {
    func items() -> AnyPublisher<GetItemsJsonObject, Error>
}

class ProductFetcher {
    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    private let getItemsUrl = "https://my-json-server.typicode.com/cernfr1993/notino-assignment/db"
    private static let itemsProcessingQueue = DispatchQueue(label: "items-processing")
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, Error> {
        let decoder = JSONDecoder()
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                error
            }
            .eraseToAnyPublisher()
    }
}

extension ProductFetcher: ProductFetchable {
    func items() -> AnyPublisher<GetItemsJsonObject, Error> {
        guard let url = URL(string: getItemsUrl) else {
            let error = ErrorCase.invalidURL
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                error
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
            }
            .subscribe(on: Self.itemsProcessingQueue)
            .eraseToAnyPublisher()
    }
}

