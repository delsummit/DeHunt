//
//  StrategiesMinTVLView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 10/01/2026.
//

import SwiftUI

struct StrategiesMinTVLView: View {
    @Bindable var viewModel: StrategiesViewModel
    @FocusState.Binding var focusedField: StrategiesView.FocusedField?
    @State private var textInput: String = ""
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Minimum TVL")
                .font(.headline)
                .foregroundStyle(.textPrimary)
            
            HStack(spacing: 12) {
                Image(systemName: "lock.badge.clock.fill")
                    .foregroundStyle(.textSecondary)
                    .font(.title3)
                
                Divider()
                
                HStack(spacing: 4) {
                    if !textInput.isEmpty {
                        Text("$")
                            .foregroundStyle(.textSecondary)
                            .font(.body)
                    }
                    
                    TextField("Example: 1 000 000", text: Binding(
                        get: { textInput },
                        set: { newValue in
                            if focusedField == .minTVL {
                                let filtered = newValue.filter { "0123456789.,".contains($0) }
                                textInput = filtered
                                
                                let normalizedInput = filtered.replacingOccurrences(of: ",", with: ".")
                                viewModel.minTVLValue = Double(normalizedInput)
                            } else {
                                textInput = newValue
                            }
                        }
                    ))
                        .textFieldStyle(.plain)
                        .foregroundStyle(.textSecondary)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .minTVL)
                        .font(.body)
                        .onChange(of: focusedField) { _, newField in
                            if newField == .minTVL {
                                unfocusedToFocused()
                            } else if newField != .minTVL {
                                focusedToUnfocused()
                            }
                        }
                        .onAppear {
                            if let value = viewModel.minTVLValue {
                                textInput = formatter.string(from: NSNumber(value: value)) ?? ""
                            }
                        }
                }
                
                if !textInput.isEmpty {
                    Button {
                        viewModel.minTVLValue = nil
                        textInput = ""
                        focusedField = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.textSecondary)
                            .font(.title3)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
            .glassEffect(.regular, in: .rect(cornerRadius: 16))
        }
    }
    
    // MARK: - Helper Methods
    private func unfocusedToFocused() {
        guard let value = viewModel.minTVLValue else { return }
        
        let cleanText = String(value)
        if cleanText.hasSuffix(".0") {
            textInput = String(cleanText.dropLast(2))
        } else {
            textInput = cleanText
        }
    }
    
    private func focusedToUnfocused() {
        guard let value = viewModel.minTVLValue else {
            textInput = ""
            return
        }
        
        if let formatted = formatter.string(from: NSNumber(value: value)) {
            textInput = formatted
        }
    }
}

#Preview {
    StrategiesView()
}
