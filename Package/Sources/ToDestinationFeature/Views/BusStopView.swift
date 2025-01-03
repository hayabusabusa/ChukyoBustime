//
//  BusStopView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/20.
//

import SwiftUI

struct BusStopView: View {
    var timeText: String
    var systemImageName: String
    var destinationText: String

    var body: some View {
        VStack(spacing: 2) {
            Text(timeText)
                .font(
                    .system(
                        size: 14,
                        weight: .bold
                    )
                )
            Image(systemName: systemImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(
                    width: 24,
                    height: 24
                )
                .foregroundStyle(.blue)
            Text(destinationText)
                .font(
                    .system(
                        size: 11,
                        weight: .medium
                    )
                )
        }
    }
}
