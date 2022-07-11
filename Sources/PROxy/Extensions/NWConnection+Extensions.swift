//
//  NWConnection+Extensions.swift
//  PROxy
//
//  Created by Jack Cummings on 7/4/22.
//

import Network

extension NWConnection: Equatable {
    public static func == (lhs: NWConnection, rhs: NWConnection) -> Bool {
        return (lhs.endpoint == rhs.endpoint)
    }
}

