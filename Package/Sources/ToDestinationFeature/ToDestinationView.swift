//
//  ToDestinationView.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/17.
//

import ComposableArchitecture
import FileClient
import FirestoreClient
import RemoteConfigClient
import SettingFeature
import Shared
import SharedView
import SwiftDate
import SwiftUI
import UserNotificationClient

// MARK: - Reducer

@Reducer
public struct ToDestinationReducer {
    @Reducer(state: .equatable)
    public enum Destination {
        /// アラートを表示する.
        case alert(AlertState<Alert>)
        /// WebView を表示する.
        case safari(SafariReducer)
        /// 設定画面を表示する.
        case setting(SettingReducer)

        public enum Alert: Equatable {}
    }

    @ObservableState
    public struct State: Equatable {
        /// 画面遷移で利用する `State`.
        @Presents public var destination: Destination.State? = nil
        /// 今日のダイヤの時刻表のデータ一覧.
        public var busTimes = [BusTime]()
        /// 行先.
        public var busDestination: BusDestination
        /// その日のダイヤ.
        public var diagram: String? = nil
        /// その日のダイヤ名.
        public var diagramName: String? = nil
        /// カウントダウンの `State`.
        public var countdown = CountdownReducer.State()
        /// `Firebase Remote Config` から取得した PDF のデータ.
        public var remoteConfig: RemoteConfig?
        /// 画面の表示状態.
        public var viewState: ViewState = .loading

        public init(
            busTimes: [BusTime] = [],
            busDestination: BusDestination,
            destination: Destination.State? = nil,
            diagram: String? = nil,
            diagramName: String? = nil,
            countdown: CountdownReducer.State = CountdownReducer.State(),
            remoteConfig: RemoteConfig? = nil,
            viewState: ViewState = .loading
        ) {
            self.busTimes = busTimes
            self.busDestination = busDestination
            self.destination = destination
            self.diagram = diagram
            self.diagramName = diagramName
            self.countdown = countdown
            self.remoteConfig = remoteConfig
            self.viewState = viewState
        }
    }

    /// 画面の表示に関する状態を定義した Enum.
    public enum ViewState {
        /// 処理実行中.
        case loading
        /// 処理完了.
        case success
        /// 処理の結果が空.
        case empty
        /// エラー等で失敗.
        case failure
    }

    public enum Action {
        /// 自発以降のバス一覧タップ時の `Action`.
        case busListButtonTapped(Int)
        /// 次発以降のバスがなくなった時の `Action`.
        case busTimesEmpty
        /// カレンダーの PDF を確認するボタンタップ時の `Action`.
        case calendarButtonTapped
        /// カウントダウンの `Action`.
        case countdown(CountdownReducer.Action)
        /// 画面遷移の `Action`.
        case destination(PresentationAction<Destination.Action>)
        /// 通知登録の結果を受け取った時の `Action`.
        case notificationResponse(Result<BusTime, any Error>)
        /// `firestore` の処理の結果を受け取った際の `Action`.
        case response(Result<ToDestinationResponse, any Error>)
        /// 設定のボタンタップ時の`Action`.
        case settingButtonTapped
        /// `View` 側の `task` 実行時の `Action`.
        case task
        /// 時刻表の PDF を確認するボタンタップ時の `Action`.
        case timetableButtonTapped
    }

    @Dependency(\.date) var dateGenerator
    @Dependency(\.fileClient) var fileClient
    @Dependency(\.firestoreClient) var firestoreClient
    @Dependency(\.remoteConfigClient) var remoteConfigClient
    @Dependency(\.userNotificationClient) var userNotificationClient

    public var body: some ReducerOf<Self> {
        Scope(state: \.countdown, action: \.countdown) {
            CountdownReducer()
        }
        Reduce<State, Action> { state, action in
            switch action {
            case let .busListButtonTapped(index):
                let busTime = state.slicedBusTimes[index]
                let now = DateInRegion(dateGenerator.now)
                // 通知する時間を指定した日付のデータを作成する.
                let dateInRegion = DateInRegion(
                    year: now.year,
                    month: now.month,
                    day: now.day,
                    hour: busTime.hour,
                    minute: busTime.minute
                )
                // すでに出発時刻の 5 分前を過ぎていた場合はアラートを表示して終了する.
                if dateInRegion.timeIntervalSince(now) < 300 {
                    state.destination = .alert(
                        AlertState {
                            TextState("エラー")
                        } message: {
                            TextState("すでに5分前の時間を過ぎています")
                        }
                    )
                    return .none
                }

                return .run { send in
                    await send(
                        .notificationResponse(
                            Result {
                                try await userNotificationClient.authorize()
                                // 1 件のみ通知を登録するため先に登録済みのものを削除しておく.
                                try await userNotificationClient.removeAllNotifications()
                                try await userNotificationClient.addNotification(date: dateInRegion.date)
                                return busTime
                            }
                        )
                    )
                }

            case .busTimesEmpty:
                // データが空の場合の表示を行う.
                state.viewState = .empty
                return .none

            case .calendarButtonTapped:
                guard let remoteConfig = try? remoteConfigClient.configuredValue(for: .pdfURL, type: RemoteConfig.self),
                      let url = URL(string: remoteConfig.calendar) else {
                    return .none
                }
                state.destination = .safari(
                    SafariReducer.State(
                        url: url
                    )
                )
                return .none

            case .countdown(.delegate(.isTimeRunningUp)):
                // カウントダウンが完了した要素を削除する.
                state.busTimes.popFirst()
                // 要素を削除した結果、次発以降のバスがなくなった場合はイベントを送る.
                guard let busTime = state.busTimes.first else {
                    return .run { send in
                        await send(.busTimesEmpty)
                    }
                }
                // カウントダウンの `Reducer` にデータの変更を通知する.
                state.countdown.busTime = busTime
                return .run { send in
                    await send(.countdown(.busTimePopped))
                }

            case .countdown:
                // `Delegate` で受け取るもの以外は何もしない.
                return .none

            case .destination:
                return .none

            case let .notificationResponse(.success(busTime)):
                // 通知登録完了後のアラートを表示する.
                state.destination = .alert(
                    AlertState {
                        TextState("")
                    } message: {
                        TextState(
                            String(
                                format: "%02i:%02i の5分前に\n通知が来るように設定しました。",
                                busTime.hour,
                                busTime.minute
                            )
                        )
                    }
                )
                return .none

            case let .notificationResponse(.failure(error)):
                state.destination = .alert(
                    AlertState {
                        TextState("エラー")
                    } message: {
                        TextState(error.localizedDescription)
                    }
                )
                return .none

            case let .response(.success(response)):
                // 次発以降のバスがない場合はイベントを送る.
                guard let busTime = response.busTimes.first else {
                    return .run { send in
                        await send(.busTimesEmpty)
                    }
                }
                // 画面の表示状態を更新.
                state.viewState = .success
                // 表示用のデータをセット.
                state.diagram = response.busDate.diagram
                state.diagramName = response.busDate.diagramName
                state.busTimes = response.busTimes
                state.remoteConfig = response.remoteConfig
                // カウントダウンの `Reducer` にデータの変更を通知する.
                state.countdown.busTime = busTime

                return .run { send in
                    await send(.countdown(.busTimePopped))
                }

            case .response(.failure):
                state.viewState = .failure
                return .none

            case .settingButtonTapped:
                state.destination = .setting(
                    SettingReducer.State()
                )
                return .none

            case .task:
                // カウントダウンの `Reducer` に行先の初期値を渡す.
                state.countdown.destination = state.busDestination
                return .run { [busDestination = state.busDestination] send in
                    await send(
                        .response(
                            Result {
                                // Firebase Remote Config から設定値を同期する
                                try await remoteConfigClient.fetchActivate()
                                let remoteConfig = try remoteConfigClient.configuredValue(
                                    for: .pdfURL,
                                    type: RemoteConfig.self
                                )
                                // 今日の日付から必要なデータを作成する.
                                let date = DateInRegion(dateGenerator.now)
                                let formatted = date.toFormat("yyyy-MM-dd")
                                let second = date.hour * 3600 + date.minute * 60 + date.second
                                // ダイヤのデータを取得した後に時刻表のデータを取得する
                                let busDate = try await firestoreClient.fetchBusDate(date: formatted)
                                let busTimes = try await firestoreClient.fetchBusTimes(
                                    diagram: busDate.diagram,
                                    destination: busDestination,
                                    second: second
                                )
                                // Widget で利用するためデータをローカルに保存する.
                                try overwriteCache(
                                    busDate: busDate,
                                    busTimes: busTimes
                                )
                                return ToDestinationResponse(
                                    busDate: busDate,
                                    busTimes: busTimes,
                                    remoteConfig: remoteConfig
                                )
                            }
                        )
                    )
                }

            case .timetableButtonTapped:
                guard let remoteConfig = try? remoteConfigClient.configuredValue(for: .pdfURL, type: RemoteConfig.self),
                      let url = URL(string: remoteConfig.timeTable) else {
                    return .none
                }
                state.destination = .safari(
                    SafariReducer.State(
                        url: url
                    )
                )
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
    }

    public init() {}
}

private extension ToDestinationReducer {
    /// Widget で利用するため今日の時刻表のデータをローカルに上書き保存する.
    /// - Parameter busDate: 今日のダイヤのデータ.
    /// - Parameter busTimes: 今日の時刻表のデータ一覧.
    func overwriteCache(busDate: BusDate, busTimes: [BusTime]) throws {
        let cache = Cache(
            busDate: busDate,
            busTimes: busTimes,
            lastUpdatedDate: dateGenerator.now.toFormat("yyyy-MM-dd")
        )
        let data = try JSONEncoder().encode(cache)
        // 常に上書き保存するため前のデータを削除する.
        fileClient.remove(name: "cache")
        try fileClient.write(data: data, name: "cache")
    }
}

// MARK: - View

public struct ToDestinationView: View {
    @Perception.Bindable public var store: StoreOf<ToDestinationReducer>

    public var body: some View {
        WithPerceptionTracking {
            Group {
                switch store.state.viewState {
                case .loading:
                    ProgressView()
                case .success:
                    ScrollView {
                        VStack {
                            if let diagramName = store.state.diagramName {
                                DiagramNameView(diagramName: diagramName)
                            }

                            CountdownView(
                                store: store.scope(
                                    state: \.countdown,
                                    action: \.countdown
                                )
                            )
                            .frame(height: 200)

                            VStack(spacing: 0) {
                                HStack {
                                    Text("次にくるバス一覧")
                                    Spacer()
                                    Text("※ 到着時刻は目安です")
                                        .foregroundStyle(.blue)
                                }
                                .font(.system(size: 11))
                                .padding(.horizontal, 16)

                                Spacer()
                                    .frame(height: 8)

                                ForEach(
                                    Array(store.state.slicedBusTimes.enumerated()),
                                    id: \.offset
                                ) { enumerated in
                                    // ここは Reducer として切り出した方がテスト可能になる.
                                    BusListItemView(
                                        index: enumerated.offset + 1,
                                        departureName: store.state.busDestination == .toCollege ? "大学発" : "浄水駅発",
                                        departureTime: String(
                                            format: "%i:%02i",
                                            enumerated.element.hour,
                                            enumerated.element.minute
                                        ),
                                        arrivalName: store.state.busDestination == .toCollege ? "浄水駅着" : "大学着",
                                        arrivalTime: String(
                                            format: "%i:%02i",
                                            enumerated.element.arrivalHour,
                                            enumerated.element.arrivalMinute
                                        ),
                                        isHighlighted: enumerated.offset == 0
                                    ) {
                                        store.send(.busListButtonTapped(enumerated.offset))
                                    }
                                }
                            }
                            .padding(.vertical, 16)
                            .background(
                                Color(.secondarySystemGroupedBackground)
                            )
                        }
                    }
                    .background(
                        Color(.systemGroupedBackground)
                    )
                case .empty:
                    DisconnectedView {
                        store.send(.calendarButtonTapped)
                    } timetableButtonAction: {
                        store.send(.timetableButtonTapped)
                    }
                case .failure:
                    ErrorView {
                        store.send(.calendarButtonTapped)
                    } timetableButtonAction: {
                        store.send(.timetableButtonTapped)
                    }
                }
            }
            .navigationTitle(store.state.busDestination == .toCollege ? "大学行き" : "浄水駅行き")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.send(.settingButtonTapped)
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.blue)
                            .frame(
                                width: 24,
                                height: 24
                            )
                    }
                }
            }
            .alert(
                $store.scope(
                    state: \.destination?.alert,
                    action: \.destination.alert
                )
            )
            .sheet(
                item: $store.scope(
                    state: \.destination?.setting,
                    action: \.destination.setting
                )
            ) { store in
                NavigationStack {
                    SettingView(store: store)
                }
            }
            .fullScreenCover(
                item: $store.scope(
                    state: \.destination?.safari,
                    action: \.destination.safari
                )
            ) { store in
                SafariView(store: store)
            }
            .task {
                store.send(.task)
            }
        }
    }

    public init(store: StoreOf<ToDestinationReducer>) {
        self.store = store
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ToDestinationView(
            store: Store(
                initialState: ToDestinationReducer.State(
                    busDestination: .toCollege
                ),
                reducer: {
                    ToDestinationReducer()
                }
            )
        )
    }
}
