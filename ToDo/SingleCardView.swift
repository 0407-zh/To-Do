//
//  SingleCardView.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

let formatter = DateFormatter()
let currentDate = DateFormatter()
let scheduledDate = DateFormatter()

func initUserData() -> [SingleToDo] {
    formatter.dateFormat = "yyyy-MM-dd HH:mm, EEEE"
    currentDate.dateFormat = "MMM dd, EEEE"
    scheduledDate.dateFormat = "yyyy-MM-dd, EEEE"
    
    var output: [SingleToDo] = []
    if let dataStored = UserDefaults.standard.object(forKey: "def") as? Data {
        let data = try! decoder.decode([SingleToDo].self, from: dataStored)
        for item in data {
            if !item.deleted {
                output.append(SingleToDo(notes: item.notes, title: item.title, duedate: item.duedate, isChecked: item.isChecked, isMarked: item.isMarked, isRemind: item.isRemind, remindTime: item.remindTime, id: output.count))
            }
        }
    }
    return output
}

struct SingleCardView: View {
    @EnvironmentObject var userData: ToDo
    @State var showEditingPage: Bool = false
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    var index: Int
    let time = Date()
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 6)
                .foregroundColor(Color("Card" + String(index % 6)))//卡片侧边颜色
            
            if editingMode {
                //删除按钮
                Button(action: {
                    userData.delete(id: index)
//                    editingMode = false
                }) {
                    Image(systemName: "minus.circle.fill")
                        .foregroundColor(.red)
                        .imageScale(.large)
                        .padding(.leading)
                }
            }
            
            Button(action: {
                if !editingMode {
                    userData.vibrationFeedback()
                    userData.check(id: index)
                }
            }){
                Group{
                    VStack(alignment: .leading, spacing: 6){
                        HStack{
                            Text(userData.todoList[index].title)
                                .font(.headline)
                                .fontWeight(.heavy)
                                .strikethrough(userData.todoList[index].isChecked)
                                .foregroundColor(userData.todoList[index].isChecked ? .secondary : .primary)
                            
                            if userData.todoList[index].isMarked {
                                Image(systemName: "bookmark.fill")
                                    .foregroundColor(.orange)
                                    .imageScale(.small)
                            }
                        }
                        
                        if !showEditingPage {
                            if (userData.todoList[index].remindTime && userData.todoList[index].isRemind) || (userData.todoList[index].remindTime) {
                                Text(formatter.string(from: userData.todoList[index].duedate!))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            } else if userData.todoList[index].isRemind {
                                Text(scheduledDate.string(from: time))
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(userData.todoList[index].notes)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
            }
            
            if editingMode {
                Button(action: {
                    showEditingPage = true
                }){
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                }
                .sheet(isPresented: $showEditingPage, content: {
                    EditingPage(notes: userData.todoList[index].notes,
                                title: userData.todoList[index].title,
                                duedate: userData.todoList[index].duedate!,
                                isMarked: userData.todoList[index].isMarked,
                                isRemind: userData.todoList[index].isRemind,
                                remindTime: userData.todoList[index].remindTime,
                                editingMode: $editingMode,
                                id: index)
                        .environmentObject(userData)
                })
            }
            
            if !editingMode {
                Image(systemName: userData.todoList[index].isChecked ? "checkmark.square" : "square")
                    .imageScale(.large)
                    .padding(.trailing)
                    .onTapGesture {
                        userData.vibrationFeedback()
                        userData.check(id: index)
                    }
            } else {
                Image(systemName:  selection.firstIndex(where: { $0 == index
                    }) == nil ? "circle" : "checkmark.circle")
                    .foregroundColor(.blue)
                    .imageScale(.large)
                    .padding(.trailing)
                    .onTapGesture {
                        userData.vibrationFeedback()
                        if selection.firstIndex(where: {
                            $0 == index
                        }) == nil {
                            selection.append(index)
                        } else {
                            selection.remove(at: selection.firstIndex(where: { $0 == index })!)
                        }
                    }
            }
        }
        .frame(height: 80)
        .background(Color("SingleCardColor"))
        .cornerRadius(10)
        .shadow(radius: 10, x: 0, y: 10)
    }
}
