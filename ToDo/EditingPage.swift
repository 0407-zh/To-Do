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
    @State var selectColorIndex: Int = 0
//    @Binding var color: Color
    @Environment(\.presentationMode) var presentation
    
    var id: Int? = nil
    
    var body: some View {
        NavigationView{
            Form {
                Section {
                    TextField(LocalizedStringKey("Title"), text: $title)
                    .keyboardType(.default)
                        
                    TextField(LocalizedStringKey("Notes"), text: $notes)
                    .keyboardType(.default)
                }
                .modifier(DismissingKeyboard())
                
                Section {
                    Toggle(isOn: $isRemind){
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                            .imageScale(.large)
                        Text(LocalizedStringKey("Date"))
                    }
                    if isRemind {
                        DatePicker(LocalizedStringKey(""), selection: $duedate, displayedComponents: .date)
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                    Toggle(isOn: $remindTime){
                        Image(systemName: "alarm")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Text(LocalizedStringKey("Time"))
                    }
                    if remindTime {
                        DatePicker(LocalizedStringKey(""), selection: $duedate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(WheelDatePickerStyle())
                    }
                }
                .modifier(DismissingKeyboard())
                
                Section {
                    
                    Toggle(isOn: $isMarked) {
                        Image(systemName: isMarked ? "bookmark.fill" : "bookmark")
                            .foregroundColor(Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)))
                            .imageScale(.large)
                        Text(LocalizedStringKey("Mark"))
                    }
                }
                .modifier(DismissingKeyboard())
                
//                Section {
//                    HStack{
//                        Image(systemName: "eyedropper.halffull")
//                            .foregroundColor(color)
//                            .imageScale(.medium)
//                        ColorPicker("Color", selection: $color)
//                    }
//                }
                
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
                        Text(LocalizedStringKey("Done"))
                    })
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Text(LocalizedStringKey("Cancel"))
                    })
                }
            }
            .navigationBarTitle(Text(LocalizedStringKey("Details")))
        }
    }
}

//struct EditingPage_Previews: PreviewProvider {
//    static var previews: some View {
//        EditingPage()
//    }
//}
