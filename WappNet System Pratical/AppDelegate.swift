//
//  AppDelegate.swift
//  WappNet System Pratical
//
//  Created by Wasim on 29/09/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static var shared : AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let localData = fetchDataFromLocalDB, localData.count > 0 {
            arrMedias = localData
        } else {
            self.fetchMediaFromJson()
        }
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WappNet")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

var arrMedias = [MediaModel]()
extension AppDelegate {
    func fetchMediaFromJson() {
        if let file = Bundle.main.url(forResource: "media", withExtension: "json"), let data = try? Data(contentsOf: file), let arrData = try? JSONDecoder().decode([MediaModel].self, from: data) {
            if self.isEmptyCoreData {
                self.storedDataInLocalDB(arrData)
            }
            arrMedias = arrData
        }
    }
    var isEmptyCoreData: Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Media")
            let count  = try self.persistentContainer.viewContext.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }

    func storedDataInLocalDB(_ arrData : [MediaModel]) {
        for objData in arrData
        {
            let employeeEntry = NSEntityDescription.insertNewObject(forEntityName: "Media", into: self.persistentContainer.viewContext)

            employeeEntry.setValue(objData.id ?? "", forKey: "id")
            employeeEntry.setValue(objData.video_link ?? "", forKey: "video_link")
            employeeEntry.setValue(objData.thumb ?? "", forKey: "thumb")
            employeeEntry.setValue(objData.title ?? "", forKey: "title")
            employeeEntry.setValue(objData.favourite ?? false, forKey: "favourite")
            do {
                try self.persistentContainer.viewContext.save()
            } catch {
                print("problem saving")
            }
        }
    }
    var fetchDataFromLocalDB : [MediaModel]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Media")
        request.returnsObjectsAsFaults = false
        if let result = try? self.persistentContainer.viewContext.fetch(request) as? [NSManagedObject] {
            return result.map({MediaModel.getObject($0)})
        }
        return nil
    }
    func updateFavourite(_ id : String,_ favourite : Bool?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Media")
        fetchRequest.predicate = NSPredicate(format: "id = %@", argumentArray: [id])

        do {
            let results = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [NSManagedObject]
            results?.first?.setValue(favourite ?? false, forKey: "favourite")
        } catch {
            print("Fetch Failed: \(error)")
        }

        do {
            try self.persistentContainer.viewContext.save()
           }
        catch {
            print("Saving Core Data Failed: \(error)")
        }

    }
}

struct MediaModel : Codable {
    var id : String?
    var video_link : String?
    var thumb : String?
    var title : String?
    var favourite : Bool?
    
    static func getObject(_ data : NSManagedObject) -> MediaModel {
        var obj = MediaModel.init()
        obj.id = data.value(forKey: "id") as? String
        obj.video_link = data.value(forKey: "video_link") as? String
        obj.thumb = data.value(forKey: "thumb") as? String
        obj.title = data.value(forKey: "title") as? String
        obj.favourite = data.value(forKey: "favourite") as? Bool
        return obj
    }
//    var favourite = false
}
