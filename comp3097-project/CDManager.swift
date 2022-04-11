//
//  CDManager.swift
//  comp3097-project
//
//  Created by Jack Robinson on 2022-03-12.
//

import Foundation
import CoreData

class CDManager {
    
    static let shared = CDManager()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: {
            _, error in
            _ = error.map{fatalError("Unresolved error \($0)")}
        })
        return container
    }()
    
    var mainContext: NSManagedObjectContext{
        return persistentContainer.viewContext
    }
    
    func backgroundContext() -> NSManagedObjectContext{
        return persistentContainer.newBackgroundContext()
    }
    
    // RESTAURANTS
    func deleteRestaurant(res: Restaurant){
        let context = persistentContainer.viewContext
        context.delete(res)
        
        do{
            try context.save()
        } catch{
            debugPrint(error)
        }
    }
    
    func updateRestaurant() {
        do{
            try persistentContainer.viewContext.save()
        }catch{
            debugPrint(error)
        }
    }
    
    func loadRestaurants() -> [Restaurant] {
        let mainContext = CDManager.shared.mainContext
        
        let request: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        
        do{
            let res = try mainContext.fetch(request)
            return res
        } catch{
            debugPrint(error)
        }
        
        return []
    }
    
    func getRestaurantByName(name: String) -> [Restaurant]{
        let mainContext = CDManager.shared.mainContext
        
        let request = NSFetchRequest<Restaurant>(entityName: "Restaurant")
        request.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let fetchResults = try mainContext.fetch(request)
            return fetchResults
        } catch {
            print(error)
        }
        return []
    }
    
    func getRestaurantById(id: NSManagedObjectID) -> Restaurant?{
        let mainContext = CDManager.shared.mainContext
        
        let request = NSFetchRequest<Restaurant>(entityName: "Restaurant")
        request.predicate = NSPredicate(format: "SELF = %@", id)
        
        do {
            let fetchResults = try mainContext.fetch(request)
            return fetchResults[0]
        } catch {
            print(error)
        }
        return nil
    }

    
    func saveRestaurant(id: Int32, name: String, address: String, cuisine: String, phonenumber: String, desc: String, rating: Int32) {
        let context = CDManager.shared.backgroundContext()
        let entity = Restaurant.entity()
        let restaurant = Restaurant(entity: entity, insertInto: context)
        restaurant.id = id
        restaurant.name = name
        restaurant.cuisine = cuisine
        restaurant.phonenumber = phonenumber
        restaurant.restaurantDescription = desc
        restaurant.rating = rating
        restaurant.address = address
        do{
            try context.save()
        } catch{
            debugPrint(error)
        }
    }
    
    func searchRestaurantByName(name: String) -> [Restaurant]{
        let mainContext = CDManager.shared.mainContext
        
        let request = NSFetchRequest<Restaurant>(entityName: "Restaurant")
        request.predicate = NSPredicate(format: "name CONTAINS %@ OR cuisine CONTAINS %@", argumentArray: [name, name])
        do {
            let fetchResults = try mainContext.fetch(request)
            return fetchResults
        } catch {
            print(error)
        }
        return []
    }
    
    // TAGS
    func loadRestaurantTags() -> [Tag] {
         return []
    }
    
    func saveRestaurantTag(res: Restaurant?, tagName: String) {
        let context = CDManager.shared.mainContext
        let entity = Tag.entity()
        let tag = Tag(entity: entity, insertInto: context)
        tag.name = tagName
        res?.addToTag(tag)

        do{
            try context.save()
        } catch{
            debugPrint(error)
        }

    }
    
    
    
    func getTagsByName(name: String) -> [Tag] {
        let mainContext = CDManager.shared.mainContext
        
        let request = NSFetchRequest<Tag>(entityName: "Tag")
        request.predicate = NSPredicate(format: "name = %@", name)
        
        do {
            let fetchResults = try mainContext.fetch(request)
            return fetchResults
        } catch {
            print(error)
        }
        return []

    }
}
