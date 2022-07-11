//
//  PXLog.swift
//  PROxy
//
//  Created by Jack Cummings on 7/5/22.
//

import Network
import SwiftUI

public struct PXLog: Identifiable {
    public let id = UUID()
    let level: Level
    let message: String
    let source: Source
    let timestamp: Date
}

extension PXLog {
    public enum Level {
        case info, success, failure
        
        var color: Color {
            switch self {
            case .info:
                return Color.primary
            case .success:
                return Color.green
            case .failure:
                return Color.red
            }
        }
    }
}

extension PXLog {
    public enum Source: CustomStringConvertible, Equatable {
        case client(NWConnection), proxy, server
        
        public var description: String {
            switch self {
            case .client(let connection):
                return "CLIENT: \(connection.endpoint.debugDescription)"
            case .proxy:
                return "PROXY"
            case .server:
                return "SERVER"
            }
        }
        
        public static func == (lhs: Source, rhs: Source) -> Bool {
            switch (lhs, rhs) {
            case (.server, .server):
                return true
            case (.client(let lhsConection), .client(let rhsConnection)):
                return lhsConection == rhsConnection
            default:
                return false
            }
        }
    }
}


