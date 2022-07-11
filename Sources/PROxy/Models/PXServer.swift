//
//  PXServer.swift
//  PROxy
//
//  Created by Jack Cummings on 7/5/22.
//

import Foundation
import Network

public class PXServer: ObservableObject, PXConnectionDelegate {
    
    @Published var state: State = .disabled
    @Published var logManager: PXLogManager
    
    let listeningPort: UInt16
    let clientConnectionManager: PXClientConnectionManager
    let serverConnectionManager: PXServerConnectionManager
    
    private var listener: NWListener!
    
    public init(_ listeningPort: UInt16, serverEndpoint: NWEndpoint, logManager: PXLogManager = PXLogManager()) {
        self.listeningPort = listeningPort
        self.clientConnectionManager = .init()
        self.serverConnectionManager = .init(endpoint: serverEndpoint)
        self.logManager = logManager
    }
    
    public func start() throws {
        let listener = try NWListener(using: .tcp, on: .init(rawValue: listeningPort)!)
        listener.stateUpdateHandler = listenerStateUpdateHandler
        listener.newConnectionHandler = clientConnectionManager.recieveNewConnection
        listener.start(queue: .main)
        
        clientConnectionManager.delegate = self
        serverConnectionManager.delegate = self
        serverConnectionManager.start()
    }
    
    public func stop() {
        listener.cancel()
    }
    
    func didRecieve(_ data: Data, from connection: NWConnection) {
        if connection == serverConnectionManager.remoteConnection {
            logManager.log("Recieved \(data) from server, sending to clients.", source: .server)
            clientConnectionManager.send(data)
        } else {
            logManager.log("Recieved \(data) from client endpoint, sending to server.", source: .client(connection))
            serverConnectionManager.send(data)
        }
    }
    
    func listenerStateUpdateHandler(_ newState: NWListener.State) {
        switch newState {
        case .setup:
            logManager.log("Setting up", source: .proxy)
        case .waiting(let nWError):
            logManager.log("Waiting with error: \(nWError.localizedDescription)", source: .proxy, level: .failure)
        case .ready:
            logManager.log("Server active", source: .server, level: .success)
            self.state = .enabled
        case .failed(let nWError):
            logManager.log("Listener failed with error: \(nWError.localizedDescription)", source: .proxy, level: .failure)
            self.state = .disabled
        case .cancelled:
            logManager.log("Listener cancelled", source: .proxy, level: .failure)
            self.state = .disabled
        @unknown default:
            fatalError()
        }
    }
}

extension PXServer {
    enum State {
        case disabled, enabled
    }
}
