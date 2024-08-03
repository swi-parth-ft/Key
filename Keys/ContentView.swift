//
//  ContentView.swift
//  Keys
//
//  Created by Parth Antala on 8/3/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var store = AppointmentStore()
    @State private var username: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Add Appointment") {
                store.addAppointment(username: username, password: password)
                indexAppointment(Appointment(id: UUID(), username: username, password: password))
                username = ""
                password = ""
            }
            .padding()
            List(store.appointments) { appointment in
                Text(appointment.username)
            }
        }
    }
}

struct CopyButtonView: View {
    let password: String

    var body: some View {
        Button(action: {
            UIPasteboard.general.string = password
        }) {
            Image(systemName: "doc.on.clipboard")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
