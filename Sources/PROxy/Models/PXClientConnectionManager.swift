//
//  PXClientConnectionManager.swift
//  PROxy
//
//  Created by Jack Cummings on 7/5/22.
//

import Foundation
import Network

class PXClientConnectionManager: PXConnectionManager {
  
    var delegate: PXConnectionDelegate?
    var clients: [NWConnection] = []
        
    func recieveNewConnection(_ connection: NWConnection) {
        print("Recieved new connection from \(connection)")
        
        connection.stateUpdateHandler = { state in
            self.connectionStateUpdateHandler(connection: connection, state: state)
        }
        
        connection.start(queue: .main)
        self.readData(from: connection)
    }
    
    func readData(from connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { data, contentContext, isComplete, error in
            
            guard error == nil, let data = data else {
                return connection.cancel()
            }
            
            // Pass to delegate
            self.delegate?.didRecieve(data, from: connection)
            
            // Prepare for next transmission
            self.readData(from: connection)
        }
    }
    
    func send(_ data: Data) {
        for connection in clients {
            connection.send(content: data, completion: .contentProcessed( { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }))
        }
    }
    
    private func connectionStateUpdateHandler(connection: NWConnection, state: NWConnection.State) {
        switch state {
        case .setup, .preparing:
            self.delegate?.logManager.log("Preparing new connection...", source: .client(connection))
        case .ready:
            self.delegate?.logManager.log("Connection is ready", source: .client(connection), level: .success)
            clients.append(connection)
        case .failed(let nWError):
            self.delegate?.logManager.log("Connection failed: \(nWError.localizedDescription)", source: .client(connection), level: .failure)
            clients.remove(connection)
        case .cancelled:
            self.delegate?.logManager.log("Connection cancelled", source: .client(connection), level: .failure)
            clients.remove(connection)
        default:
            print("...")
        }
    }
}
