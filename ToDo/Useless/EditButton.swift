//
//  SelectButton.swift
//  ToDo
//
//  Created by Derek Chan on 2020/9/1.
//

import SwiftUI
//import PureSwiftUI https://github.com/CodeSlicing/pure-swift-ui.git

//struct EditButton: View {
//    @State var animate = false
//    @State private var rotation: Double = 0
//    @State private var trim: CGFloat = 0
//    @Binding var editingMode: Bool
//    @Binding var selection: [Int]
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .foregroundColor(Color("ButtonColor"))
//            ZStack {
////                Circle()
////                    .trim(from: 0, to: trim)
////                    .stroke(lineWidth: 2)
////                    .rotate(.degrees(rotation - 90.0))
//                Menu(animate: animate)
//                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round))
//                    .frame(15)
//            }
//            .rotate(.degrees(rotation))
//        }
//        .frame(25)
//        .onTapGesture {
//            withAnimation(Animation.linear(duration: 0.4)) {
//                if animate {
//                    rotation = 0
//                    trim = 0
//                } else {
//                    rotation = 180
//                    trim = 1
//                }
//                animate.toggle()
//            }
//            selection.removeAll()
//        }
//    }
//}
//
////struct SelectButton_Previews: PreviewProvider {
////    static var previews: some View {
////        SelectButton()
////    }
////}
//
//struct Menu: Shape {
//    private let layoutConfig = LayoutGuideConfig.grid(columns: 2, rows: 2)
//    private var factor: Double
//
//    init(animate: Bool = true) {
//        self.factor = animate ? 1 : 0
//    }
//
//    var animatableData: Double {
//        get { factor }
//        set { factor = newValue }
//    }
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        var g = layoutConfig.layout(in: rect)
//
//        path.move(g[0, 0])
//        path.line(g[2, 0].to(g[2, 2], factor))
//
//        path.move(g[0, 1].to(g[1, 1], factor))
//        path.line(g[2, 1].to(g[1, 1], factor))
//
//        path.move(g[0, 2])
//        path.line(g[2, 2].to(g[2, 0], factor))
//
//        return path
//    }
//}
