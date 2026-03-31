//
//  ImmersiveView.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI
import RealityKit

struct ImmersiveView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            RealityView { content in
                do {
                    let hpDesk = try await ModelEntity(named: "HPDesk")
                    hpDesk.position = [0, -1.5, -10] // x,y,z
                    content.add(hpDesk)
                } catch {
                    print("Unable to load 3D model: \(error)")
                }
            }
        }
        .preferredSurroundingsEffect(.colorMultiply(.black))
    }
}
