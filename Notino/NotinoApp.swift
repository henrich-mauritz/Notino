//
//  NotinoApp.swift
//  Notino
//
//  Created by Henrich Mauritz on 05/03/2022.
//

import SwiftUI

@main
struct NotinoApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .withErrorHandling()
        }
    }
}
