//
//  PXConnectionManager.swift
//  PROxy
//
//  Created by Jack Cummings on 7/5/22.
//

import Foundation
import Network

protocol PXConnectionManager {
    func readData(from connection: NWConnection)
    func send(_ data: Data)
}
