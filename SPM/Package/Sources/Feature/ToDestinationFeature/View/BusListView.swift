//
//  BusListView.swift
//  
//
//  Created by Shunya Yamada on 2022/11/14.
//

import SwiftUI

struct BusListView: View {
    let dataSource: DataSource

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("次にくるバス一覧")
                Spacer()
                Text("※ 到着時刻は目安です")
                    .foregroundColor(.blue)
            }
            .font(.system(size: 11))
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

            Spacer()
                .frame(height: 8)

            ForEach(dataSource.items) { element in
                BusListItemView(dataSource: element)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
        .background(Color(UIColor.secondarySystemGroupedBackground))
    }
}

extension BusListView {
    final class DataSource: ObservableObject {
        let items: [BusListItemView.DataSource]

        init(items: [BusListItemView.DataSource]) {
            self.items = items
        }
    }
}

#if DEBUG
struct BusListView__Preview: PreviewProvider {
    static let dataSource = BusListView.DataSource(items: [
        BusListItemView.DataSource(index: 1,
                                   departureName: "大学",
                                   departureTime: "00:00",
                                   arrivalName: "浄水駅",
                                   arrivalTime: "00:00",
                                   isHighlighted: true,
                                   action: {}),
        BusListItemView.DataSource(index: 2,
                                   departureName: "大学",
                                   departureTime: "00:00",
                                   arrivalName: "浄水駅",
                                   arrivalTime: "00:00",
                                   isHighlighted: false,
                                   action: {}),
        BusListItemView.DataSource(index: 3,
                                   departureName: "大学",
                                   departureTime: "00:00",
                                   arrivalName: "浄水駅",
                                   arrivalTime: "00:00",
                                   isHighlighted: false,
                                   action: {})
    ])

    static var previews: some View {
        BusListView(dataSource: dataSource)
            .previewLayout(.fixed(width: 320, height: 240))
    }
}
#endif
