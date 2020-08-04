//
//  UserData.swift
//  ToDo
//
//  Created by Derek Chan on 2020/8/3.
//

import Foundation

var encoder = JSONEncoder()//编码器
var decoder = JSONDecoder()//解码器

class ToDo: ObservableObject {
    @Published var todoList: [SingleToDo]
    var count: Int = 0
    
    init() {
        self.todoList = []
    }
    init(data: [SingleToDo]) {
        self.todoList = []
        for item in data {
            todoList.append(SingleToDo(id: self.count,title: item.title, duedate: item.duedate, isChecked: item.isChecked))
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
        
        sort()
        
        dataStore()
    }
    
    //MARK: 编辑现有提醒事项
    func edit(id: Int, data: SingleToDo) {
        todoList[id].title = data.title
        todoList[id].duedate = data.duedate
        todoList[id].isChecked = false
        
        sort()
        
        dataStore()
    }
    
    //MARK: 删除提醒事项
    func delete(id: Int) {
        todoList[id].deleted = true
        
        dataStore()
    }
    
    //MARK: 对提醒事项按照时间排序
    func sort() {
        todoList.sort (by: { (data1, data2) in
            return data1.duedate.timeIntervalSince1970 < data2.duedate.timeIntervalSince1970
        })
        for i in 0..<self.todoList.count {
            todoList[i].id = i
        }
    }
    
    //MARK: 存储数据
    func dataStore() {
        let dataStored = try! encoder.encode(todoList)
        UserDefaults.standard.set(dataStored, forKey: "todoList")
    }
}

struct SingleToDo: Identifiable, Codable {
    var id: Int = 0
    
    var deleted: Bool = false
    
    var title: String = ""
    var duedate: Date = Date()
    var isChecked: Bool = false
}
