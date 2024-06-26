//
//  SMSniperApp.swift
//  SMSniper
//

import SwiftUI
import StoreKit

@main
struct SMSniperApp: App {

    let store = AppStore(initialState: .init(                            
                        settings: SettingsState(),
                        filters: FilterState() 
                        ),
                      reducer: appReducer,
                      middlewares: [
                        settingsMiddleware(appSettings: AppSettingsDefaults(userDefaults: UserDefaults.standard)),
                        filterMiddleware(filterStore: FilterStoreFile()),
                        reviewMiddleware(reviewService: ReviewServiceStoreKit(appSettings: AppSettingsDefaults(userDefaults: UserDefaults.standard)))                        
                      ]
    )

    init() {
        // Fetch existing settings
        store.dispatch(.settings(action: .fetchSettings))

        // FetchExisting Filters
        store.dispatch(.filter(action: .fetch))

        // Increase launch number
        store.dispatch(.settings(action: .setNumberOfLaunches(number: store.state.settings.numberOfLaunches + 1)))

      self.store.dispatch(.isLoading(status: false))
    }
    
    var body: some Scene {
        WindowGroup {
            BaseView().environmentObject(store)
        }
    }
}
