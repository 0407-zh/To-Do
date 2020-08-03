//
//  ContentView.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userdata: ToDo = ToDo(data: [SingleToDo(title: "Hello World", duedate: Date()),
                                     SingleToDo(title: "Swift", duedate: Date()),
                                     SingleToDo(title: "Xcode", duedate: Date())
    ])
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true/*显示滚动条*/) {
            VStack{
                ForEach(userdata.todoList){ item in
                    SingleCardView(index: item.id)
                        .environmentObject(userdata)
                        .padding(.bottom, 10)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

