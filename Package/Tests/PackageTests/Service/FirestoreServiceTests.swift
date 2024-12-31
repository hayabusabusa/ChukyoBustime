//
//  FirestoreServiceTests.swift
//  
//
//  Created by Shunya Yamada on 2022/11/03.
//

import XCTest
import Firebase

@testable import Service

final class FirestoreServiceTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        FirestoreTestHelper.configureFirebaseApp()
    }

    override class func tearDown() {
        super.tearDown()
        FirestoreTestHelper.tearDownFirebaseApp()
    }
}

// MARK: - Private

/// Firestore のテスト用実装.
///
/// - Note: この実装を利用する前に `firebase emulators:start --only firestore` コマンドで
/// Firestore のエミュレーターを起動しておく. ここで起動したエミュレーターはセキュリティルールが適応されていないので注意.
private enum FirestoreTestHelper {
    static func configureFirebaseApp() {
        guard FirebaseApp.app() == nil else { return }

        let options = FirebaseOptions(googleAppID: "1:123:ios:123abc", gcmSenderID: "sender_id")
        options.projectID = "test-" + dateFormatter.string(from: Date())
        FirebaseApp.configure(options: options)

        let settings = Firestore.firestore().settings
        settings.host = "localhost:8080"
        settings.isSSLEnabled = false
        Firestore.firestore().settings = settings
    }

    static func configureStub() async {
        let stub: [String: Any] = [
            "": 0
        ]
        try! await Firestore.firestore().collection("").document().setData(stub)
    }

    static func tearDownFirebaseApp() {
        guard let app = FirebaseApp.app() else { return }
        app.delete { _ in }
    }
}

private let dateFormatter: DateFormatter = {
    let f = DateFormatter()
    f.locale = Locale(identifier: "en-US")
    f.dateFormat = "yyyyMMddHHmmss"
    return f
}()
