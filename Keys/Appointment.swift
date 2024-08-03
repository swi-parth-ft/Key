//
//  Appointment.swift
//  Keys
//
//  Created by Parth Antala on 8/3/24.
//

import Foundation
import CoreSpotlight
import MobileCoreServices

struct Appointment: Identifiable, Codable {
    var id: UUID
    var username: String
    var password: String
}

class AppointmentStore: ObservableObject {
    @Published var appointments: [Appointment] = []

    init() {
        load()
    }

    func addAppointment(username: String, password: String) {
        let newAppointment = Appointment(id: UUID(), username: username, password: password)
        appointments.append(newAppointment)
        save()
    }

    private func save() {
        let data = try? JSONEncoder().encode(appointments)
        UserDefaults.standard.set(data, forKey: "appointments")
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: "appointments") {
            if let decodedAppointments = try? JSONDecoder().decode([Appointment].self, from: data) {
                appointments = decodedAppointments
            }
        }
    }
}



func indexAppointment(_ appointment: Appointment) {
    let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
    attributeSet.title = appointment.username
    attributeSet.contentDescription = "Password: \(appointment.password)"

    let searchableItem = CSSearchableItem(uniqueIdentifier: appointment.id.uuidString, domainIdentifier: "com.yourapp", attributeSet: attributeSet)

    CSSearchableIndex.default().indexSearchableItems([searchableItem]) { error in
        if let error = error {
            print("Error indexing item: \(error.localizedDescription)")
        } else {
            print("Successfully indexed item")
        }
    }
}
