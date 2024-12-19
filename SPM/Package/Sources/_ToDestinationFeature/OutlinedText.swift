//
//  OutlinedText.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/20.
//

import SwiftUI

struct OutlinedText: View {
    var text: String

    var body: some View {
        Text(text)
            .font(
                Font(
                    UIFont.monospacedSystemFont(
                        ofSize: 12,
                        weight: .medium
                    )
                )
            )
            .padding(6.0)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(
                        Color.blue,
                        lineWidth: 1
                    )
            )
            .foregroundStyle(.blue)
    }
}
