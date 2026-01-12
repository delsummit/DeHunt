//
//  StrategiesUserInputView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 02/01/2026.
//

import SwiftUI

struct StrategiesUserInputMoneyView: View {
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
        Text("Amount you want to invest")
            .font(.headline)
            .foregroundStyle(.textPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
        
        HStack {
            HStack {
                Image("usdtLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("USDT")
                    .foregroundStyle(.textSecondary)
                    .bold()
                Divider()
                
                HStack(spacing: 4) {
                    if !textInput.isEmpty {
                        Text("$")
                            .foregroundStyle(.textSecondary)
                            .font(.body)
                    }
                    
                    TextField("Enter the value", text: Binding(
                        get: { textInput },
                        set: { newValue in
                            if focusedField == .investmentAmount {
                                let filtered = newValue.filter { "0123456789.,".contains($0) }
                                textInput = filtered
                                
                                let normalizedInput = filtered.replacingOccurrences(of: ",", with: ".")
                                viewModel.investmentAmount = Double(normalizedInput)
                            } else {
                                textInput = newValue
                            }
                        }
                    ))
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                        .focused($focusedField, equals: .investmentAmount)
                        .foregroundStyle(.textSecondary)
                        .onChange(of: focusedField) { _, newField in
                            if newField == .investmentAmount {
                                unfocusedToFocused()
                            } else if newField != .investmentAmount {
                                focusedToUnfocused()
                            }
                        }
                        .onAppear {
                            if let amount = viewModel.investmentAmount {
                                textInput = formatter.string(from: NSNumber(value: amount)) ?? ""
                            }
                        }
                }
                
                
                if !textInput.isEmpty {
                    Button {
                        viewModel.investmentAmount = nil
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
        guard let amount = viewModel.investmentAmount else { return }
        
        let cleanText = String(amount)
        if cleanText.hasSuffix(".0") {
            textInput = String(cleanText.dropLast(2))
        } else {
            textInput = cleanText
        }
    }
    
    private func focusedToUnfocused() {
        guard let amount = viewModel.investmentAmount else {
            textInput = ""
            return
        }
        
        if let formatted = formatter.string(from: NSNumber(value: amount)) {
            textInput = formatted
        }
    }
}

#Preview {
    StrategiesView()
}
