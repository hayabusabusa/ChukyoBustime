//
//  BusListItemView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/22.
//

import SwiftUI
import Shared

struct BusListItemView: View {
    var index: Int
    var departureName: String
    var departureTime: String
    var arrivalName: String
    var arrivalTime: String
    var isHighlighted: Bool
    var action: () -> Void

    var body: some View {
        ZStack(alignment: .bottom) {
            Button {
                action()
            } label: {
                HStack {
                    Text("\(index)")
                        .font(
                            .system(
                                size: 20,
                                weight: .bold
                            )
                        )

                    Spacer()
                        .frame(width: 24)

                    VStack {
                        Text(departureName)
                            .font(.system(size: 11))
                        Text(departureTime)
                            .font(
                                .system(
                                    size: 20,
                                    weight: .bold
                                )
                            )
                    }
                    .foregroundColor(Color(.label))

                    Spacer()

                    Image(systemName: "arrowshape.right.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: 24,
                            height: 24
                        )
                        .foregroundStyle(.blue)

                    Spacer()

                    VStack {
                        Text(arrivalName)
                            .font(.system(size: 11))

                        Text(arrivalTime)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .foregroundColor(Color(.label))
                }
                .padding(
                    EdgeInsets(
                        top: 8,
                        leading: 24,
                        bottom: 8,
                        trailing: 24
                    )
                )
            }

            Rectangle()
                .frame(height: 1)
                .foregroundColor(
                    Color(.systemGray2.withAlphaComponent(0.3))
                )
                .padding(
                    EdgeInsets(
                        top: 0,
                        leading: 24,
                        bottom: 0,
                        trailing: 0
                    )
                )
        }
        .background(
            isHighlighted
                ? Color.blue.opacity(0.2)
                : Color(.secondarySystemGroupedBackground)
        )
    }
}
