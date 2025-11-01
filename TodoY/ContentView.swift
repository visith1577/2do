//
//  ContentView.swift
//  TodoY
//
//  Created by visith kumarapperuma on 2025-10-31.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var showAddItemSheet = false
    @State private var newItemTitle = ""

    var body: some View {
        List {
            ForEach(items) { item in
                HStack {
                    Button {
                        toggleCompleted(item)
                    } label: {
                        Image(systemName: item.isCompleted
                              ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(item.isCompleted ? .green : .gray)
                    }
                    .buttonStyle(.plain)
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title!)
                            Text(item.timestamp!, formatter: itemFormatter)
                        }
                        .strikethrough(item.isCompleted, color: .gray)
                        .foregroundColor(item.isCompleted ? .gray : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Todoey")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            ToolbarItem {
                Button{ showAddItemSheet = true } label: {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddItemSheet) {
            AddItemView(newItemTitle: $newItemTitle,
                onSave: addItem,
                onCancel: {
                    showAddItemSheet = false
                    newItemTitle = ""
            })
        }
        .presentationDetents([.medium])
        .presentationCornerRadius(20)
    }

    private func addItem() {
        guard !newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.title = newItemTitle
            newItem.isCompleted = false
            
            do {
                try viewContext.save()
                newItemTitle = ""
                showAddItemSheet = false
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func toggleCompleted(_ item: Item) {
        withAnimation {
            item.isCompleted.toggle()
            do {
                try viewContext.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    NavigationStack {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
