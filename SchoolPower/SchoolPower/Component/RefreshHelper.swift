//
//  RefreshHelper.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/15/21.
//

import Foundation
import UIKit
import SwiftUI

protocol ErrorHandler {
    var errorResponse: ErrorResponse? { get set }
    var showingError: Bool { get set }
}

class RefreshHelper<T> where T: ErrorHandler {
    var parent: T?
    var refreshControl: UIRefreshControl?
    
    @objc func didRefresh() {
        guard parent != nil, let refreshControl = refreshControl
        else { return }
        StudentDataStore.shared.refresh { success, errorResponse, error in
            refreshControl.endRefreshing()
            if success {
                
            } else {
                self.parent!.errorResponse = errorResponse
                ?? ErrorResponse(
                    title: "Failed to refresh data".localized,
                    description: error ?? "Unknown error.".localized
                )
                self.parent!.showingError = true
            }
        }
    }
}

extension List {
    func withRefresh<T>(
        parent: T,
        refreshHelper: RefreshHelper<T>
    ) -> some View where T: ErrorHandler {
        self
            .introspectTableView { tableView in
                guard UIDevice.current.userInterfaceIdiom != .mac else { return }
                guard tableView.refreshControl == nil else { return }
                let control = UIRefreshControl()
                refreshHelper.parent = parent
                refreshHelper.refreshControl = control
                control.addTarget(
                    refreshHelper,
                    action: #selector(RefreshHelper<T>.didRefresh),
                    for: .valueChanged
                )
                tableView.refreshControl = control
            }
    }
}
