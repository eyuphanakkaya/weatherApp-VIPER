//
//  HomeRouter.swift
//  weatherApp
//
//  Created by Eyüphan Akkaya on 18.11.2023.
//

import Foundation

class HomeRouter: PresenterToRouterHomeProtocol {
    static func createModule(ref: HomeViewController) {
        let presenter = HomePresenter()
        ref.homePresenter = presenter
        ref.homePresenter?.homeInteractor = HomeInteractor()
        ref.homePresenter?.homeView = ref
        ref.homePresenter?.homeInteractor?.interactorToPresenterProtocol = presenter
    }
    
    
}
