//
//  URLRequest+Extensions.swift
//  Rick and Morty MVVM and RxSwift
//
//  Created by Pavel Todorov on 4.08.21.
//

import Foundation
import RxSwift
import RxCocoa

struct Resource<T: Decodable> {
    let url: URL
}

/// an extension function to URLRequest so that it returns an Observable that  could be used with RxSwift
extension URLRequest {
    static func load<T>(resource: Resource<T>) -> Observable<T> {
        
        return Observable.just(resource.url)
            .flatMap { url -> Observable<Data> in
                
                let request = URLRequest(url: url)
                return URLSession.shared.rx.data(request: request)
                
            }.map { data -> T in
                
                return try JSONDecoder().decode(T.self, from: data)
                
            }
        
    }
    
}
