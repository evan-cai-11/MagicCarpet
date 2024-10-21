//
//  MagicCarpetApp.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import SwiftUI

@main
struct MagicCarpetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                QuestionareStepperView(viewModel: StepperViewModel())
            }
        }
    }
}
