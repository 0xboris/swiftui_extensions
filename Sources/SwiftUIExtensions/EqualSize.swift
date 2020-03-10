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
        .frame(width: size?.width, height: size?.width)
    }
}

public enum SizeReference {
    case width
    case height
    case max
}

private struct EqualSizes: ViewModifier {
    @State private var size: CGFloat?
    private let reference: SizeReference
    
    init(reference: SizeReference) { self.reference = reference }
    
    func body(content: Content) -> some View {
        content.onPreferenceChange(SizePreferenceKey.self, perform: { sizes in
            self.size = sizes.map {
                switch self.reference {
                case .width: return $0.width
                case .height: return $0.height
                case .max: return  max($0.width, $0.height)
                }
            }.max()
        })
        .environment(\.size, size.map { CGSize(width: $0, height: $0) })
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
