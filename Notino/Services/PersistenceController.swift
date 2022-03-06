//
//  PersistenceController.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Notino")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func remove(id: Int, completion: @escaping (_ success: Bool) -> Void) {
        let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
        do {
            let favoritedIds = try container.viewContext.fetch(request)
            if let objectToDelete = favoritedIds.first(where: { $0.id == Int64(id) }) {
                container.viewContext.delete(objectToDelete)
                try container.viewContext.save()
                completion(true)
            } else {
                NSLog((ErrorCase.coreDataIdNotFound).localizedDescription)
                completion(false)
            }
        } catch {
            NSLog(error.localizedDescription)
            completion(false)
        }
    }
    
    func add(id: Int, completion: @escaping (_ success: Bool) -> Void ) {
        let newFavorited = Favorited(context: container.viewContext)
        newFavorited.id = Int64(id)
        do {
            try container.viewContext.save()
            completion(true)
        } catch {
            NSLog(error.localizedDescription)
            completion(false)
        }
    }
    func getStatus(_ id: Int, completion: @escaping (_ isFavorited: Bool) -> Void) {
        do {
            let request: NSFetchRequest<Favorited> = Favorited.fetchRequest()
            let favoritedIds = try container.viewContext.fetch(request)
            if let _ = favoritedIds.first(where: { $0.id == Int64(id) }) {
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            NSLog(error.localizedDescription)
            completion(false)
        }
    }
}
