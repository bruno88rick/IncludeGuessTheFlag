//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Bruno Oliveira on 13/12/23.
//

import SwiftUI

struct FlagImage: View {
    var image: String

    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

#Preview {
    FlagImage(image: "France")
}
