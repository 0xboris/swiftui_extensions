//
//  OriginsPreferenceKey.swift
//  
//
//  Created by Boris Gutic on 12.04.22.
//

import SwiftUI

public struct OriginPreferenceKey: PreferenceKey {
    public static let defaultValue: CGPoint = .zero
    
    public static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

public struct OriginsPreferenceKey: PreferenceKey {
    public static let defaultValue: [CGPoint] = []
    
    public static func reduce(value: inout [CGPoint], nextValue: () -> [CGPoint]) {
        value.append(contentsOf: nextValue())
    }
}
