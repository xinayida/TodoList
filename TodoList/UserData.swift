//
//  UserData.swift
//  TodoList
//
//  Created by 王为 on 2021/1/19.
//

import Foundation

class ToDo: ObservableObject {
    @Published var ToDoList: [SingleToDo]
    var count = 0
    
    init(){
        ToDoList = []
        
    }
    init(data: [SingleToDo]) {
        self.ToDoList = []
        for item in data{
            self.ToDoList.append(SingleToDo(title: item.title, dueDate: item.dueDate, id: self.count))
           count += 1
        }
    }
    
    func check(id: Int) {
        self.ToDoList[id].isChecked.toggle()
    }
}

struct SingleToDo: Identifiable {
    var title: String = ""
    var dueDate: Date = Date()
    var isChecked: Bool = false
    
    var id: Int = 0
}
