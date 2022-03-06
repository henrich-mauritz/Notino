//
//  ErrorAlert.swift
//  Notino
//
//  Created by Henrich Mauritz on 06/03/2022.
//

import Foundation

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}
