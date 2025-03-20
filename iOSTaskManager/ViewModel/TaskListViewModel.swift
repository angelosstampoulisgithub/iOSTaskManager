//
//  TaskListViewModel.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import Foundation
import SwiftUI

class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskItemModel] = []
    @Published var sortOption: SortOption = .manual
    @Published var filterOption: FilterOption = .all

    enum SortOption: String, CaseIterable {
        case manual = "Manual"
        case priority = "Priority"
        case dueDate = "Due Date"
        case alphabetical = "Alphabetical"
    }

    enum FilterOption: String, CaseIterable {
        case all = "All"
        case completed = "Completed"
        case pending = "Pending"
    }

    private let repository: TaskStorageRepository
    
    private var lastDeletedTask: TaskItemModel?
    private var lastCompletedTask: TaskItemModel?
    

    init(repository: TaskStorageRepository) {
        self.repository = repository
        fetchTasks()
    }
    
    

    func createTask(task: TaskItemModel) {
        repository.createTask(task)
        fetchTasks()
    }
    
    func addDummyTasks()
    {
        repository.addDummyTasks()
        fetchTasks()
    }
    
    func deleteAllTasks()
    {
        repository.deleteAllTasks()
        fetchTasks()
    }
    
    func deleteTask(_ task: TaskItemModel) {
        lastDeletedTask = task
        repository.deleteTask(task)
        fetchTasks()
    }
    
    func undoDelete() {
        if let task = lastDeletedTask {
            let newTask = TaskItemModel(
                id: UUID(),
                title: task.title,
                description: task.description,
                priority: task.priority,
                dueDate: task.dueDate,
                isCompleted: task.isCompleted,
                order: task.order
            )
            repository.createTask(newTask)
            lastDeletedTask = nil
            fetchTasks()
        }
    }
    
    func completeTask(_ task: TaskItemModel) {
        lastCompletedTask = task
        var updatedTask = task
        updatedTask.isCompleted = true
        repository.updateTask(updatedTask)
        fetchTasks()
    }
    
    func undoComplete() {
        if let task = lastCompletedTask {
            var updatedTask = task
            updatedTask.isCompleted = false
            repository.updateTask(updatedTask)
            lastCompletedTask = nil
            fetchTasks()
        }
    }
    
    func moveTask(from source: IndexSet, to destination: Int) {
        tasks.move(fromOffsets: source, toOffset: destination)
        for (index, _) in tasks.enumerated() {
            tasks[index].order = Int16(index) // Update order directly in the array
            repository.updateTask(tasks[index])
        }
        if sortOption != .manual {
            fetchTasks() // Refresh to apply other sorting if not manual
        }
    }

    /// Fetches tasks from the repository with the current sort and filter options
    func fetchTasks() {
        tasks = repository.fetchTasks(sortOption: sortOption, filterOption: filterOption)
    }
}
