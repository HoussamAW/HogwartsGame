//
//  MuseController.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 03/04/2026.
//

import GameController
import Observation

@Observable
@MainActor
final class MuseController {
    var isConnected = false
    private(set) var stylus: GCStylus?

    func start() {
        for stylus in GCStylus.styli where stylus.productCategory == GCProductCategorySpatialStylus {
            attach(stylus)
        }

        NotificationCenter.default.addObserver(
            forName: .GCStylusDidConnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let stylus = notification.object as? GCStylus,
                stylus.productCategory == GCProductCategorySpatialStylus
            else { return }

            Task { @MainActor [weak self] in
                self?.attach(stylus)
            }
        }

        NotificationCenter.default.addObserver(
            forName: .GCStylusDidDisconnect,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard
                let stylus = notification.object as? GCStylus,
                stylus.productCategory == GCProductCategorySpatialStylus
            else { return }

            Task { @MainActor [weak self] in
                guard let self else { return }
                guard self.stylus === stylus else { return }

                self.isConnected = false
                self.stylus = nil
            }
        }
    }

    private func attach(_ stylus: GCStylus) {
        self.stylus = stylus
        self.isConnected = true
    }
}
