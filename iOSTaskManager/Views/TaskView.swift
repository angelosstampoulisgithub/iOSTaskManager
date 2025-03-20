//
//  TaskView.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import SwiftUI
struct TaskView: View {
    @StateObject private var viewModel: TaskListViewModel
    @State private var showingTaskCreation = false
    @State private var showingDeleteAlert = false
    @State private var showingCompleteAlert = false
    private let repository: TaskStorageRepository
    @Environment(\.accentColor) private var accentColor
    @State private var isPulsing = false // to track pulse animation
    
    init(viewModel: TaskListViewModel, repository: TaskStorageRepository) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.repository = repository
    }

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.tasks.isEmpty {
                    EmptyStateView()
                } else {
                    List {
                        ForEach(viewModel.tasks) { task in
                            NavigationLink(destination: TaskDetailsView(viewModel: TaskDetailsViewModel(
                                task: task,
                                repository: repository,
                                onDelete: { viewModel.fetchTasks() }
                            ))) {
                                TaskRowView(task: task)
                                    .padding(.vertical, 8)
                            }
                            .swipeActions(edge: .trailing) {
                                Button("Delete", role: .destructive) {
                                    let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.error)
                                    viewModel.deleteTask(task)
                                    showingDeleteAlert = true
                                }
                                Button("Complete") {
                                    viewModel.completeTask(task)
                                    showingCompleteAlert = true
                                }
                                .tint(.green)
                            }
                            .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            .listRowSeparator(.hidden)
                        }
                        .onMove(perform: moveTask)
                    }
                    .listStyle(.plain)
                    .background(Color(UIColor.systemBackground))
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink {
                        CreateTaskView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(accentColor)
                        
                    }
                  
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    SortBy(viewModel: viewModel, repository: repository)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .foregroundColor(accentColor) // Accent color applied
                    }
                }
            }
            .onChange(of: viewModel.sortOption) { _, _ in
                viewModel.fetchTasks()
            }
            .onChange(of: viewModel.filterOption) { _, _ in
                viewModel.fetchTasks()
            }
            .alert("Task Deleted", isPresented: $showingDeleteAlert) {
                Button("Undo") { viewModel.undoDelete() }
                Button("OK", role: .cancel) {}
            } message: {
                Text("The task has been deleted.")
            }
            .alert("Task Completed", isPresented: $showingCompleteAlert) {
                Button("Undo") { viewModel.undoComplete() }
                Button("OK", role: .cancel) {}
            } message: {
                Text("The task has been marked as completed.")
            }
            .accentColor(.accentColor) 
        }
    }

    private func moveTask(from source: IndexSet, to destination: Int) {
        viewModel.moveTask(from: source, to: destination)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
}

