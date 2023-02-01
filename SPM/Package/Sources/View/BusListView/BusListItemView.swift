//
//  BusListItemView.swift
//  
//
//  Created by Shunya Yamada on 2022/11/06.
//

import SwiftUI

public struct BusListItemView: View {
    private let dataSource: DataSource

    public var body: some View {
        ZStack(alignment: .bottom) {
            Button {
                dataSource.action()
            } label: {
                HStack {
                    Text(dataSource.index.description)
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                        .frame(width: 24)
                    VStack {
                        Text(dataSource.departureName)
                            .font(.system(size: 11))
                        Text(dataSource.departureTime)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .foregroundColor(Color(UIColor.label))
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color(UIColor.label))
                    VStack {
                        Text(dataSource.arrivalName)
                            .font(.system(size: 11))
                        Text(dataSource.departureTime)
                            .font(.system(size: 20, weight: .bold))
                    }
                    .foregroundColor(Color(UIColor.label))
                    Spacer()
                }
                .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 16))
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(UIColor.systemGray2.withAlphaComponent(0.3)))
                .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0))
        }
        .background(dataSource.isHighlighted ? Color.blue.opacity(0.2) : Color.clear)
    }

    public init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
}

public extension BusListItemView {
    final class DataSource: Identifiable {
        let index: Int
        let departureName: String
        let departureTime: String
        let arrivalName: String
        let arrivalTime: String
        let isHighlighted: Bool
        let action: (() -> Void)

        public init(index: Int,
                    departureName: String,
                    departureTime: String,
                    arrivalName: String,
                    arrivalTime: String,
                    isHighlighted: Bool,
                    action: @escaping (() -> Void)) {
            self.index = index
            self.departureName = departureName
            self.departureTime = departureTime
            self.arrivalName = arrivalName
            self.arrivalTime = arrivalTime
            self.isHighlighted = isHighlighted
            self.action = action
        }
    }
}

#if DEBUG
struct BusListItemView__Preview: PreviewProvider {
    static let dataSource = BusListItemView.DataSource(index: 1,
                                                       departureName: "大学発",
                                                       departureTime: "00:00",
                                                       arrivalName: "浄水駅着",
                                                       arrivalTime: "00:00",
                                                       isHighlighted: false,
                                                       action: {})
    static var previews: some View {
        BusListItemView(dataSource: dataSource)
            .previewLayout(.fixed(width: 320, height: 54))
    }
}
#endif
