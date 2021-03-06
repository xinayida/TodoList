//
//  EditingPage.swift
//  TodoList
//
//  Created by 王为 on 2021/1/19.
//

import SwiftUI

struct EditingPage: View {
    
    @EnvironmentObject var UserData: ToDo
    
    @State var title: String = ""
    @State var dueDate: Date = Date()
    @State var isFavorite: Bool = false
    var id: Int? = nil
    
    @Environment(\.presentationMode) var presentation
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("事项")){
                    TextField("事项内容", text: $title)
                    DatePicker(selection: self.$dueDate, label: { Text("截止时间")})
                }
                
                Section{
                    Toggle(isOn: self.$isFavorite, label: {
                        Text("收藏")
                    })
                }
                
                Section{
                    Button(action: {
                        if(id == nil){
                            self.UserData.add(data: SingleToDo(title: self.title, dueDate: self.dueDate, isFavorite: self.isFavorite))
                        } else {
                            self.UserData.edit(id: self.id!, data: SingleToDo(title: self.title, dueDate: self.dueDate, isFavorite: self.isFavorite))
                        }
                        
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Text("确认")
                    }
                    
                    Button(action:{
                        self.presentation.wrappedValue.dismiss()
                    }){
                        Text("取消")
                    }
                }
            }
            .navigationTitle("添加")
        }
    }
}

struct EditingPage_Previews: PreviewProvider {
    static var previews: some View {
        EditingPage()
    }
}
