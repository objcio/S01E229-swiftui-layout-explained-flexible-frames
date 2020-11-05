//
//  Base.swift
//  SwiftUILayout
//
//  Created by Florian Kugler on 26-10-2020.
//

import SwiftUI

protocol View_ {
    associatedtype Body: View_
    var body: Body { get }
    
    // for debugging
    associatedtype SwiftUIView: View
    var swiftUI: SwiftUIView { get }
}

typealias RenderingContext = CGContext
typealias ProposedSize = CGSize

protocol BuiltinView {
    func render(context: RenderingContext, size: CGSize)
    func size(proposed: ProposedSize) -> CGSize
    typealias Body = Never
}

extension View_ where Body == Never {
    var body: Never { fatalError("This should never be called.") }
}

extension Never: View_ {
    typealias Body = Never
    var swiftUI: Never { fatalError("Should never be called") }
}

extension View_ {
    func _render(context: RenderingContext, size: CGSize) {
        if let builtin = self as? BuiltinView {
            builtin.render(context: context, size: size)
        } else {
            body._render(context: context, size: size)
        }
    }
    
    func _size(proposed: ProposedSize) -> CGSize {
        if let builtin = self as? BuiltinView {
            return builtin.size(proposed: proposed)
        } else {
            return body._size(proposed: proposed)
        }
    }
}
