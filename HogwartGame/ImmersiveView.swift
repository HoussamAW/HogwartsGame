//
//  ImmersiveView.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var modelLoadingError: String?

    var body: some View {
        ZStack(alignment: .bottom) {
            RealityView { content in
                do {
                    let hpDesk = try await ModelEntity(named: "HPDesk")
                    hpDesk.position = [0, -1.5, -10]
                    content.add(hpDesk)
                } catch {
                    modelLoadingError = "Unable to load 3D model."
                }
            }
        }
        .preferredSurroundingsEffect(.colorMultiply(.black))
    }
}
