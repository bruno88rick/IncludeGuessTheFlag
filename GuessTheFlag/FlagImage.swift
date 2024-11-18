//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Bruno Oliveira on 13/12/23.
//

import SwiftUI

struct FlagImage: View {
    var image: String
    var labels: [String:String]
    var rotationAmount = 0.0

    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
            .accessibilityLabel(labels[image]!)
    }
}

#Preview {
    FlagImage(image: "France", labels: ["France" : "Flag of France"])
}
