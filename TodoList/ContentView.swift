//
//  ContentView.swift
//  TodoList
//
//  Created by 王为 on 2021/1/18.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var UserData: ToDo = ToDo(data:[
                                SingleToDo(title: "写作业", dueDate: Date()),
                                SingleToDo(title: "复习", dueDate: Date())])
 
    var body: some View {
        ScrollView(.vertical,showsIndicators: true){
        VStack {
            ForEach(self.UserData.ToDoList){item in
                SingleCardView(index: item.id).environmentObject(self.UserData).padding()
            }
        }.padding(.horizontal)
        }
    }
}

struct SingleCardView: View {
    @EnvironmentObject var userData: ToDo
    var index: Int
    @State var isChecked : Bool = false
    var body: some View {
        HStack {
            Rectangle().frame(width: 6).foregroundColor(.blue)
            VStack(alignment: .leading, spacing: 6.0){
                Text(self.userData.ToDoList[index].title).font(.headline).fontWeight(.heavy)
                Text(self.userData.ToDoList[index].dueDate.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }.padding(.leading)
            Spacer()
            Image(systemName: self.userData.ToDoList[index].isChecked ? "checkmark.square.fill": "square").imageScale(.large).padding(.trailing)
                .onTapGesture {
                    self.userData.check(id: self.index)
                }
        }
        .frame(height: 80, alignment: .center)
        .background(Color.white)
        .cornerRadius(10, antialiased: true)
        .shadow(radius: 10,x:0, y:10)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
