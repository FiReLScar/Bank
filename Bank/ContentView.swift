//
//  ContentView.swift
//  Bank
//
//  Created by Levi Hicks on 2/18/23.
//

import SwiftUI
import Foundation

struct Input: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
    
}

struct PasswordInput: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            SecureField("", text: $text, onCommit: commit)
        }
    }
    
}

func Login(username: String, password: String) -> (Bool, String) {
    if (username == "" && password == "") {
        return (true, "Please enter your username and password")
    } else if (username == "") {
        return (true, "Please enter your username")
    } else if (password == "") {
        return (true, "Please enter your password")
    }
    print("Username: " + username)
    print("Password: " + password)
    // Connect to API
    guard let url = URL(string: "https://bank.n11.dev/api/login") else {
        return (false, "Failed to connect!")
    }

    var done: Bool = false
    
    let task = URLSession.shared.dataTask(with: url) {
        data, response, error in
        if let data = data, let string = String(data: data, encoding: .utf8) {
            print(string)
            done = true
        }
    }

    task.resume()
    
    while (!done) {}
    return (false, "Unknown Error")
}

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    enum Field {
        case username
        case password
    }
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var loggingIn: Bool = false
    @State private var status: String = ""
    @FocusState private var focusedField: Field?
    var body: some View {
        VStack {
            Text("Bank")
                .padding(.top, 96)
                .padding(.bottom, 10)
                .font(.system(size: 36))
                .bold(true)
            Text(status)
                .font(.system(size: 18))
                .foregroundColor(.red)
            Spacer()
            Input(placeholder: Text("Username").foregroundColor(.gray), text: $username)
                .foregroundColor((colorScheme != .light ? .white : .black))
                .accentColor(.blue)
                .font(.system(size: 20))
                .padding(.horizontal, 16.0)
                .padding(.vertical, 8)
                .background(Color("OffWhite"))
                .cornerRadius(5)
                .padding(.vertical, 2)
                .keyboardType(.default)
                .submitLabel(.next)
                .focused($focusedField, equals: .username)
                .textContentType(.username)
                .contentShape(Rectangle())
            PasswordInput(placeholder: Text("Password").foregroundColor(.gray), text: $password)
                .foregroundColor((colorScheme != .light ? .white : .black))
                .accentColor(.blue)
                .font(.system(size: 20))
                .padding(.horizontal, 16.0)
                .padding(.vertical, 8)
                .background(Color("OffWhite"))
                .cornerRadius(5)
                .padding(.vertical, 4)
                .keyboardType(.default)
                .submitLabel(.send)
                .focused($focusedField, equals: .password)
                .textContentType(.password)
                .contentShape(Rectangle())
            Button(action: {
                if (!loggingIn) {
                    loggingIn=true
                    let ret: (Bool, String) = Login(username: username, password: password)
                    status = ret.1
                    if (ret.0) {
                        loggingIn=false
                    }
                }
            }) {
                if (loggingIn) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: (colorScheme == .light ? .white : .black)))
                        .padding(.vertical, 2)
                } else {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
            .font(.system(size: 20))
            .padding(.vertical, 2)
            .background(Color("AccentColor"))
            .foregroundColor((colorScheme == .light ? .white : .black))
            .cornerRadius(5)
            .padding(.top, 16)
            .contentShape(Rectangle())
            Spacer()
            Spacer()
        }
        .padding()
        .onSubmit {
            switch focusedField {
            case .username:
                focusedField = .password
            default:
                if (!loggingIn) {
                    loggingIn=true
                    let ret: (Bool, String) = Login(username: username, password: password)
                    status = ret.1
                    if (ret.0) {
                        loggingIn=false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
