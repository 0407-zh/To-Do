//
//  SingleCardView.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

struct SingleCardView: View {
    @EnvironmentObject var userData: ToDo
    @State var showEditingPage: Bool = false
    @Binding var editingMode: Bool
    @Binding var selection: [Int]
    var index: Int
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(width: 6)
                .foregroundColor(.blue)
            
            if editingMode {
                //删除按钮
                Button(action: {
                    userData.delete(id: index)
                }) {
                    Image(systemName: "trash")
                        .imageScale(.large)
                        .padding(.leading)
                }
            }
            
            //点击已创建事项进行编辑
            Button(action: {
                showEditingPage = true
            }){
                Group{
                    VStack(alignment: .leading, spacing: 6){
                        Text(userData.todoList[index].title)
                            .font(.headline)
                            .foregroundColor(.black)
                            .fontWeight(.heavy)
                        Text(userData.todoList[index].duedate.description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.leading)
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $showEditingPage, content: {
                EditingPage(title: userData.todoList[index].title,
                            duedate: userData.todoList[index].duedate,
                            id: index)
                    .environmentObject(userData)
            })
            
            if !editingMode {
                Image(systemName: userData.todoList[index].isChecked ? "record.circle" : "circle")
                    .imageScale(.large)
                    .padding(.trailing)
                    .onTapGesture {
                        userData.check(id: index)
                    }
            } else {
                Image(systemName:  selection.firstIndex(where: { $0 == index
                    }) == nil ? "circle" : "checkmark.circle.fill")
                    .imageScale(.large)
                    .padding(.trailing)
                    .onTapGesture {
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
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10, x: 0, y: 10)
    }
}


//struct SingleCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleCardView(index: 1)
//    }
//}
