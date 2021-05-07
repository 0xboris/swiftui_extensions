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
