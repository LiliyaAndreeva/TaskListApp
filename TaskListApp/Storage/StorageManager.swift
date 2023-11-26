//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Лилия Андреева on 24.11.2023.
//

import Foundation
import CoreData
import UIKit

final class Storagemanager {
    static let shared = Storagemanager()
    var context: NSManagedObjectContext
    
    
    // MARK: - Core Data stack
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init(){
        context = persistentContainer.viewContext
    }
    
    
    
    func getfetchData() -> [Task]{
        var taskList: [Task] = []
        let fetchRequest = Task.fetchRequest()
        
        do{
             taskList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return taskList
    }
    
    func deleteContext (_ task: Task) {
        context.delete(task)
        saveContext()
    }
    
    func refreshContext(_ task: Task) {
        context.refresh(task, mergeChanges: true)
        saveContext()
    }
    

    // MARK: - Core Data Saving support
    
    func saveContext () {
        
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
