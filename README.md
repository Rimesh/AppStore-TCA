<h1> AppStoreTCA
  <img align="right" alt="App icon" src="Docs/assets/Icons/icon-small.png" width=128px>
</h1>

<p>
    <img src="https://img.shields.io/badge/iOS-18.0+-green.svg" />
    <img src="https://img.shields.io/badge/Xcode-16+-blue.svg" />
    <img src="https://img.shields.io/badge/-SwiftUI-red.svg" />
</p>

### AppStore App using The Composable Architecture
This is a sample iOS app built with SwiftUI and [The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) by [Point-Free](https://www.pointfree.co)

<br>
<p>
    <img alt="Search screen" src="Docs/assets/Screens/Category.png" width="200" />
    <img alt="Search screen" src="Docs/assets/Screens/NoResults.png" width="200" />
    <img alt="Search Results screen" src="Docs/assets/Screens/SearchResults.png" width="200" />
    <img alt="App detail screen" src="Docs/assets/Screens/AppDetails.png" width="200" />
</p>
<br>

## Features

- **Search**: Allows users to search for apps using iTunes API.
- **Navigation**: Navigate through the list of apps, view details,
- **Empty state and Error Handling**: Shows `ContentUnavailableView` in case of "No results" and `Alert` for Network errors.
- **Testing**: Demonstrates how to write unit tests for TCA-based components, ensuring that actions, state updates, and effects behave as expected.

## API

The app uses iTunes search API to search for apps and retrieve their details.

```
https://itunes.apple.com/search?term=Notes&country=us&media=software
```

## Accessibility

The user interface supports **Dynamic Type** to ensure the app is accessible to users with different font size preferences.

#### Screenshots 
<details>
  <summary>Search Screen</summary>
  <img alt="App detail screen" src="Docs/assets/DynamicType/CategoryScreen/category-banner.png"/>
</details>
<details>
  <summary>Search Results Screen</summary>
  <img alt="App detail screen" src="Docs/assets/DynamicType/AppResultsScreen/app-results-banner.png"/>
</details>
<details>
  <summary>App Details Screen</summary>
  <img alt="App detail screen" src="Docs/assets/DynamicType/AppDetailsScreen/details-banner.png"/>
</details>

## Setup

1. Clone this repository to your local machine.
2. Open the project in Xcode.
3. Run the app on the simulator or a physical device.

## Getting strated with TCA

If you want to learn more about TCA, Point-Free has released an interactive tutorial [Meet the Composable Architecture](https://pointfreeco.github.io/swift-composable-architecture/main/tutorials/meetcomposablearchitecture/)
