//
//  EqualSize.swift
//  
//
//  Created by Boris Gutic on 10.03.20.
//

import SwiftUI

private struct SizePreferenceKey: PreferenceKey {
    static let defaultValue: [CGSize] = []
    static func reduce(value: inout [CGSize], nextValue: () -> [CGSize]) {
        value.append(contentsOf: nextValue())
    }
}

private struct SizeEnvironmentKey: EnvironmentKey {
    static var defaultValue: CGSize? = nil
}

private extension EnvironmentValues {
    var size: CGSize? {
        get { self[SizeEnvironmentKey.self] }
        set { self[SizeEnvironmentKey.self] = newValue }
    }
}

private struct EqualSize: ViewModifier {
    @Environment(\.size) private var size
    
    func body(content: Content) -> some View {
        content.overlay(GeometryReader { proxy in
            Color.clear.preference(key: SizePreferenceKey.self, value: [proxy.size])
        })
        .frame(width: size?.width == 0 ? nil : size?.width, height: size?.height == 0 ? nil : size?.height)
    }
}

public enum SizeReference {
    case width
    case height
    case widthAndHeight
    case max
}

private struct EqualSizes: ViewModifier {
    @State private var size: CGSize?
    private let reference: SizeReference
    
    init(reference: SizeReference) { self.reference = reference }
    
    func body(content: Content) -> some View {
        content.onPreferenceChange(SizePreferenceKey.self, perform: { sizes in
            self.size = sizes
                .reduce(CGSize.zero) { result, size -> CGSize in
                    switch self.reference {
                    case .width: return CGSize(width: max(result.width, size.width), height: 0)
                    case .height: return CGSize(width: 0, height: max(result.height, size.height))
                    case .widthAndHeight: return CGSize(width: max(result.width, size.width), height: max(result.height, size.height))
                    case .max:
                        let m = max(size.width, size.height)
                        return CGSize(width: m, height: m)
                    }
                }
        })
        .environment(\.size, size)
    }
}

extension View {
    
    /// Call this method on views you want to be equally sized
    public func sizedEqually() -> some View {
        self.modifier(EqualSize())
    }
    
    /// Call this method on the view that contains the views you want to be equally sized
    public func equalSizes(by reference: SizeReference) -> some View {
        self.modifier(EqualSizes(reference: reference))
    }
}
