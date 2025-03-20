//
//  AddTaskView.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import SwiftUI

struct AddTaskView: View {
    @StateObject private var viewModel: TaskListViewModel
    private let repository: TaskStorageRepository
    @Environment(\.accentColor) private var accentColor

    init(viewModel: TaskListViewModel, repository: TaskStorageRepository) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.repository = repository
    }
    var body: some View {
        VStack{
            NavigationLink {
                CreateTaskView(viewModel: viewModel)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30)) // Increase size
                    .foregroundColor(accentColor)
                
            }
        }
    }
}

