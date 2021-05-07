//
//  SizePreferenceKey.swift
//  
//
//  Created by Boris Gutic on 06.05.21.
//

import SwiftUI

public struct SizePreferenceKey: PreferenceKey {
    public static let defaultValue: [CGSize] = []
    
    public static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}
