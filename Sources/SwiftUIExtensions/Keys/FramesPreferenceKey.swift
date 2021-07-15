//
//  File.swift
//  
//
//  Created by Boris Gutic on 06.05.21.
//

import SwiftUI

struct FramesPreferenceKey: PreferenceKey {
    static let defaultValue: [CGRect] = []
    
    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value += nextValue()
    }
}

struct IdentifiableFramesPreferenceKey<ID: Hashable>: PreferenceKey {
    typealias Value = [ID: CGRect]
    static var defaultValue: Value { [ID: CGRect]() }
    
    static func reduce(value: inout [ID: CGRect], nextValue: () -> [ID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { lhs, rhs in return lhs })
    }
}
