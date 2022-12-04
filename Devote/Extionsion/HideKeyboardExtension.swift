//
//  HideKeyboardExtension.swift
//  Devote
//
//  Created by Jake Choi on 12/4/22.
//

import SwiftUI

#if canImport(UIKit)
extension View {
    func hidekeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

