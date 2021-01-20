//
//  ContentView.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userdata: ToDo = ToDo(data: initUserData())
    @State var showEditingPage: Bool = false
    @State var selection: [Int] = []
    @State var editingMode: Bool = false
    @State var showMarkedOnly: Bool = false
    @State var dateStr: String = ""
    @State var date = Date()
    @State var animate: Bool = false
    @State var color: Color = Color.blue
    
    // 定时器，每秒触发一次
    let timer = Timer.publish(every: 3600 * 24, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack{
            NavigationView{
                ScrollView(.vertical, showsIndicators: true/*显示滚动条*/) {
                    VStack {
                        HStack {
                            Text(currentDate.string(from: date))
                                .bold()
                                .font(.headline)
                                .padding(.leading)
                                .onReceive(timer) { _ in
                                    date = Date(timeInterval: 3600 * 24, since: date)
                                }
                            Spacer()
                        }
                        ForEach(userdata.todoList){ item in
                            if !item.deleted {
                                if !showMarkedOnly || item.isMarked {
                                    SingleCardView(editingMode: $editingMode, selection: $selection, animate: $animate, color: $color, index: item.id)
                                        .environmentObject(userdata)
                                        .padding(.top)
                                        .padding(.horizontal)
                                        .animation(.spring())
                                        .transition(.slide)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("To Do!")
                .navigationBarItems(trailing:
                                        HStack(spacing: 15){
                                            if editingMode {
                                                DeleteButton(selection: $selection, editingMode: $editingMode)
                                                    .environmentObject(userdata)
                                                    .animation(.spring())
                                                    .transition(.opacity)
                                            } else {
                                                ShowMarkedOnlyButton(showMarkedOnly: $showMarkedOnly)
                                                    .animation(.spring())
                                                    .transition(.opacity)
                                            }
                                            EditButton(editingMode: $editingMode, selection: $selection)
                                        })
            }
            
            VStack{
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
                        EditingPage(editingMode: $editingMode, color: $color)
                            .environmentObject(userdata)
                    })
                }
            }
        }
    }
}

struct DeleteButton: View {
    @Binding var selection: [Int]
    @EnvironmentObject var userdata: ToDo
    @Binding var editingMode: Bool
    
    var body: some View {
        Button(action: {
            for i in selection {
                userdata.delete(id: i)
            }
            editingMode = false
        }){
            Image(systemName: "trash")
                .imageScale(.large)
        }
    }
}

struct EditButton: View {
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    
    var body: some View {
        Button(action: {
            editingMode.toggle()
            selection.removeAll()
        }){
            Image(systemName: "slider.horizontal.3")
                .imageScale(.large)
        }
    }
}

struct ShowMarkedOnlyButton: View {
    @Binding var showMarkedOnly: Bool
    
    var body: some View {
        Button(action: {
            showMarkedOnly.toggle()
        }){
            Image(systemName: showMarkedOnly ? "bookmark.fill" : "bookmark")
                .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                .imageScale(.large)
        }
    }
}

extension Date {
    func relativeTime(in locale: Locale = .current) -> String {
        let homepageFormatter = RelativeDateTimeFormatter()
        homepageFormatter.calendar = .current
        return homepageFormatter.localizedString(for: self, relativeTo: Date())
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
