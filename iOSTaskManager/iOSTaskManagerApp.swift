//
//  iOSTaskManagerApp.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import SwiftUI

@main
struct iOSTaskManagerApp: App {
    let persistenceController = PersistenceController.shared
    let repository: TaskStorageRepository
    @AppStorage("accentColorHex") private var accentColorHex: String = Color.blue.hexString

    init() {
        let coreDataManager = CoreDataManager(persistentContainer: persistenceController.container)
        repository = coreDataManager
    }

    var body: some Scene {
        WindowGroup {
            TaskView(
                viewModel: TaskListViewModel(repository: repository),
                repository: repository
            )
            .environment(\.accentColor, Color(hex: accentColorHex))
        }
    }
}
