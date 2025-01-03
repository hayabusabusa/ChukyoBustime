//
//  DiagramNameView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/02.
//

import SwiftUI

struct DiagramNameView: View {
    var diagramName: String
    
    var body: some View {
        VStack {
            Text("今日の運行ダイヤ")
                .font(.system(size: 14))
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )

            Text(diagramName)
                .font(
                    .system(
                        size: 32,
                        weight: .bold
                    )
                )
                .foregroundStyle(.blue)
        }
        .frame(maxWidth: .infinity)
        .padding(
            EdgeInsets(
                top: 24,
                leading: 16,
                bottom: 24,
                trailing: 16
            )
        )
        .background(
            Color(.secondarySystemGroupedBackground)
        )
    }
}
