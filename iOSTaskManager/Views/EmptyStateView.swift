//
//  EmptyStateView.swift
//  iOSTaskManager
//
//  Created by Angelos Staboulis on 20/3/25.
//
import SwiftUI
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checklist")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue.opacity(0.8))
            
            Text("No tasks yet!")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Stay productive by adding your first task now.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 30)
        }
        .padding()
    }
}
