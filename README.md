# OneSpan Interview Project

A sample iOS application demonstrating fetching and displaying dog breeds using a table view with image prefetching. This project showcases several key iOS development technologies and design patterns, including:

- **UIKit** for the user interface and table view
- **Dependency Injection** for initializing controllers with their dependencies
- **Composition** for cell controllers, making each cell responsible for its own configuration
- **Table View Prefetching** to optimize loading data/images ahead of time
- **MVC** (Model-View-Controller) Multiple MVC as the high-level architectural pattern
- **Unit Test** As requested for couple unit tests, the project includes unit tests covering the `RemoteFeedLoader` and `URLSessionHTTPClient`.

---

## Table of Contents

1. [Overview](#overview)
2. [Technologies Used](#technologies-used)
3. [Design Patterns](#design-patterns)
4. [Dependency Diagram](#dependency-diagram)
5. [Getting Started](#getting-started)

---

## Overview

This app displays a list of dog breeds retrieved from a remote API. The `MainViewController` manages the table view, handles user interactions, and coordinates fetching new data through a `RefreshController`. Each row in the table is driven by a `CellController`, which is responsible for configuring and managing the logic for its own cell (including image loading, prefetching, and cancellation).

---

## Technologies Used

- **Swift 5+**
- **iOS SDK (UIKit)**:
  - `UITableView` for listing dog breeds
  - `UITableViewDataSourcePrefetching` for optimizing table view performance
  - `UIActivityIndicatorView` for indicating loading states
- **Dependency Injection**:
  - The `RefreshController` is injected into `MainViewController` during initialization, making the code more testable and flexible.
- **Xcode**:
  - Built and tested with an Xcode 14+ environment (though future versions should also work).

---

## Design Patterns

1. **MVC (Model-View-Controller)**

   - `MainViewController` acts as the primary Controller for the UI.
   - `RefreshController` acts as the Controller for the LoadingView and Refresh action.
   - `CellController` acts as the Controller for each cell.
   - The “model” data for the table is represented by an array of `CellController` objects (`tableModel`).
   - The table view (`UITableView`) and its cells (`UITableViewCell`) represent the main View layer.

2. **Composition for Cell Logic**

   - Each cell is driven by a `CellController`, which encapsulates:
     - Loading or prefetching of cell data (e.g., images).
     - Cancelling any ongoing work if the cell is no longer visible or is prefetch-cancelled.
   - This design keeps `MainViewController` lightweight and focused on high-level coordination.

3. **Dependency Injection**

   - `RefreshController` is passed into `MainViewController` via its custom initializer, allowing easy testing and flexibility to swap different refresh strategies or mock implementations.

4. **Table View Prefetching**
   - By implementing `UITableViewDataSourcePrefetching`, the app can load resources in advance (like images) for upcoming rows. This can improve performance and the user experience.

---

## Dependency Diagram

![Dependency Diagram](./OneSpan%20Dependency%20Diagram.png 'Dependency Diagram')

---

## Getting Started

1. **Clone** or **Download** the repository:
   ```bash
   git clone https://github.com/YourUsername/OneSpan.git
   ```
