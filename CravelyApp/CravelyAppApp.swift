//
//  CravelyAppApp.swift
//  CravelyApp
//
//  Created by ayman moh on 22/07/2026.
//

import SwiftUI

@main
struct CravelyAppApp: App {
    @State private var appModel: AppModel = AppModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appModel)
        }
    }
}
