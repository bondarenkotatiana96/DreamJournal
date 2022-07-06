//
//  DetailView.swift
//  DreamJournal
//
//  Created by Tatiana Bondarenko on 7/6/22.
//

import SwiftUI

struct DetailView: View {
    
    var entry: Entry?
    
    @State var entryTitleText: String = ""
    @State var entryBodyText: String = "Write the details of your dream here..."
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Title")
                TextField("Enter your dream's title", text: $entryTitleText)
            }.padding()
            VStack(alignment: .leading) {
                HStack {
                    Text("Body")
                    Spacer()
                    Button {
                        entryBodyText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                TextEditor(text: $entryBodyText)
            }.padding()
            
            Spacer()
            
            Button {
                // Action
                // TODO: SAVE OUR ENTRY
                print("\(entryBodyText), \(entryTitleText)")
            } label: {
                // What our button will look like
                ZStack {
                    // very bottom
                    Rectangle().fill(.ultraThinMaterial)
                        .cornerRadius(12)
                    // very top
                    Text("Tap me")
                }
            }.frame(width: UIScreen.main.bounds.width - 40, height: 55)
        }
        .navigationTitle("Detail View")
        .onAppear {
            if let entry = entry {
                entryTitleText = entry.title
                entryBodyText = entry.body
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView()
        }
    }
}
