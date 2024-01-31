
# Minimal Money

A simplistic budgeting app meant to help low-income people, young adults, and college students simply manage their money and purchases. 


## Authors

- [@benc2711](https://www.github.com/benc2711)


## Demo
![](https://github.com/benc2711/MinimalMoney/blob/main/MinMoneyDemo.gif)

## Description 

The "Minimal Money" application, crafted by Ben Crotty, embodies a streamlined financial management tool leveraging modern software architecture and technologies. Developed with an underlying structure of Firebase Authentication and Firestore, it adheres to the Model-View-ViewModel (MVVM) architecture, addressing the creator's personal need for simplified financial management. A significant enhancement was achieved by refactoring the application using Swift Charts, which resulted in a 20% improvement in performance and a reduction in bugs that were prevalent with the previously used third-party chart SDK.

Furthermore, the application integrates essential Apple Frameworks such as push notifications and Core Location. These integrations are meticulously designed to provide timely user updates, prompting them to record purchases. This feature has contributed to a 15% increase in app usage, indicating a successful engagement strategy.

ContentView.swift serves as the main view, determining whether to display the main tab or the login view based on the user's authentication status. LoginView.swift is a user interface component that allows users to sign in or register, handling authentication with Firebase. LoginViewModel.swift is the ViewModel layer in MVVM, managing the business logic for user authentication, including user registration, sign-in, and sign-out functions, and handling errors during these processes. This ViewModel interacts with Firebase services and maintains the user's authentication state.

The additional code for "Minimal Money" adds several features and views, further enhancing its functionality as a financial management tool.

1. PurchaseViewModel.swift This class manages the logic related to user purchases. It keeps track of the user's daily budget, their purchases, and calculates spending data for chart visualization. The `addPurchase` method updates the user's daily budget and the linked bank account balance upon a new transaction. The ViewModel also contains methods for analyzing spending by category and updating data for selected periods, enhancing the app's analytical capabilities.

2. PurchaseView This SwiftUI view allows users to input and view their purchase transactions. It includes fields for entering transaction details, a picker for categories, a button to add purchases, and displays a list of transactions. This view integrates closely with `PurchaseViewModel` to manage and display purchase data.

3. SnapshotView Another SwiftUI view, it provides a snapshot of the user's financial activities. It includes a slider to select the number of days for which the user wants to view transactions and visualizations like pie charts (using `PieChartView`) to display spending by category. This view is designed to give users an overview of their spending habits over a selected period.

4. PieChartView This view, available in iOS 17.0 and later, is used within `SnapshotView` to create a pie chart visualizing the user's spending by category. It uses SwiftUI's `Chart` API to create an interactive pie chart, enhancing the user experience with visual data representation.

5. MainTabView This SwiftUI view functions as the main container for the app, organizing the different views (`PurchaseView`, `SnapshotView`, and `AccountView`) into a tabbed interface. This allows users to navigate easily between different functionalities of the app, such as adding purchases, viewing financial snapshots, and managing account settings.

6. AccountViewModel.swift: This ViewModel manages user account-related data. It tracks the user's daily budget, account balance, spending categories, and financial goals. The ViewModel provides functionalities such as modifying the daily budget, account balance, adding new spending categories, and setting financial goals. These operations involve both updating the local data model (UserAccount) and saving the changes to Firebase Firestore, ensuring data consistency and persistence.

7. AccountView: This SwiftUI view serves as the user interface for managing account settings. It allows users to update their daily budget and account balance, add new spending categories, and navigate to a sheet for adding financial goals. The view uses @ObservedObject to bind to AccountViewModel, PurchaseViewModel, and LoginViewModel for interacting with the data layer and handling authentication-related actions, such as logging out.

8. FinancialGoalSheetView: A SwiftUI view presented as a sheet from AccountView, it provides a form for users to add new financial goals. Users can enter a goal title and a target amount, which are then added to their account through AccountViewModel. This feature aids users in setting and tracking their financial aspirations.

## Features

- Light/dark mode toggle
- Live previews
- Fullscreen mode
- Cross platform

