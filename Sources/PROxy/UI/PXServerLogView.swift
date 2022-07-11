//
//  PXConfigurationView.swift
//  PROxy
//
//  Created by Jack Cummings on 7/2/22.
//

import SwiftUI

public struct PXServerLogView: View {
    
    @ObservedObject public var logManager: PXLogManager
    
    public var body: some View {
        NavigationView {
            List(logManager.logs) { log in
                logRowView(log)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
        }
    }
    
    // MARK: Functions
    func logRowView(_ log: PXLog) -> some View {
        VStack(alignment: .leading) {
            Text(log.source.description)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(log.message)
                .foregroundColor(log.level.color)
                .font(.subheadline)
        }
    }
}
