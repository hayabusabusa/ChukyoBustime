//
//  CountdownView.swift
//  
//
//  Created by Shunya Yamada on 2022/11/06.
//

import Shared
import SwiftUI

/// 出発までのカウントダウンを表示する View.
struct CountdownView: View {
    let dataSource: DataSource

    var body: some View {
        VStack {
            HStack {
                outlinedText("最終バス")
                outlinedText("折り返し")
                outlinedText("貝津経由")
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer()

            Text("出発まであと")
                .font(.system(size: 12))
            Text(dataSource.countdownTime)
                .font(Font(UIFont.monospacedDigitSystemFont(ofSize: 40, weight: .bold)))

            Spacer()

            HStack {
                stationView(name: dataSource.destination == .toStation ? "大学発" : "浄水駅発",
                            time: dataSource.departureTime,
                            image: "tram.fill")
                Spacer()
                stationView(name: dataSource.destination == .toStation ? "浄水駅着" : "大学着",
                            time: dataSource.arrivalTime,
                            image: "tram.fill")
            }
        }
        .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
    }

    func outlinedText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .padding(6.0)
            .overlay(
                RoundedRectangle(cornerRadius: .infinity)
                    .stroke(Color.blue, lineWidth: 1)
            )
    }

    func stationView(name: String, time: String, image: String) -> some View {
        VStack(spacing: 2) {
            Text(time)
                .font(.system(size: 14, weight: .bold))
            Image(systemName: image)
            Text(name)
                .font(.system(size: 11, weight: .medium))
        }
    }
}

extension CountdownView {
    final class DataSource: ObservableObject {
        let destination: BusDestination
        let countdownTime: String
        let departureTime: String
        let arrivalTime: String
        let isLast: Bool
        let isViaKaizu: Bool
        let isReturn: Bool

        init(destination: BusDestination,
             countdownTime: String,
             departureTime: String,
             arrivalTime: String,
             isLast: Bool,
             isViaKaizu: Bool,
             isReturn: Bool) {
            self.destination = destination
            self.countdownTime = countdownTime
            self.departureTime = departureTime
            self.arrivalTime = arrivalTime
            self.isLast = isLast
            self.isViaKaizu = isViaKaizu
            self.isReturn = isReturn
        }
    }
}

#if DEBUG
struct CountdownView__Preview: PreviewProvider {
    static var previews: some View {
        CountdownView(
            dataSource: CountdownView.DataSource(destination: .toCollege,
                                                 countdownTime: "02:56",
                                                 departureTime: "08:00",
                                                 arrivalTime: "08:15",
                                                 isLast: false,
                                                 isViaKaizu: false,
                                                 isReturn: false)
        )
        .previewLayout(.fixed(width: 320, height: 200))
        .previewDisplayName("大学行きの表示")

        CountdownView(
            dataSource: CountdownView.DataSource(destination: .toStation,
                                                 countdownTime: "02:56",
                                                 departureTime: "08:00",
                                                 arrivalTime: "08:15",
                                                 isLast: false,
                                                 isViaKaizu: false,
                                                 isReturn: false)
        )
        .previewLayout(.fixed(width: 320, height: 200))
        .previewDisplayName("浄水駅行きの表示")
    }
}
#endif
