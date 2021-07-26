//
//  Frames+Emitting.swift
//  
//
//  Created by Boris Gutic on 06.05.21.
//

import SwiftUI

public enum FrameEmitterLocation {
    case background
    case overlay
}

fileprivate struct FrameEmitter: View {
    var coordinateSpace: CoordinateSpace = .global

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: FramePreferenceKey.self,
                    value: proxy.frame(in: self.coordinateSpace)
                )
        }
    }
}

fileprivate struct FramesEmitter: View {
    var coordinateSpace: CoordinateSpace = .global

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: FramesPreferenceKey.self,
                    value: [proxy.frame(in: self.coordinateSpace)]
            )
        }
    }
}

fileprivate struct IdentifiedFramesEmitter<ID: Hashable>: View {
    var coordinateSpace: CoordinateSpace = .global
    var id: ID

    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: IdentifiableFramesPreferenceKey<ID>.self,
                    value: [id: proxy.frame(in: coordinateSpace)]
            )
        }
    }
}

fileprivate struct FramesCollector: ViewModifier {
    @Binding var frames: [CGRect]

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(FramesPreferenceKey.self) { frames in
                self.frames = frames.sorted(by: {
                    if $0.origin.x != $1.origin.x {
                        return $0.origin.x < $1.origin.x
                    }
                    return $0.origin.y < $1.origin.y
                })
            }
    }
}

public extension View {
    @ViewBuilder
    func emitFrames(
        in coordinateSpace: CoordinateSpace = .global,
        from location: FrameEmitterLocation = .background
    ) -> some View {
        switch location {
        case .background:
            background(FramesEmitter(coordinateSpace: coordinateSpace))
        case .overlay:
            overlay(FramesEmitter(coordinateSpace: coordinateSpace))
        }
    }

    func collectEmittedFrames(in frames: Binding<[CGRect]>) -> some View {
        modifier(FramesCollector(frames: frames))
    }
    
    @ViewBuilder
    func emitFrame(
        in coordinateSpace: CoordinateSpace = .global,
        from location: FrameEmitterLocation = .background
    ) -> some View {
        switch location {
        case .background:
            background(FrameEmitter(coordinateSpace: coordinateSpace))
        case .overlay:
            overlay(FrameEmitter(coordinateSpace: coordinateSpace))
        }
    }
    
    func collectEmittedFrame(in frame: Binding<CGRect>) -> some View {
        onPreferenceChange(FramePreferenceKey.self) { newFrame in
            frame.wrappedValue = newFrame
        }
    }
    
    @ViewBuilder
    func emitIdentifiableFrames<ID: Hashable>(
        in coordinateSpace: CoordinateSpace = .global,
        id: ID,
        from location: FrameEmitterLocation = .background
    ) -> some View {
        switch location {
        case .background:
            background(IdentifiedFramesEmitter(coordinateSpace: coordinateSpace, id: id))
        case .overlay:
            overlay(IdentifiedFramesEmitter(coordinateSpace: coordinateSpace, id: id))
        }
    }
    
    func collectEmittedIdentifiableFrames<ID: Hashable>(in frames: Binding<[ID: CGRect]>) -> some View {
        self.onPreferenceChange(IdentifiableFramesPreferenceKey<ID>.self) { identifiableFrames in
            frames.wrappedValue = identifiableFrames
        }
    }
}

struct FramesEmitter_Previews: PreviewProvider {
    private struct TestView: View {
        @State private var frames: [CGRect] = []
        
        private var frameStrings: [String] {
            frames.map { frame in
                String(format: "x: %.2f, y: %.2f  |  w: %.2f, h: %.2f",
                       frame.origin.x,
                       frame.origin.y,
                       frame.size.width,
                       frame.size.height)
            }
        }
        
        var body: some View {
            VStack(spacing: 20) {
                VStack(spacing: 4) {
                    ForEach(frameStrings, id: \.self) { frameString in
                        Text(frameString)
                            .font(.footnote.bold())
                            .padding(4)
                            .background(Color.yellow.opacity(0.2))
                    }
                }
                
                VStack(spacing: 8) {
                    Group {
                        Text("Hello, World!")
                            .font(.title)
                        
                        Text("This is some description text")
                            .font(.body)
                    
                        Text("and some really")
                            .font(.caption)
                        
                        Text("small caption")
                            .font(.caption)
                    }
                    .emitFrames()
                }
                .collectEmittedFrames(in: $frames)
            }
        }
    }
    
    static var previews: some View {
        TestView()
    }
}
