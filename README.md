# Cravely 🚬🌿

Cravely is an iOS app that helps you quit cigarettes or cannabis by turning every craving you resist into a visible win — a running savings total, a streak, and a history you can look back on.

Built with **SwiftUI** and **SwiftData**, using an **MVVM** architecture.

## How it works

Instead of tracking what you consume, Cravely tracks what you *resist*. Every time you feel a craving and tap "I crave one," the app logs it as a win, adds the unit price of your habit to your running savings total, and keeps your streak alive.

## Features

- **Resist button** — one tap to log a resisted craving, with a satisfying smoke-dissipation animation
- **Savings tracker** — running total of money saved, calculated from your habit's real unit price
- **Streaks** — consecutive-day tracking that stays alive as long as you log at least one resist per day
- **Daily stats** — cravings resisted, time since your last craving, and average daily savings
- **History** — a day-by-day log of every resisted craving
- **Habit & brand selection** — choose between cigarettes or cannabis, then pick a specific brand/product (Marlboro, Newport, American Spirit, pre-rolls, flower, vape carts, edibles, concentrates, etc.), each with realistic default pricing that's automatically converted to a per-use cost
- **Onboarding flow** — notification permission, habit type, and brand/product selection on first launch
- **Daily reminders** — optional 8 PM local notification to reinforce the habit
- **Dark, minimal UI** — a focused black-and-white interface designed to keep the "resist" action front and center

## Roadmap

- 📱 **Home Screen & Lock Screen widgets** (WidgetKit) — surface streak and savings totals without opening the app

## Tech stack

| Layer | Technology |
|---|---|
| UI | SwiftUI |
| Architecture | MVVM |
| Persistence | SwiftData |
| Notifications | UserNotifications |
| Language | Swift |

## Project structure

```
CravelyApp/
├── CravelyAppApp.swift        # App entry point
├── NotificationManger.swift   # Local notification scheduling & permissions
├── Models/
│   └── TapModel.swift         # SwiftData model for a logged "resist" event
├── Screens/
│   ├── Home/                  # Main screen — resist button, stats, streak
│   ├── History/                # Day-by-day log of resisted cravings
│   └── Settings/               # Habit type, brand/product, pricing, reminders
└── Views/
    ├── ContentView.swift       # Root tab container
    ├── LunchScreenView.swift  # Launch/splash screen
    └── OnboadingFlowView.swift # First-launch onboarding flow
```

## Getting started

1. Clone the repo
   ```bash
   git clone https://github.com/aymantx1/Cravely.git
   ```
2. Open `CravelyApp.xcodeproj` in Xcode
3. Build and run on a simulator or device running iOS 17+ (required for SwiftData)

## Requirements

- Xcode 15+
- iOS 17+
- Swift 5.9+
