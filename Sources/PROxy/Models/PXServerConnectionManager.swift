//
//  PXServerConnectionManager.swift
//  PROxy
//
//  Created by Jack Cummings on 7/5/22.
//

import Foundation
import Network

class PXServerConnectionManager: PXConnectionManager {
    
    var delegate: PXConnectionDelegate?
    let remoteConnection: NWConnection
    
    init(endpoint: NWEndpoint) {
        self.remoteConnection = NWConnection(to: endpoint, using: .tcp)
    }
    
    func start() {
        remoteConnection.start(queue: .main)
        readData(from: remoteConnection)
    }
    
    func send(_ data: Data) {
        remoteConnection.send(content: data, completion: .contentProcessed( { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }))
    }
    
    func readData(from connection: NWConnection) {
        remoteConnection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, contentContext, isComplete, error in
            
            guard error == nil, let data = data else {
                return self.remoteConnection.cancel()
            }
            
            // Pass to delegate
            print("Recieved \(data) from remote endpoint.")
            self.delegate?.didRecieve(data, from: self.remoteConnection)
            self.readData(from: self.remoteConnection)
        }
    }
}
