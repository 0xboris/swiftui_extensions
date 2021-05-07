//
//  FramePreferenceKey.swift
//  
//
//  Created by Boris Gutic on 06.05.21.
//

import SwiftUI

struct FramePreferenceKey: PreferenceKey {
    static let defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
