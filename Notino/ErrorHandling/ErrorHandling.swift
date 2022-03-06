//
//  ErrorHandling.swift
//  Notino
//
//  Created by Henrich Mauritz on 06/03/2022.
//

import SwiftUI

class ErrorHandling: ObservableObject {
    @Published var currentAlert: ErrorAlert?

    func handle(error: Error) {
        currentAlert = ErrorAlert(message: error.localizedDescription)
    }
}

extension View {
    func withErrorHandling() -> some View {
        modifier(AlertModifier())
    }
}
