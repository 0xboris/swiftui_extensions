//
//  SizeEnvironmentKey.swift
//  
//
//  Created by Boris Gutic on 06.05.21.
//

import SwiftUI

public struct SizeEnvironmentKey: EnvironmentKey {
    public static var defaultValue: CGSize? = nil
}

public extension EnvironmentValues {
    var size: CGSize? {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
}
