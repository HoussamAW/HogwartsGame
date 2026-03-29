//
//  ContentView.swift
//  HogwartGame
//
//  Created by Houssam Dine Abdoul Wahab on 29/03/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    var body: some View {
        VStack(spacing: 24) {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)

            Button {
                Task {
                    await openImmersiveSpace(id: "GameImmersiveView")
                }
            } label: {
                Text("Enter")
                    .frame(width: 220)
                    .padding()
                    .background(Color.orange.opacity(0.3))
                    .glassBackgroundEffect()
            }
            .offset(y: -180)
            .buttonStyle(.plain)
         

          
        }
    }
}


#Preview(windowStyle: .plain) {
    ContentView()
}
