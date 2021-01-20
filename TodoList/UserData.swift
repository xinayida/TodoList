//
//  UserData.swift
//  TodoList
//
//  Created by 王为 on 2021/1/19.
//

import Foundation

var encoder = JSONEncoder()
var decoder = JSONDecoder()

class ToDo: ObservableObject {
    @Published var todoList: [SingleToDo]
    var count = 0
    
    init(){
        todoList = []
        
    }
    init(data: [SingleToDo]) {
        self.todoList = []
        for item in data{
            self.todoList.append(SingleToDo(title: item.title, dueDate: item.dueDate, isChecked: item.isChecked, id: self.count))
           count += 1
        }
    }
    
    func check(id: Int) {
        self.todoList[id].isChecked.toggle()
        self.dataStore()
    }
    
    func add(data: SingleToDo) {
        todoList.append(SingleToDo(title: data.title, dueDate: data.dueDate, id: self.count))
        self.count += 1
        self.sort()
        self.dataStore()
    }
    
    func edit(id: Int, data: SingleToDo) {
        self.todoList[id].dueDate = data.dueDate
        self.todoList[id].title = data.title
        self.todoList[id].isChecked = false
        self.sort()
        self.dataStore()
    }
    
    func sort(){
        self.todoList.sort(by: {(data1, data2) in
//            return data1.dueDate.timeIntervalSince1970 < data2.dueDate.timeIntervalSince1970
            return data1.dueDate.distance(to: data2.dueDate) < 0
        })
        
        for i in 0 ..< self.todoList.count{
            self.todoList[i].id = i
        }
    }
    
    func delete(id: Int) {
        self.todoList[id].deleted = true
//        self.ToDoList.remove(at: id)
//        for i in id ..< self.ToDoList.count{
//            self.ToDoList[i].id = i
//        }
        self.dataStore()
    }
    
    func dataStore(){
        let dataStore = try! encoder.encode(self.todoList)
        UserDefaults.standard.set(dataStore, forKey: "todoList")
    }
}

struct SingleToDo: Identifiable , Codable{
    var title: String = ""
    var dueDate: Date = Date()
    var isChecked: Bool = false
    var deleted: Bool = false
    
    var id: Int = 0
}
