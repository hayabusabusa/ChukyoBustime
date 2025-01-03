//
//  PDFView.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/03.
//

import SwiftUI

/// カレンダーと時刻表の PDF のボタンを表示する View.
struct PDFView: View {
    var calendarButtonAction: (() -> Void)?
    var timetableButtonAction: (() -> Void)?

    var body: some View {
        HStack {
            Button {
                calendarButtonAction?()
            } label: {
                HStack {
                    Image(systemName: "calendar")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: 24,
                            height: 24
                        )
                    Text("カレンダー")
                }
                .frame(maxWidth: .infinity)
            }

            Rectangle()
                .frame(
                    width: 1,
                    height: 28
                )
                .foregroundStyle(Color(.systemGray2))

            Button {
                timetableButtonAction?()
            } label: {
                HStack {
                    Image(systemName: "tablecells.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: 24,
                            height: 24
                        )
                    Text("時刻表")
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundStyle(.blue)
        .font(.system(size: 14))
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

#Preview {
    PDFView()
        .frame(height: 64)
}
