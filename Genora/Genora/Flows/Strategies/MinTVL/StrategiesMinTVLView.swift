//
//  StrategiesMinTVLView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 10/01/2026.
//

import SwiftUI

struct StrategiesMinTVLView: View {
    @Bindable var viewModel: StrategiesViewModel
    @FocusState.Binding var isKeyboardVisible: Bool
    @State private var tester: Double?
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
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
                    if tester != nil {
                        Text("$")
                            .foregroundStyle(.textSecondary)
                            .font(.body)
                    }
                    
                    TextField("Example: 1 000 000", value: $tester, formatter: formatter)
                        .textFieldStyle(.plain)
                        .foregroundStyle(.textSecondary)
                        .keyboardType(.decimalPad)
                        .focused($isKeyboardVisible)
                        .font(.body)
                }
                
                if tester != nil {
                    Button {
                        tester = nil
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
