//
//  ToDestinationView.swift
//  
//
//  Created by Shunya Yamada on 2023/03/05.
//

import SwiftUI

struct ToDestinationView: View {
    @ObservedObject var dataSource: DataSource

    var body: some View {
        if dataSource.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
        } else {
            ScrollView {
                VStack {
                    DiagramView(dataSource: dataSource.diagram)
                        .frame(height: 96)
                    CountdownView(dataSource: dataSource.countdown)
                        .frame(height: 200)
                    BusListView(dataSource: dataSource.busList)
                }
            }
        }
    }
}

extension ToDestinationView {
    final class DataSource: ObservableObject {
        @Published var busList: BusListView.DataSource
        @Published var countdown: CountdownView.DataSource
        @Published var diagram: DiagramView.DataSource
        @Published var isLoading: Bool

        init(busList: BusListView.DataSource,
             countdown: CountdownView.DataSource,
             diagram: DiagramView.DataSource,
             isLoading: Bool) {
            self.busList = busList
            self.countdown = countdown
            self.diagram = diagram
            self.isLoading = isLoading
        }
    }
}

extension ToDestinationView.DataSource {
    static let empty = ToDestinationView.DataSource(busList: BusListView.DataSource(items: []),
                                                    countdown: CountdownView.DataSource(destination: .toCollege,
                                                                                        countdownTime: "",
                                                                                        departureTime: "",
                                                                                        arrivalTime: "",
                                                                                        isLast: false,
                                                                                        isViaKaizu: false,
                                                                                        isReturn: false),
                                                    diagram: DiagramView.DataSource(diagramName: ""),
                                                    isLoading: true)
}
