//
//  UserData.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import Foundation

class ToDo: ObservableObject {
    @Published var todoList: [SingleToDo]
    var count: Int = 0
    
    init() {
        self.todoList = []
    }
    init(data: [SingleToDo]) {
        self.todoList = []
        for item in data {
            todoList.append(SingleToDo(id: self.count,title: item.title, duedate: item.duedate))
            count += 1
        }
    }
    
    func check(id: Int) {
        todoList[id].isChecked.toggle()
    }
    
    //MARK: 添加新提醒事项
    func add(data: SingleToDo) {
        todoList.append(SingleToDo(id: self.count, title: data.title, duedate: data.duedate))
        count += 1
    }
    
    //MARK: 编辑现有提醒事项
    func edit(id: Int, data: SingleToDo) {
        todoList[id].title = data.title
        todoList[id].duedate = data.duedate
        todoList[id].isChecked = false
    }
}

struct SingleToDo: Identifiable {
    var id: Int = 0
    
    var title: String
    var duedate: Date = Date()
    var isChecked: Bool = false
}
