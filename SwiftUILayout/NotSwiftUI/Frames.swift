//
//  Frames.swift
//  SwiftUILayout
//
//  Created by Florian Kugler on 26-10-2020.
//

import SwiftUI

struct FixedFrame<Content: View_>: View_, BuiltinView {
    var width: CGFloat?
    var height: CGFloat?
    var alignment: Alignment_
    var content: Content
    
    func size(proposed: ProposedSize) -> CGSize {
        let childSize = content._size(proposed: ProposedSize(width: width ?? proposed.width, height: height ?? proposed.height))
        return CGSize(width: width ?? childSize.width, height: height ?? childSize.height)
    }
    func render(context: RenderingContext, size: ProposedSize) {
        context.saveGState()
        let childSize = content._size(proposed: size)
        context.align(childSize, in: size, alignment: alignment)
        content._render(context: context, size: childSize)
        context.restoreGState()
    }
    
    var swiftUI: some View {
        content.swiftUI.frame(width: width, height: height, alignment: alignment.swiftUI)
    }
}

extension RenderingContext {
    func align(_ childSize: CGSize, in parentSize: CGSize, alignment: Alignment_) {
        let parentPoint = alignment.point(for: parentSize)
        let childPoint = alignment.point(for: childSize)
        translateBy(x: parentPoint.x - childPoint.x, y: parentPoint.y-childPoint.y)
    }
}

struct FlexibleFrame<Content: View_>: View_, BuiltinView {
    var minWidth: CGFloat?
    var idealWidth: CGFloat?
    var maxWidth: CGFloat?
    var minHeight: CGFloat?
    var idealHeight: CGFloat?
    var maxHeight: CGFloat?
    var alignment: Alignment_
    var content: Content
    
    func size(proposed p: ProposedSize) -> CGSize {
        var proposed = p
        if let min = minWidth, min > proposed.width {
            proposed.width = min
        }
        if let max = maxWidth, max <  proposed.width {
            proposed.width = max
        }
        var result = content._size(proposed: proposed)
        if let m = minWidth {
            result.width = max(m, min(result.width, proposed.width))
        }
        if let m = maxWidth {
            result.width = min(m, max(result.width, proposed.width))
        }
        return result
    }
    func render(context: RenderingContext, size: ProposedSize) {
        context.saveGState()
        let childSize = content._size(proposed: size)
        context.align(childSize, in: size, alignment: alignment)
        content._render(context: context, size: childSize)
        context.restoreGState()
    }
    
    var swiftUI: some View {
        content.swiftUI.frame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment.swiftUI)
    }
}


extension View_ {
    func frame(width: CGFloat? = nil, height: CGFloat? = nil, alignment: Alignment_ = .center) -> some View_ {
        FixedFrame(width: width, height: height, alignment: alignment, content: self)
    }
    
    func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment_ = .center) -> some View_ {
        FlexibleFrame(minWidth: minWidth, idealWidth: idealWidth, maxWidth: maxWidth, minHeight: minHeight, idealHeight: idealHeight, maxHeight: maxHeight, alignment: alignment, content: self)
    }

}


