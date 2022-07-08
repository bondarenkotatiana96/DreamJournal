//
//  EntryListViewModel.swift
//  DreamJournal
//
//  Created by Tatiana Bondarenko on 7/6/22.
//

import Foundation

// Ensure that changes on this viewModel are ABLE to be observed
class EntryListViewModel: ObservableObject {
    
    // SOT
    // All changes to our SOT will be published to the view that is listening
    // If we add an entry, that change will be published, etc.
    @Published var entries: [Entry] = []
    @Published var streak: Int = 0
    @Published var hasJournaled: Bool = false
    
//    [
//        Entry(title: "Test1", body: "This is my body. All of the details of my dream will be written here."),
//        Entry(title: "Test2", body: "This is my body. All of the details of my dream will be written here."),
//        Entry(title: "Test3", body: "This is my body. All of the details of my dream will be written here."),
//        Entry(title: "Test4", body: "This is my body. All of the details of my dream will be written here."),
//    ]
    
    // MARK: - Magic Strings
    let dayStreakText = "DAY STREAK"
    let entriesText = "ENTRIES"
    let journaledTodayText = "JOURNALED TODAY"
    static let emptyMessage = "You have not written any entries yet!"
    
    // MARK: - CRUD
    func createEntry(_ entry: Entry) {
        entries.append(entry)
        saveToPersistenceStore()
    }
    
    func updateEntry(_ entry: Entry, _ title: String, _ body: String) {
        // Find the entry that we want to update
        guard let index = entries.firstIndex(of: entry) else { return }
        // Update
        entries[index].title = title
        entries[index].body = body
        // Save
        saveToPersistenceStore()
    }
    
    func deleteEntry(indexSet: IndexSet) {
        entries.remove(atOffsets: indexSet)
    }
    
    // MARK: - DASHBOARD
    
    // Calculate current streak
    func getStreak() {
        var localStreak: Int = 0
        var previousEntry: Entry?
        
        // Loop through our entries
        for entry in entries {
            // make sure we have a previous entry
            guard let previousEntryDate = previousEntry?.date else {
                localStreak += 1
                previousEntry = entry
                continue
            }
            // Next compare entry 1 and entry 2
            let components = Calendar.current.dateComponents([.hour], from: previousEntryDate, to: entry.date)
            let hours = components.hour
            
            if let hours = hours, hours <= 24 {
                if Calendar.current.isDate(previousEntryDate, inSameDayAs: entry.date) {
                    continue
                } else {
                    localStreak += 1
                }
            } else {
                return self.streak = localStreak
            }
            previousEntry = entry
            
        }
        self.streak = localStreak
    }
    
    func hasJournaledToday() {
        let today = Date()
        for entry in entries {
            if Calendar.current.isDate(today, inSameDayAs: entry.date) {
                self.hasJournaled = true
                return
            } else {
                continue
            }
            self.hasJournaled = false
        }
    }
    
    
    // MARK: - Persistence
    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Entries.json")
        return fileURL
    }
    
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: createPersistenceStore())
        } catch {
            print("")
        }
    }
    
    func loadFromPersistenceStore() {
        do {
            let data = try Data(contentsOf: createPersistenceStore())
            entries = try JSONDecoder().decode([Entry].self, from: data)
        } catch {
            print("")
        }
    }
}

// Keyboard Objects
// Search for a file -- CMD + SHIFT + O
// Jump to file in Navigator == CMD + SHIFT + J

