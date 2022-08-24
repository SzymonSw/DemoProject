//
//  SimpleSwiftUIView.swift
//  PlayAround
//
//  Created by Szymon Swietek on 11/08/2022.
//

import SwiftUI

struct TheItem: Identifiable, Hashable {
    let name: String
    let secondName: String
    var id: Self {
        self
    }
}

struct SimpleSwiftUIView: View {
    
    static let items = [
        TheItem(name: "Name_1", secondName: "SName_1"),
        TheItem(name: "Name_2", secondName: "SName_2"),
        TheItem(name: "Name_3", secondName: "SName_3")
    ]
    
    @State var selectedItem = items.first!
        
    var body: some View {
        Form {
            Picker("Select item", selection: $selectedItem) {
                ForEach(Self.items) { item in
                    Text(item.name)
                }
            }
            Text("Selected:  \(selectedItem.name) \(selectedItem.secondName)")
        }
    }
}

struct SimpleSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SimpleSwiftUIView()
        }
    }
}
