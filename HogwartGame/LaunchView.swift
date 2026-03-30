//
//  Test.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 30/03/2026.
//

import SwiftUI


struct LaunchView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(AppModel.self) private var appModel
    var body: some View {
        VStack(spacing: 24) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Button {
                //code
            } label: {
                Text("Enter")
                    .frame(width: 220)
                    .padding()
                    .background(Color.orange.opacity(0.3))
                    .glassBackgroundEffect()
            }
            .offset(y:-180)
            .buttonStyle(.plain)
            
        }.task {
            let result = await openImmersiveSpace(id: "GameImmersiveView")
            if case .opened = result {
                dismissWindow(id:"LaunchView")
            }
        }
    }
}
