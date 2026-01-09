//
//  StrategiesAPYSliderView.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 08/01/2026.
//

import SwiftUI

struct StrategiesAPYSliderView: View {
    @Bindable var viewModel: StrategiesViewModel
    @FocusState.Binding var isKeyboardVisible: Bool
    
    var body: some View {
        Text("Minimum APY")
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 10)
        
        HStack {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    GeometryReader { _ in
                        HStack(spacing: 0) {
                            ForEach(0..<21) { index in
                                Rectangle()
                                    .fill(.secondary.opacity(0.3))
                                    .frame(width: 1, height: index % 5 == 0 ? 8 : 4)
                                if index < 20 {
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(height: 8)
                    .padding(.bottom, 4)
                    
                    Slider(value: $viewModel.minimumAPY, in: 0...100, step: 0.5)
                        .tint(.element)
                        .onChange(of: viewModel.minimumAPY) { oldValue, newValue in
                            let oldMilestone = Int(oldValue)
                            let newMilestone = Int(newValue)
                            
                            if oldMilestone != newMilestone {
                                HapticsEngine.shared.lightTap()
                            }
                        }
                }
            }
            .padding()
            .glassEffect(.regular, in: .rect(cornerRadius: 24))
            
            HStack(spacing: 4) {
                TextField("0", value: $viewModel.minimumAPY, format: .number.precision(.fractionLength(1)))
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.element)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .focused($isKeyboardVisible)
                    .onChange(of: viewModel.minimumAPY) { oldValue, newValue in
                        viewModel.minimumAPY = min(max(newValue, 0), 100)
                    }
                
                Text("%")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .frame(width: 80)
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 16)
            .glassEffect(.regular, in: .rect(cornerRadius: 24))
        }
    }
}


#Preview {
    StrategiesView()
}
