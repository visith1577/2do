//
//  TodoDetailView.swift
//  TodoY
//
//  Created by visith kumarapperuma on 2025-11-01.
//

import SwiftUI
internal import CoreData

struct TodoDetailView: View {
    
    @ObservedObject var item: Item
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var isDetailsFocused: Bool
    
    @State private var animateGlow = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    AngularGradient(
                        gradient: Gradient(colors: [.orange, .pink, .purple, .blue, .orange]),
                        center: .center
                    ),
                    lineWidth: 3
                )
                .shadow(color: .orange.opacity(0.6), radius: 12)
                .scaleEffect(animateGlow ? 1.02 : 0.98)
                .rotationEffect(.degrees(animateGlow ? 360 : 0))
                .animation(
                    .linear(duration: 5)
                    .repeatForever(autoreverses: false),
                    value: animateGlow
                )
                .padding(8)
            Form {
                Section("Title") {
                    TextField("Enter title", text: Binding(
                        get: { item.title ?? "" },
                        set: { item.title = $0; saveContext() }
                    ))
                    .textFieldStyle(.roundedBorder)
                }
                
                Section("Details") {
                    TextEditor(text: Binding(
                        get: { item.detail?.details ?? ""},
                        set: { item.detail?.details = $0; saveContext()}
                    ))
                    .frame(minHeight: 150)
                    .focused($isDetailsFocused)
                    .foregroundStyle(.primary)
                }
                
                Section("Deadline") {
                    DatePicker("Due date",  selection: Binding(
                        get: { item.detail?.deadline ?? Date()},
                        set: { item.detail?.deadline = $0; saveContext()}
                    ), displayedComponents: .date)
                    .foregroundStyle(item.ugencyColor)
                }
            }
            .navigationTitle("Task Pad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            .onTapGesture {
                isDetailsFocused = false
            }
            .onAppear {
                animateGlow = true
            }
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } catch {
            print("Failed to save: \(error)")
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext

    // Create a sample item
    let sampleItem = Item(context: context)
    sampleItem.title = "Buy Groceries"
    sampleItem.isCompleted = false

    // Create related ItemDetails
    let sampleDetails = ItemDetails(context: context)
    sampleDetails.deadline = Calendar.current.date(byAdding: .day, value: 2, to: Date())
    sampleDetails.details = "Milk, eggs, bread, and coffee."
    sampleItem.detail = sampleDetails
    sampleDetails.item = sampleItem

    return NavigationStack {
        TodoDetailView(item: sampleItem)
            .environment(\.managedObjectContext, context)
    }
}
