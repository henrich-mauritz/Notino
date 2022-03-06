//
//  ItemViewModel.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import SwiftUI

class ItemViewModel: ObservableObject {
    let item: Item
    
    @Published var brandName: String = ""
    @Published var name: String = ""
    @Published var annotation: String = ""
    @Published var score: [RatingStar] = []
    @Published var price: String = ""
    
    @Published var favorited = false
    
    private let persistanceController = PersistenceController.shared
    
    init(item: Item) {
        self.item = item
        prepareItem()
        getFavoritedStatus()
    }
    
    func toggleFavorited() {
        if favorited {
            // remove from coreData database
            persistanceController.remove(id: item.productId, completion: { success in
                self.favorited = !success
            })
        } else {
            // add to coreData database
            persistanceController.add(id: item.productId, completion: { success in
                self.favorited = success
            })
        }
    }
    
    private func getFavoritedStatus() {
        persistanceController.getStatus(item.productId, completion: { isFavorited in
            self.favorited = isFavorited
        })
    }
    
    private func prepareItem() {
        if let brand = item.brand,
           let brandName = brand.name {
            self.brandName = brandName
        }
        
        if let name = item.name {
            self.name = name
        }
        
        if let annotation = item.annotation {
            self.annotation = annotation
        }
        
        if let reviewSummary = item.reviewSummary,
           let score = reviewSummary.score {
            var imageStack: [RatingStar] = []
            for i in 1...5 {
                if i <= score {
                    imageStack.append(RatingStar(id: String(i),
                                                 image: Image("starFull"))
                    )
                } else {
                    imageStack.append(RatingStar(id: String(i),
                                                 image: Image("starEmpty"))
                    )
                }
            }
            self.score = imageStack
        } else {
            self.score = []
        }
        
        let nf = NumberFormatter()
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 2
        if let price = item.price,
           let amount = price.value,
           let formattedAmount = nf.string(from: NSNumber(value: amount)),
           let currency = price.currency {
            self.price = "\(formattedAmount) \(currency)"
        }
    }
}
