//
//  ContentView.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

func initUserData() -> [SingleToDo] {
    var output: [SingleToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "todoList") as? Data {
        let data = try! decoder.decode([SingleToDo].self, from: dataStored)
        for item in data {
            if !item.deleted {
                output.append(SingleToDo(id: output.count, title: item.title, duedate: item.duedate, isChecked: item.isChecked))
            }
        }
    }
    return output
}

struct ContentView: View {
    @ObservedObject var userdata: ToDo = ToDo(data: initUserData())
    @State var showEditingPage = false
    @State var selection: [Int] = []
    @State var editingMode = false
    
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView(.vertical, showsIndicators: true/*显示滚动条*/) {
                    VStack{
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
                .navigationTitle("ToDo")
                .navigationBarItems(trailing:
                                        HStack(spacing: editingMode ? 20 : 0){
                                            if editingMode {
                                                DeleteButton(selection: $selection)
                                                    .environmentObject(userdata)
                                            }
                                            EditingButton(editingMode: $editingMode, selection: $selection)
                                        })
            }
        
            HStack{
                Spacer()
                
                VStack{
                    Spacer()
                    
                    Button(action: {
                        if editingMode {
                            showEditingPage = false
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
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
