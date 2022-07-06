//
//  Entry.swift
//  DreamJournal
//
//  Created by Tatiana Bondarenko on 7/6/22.
//

import Foundation

// Struct is like a class BUT
// --- They can not inherit things from other structs (classes CAN)
// --- They have memberwise initializer (Classes can have a deinitializer)
// --- They are VALUE types (Classes are REFERENCE type)
// --- They are LIGHT WEIGHT


struct Entry: Identifiable {
    var title: String
    var body: String
    
    // Add default values for properties we will never edit
    var id = UUID()
    var date = Date()
}
