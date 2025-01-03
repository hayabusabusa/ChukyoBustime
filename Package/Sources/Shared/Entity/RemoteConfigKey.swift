//
//  RemoteConfigKey.swift
//  
//
//  Created by Shunya Yamada on 2023/03/07.
//

import Foundation

/// Remote Config の設定値に利用するキー.
public enum RemoteConfigKey: String, CaseIterable {
    /// カレンダーと時刻表の PDF の URL をまとめたデータを取得するキー.
    case pdfURL = "pdf_url"
}
