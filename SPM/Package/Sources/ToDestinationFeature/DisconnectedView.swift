//
//  DisconnectedView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/31.
//

import SwiftUI

/// 運行終了時の View.
struct DisconnectedView: View {
    var calendarButtonAction: (() -> Void)?
    var timetableButtonAction: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Image(systemName: "star.fill")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(height: 108)

            VStack(spacing: 4) {
                Text("本日の運行は終了しました")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(Color(.lightGray))

                Text("明日の運行カレンダーと時刻表は\n以下から確認できます")
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
    DisconnectedView()
}
