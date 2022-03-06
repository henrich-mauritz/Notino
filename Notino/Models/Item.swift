//
//  Item.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import SwiftUI

struct GetItemsJsonObject: Codable {
    let vpProductByIds: [Item]
}

struct Item: Codable {
    let productId: Int
    let brand: Brand?
    let attributes: Attributes?
    let annotation: String?
    let masterId: Int?
    let url: String?
    let orderUnit: String?
    let price: Price?
    let imageUrl: String?
    let name: String?
    let productCode: String?
    let reviewSummary: ReviewSummary?
    let stockAvailabilty: StockAvailability?
    
    struct Brand: Codable {
        let id: String?
        let name: String?
    }
    
    struct Attributes: Codable {
        let Master: Bool?
        let AirTransportDisallowed: Bool?
        let PackageSize: PackageSize?
        let FreeDelivery: Bool?
        
        struct PackageSize: Codable {
            let height: Double?
            let width: Double?
            let depth: Double?
        }
    }
    
    struct Price: Codable {
        let value: Double?
        let currency: String?
    }
    
    struct ReviewSummary: Codable {
        let score: Int?
        let averageRating: Double?
    }
    
    struct StockAvailability: Codable {
        let code: String?
        let count: Int?
    }
}
    
struct RatingStar: Identifiable {
    let id: String
    let image: Image
}



