//
//  ScreenView.swift
//  POC
//
//  Created by Mark Randall on 10/21/20.
//

import SwiftUI

struct ScreenView: View {
    
    // MARK: - ViewModel
    
    @ObservedObject private(set) var viewModel = ViewModel(screenId: "homeScreen", isNavigationView: true)
        
    // MARK: - Alert

    @State private(set) var alert: AlertComponentState?

    // MARK: - NavigationLink
    
    @State private(set) var navigationLinkViewModel: ViewModel?
    @State private(set) var navigationLinkIsActive: Bool = false
        
    // MARK: - Sheet
    
    @State private(set) var sheetViewModel: ViewModel?
    
    // MARK: - Body
    
    var body: some View {
        ScreenWrapperView(viewModel: viewModel) {
            if viewModel.viewState.showActivityIndicator {
                ProgressView("")
            }
            NavigationLink(destination: navigationLinkView(viewModel: navigationLinkViewModel), isActive: $navigationLinkIsActive) {
                EmptyView()
            }
            ComponentsView(componentModelFactory: viewModel, components: viewModel.viewState.components)
        }
        .alert(item: self.$alert) { Alert(title: Text($0.content.title), message: Text($0.content.message ?? "")) }
        .sheet(item: self.$sheetViewModel, content: { vm in ScreenView(viewModel: vm) })
        .onReceive(viewModel.viewEffect) {
            switch $0 {
            case .presentAlert(let alert): self.alert = alert
            case .presentNavigationLink(let vm):
                self.navigationLinkViewModel = vm
                self.navigationLinkIsActive = true
            case .presentSheet(let vm): self.sheetViewModel = vm
            }
        }
    }
    
    @ViewBuilder
    private func navigationLinkView(viewModel: ViewModel? = nil) -> some View {
        if let vm = viewModel {
            ScreenView(viewModel: vm)
        } else {
            EmptyView()
        }
    }
}

// MARK: - ScreenWrapperView

struct ScreenWrapperView<Content: View>: View {
    
    private let viewModel: ViewModel
    let content: Content

    init(viewModel: ViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
    }

    var body: some View {
        if viewModel.isNavigationView {
            NavigationView {
                VStack {
                    content
                }
                .navigationBarTitle(viewModel.viewState.title, displayMode: viewModel.navigationViewDisplayMode)
            }
        } else {
            VStack {
                content
                    .navigationBarTitle(viewModel.viewState.title, displayMode: viewModel.navigationViewDisplayMode)
            }
        }
    }
}

// MARK: - PreviewProvider

struct ScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ScreenView()
    }
}
