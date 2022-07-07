//
//  DetailView.swift
//  DreamJournal
//
//  Created by Tatiana Bondarenko on 7/6/22.
//

import SwiftUI

struct DetailView: View {
    
    // MARK: - Landing Pad
    var entry: Entry?
    
    // State variables
    @State var entryTitleText: String = ""
    @State var entryBodyText: String = "Write the details of your dream here..."
    
    // Enviroment Values
    @Environment(\.dismiss) private var dismiss
    
    // ViewModel
    @ObservedObject var entryViewModel: EntryListViewModel // Required property in order to initialize this view
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 22, weight: .heavy, design: .monospaced))
                    .foregroundColor(.secondary)
                TextField("Enter your dream's title", text: $entryTitleText)
            }.padding()
            
            HStack {
                Rectangle().fill(.secondary).frame(width: 2)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Body")
                            .font(.system(size: 22, weight: .heavy, design: .monospaced))
                            .foregroundColor(.secondary)
                        Spacer()
                        Button {
                            entryBodyText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                    TextEditor(text: $entryBodyText)
                }
            }.padding()
            
            Spacer()
            
            VStack {
                HStack(spacing: 0) {
                    Text("Created on ")
                    Text(entry?.date.formatted(.dateTime.day().month().year()) ?? Date().formatted(.dateTime.day().month().year()))
                }
                .font(.caption)
                .foregroundColor(.secondary)
                
                Button {
                    if entry == nil {
                        prepareForCreateEntry(title: entryTitleText, body: entryBodyText)
                    }  else {
                        prepareForUpdateEntry()
                    }
                    dismiss()
                } label: {
                    // What our button will look like
                    ZStack {
                        // very bottom
                        Rectangle().fill(.ultraThinMaterial)
                            .cornerRadius(12)
                        // very top
                        Text( entry == nil ? "Save" : "Update")
                    }
            }.frame(width: UIScreen.main.bounds.width - 40, height: 55)
            }
        }
        .navigationTitle("Detail View")
        .onAppear {
            if let entry = entry {
                entryTitleText = entry.title
                entryBodyText = entry.body
            }
        }
    }
    
    func prepareForCreateEntry(title: String?, body: String?) {
        // Make sure that we have the necessary components to create an entry
        guard let title = title, !title.isEmpty,
              let body = body, !body.isEmpty else { return }
        // Create that entry
        let entry = Entry(title: title, body: body)
        // ViewModel Save the entry
        entryViewModel.createEntry(entry)
    }
    
    func prepareForUpdateEntry() {
        let title = entryTitleText
        let body = entryBodyText
        guard !title.isEmpty, !body.isEmpty else { return }
        if let entry = entry {
            entryViewModel.updateEntry(entry, title, body)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(entryViewModel: EntryListViewModel())
        }
    }
}
