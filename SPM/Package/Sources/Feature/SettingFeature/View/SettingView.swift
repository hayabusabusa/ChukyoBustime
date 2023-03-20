//
//  SettingView.swift
//  
//
//  Created by Shunya Yamada on 2023/03/19.
//

import SwiftUI

protocol SettingViewDelegate: AnyObject {
    func settingViewDidTapItemView(for item: SettingItem)
}

struct SettingView: View {
    @ObservedObject var dataSource: DataSource
    weak var delegate: SettingViewDelegate?

    var body: some View {
        List {
            ForEach(Array(dataSource.sections.enumerated()), id: \.offset) { _, section in
                Section(header: Text(section.title)) {
                    ForEach(Array(section.items.enumerated()), id: \.offset) { _, item  in
                        itemView(for: item) {
                            delegate?.settingViewDidTapItemView(for: item)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
    }
}

extension SettingView {
    final class DataSource: ObservableObject {
        @Published var sections: [SettingSection]

        init(sections: [SettingSection]) {
            self.sections = sections
        }
    }
}

private extension SettingView {
    func itemView(for type: SettingItem, onTap: @escaping (() -> Void)) -> some View {
        Group {
            switch type {
            case .tabSetting(let setting):
                Button {
                    onTap()
                } label: {
                    HStack {
                        Text("起動時に表示")
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        Text(setting)
                            .foregroundColor(.gray)
                    }
                }
            case .version(let version):
                HStack {
                    Text("バージョン")
                        .foregroundColor(Color(UIColor.label))
                    Spacer()
                    Text(version)
                        .foregroundColor(.gray)
                }
            case .about:
                SettingItemView(title: "このアプリについて") {
                    onTap()
                }
            case .disclaimer:
                SettingItemView(title: "利用上の注意") {
                    onTap()
                }
            case .privacyPolicy:
                SettingItemView(title: "プライバシーポリシー") {
                    onTap()
                }
            }
        }
    }
}

#if DEBUG
struct SettingView_Preview: PreviewProvider {
    static var previews: some View {
        SettingView(dataSource: SettingView.DataSource(sections: [
            SettingSection(title: "アプリの設定",
                           items: [
                            .tabSetting(setting: "浄水駅行き"),
            ]),
            SettingSection(title: "このアプリについて",
                           items: [
                            .version(version: "1.1"),
                            .about,
                            .disclaimer,
                            .privacyPolicy
            ])
        ]))
    }
}
#endif
