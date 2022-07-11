//
//  PXConnectionDelegate.swift
//  PROxy
//
//  Created by Jack Cummings on 7/5/22.
//

import Foundation
import Network

protocol PXConnectionDelegate {
    var logManager: PXLogManager { get }
    func didRecieve(_ data: Data, from connection: NWConnection)
}
