//
//  EntryListView.swift
//  DreamJournal
//
//  Created by Tatiana Bondarenko on 7/6/22.
//

import SwiftUI

struct EntryListView: View {
    
    @ObservedObject var viewModel = EntryListViewModel()
    
    var body: some View {
        NavigationView {
            
            // Dashboard
            ScrollView {
                JournalDashBoard(viewModel: viewModel)
                    .padding(.horizontal)
                    .frame(height: 140)
                
                if viewModel.entries.isEmpty {
                    EmptyJournalTile()
                } else {
                // List of entries
                List {
                    Section("My  Entries") {
                        ForEach(viewModel.entries) { entry in
                            
                            NavigationLink {
                                // Destination
                                DetailView(entry: entry, entryViewModel: viewModel)
                            } label: {
                                // What our navigation lint looks like
                                JournalRowView(entry: entry)
                                    .padding()
                                    .frame(maxHeight: 120)
                            }
                        }
                        .onDelete(perform: viewModel.deleteEntry(indexSet:))
                    }
                }
                .frame(height: CGFloat(viewModel.entries.count) * 100 + 16)
                .listStyle(.plain)
                }
            }
            .navigationTitle("Dream Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        DetailView(entryViewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                setupViews()
            }
        }
    }
    
    func setupViews() {
        viewModel.loadFromPersistenceStore()
        viewModel.getStreak()
        viewModel.hasJournaledToday()
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        EntryListView()
    }
}

struct EmptyJournalTile: View {
    var body: some View {
        VStack {
            Divider()
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            Text(EntryListViewModel.emptyMessage)
                .font(.system(.caption, design: .monospaced))
                    .padding()
        }.cornerRadius(12)
            .frame(width: UIScreen.main.bounds.width - 40)
            .padding(.top)
        }
    }
}

struct JournalRowView: View {
    var entry: Entry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(entry.title)
                .bold()
                .font(.headline)
            Text(entry.body)
                .font(.system(size: 14))
                .lineLimit(2)
        }
    }
}

struct JournalDashBoard: View {
    @ObservedObject var viewModel: EntryListViewModel
    var body: some View {
        VStack {
            HStack {
                // Day streak tile
                DayStreakTile(viewModel: viewModel)
                
                VStack {
                    // Total entries tile
                    TotalEntriesTile(viewModel: viewModel)
                    
                    // Journaled today tile
                    JournaledTodayTile(viewModel: viewModel)
                }
            }
        }
    }
}

struct DayStreakTile: View {
    @ObservedObject var viewModel: EntryListViewModel
    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            VStack {
                Text(String(viewModel.streak))
                    .font(.title)
                    .bold()
                Text(viewModel.dayStreakText)
                    .font(.headline)
            }
        }.cornerRadius(12)
    }
}

struct TotalEntriesTile: View {
    @ObservedObject var viewModel: EntryListViewModel
    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            VStack {
                Text("\(viewModel.entries.count)")
                    .font(.title3)
                    .bold()
                Text(viewModel.entriesText)
                    .font(.caption)
            }
        }.cornerRadius(12)
    }
}

struct JournaledTodayTile: View {
    @ObservedObject var viewModel: EntryListViewModel
    var body: some View {
        ZStack {
            Rectangle().fill(.ultraThinMaterial)
            VStack {
                Image(systemName: viewModel.hasJournaled ? "checkmark.circle.fill" : "xmark.circle.fill")
                Text(viewModel.journaledTodayText)
                    .font(.caption2)
            }
        }.cornerRadius(12)
    }
}
