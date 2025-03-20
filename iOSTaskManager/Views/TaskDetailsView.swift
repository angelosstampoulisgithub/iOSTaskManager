//
//  TaskDetailsView.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import SwiftUI

struct TaskDetailsView: View {
    @ObservedObject private var viewModel: TaskDetailsViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accentColor) private var accentColor
    @State private var showingDeleteAlert = false

    init(viewModel: TaskDetailsViewModel) {
        self.viewModel = viewModel
    }
    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .strikethrough(viewModel.isCompleted, color: .secondary)
                    .foregroundColor(viewModel.isCompleted ? .secondary : .primary)

                if let description = viewModel.description, !description.isEmpty {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }

            Section {
                Toggle("Completed", isOn: Binding(
                    get: { viewModel.isCompleted },
                    set: { viewModel.setCompletion(to: $0) }
                ))
                .tint(accentColor)
                .accessibilityLabel("Task completed")
            }

            Section(header: Text("Task Details")) {
                HStack {
                    Text("Due Date")
                        .font(.subheadline)
                    Spacer()
                    Text(viewModel.formattedDueDate())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Priority")
                        .font(.subheadline)
                    Spacer()
                    Text(viewModel.priorityText())
                        .font(.subheadline)
                        .foregroundColor(viewModel.priorityColor())
                }
            }

            Section {
                Button("Delete Task", role: .destructive) {
                    showingDeleteAlert = true
                }
                .tint(accentColor)
            }
        }
        .navigationTitle("Task Details")
        .alert("Delete Task", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                viewModel.deleteTask()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Are you sure you want to delete this task?")
        }
    }
}

