//
//  PXLogManager.swift
//  PROxy
//
//  Created by Jack Cummings on 7/8/22.
//

import Foundation

public class PXLogManager: ObservableObject {
    
    @Published public var logs: [PXLog]
    
    public init() {
        self.logs = []
    }
    
    public func clear() {
        self.logs.removeAll()
    }
    
    public func log(_ message: String, source: PXLog.Source, level: PXLog.Level = .info) {
        let log = PXLog(level: level, message: message, source: source, timestamp: Date())
        logs.insert(log, at: 0)
    }
}
