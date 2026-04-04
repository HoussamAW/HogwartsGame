//
//  MuseController.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 03/04/2026.
//

import GameController
import Observation
import RealityKit

@Observable
@MainActor
final class MuseController {
    var isConnected = false
    var onPrimaryButtonPressed: (() -> Void)?
    weak var rootEntity: Entity?
    private(set) var stylus: GCStylus?
    private(set) var wandAnchor: AnchorEntity?
    private(set) var wandTip: Entity?

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
                self.onPrimaryButtonPressed = nil
                self.wandAnchor?.removeFromParent()
                self.wandAnchor = nil
                self.wandTip = nil
            }
        }
    }

    private func attach(_ stylus: GCStylus) {
        self.stylus = stylus
        self.isConnected = true
        bindPrimaryButton(for: stylus)

        Task { @MainActor [weak self] in
            await self?.setupWandIfNeeded(for: stylus)
        }
    }

    private func bindPrimaryButton(for stylus: GCStylus) {
        guard let input = stylus.input else { return }
        guard let primary = input.buttons[.stylusPrimaryButton] else { return }

        primary.pressedInput.pressedDidChangeHandler = { [weak self] _, _, pressed in
            guard pressed else { return }

            Task { @MainActor [weak self] in
                self?.onPrimaryButtonPressed?()
            }
        }
    }

    private func setupWandIfNeeded(for stylus: GCStylus) async {
        guard wandAnchor == nil else { return }
        guard let rootEntity else { return }

        do {
            let source = try await AnchoringComponent.AccessoryAnchoringSource(device: stylus)
            guard let location = source.locationName(named: "origin") else { return }

            let anchor = AnchorEntity(
                .accessory(from: source, location: location),
                trackingMode: .predicted,
                physicsSimulation: .none
            )

            let wand = try await Entity(named: "Wand")
            wand.position = SIMD3<Float>(0, 0, 0.25)
            wand.orientation = simd_quatf(angle: -.pi / 2, axis: SIMD3<Float>(1, 0, 0))

            let tip = Entity()
            tip.name = "WandTip"
            tip.position = SIMD3<Float>(0, 0.45, 0)

            wand.addChild(tip)
            anchor.addChild(wand)
            rootEntity.addChild(anchor)

            self.wandAnchor = anchor
            self.wandTip = tip
        } catch {
            print("Failed to setup wand: \(error)")
        }
    }

    func fireDirection() -> SIMD3<Float>? {
        guard let wandTip else { return nil }
        let temp = Entity()
        temp.orientation = wandTip.orientation(relativeTo: nil)
        return temp.convert(direction: SIMD3<Float>(0, 1, 0), to: nil)
    }
}
