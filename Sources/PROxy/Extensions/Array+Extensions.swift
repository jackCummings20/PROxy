//
//  Array+Extensions.swift
//  PROxy
//
//  Created by Jack Cummings on 7/4/22.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(_ element: Element) {
        guard let index = firstIndex(of: element) else { return }
        remove(at: index)
    }
}

