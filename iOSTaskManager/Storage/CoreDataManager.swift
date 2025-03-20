//
//  CoreDataManager.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import Foundation
import CoreData

protocol TaskStorageRepository {
    func createTask(_ taskItem: TaskItemModel)
    func fetchTasks(sortOption: TaskListViewModel.SortOption, filterOption: TaskListViewModel.FilterOption) -> [TaskItemModel]
    func updateTask(_ taskItem: TaskItemModel)
    func deleteTask(_ taskItem: TaskItemModel)
    func deleteAllTasks()
    func addDummyTasks()
}

class CoreDataManager: TaskStorageRepository {
   
    
    let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer = PersistenceController.shared.container) {
        self.persistentContainer = persistentContainer
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
    
    func addDummyTasks() {
        for i in 1...100 {
            let task = TaskManager(context: context)
            task.id = UUID()
            task.title = "Test Task \(i)"
            task.taskdescription = "This is a Test task description for task \(i)."
            task.priority = Int16([0,1,2].randomElement()!) // Random priority (1 to 3)
            task.dueDate = Calendar.current.date(byAdding: .day, value: i % 30, to: Date()) // Spread due dates
            task.isCompleted = Bool.random() // Random completion status
            task.order = Int16(i) // Order based on loop index
        }
        
        saveContext()
        print("✅ Successfully added 100 dummy tasks.")
    }

    
    func createTask(_ taskItem: TaskItemModel) {
        let task = TaskManager(context: context)
        task.id = taskItem.id
        task.title = taskItem.title
        task.taskdescription = taskItem.description
        task.priority = taskItem.priority
        task.dueDate = taskItem.dueDate
        task.isCompleted = taskItem.isCompleted
        task.order = taskItem.order // Keep order value

        saveContext()
    }

    
    func fetchTasks(sortOption: TaskListViewModel.SortOption, filterOption: TaskListViewModel.FilterOption) -> [TaskItemModel] {
        let request: NSFetchRequest<TaskManager> = TaskManager.fetchRequest()
        
        // Sorting
        switch sortOption {
        case .manual:
            request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        case .priority:
            request.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: false)]
        case .dueDate:
            request.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true)]
        case .alphabetical:
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        }

        do {
            var tasks = try context.fetch(request)
            
            switch filterOption {
            case .completed:
                tasks = tasks.filter { $0.isCompleted }
            case .pending:
                tasks = tasks.filter { !$0.isCompleted }
            case .all:
                break
            }

            return tasks.map { task in
                TaskItemModel(
                    id: task.id!,
                    title: task.title ?? "Untitled",
                    description: task.taskdescription,
                    priority: task.priority,
                    dueDate: task.dueDate,
                    isCompleted: task.isCompleted,
                    order: task.order
                )
            }
            
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }

    
    func updateTask(_ taskItem: TaskItemModel) {
        let request: NSFetchRequest<TaskManager> = TaskManager.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", taskItem.id as CVarArg)

        do {
            if let task = try context.fetch(request).first {
                task.title = taskItem.title
                task.taskdescription = taskItem.description
                task.priority = taskItem.priority
                task.dueDate = taskItem.dueDate
                task.isCompleted = taskItem.isCompleted
                task.order = taskItem.order

                saveContext()
            }
            else
            {
                print("")
            }
        } catch {
            print("Failed to update task: \(error)")
        }
    }
    
    func deleteAllTasks() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TaskManager.fetchRequest()
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeObjectIDs

            do {
                let result = try context.execute(batchDeleteRequest) as? NSBatchDeleteResult
                if let objectIDs = result?.result as? [NSManagedObjectID] {
                    let changes = [NSDeletedObjectsKey: objectIDs]
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [context])
                }
            } catch {
                print("Failed to delete all tasks: \(error)")
            }
        }
    

    
    func deleteTask(_ taskItem: TaskItemModel) {
        let request: NSFetchRequest<TaskManager> = TaskManager.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", taskItem.id as CVarArg)

        do {
            if let task = try context.fetch(request).first {
                context.delete(task)
                saveContext()
            }
        } catch {
            print("Failed to delete task: \(error)")
        }
    }
}
