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
    @State var showEditingPage = false
    
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView(.vertical, showsIndicators: true/*显示滚动条*/) {
                    VStack{
                        ForEach(userdata.todoList){ item in
                            SingleCardView(index: item.id)
                                .environmentObject(userdata)
                                .padding(.top)
                                .padding(.horizontal)
                        }
                    }
                }
                .navigationTitle("ToDo")
            }
        
            HStack{
                Spacer()
                
                VStack{
                    Spacer()
                    
                    Button(action: {
                        showEditingPage = true
                    }){
                        Image(systemName: "pencil.tip.crop.circle.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .foregroundColor(.blue)
                            .padding(.trailing)
                    }
                    .sheet(isPresented: $showEditingPage, content: {
                        EditingPage()
                            .environmentObject(userdata)
                    })
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

