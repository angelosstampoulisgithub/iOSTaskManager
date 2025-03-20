//
//  CreateTaskView.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import SwiftUI

struct CreateTaskView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.accentColor) var accentColor
    @State var title = ""
    @State var description = ""
    @State var priority: Int16 = 1 
    @State  var dueDate = Date()
    @ObservedObject  var viewModel: TaskListViewModel
    var body: some View {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    Picker("Priority", selection: $priority) {
                        Text("Low").tag(Int16(0))
                        Text("Medium").tag(Int16(1))
                        Text("High").tag(Int16(2))
                    }
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    .onChange(of: dueDate) { oldValue, newValue in
                        saveTask()
                        dismiss()
                    }
                    
                }
            }
            .navigationTitle("New Task")
        }
    private func saveTask() {
        let newTask = TaskItemModel(
            id: UUID(),
            title: title,
            description: description.isEmpty ? nil : description,
            priority: priority,
            dueDate: dueDate,
            isCompleted: false,
            order: 0 
        )
        
        viewModel.createTask(task: newTask)
    }
}

