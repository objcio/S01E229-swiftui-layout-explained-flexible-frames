//
//  Shape.swift
//  SwiftUILayout
//
//  Created by Florian Kugler on 26-10-2020.
//

import SwiftUI

protocol Shape_: View_ {
    func path(in rect: CGRect) -> CGPath
}

extension Shape_ {
    var body: some View_ {
        ShapeView(shape: self)
    }
    var swiftUI: AnyShape {
        AnyShape(shape: self)
    }
}

extension NSColor: View_ {
    var body: some View_ {
        ShapeView(shape: Rectangle_()).foregroundColor(self)
    }
    
    var swiftUI: some View {
        Color(self)
    }
}

struct AnyShape: Shape {
    let _path: (CGRect) -> CGPath
    init<S: Shape_>(shape: S) {
        _path = shape.path(in:)
    }
    
    func path(in rect: CGRect) -> Path {
        Path(_path(rect))
    }
}

struct ShapeView<S: Shape_>: BuiltinView, View_ {
    var shape: S
    
    func size(proposed: ProposedSize) -> CGSize {
        return proposed
    }
    
    func render(context: RenderingContext, size: ProposedSize) {
        context.saveGState()
        context.addPath(shape.path(in: CGRect(origin: .zero, size: size)))
        context.fillPath()
        context.restoreGState()
    }
    
    var swiftUI: some View {
        AnyShape(shape: shape)
    }
}

struct Rectangle_: Shape_ {
    func path(in rect: CGRect) -> CGPath {
        CGPath(rect: rect, transform: nil)
    }
}

struct Ellipse_: Shape_ {
    func path(in rect: CGRect) -> CGPath {
        CGPath(ellipseIn: rect, transform: nil)
    }
}

extension View_ {
    func foregroundColor(_ color: NSColor) -> some View_ {
        ForegroundColor(content: self, color: color)
    }
}

struct ForegroundColor<Content: View_>: View_, BuiltinView {
    var content: Content
    var color: NSColor
    
    func render(context: RenderingContext, size: CGSize) {
        context.saveGState()
        context.setFillColor(color.cgColor)
        content._render(context: context, size: size)
        context.restoreGState()
    }
    
    func size(proposed: ProposedSize) -> CGSize {
        content._size(proposed: proposed)
    }
    
    var swiftUI: some View {
        content.swiftUI.foregroundColor(Color(color))
    }
}
