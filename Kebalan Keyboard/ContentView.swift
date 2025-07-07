//
//  ContentView.swift
//  Kebalan Keyboard
//
//  Created by Elias Scott on 2025/6/1.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "tree")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("nengi ta!ti keyboard na  text na kebalan")

            @State  var inputText: String = ""
            TextField("請輸入文字...", text: $inputText, onCommit: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
