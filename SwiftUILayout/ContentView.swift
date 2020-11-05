//
//  ContentView.swift
//  NotSwiftUI
//
//  Created by Chris Eidhof on 05.10.20.
//

import SwiftUI
import Cocoa

func render<V: View_>(view: V, size: CGSize) -> Data {
    return CGContext.pdf(size: size) { context in
        view
            .frame(width: size.width, height: size.height)
            ._render(context: context, size: size)
    }
}

struct ContentView: View {
    let size = CGSize(width: 600, height: 400)

    
    var sample: some View_ {
        Ellipse_()
            .foregroundColor(.red)
            .frame(width: 150)
            .frame(
                minWidth: minWidth.enabled ? minWidth.0.rounded() : nil,
                maxWidth: maxWidth.enabled ? maxWidth.0.rounded() : nil
            )
            .overlay(GeometryReader_ { size in
                Text_("\(Int(size.width))x\(Int(size.height))")
            })
            .border(NSColor.blue, width: 2)
            .frame(width: width.rounded(), height: 300)
            .border(NSColor.yellow, width: 2)
    }
    


    @State var opacity: Double = 0.5
    @State var width: CGFloat  = 300
    @State var minWidth: (CGFloat, enabled: Bool)  = (100, true)
    @State var maxWidth: (CGFloat, enabled: Bool)  = (400, true)

    var body: some View {
        VStack {
            ZStack  {
                Image(nsImage: NSImage(data: render(view: sample, size: size))!)
                    .opacity(1-opacity)
                sample.swiftUI.frame(width: size.width, height: size.height)
                    .opacity(opacity)
            }
            Slider(value: $opacity, in: 0...1)
            HStack {
                Text("Width \(width.rounded())")
                Slider(value: $width, in: 0...600)
            }
            HStack {
                Text("Min Width \(minWidth.0.rounded())")
                Slider(value: $minWidth.0, in: 0...600)
                Toggle("", isOn: $minWidth.enabled)
            }
            HStack {
                Text("Max Width \(maxWidth.0.rounded())")
                Slider(value: $maxWidth.0, in: 0...600)
                Toggle("", isOn: $maxWidth.enabled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
