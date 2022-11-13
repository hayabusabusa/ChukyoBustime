//
//  BusListItemView.swift
//  
//
//  Created by Shunya Yamada on 2022/11/06.
//

import SwiftUI

struct BusListItemView: View {
    let index: Int
    let departureName: String
    let departureTime: String
    let arrivalName: String
    let arrivalTime: String
    let isHighlighted: Bool
    let action: (() -> Void)

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(index.description)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                    .frame(width: 24)
                VStack {
                    Text(departureName)
                        .font(.system(size: 11))
                    Text(departureTime)
                        .font(.system(size: 20, weight: .bold))
                }
                .foregroundColor(Color(UIColor.label))
                Image(systemName: "arrow.right")
                    .foregroundColor(Color(UIColor.label))
                VStack {
                    Text(arrivalName)
                        .font(.system(size: 11))
                    Text(departureTime)
                        .font(.system(size: 20, weight: .bold))
                }
                .foregroundColor(Color(UIColor.label))
                Spacer()
            }
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 16))
        }
        .background(isHighlighted ? Color.blue.opacity(0.2) : Color.clear)
    }

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

#if DEBUG
struct BusListView__Preview: PreviewProvider {
    static var previews: some View {
        BusListItemView(index: 1,
                        departureName: "大学発",
                        departureTime: "00:00",
                        arrivalName: "浄水駅着",
                        arrivalTime: "00:00",
                        isHighlighted: false,
                        action: {})
        .previewLayout(.fixed(width: 320, height: 64))
    }
}
#endif
