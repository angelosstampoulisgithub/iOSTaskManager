//
//  TaskItemModel.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import Foundation
struct TaskItemModel: Identifiable {
    let id: UUID
    let title: String
    let description: String?
    let priority: Int16
    let dueDate: Date?
    var isCompleted: Bool
    var order: Int16
}
