//
//  EditingPage.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import SwiftUI

struct EditingPage: View {
    @EnvironmentObject var userData: ToDo
    @State var notes: String = ""
    @State var title: String = ""
    @State var duedate: Date = Date()
    @State var isMarked: Bool = false
    @State var isRemind: Bool = false
    @State var remindTime: Bool = false
    @Binding var editingMode: Bool
    @Environment(\.presentationMode) var presentation
    
    var id: Int? = nil
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField("Title", text: $title)
                    .keyboardType(.default)
                        
                    TextField("Notes", text: $notes)
                    .keyboardType(.default)
                }
                .modifier(DismissingKeyboard())
                
                Section {
                    Toggle(isOn: $isRemind){
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                            .imageScale(.large)
                        Text("Date")
                    }
                    if isRemind {
                        DatePicker(selection: $duedate, displayedComponents: .date){
                            
                        }
                    }
                    Toggle(isOn: $remindTime){
                        Image(systemName: "alarm")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Text("Time")
                    }
                    if remindTime {
                        DatePicker(selection: $duedate, displayedComponents: .hourAndMinute){
                            
                        }
                    }
                }
                .modifier(DismissingKeyboard())
                
                Section {
                    Toggle(isOn: $isMarked) {
                        Image(systemName: isMarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(.orange)
                            .imageScale(.medium)
                        Text("Mark")
                    }
                }
                .modifier(DismissingKeyboard())
                
                Section {
                    Button(action: {
                        if title == "" {
                            presentation.wrappedValue.dismiss()
                        } else if id == nil {
                            userData.add(data: SingleToDo(notes: notes, title: title, duedate: duedate, isMarked: isMarked, isRemind: isRemind, remindTime: remindTime))
                        } else {
                            userData.edit(id: self.id!, data: SingleToDo(notes: notes, title: title, duedate: duedate, isMarked: isMarked, isRemind: isRemind, remindTime: remindTime))
                        }
                        presentation.wrappedValue.dismiss()
                        if editingMode {
                            editingMode = false
                        }
                    }, label: {
                        Text("Done")
                    })
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            }
            .navigationTitle("Details")
        }
    }
}

//struct EditingPage_Previews: PreviewProvider {
//    static var previews: some View {
//        EditingPage()
//    }
//}
