//
//  AppModel.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 30/03/2026.
//

import Observation

@Observable
final class AppModel {
    var openImmersiveSpace: (() async -> Bool)?
    var dismissImmersiveSpace: (() async -> Void)?

    var immersiveIsOpen = false
    var isTransitioning = false

    func openImmersiveIfNeeded() async {
        guard !immersiveIsOpen, !isTransitioning else { return }

        isTransitioning = true
        let opened = await openImmersiveSpace?() ?? false
        immersiveIsOpen = opened
        isTransitioning = false
    }

    func closeImmersiveIfNeeded() async {
        guard immersiveIsOpen, !isTransitioning else { return }

        isTransitioning = true
        await dismissImmersiveSpace?()
        immersiveIsOpen = false
        isTransitioning = false
    }
}
