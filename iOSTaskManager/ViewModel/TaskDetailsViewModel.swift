//
//  TaskDetailsViewModel.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import Foundation
import SwiftUI
class TaskDetailsViewModel: ObservableObject {
   
    private var task: TaskItemModel
    private let repository: TaskStorageRepository
    private let onDelete: () -> Void
    
    init(task: TaskItemModel, repository: TaskStorageRepository, onDelete: @escaping () -> Void) {
        self.task = task
        self.repository = repository
        self.onDelete = onDelete
    }
   

    var title: String { task.title }
    var isCompleted: Bool { task.isCompleted }
    var description: String? { task.description }
    var priority: Int16 { task.priority }

    
    func setCompletion(to newValue: Bool) {
        task.isCompleted = newValue
        repository.updateTask(task)
        onDelete()
        
    }

    func deleteTask() {
        repository.deleteTask(task)
        onDelete()
    }

    func formattedDueDate() -> String {
        guard let dueDate = task.dueDate else { return "No Due Date" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: dueDate)
    }

    func priorityText() -> String {
        switch task.priority {
        case 0: return "Low"
        case 1: return "Medium"
        case 2: return "High"
        default: return "Unknown"
        }
    }

    func priorityColor() -> Color {
        switch task.priority {
        case 0: return .blue
        case 1: return .orange
        case 2: return .red
        default: return .gray
        }
    }
}
