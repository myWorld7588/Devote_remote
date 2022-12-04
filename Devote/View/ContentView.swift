//
//  ContentView.swift
//  Devote
//
//  Created by Jake Choi on 12/3/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    // MARK: - PROPERTY
    
    @State var task: String = ""
    
    private var isButtonDisabled: Bool {
        task.isEmpty
        
    }
    
    // FETCHING DATA
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // MARK: - FUNCTION
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.completion = false
            newItem.id = UUID()

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            
            task = ""
            hidekeyboard()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 16) {
                    TextField("Type in New Tasks", text: $task)
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(10)
                    
                    Button(action: { addItem() }, label: {
                        Spacer()
                        Text("SAVE")
                        Spacer()
                        
                    })
                    .disabled(isButtonDisabled)
                    .padding()
                    .font(.headline)
                    .foregroundColor(.white)
                    .background(Color.pink)
                    .background(isButtonDisabled ? Color.gray : Color.pink)
                    .cornerRadius(10)
                    
                } //: VSTACK
                .padding()
                
                List {
                    ForEach(items) { item in
                        NavigationLink {
                            VStack (alignment: .leading){
                                Text(item.task ?? "")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            } //: LIST ITEM
                        } label: {
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                    }
                    .onDelete(perform: deleteItems)
                } //: LIST
            } //: VSTACK
            .navigationBarTitle("Daily Tasks", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            } //: TOOLBAR
            Text("Select an item")
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
