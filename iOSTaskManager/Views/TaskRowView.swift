//
//  TaskRowView.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//

import SwiftUI

struct TaskRowView: View {
    let task: TaskItemModel
    @Environment(\.accentColor) private var accentColor
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack {
            Rectangle()
                .fill(priorityColor(for: task.priority))
                .frame(width: 5, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .strikethrough(task.isCompleted, color: .secondary)
                    .accessibilityLabel(task.isCompleted ? "Completed task, \(task.title)" : task.title)
                

                if let description = task.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                if let dueDate = task.dueDate {
                    let isOverdue = Calendar.current.compare(dueDate, to: Date(), toGranularity: .day) == .orderedAscending
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(accentColor) // Apply accent color to calendar icon
                        Text(formattedDate(dueDate))
                            .font(.caption)
                            .foregroundColor(isOverdue ? .red : .secondary)
                    }
                }
            }
            .padding(.leading, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }

    private func priorityColor(for priority: Int16) -> Color {
        switch priority {
        case 0: return .green
        case 1: return .orange
        case 2: return .red 
        default: return .gray
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

