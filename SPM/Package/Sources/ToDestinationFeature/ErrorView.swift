//
//  ErrorView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/31.
//

import Shared
import SwiftUI

/// エラー発生時の View.
struct ErrorView: View {
    var calendarButtonAction: (() -> Void)?
    var timetableButtonAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(resource: .imgError)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 108)

            VStack(spacing: 4) {
                Text("エラーが発生しました")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(Color(.lightGray))

                Text("予期しないエラーが発生しました")
                    .font(.system(size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(.lightGray))
            }

            HStack(spacing: 8) {
                Button {
                    calendarButtonAction?()
                } label: {
                    Text("カレンダー")
                        .font(.system(size: 13))
                }

                Button {
                    timetableButtonAction?()
                } label: {
                    Text("時刻表")
                        .font(.system(size: 13))
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ErrorView()
}
