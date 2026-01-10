//
//  StrategiesUserInputView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 02/01/2026.
//

import SwiftUI

struct StrategiesUserInputMoneyView: View {
    @Bindable var viewModel: StrategiesViewModel
    @FocusState.Binding var isKeyboardVisible: Bool
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
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
                    if viewModel.investmentAmount != nil {
                        Text("$")
                            .foregroundStyle(.textSecondary)
                            .font(.body)
                    }
                    
                    TextField("Enter the value", value: $viewModel.investmentAmount, formatter: formatter)
                        .textFieldStyle(.plain)
                        .keyboardType(.decimalPad)
                        .focused($isKeyboardVisible)
                        .foregroundStyle(.textSecondary)
                }
                
                
                if viewModel.investmentAmount != nil {
                    Button {
                        viewModel.investmentAmount = nil
                        isKeyboardVisible = false
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
}

#Preview {
    StrategiesView()
}
