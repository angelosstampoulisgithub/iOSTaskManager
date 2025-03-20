//
//  SortBy.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import SwiftUI

struct SortBy: View {
    @StateObject private var viewModel: TaskListViewModel
    private let repository: TaskStorageRepository
    @Environment(\.accentColor) private var accentColor

    init(viewModel: TaskListViewModel, repository: TaskStorageRepository) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.repository = repository
    }
    var body: some View {
        Menu {
            Picker("Sort By", selection: $viewModel.sortOption) {
                ForEach(TaskListViewModel.SortOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            Picker("Filter By", selection: $viewModel.filterOption) {
                ForEach(TaskListViewModel.FilterOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .font(.title3)
                .foregroundColor(accentColor) 
        }
        
    }
}


