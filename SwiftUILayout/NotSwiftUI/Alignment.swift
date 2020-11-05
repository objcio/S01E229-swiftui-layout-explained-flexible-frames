//
//  Alignment.swift
//  SwiftUILayout
//
//  Created by Florian Kugler on 26-10-2020.
//

import SwiftUI

struct Alignment_ {
    var horizontal: HorizontalAlignment_
    var vertical: VerticalAlignment_
    var swiftUI: Alignment {
        Alignment(horizontal: horizontal.swiftUI, vertical: vertical.swiftUI)
    }
    static let center = Self(horizontal: .center, vertical: .center)
    static let leading = Self(horizontal: .leading, vertical: .center)
    static let trailing = Self(horizontal: .trailing, vertical: .center)
    static let top = Self(horizontal: .center , vertical: .top)
    static let topLeading = Self(horizontal: .leading, vertical: .top)
    static let topTrailing = Self(horizontal: .trailing, vertical: .top)
    static let bottom = Self(horizontal: .center , vertical: .bottom)
    static let bottomLeading = Self(horizontal: .leading, vertical: .bottom)
    static let bottomTrailing = Self(horizontal: .trailing, vertical: .bottom)
}

struct HorizontalAlignment_ {
    var  alignmentID:  AlignmentID.Type
    var swiftUI: HorizontalAlignment
    static let leading = Self(alignmentID: HLeading.self, swiftUI: .leading)
    static let center = Self(alignmentID: HCenter.self, swiftUI: .center)
    static let trailing = Self(alignmentID: HTrailing.self, swiftUI: .trailing)
}

struct VerticalAlignment_ {
    var  alignmentID:  AlignmentID.Type
    var swiftUI: VerticalAlignment
    static let top = Self(alignmentID: VTop.self, swiftUI: .top)
    static let center = Self(alignmentID: VCenter.self, swiftUI: .center)
    static let bottom = Self(alignmentID: VBottom.self, swiftUI: .bottom)
}

protocol AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat
}

enum VTop: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.height }
}

enum VCenter: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.height/2 }
}

enum VBottom: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { 0 }
}

enum HLeading: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { 0 }
}

enum HCenter: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.width/2 }
}

enum HTrailing: AlignmentID {
    static func defaultValue(in context: CGSize) -> CGFloat { context.width }
}

extension Alignment_ {
    func point(for size: CGSize) -> CGPoint {
        let x = horizontal.alignmentID.defaultValue(in: size)
        let y = vertical.alignmentID.defaultValue(in: size)
        return CGPoint(x: x, y: y)
    }
}

