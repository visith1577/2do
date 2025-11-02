//
//  AddItemView.swift
//  TodoY
//
//  Created by visith kumarapperuma on 2025-11-01.
//

import SwiftUI

struct AddItemView: View {
    
    @Binding var newItemTitle: String
    var onSave: (Date) -> Void
    var onCancel: () -> Void
    
    @FocusState private var isTextFieldFocused: Bool
    @State private var deadline = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Add New Item")
                .font(.title2)
                .padding(.top, 10)
                .bold()
            
            TextField("Enter task title", text: $newItemTitle)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
                .focused($isTextFieldFocused)
            
            DatePicker("Deadline", selection: $deadline, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding(.horizontal)
            
            HStack {
                Button("Cancel", action: onCancel)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                
                Spacer()
                
                Button(action: {
                    onSave(deadline)
                }) {
                    Text("Save")
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .disabled(newItemTitle.trimmingCharacters(in: .whitespaces).isEmpty)
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .padding(.vertical)
        .background(Color(.systemGroupedBackground))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isTextFieldFocused = true
            }
        }
    }
}

#Preview {
    @Previewable @State var tempTitle = ""
        VStack {
            AddItemView(
                newItemTitle: $tempTitle,
                onSave: { deadline in
                    print("Saved item: \(tempTitle)")
                },
                onCancel: {
                    print("Cancelled")
                }
            )
        }
        .background(Color(.systemGroupedBackground))
}
