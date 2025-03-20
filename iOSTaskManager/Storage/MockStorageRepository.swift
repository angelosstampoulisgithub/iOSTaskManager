//
//  MockStorageRepository.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import Foundation


class MockStorageRepository: TaskStorageRepository {
    
    private var tasks: [TaskItemModel] = []
    
    func createTask(_ taskItem: TaskItemModel) {
        tasks.append(taskItem)
    }
    
    func fetchTasks(sortOption: TaskListViewModel.SortOption, filterOption: TaskListViewModel.FilterOption) -> [TaskItemModel] {
        var filteredTasks = tasks
        
        switch filterOption {
        case .completed:
            filteredTasks = tasks.filter { $0.isCompleted }
        case .pending:
            filteredTasks = tasks.filter { !$0.isCompleted }
        case .all:
            break
        }
        
        switch sortOption {
        case .manual:
            break
        case .priority:
            filteredTasks.sort { $0.priority > $1.priority }
        case .dueDate:
            filteredTasks.sort { ($0.dueDate ?? Date.distantFuture) < ($1.dueDate ?? Date.distantFuture) }
        case .alphabetical:
            filteredTasks.sort { $0.title < $1.title }
        }
        
        return filteredTasks
    }
    
    func updateTask(_ taskItem: TaskItemModel) {
        if let index = tasks.firstIndex(where: { $0.id == taskItem.id }) {
            tasks[index] = taskItem
        }
    }
    
    func deleteTask(_ taskItem: TaskItemModel) {
        tasks.removeAll { $0.id == taskItem.id }
    }
    
    func deleteAllTasks() {
        tasks.removeAll()
    }
    
    func addDummyTasks() {
        tasks = (1...100).map { i in
            TaskItemModel(
                id: UUID(),
                title: "Test Task \(i)",
                description: "Description for Test Task \(i)",
                priority: Int16(Int.random(in: 1...3)),
                dueDate: Calendar.current.date(byAdding: .day, value: i % 30, to: Date()),
                isCompleted: Bool.random(),
                order: Int16(i)
            )
        }
    }
}
