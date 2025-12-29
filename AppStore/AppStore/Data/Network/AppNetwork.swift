//
//  AppNetwork.swift
//  AppStore
//
//  Created by Langpeu on 12/29/25.
//

import Alamofire

protocol AppNetworkProtocol {
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError>
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError>
}


struct AppNetwork: AppNetworkProtocol {
    private let manager = NetworkManager()
    private let baseUrl = "https://itunes.apple.com/"
    
    func fetchAppList(term: String, limit: Int) async -> Result<[AppListItem], NetworkError> {
        let url = baseUrl + "search?term=\(term)&country=kr&entity=software&limit=\(limit)"
        return await manager.fetchData(url: url, method: .get)
    }
    
    func fetchAppDetail(id: Int) async -> Result<[AppDetailItem], NetworkError> {
        let url = baseUrl + "looking?id=\(id)"
        return await manager.fetchData(url: url, method: .get)
    }
}
