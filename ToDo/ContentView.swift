//
//  ContentView.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userdata: ToDo = ToDo(data: initUserData())
    @State var showEditingPage = false
    @State var selection: [Int] = []
    @State var editingMode = false
    let date = Date()
    
    var body: some View {
        VStack{
            NavigationView{
                ScrollView(.vertical, showsIndicators: true/*显示滚动条*/) {
                    VStack{
                        HStack{
                            Text(currentDate.string(from: date))
                                .bold()
                                .font(.headline)
                                .padding(.leading)
                            Spacer()
                        }
                        ForEach(userdata.todoList){ item in
                            if !item.deleted {
                                SingleCardView(editingMode: $editingMode, selection: $selection, index: item.id)
                                    .environmentObject(userdata)
                                    .padding(.top)
                                    .padding(.horizontal)
                                    .animation(.spring())
                                    .transition(.slide)
                            }
                        }
                    }
                }
                .navigationTitle("To Do")
                .navigationBarItems(trailing:
                                        HStack(spacing: 10){
                                            if editingMode {
                                                DeleteButton(selection: $selection, editingMode: $editingMode)
                                                    .environmentObject(userdata)
                                            }
                                            EditingButton(editingMode: $editingMode, selection: $selection)
                                        })
            }
        Spacer()
            
            HStack{
                Spacer()
                
                Button(action: {
                    if !editingMode {
                        showEditingPage = true
                    }
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


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
