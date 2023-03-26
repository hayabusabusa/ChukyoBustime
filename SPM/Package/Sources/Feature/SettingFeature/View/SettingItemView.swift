//
//  SettingItemView.swift
//  
//
//  Created by Shunya Yamada on 2023/03/20.
//

import SwiftUI

struct SettingItemView: View {
    let title: String
    let onTap: (() -> Void)

    var body: some View {
        Button {
            onTap()
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(Color(UIColor.label))
                Spacer()
                Image(systemName: "chevron.forward")
                    .foregroundColor(Color(UIColor.systemGray2))
            }
        }
    }
}
