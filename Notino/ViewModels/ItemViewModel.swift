//
//  ItemViewModel.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import SwiftUI
import CoreData

class ItemViewModel: ObservableObject {
    private let context = PersistenceController.shared.container.viewContext
    
    let item: Item
    
    @Published var brandName: String = ""
    @Published var name: String = ""
    @Published var annotation: String = ""
    @Published var score: [RatingStar] = []
    @Published var price: String = ""
    
    @Published var favorited = false
    
    init(item: Item) {
        self.item = item
        prepareItem()
        getFavoritedStatus()
    }
    
    func toggleFavorited() {
        if favorited {
            // remove from coreData database
            let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
            do {
                let favoritedIds = try context.fetch(request)
                if let objectToDelete = favoritedIds.first(where: { $0.id == Int64(item.productId) }) {
                    context.delete(objectToDelete)
                    try context.save()
                    self.favorited = false
                } else {
                    NSLog((ErrorCase.coreDataIdNotFound).localizedDescription)
                    self.favorited = true
                }
            } catch {
                NSLog(error.localizedDescription)
                self.favorited = true
            }
        } else {
            // add to coreData database
            let newFavorited = Favorited(context: context)
            newFavorited.id = Int64(item.productId)
            do {
                try context.save()
                self.favorited = true
            } catch {
                NSLog(error.localizedDescription)
                self.favorited = false
            }
        }
    }
    
    private func getFavoritedStatus() {
        do {
            let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
            let favoritedIds = try context.fetch(request)
            if let _ = favoritedIds.first(where: { $0.id == Int64(item.productId) }) {
                self.favorited = true
            } else {
                self.favorited = false
            }
        } catch {
            NSLog(error.localizedDescription)
            self.favorited = false
        }
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
