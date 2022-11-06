//
//  DiagramView.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import SwiftUI

/// ダイヤ名を表示する View.
public struct DiagramView: View {
    @ObservedObject var dataSource: DataSource

    public init(dataSource: DiagramView.DataSource) {
        self.dataSource = dataSource
    }

    public var body: some View {
        VStack {
            Text("今日の運行ダイヤ")
                .font(.system(size: 14))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(dataSource.diagramName)
                .font(.system(size: 32, weight: .bold))
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
    }
}

public extension DiagramView {
    class DataSource: ObservableObject {
        @Published public var diagramName: String

        public init(diagramName: String) {
            self.diagramName = diagramName
        }
    }
}

#if DEBUG
struct DiagramView__Preview: PreviewProvider {
    static var previews: some View {
        Group {
            DiagramView(dataSource: DiagramView.DataSource(diagramName: "Aダイヤ"))
                .previewDisplayName("通常表示")
                .previewLayout(.fixed(width: 320, height: 80))
        }
    }
}
#endif
