//
//  View+Extensions.swift
//  Genora
//
//  Created by Rostyslav Mukoida on 29/12/2025.
//

import SwiftUI

extension View {
    func hideKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
