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
                VStack {
                    HStack {
                        // Day streak tile
                        ZStack {
                            Rectangle().fill(.ultraThinMaterial)
                            VStack {
                                Text(String(viewModel.streak))
                                    .font(.title)
                                    .bold()
                                Text("DAY STREAK")
                                    .font(.headline)
                            }
                        }.cornerRadius(12)
                        
                        VStack {
                            // Total entries tile
                            ZStack {
                                Rectangle().fill(.ultraThinMaterial)
                                VStack {
                                    Text("\(viewModel.entries.count)")
                                        .font(.title3)
                                        .bold()
                                    Text("ENTRIES")
                                        .font(.caption)
                                }
                            }.cornerRadius(12)
                            
                            // Journaled today tile
                            ZStack {
                                Rectangle().fill(.ultraThinMaterial)
                                VStack {
                                    Image(systemName: viewModel.hasJournaled ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    Text("JOURNALED TODAY")
                                        .font(.caption2)
                                }
                            }.cornerRadius(12)
                        }
                    }
                }.padding(.horizontal)
                    .frame(height: 140)
                
                // List of entries
                List {
                    Section("My  Entries") {
                        ForEach(viewModel.entries) { entry in
                            
                            NavigationLink {
                                // Destination
                                DetailView(entry: entry, entryViewModel: viewModel)
                            } label: {
                                // What our navigation lint looks like
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(entry.title)
                                        .bold()
                                        .font(.headline)
                                    Text(entry.body)
                                        .font(.system(size: 14))
                                        .lineLimit(2)
                                }.padding()
                                    .frame(maxHeight: 120)
                            }
                        }
                        .onDelete(perform: viewModel.deleteEntry(indexSet:))
                    }
                }
                .frame(height: CGFloat(viewModel.entries.count) * 100 + 16)
                .listStyle(.plain)
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
