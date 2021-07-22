//
//  Webservices.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 20.07.21.
//

import Foundation

//protocol WebServiceDelegate {
//    func finishedLoading()
//}

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}

final class WebService {
    
//    var delegate: WebServiceDelegate?
    
    func load<T>(resource: Resource<T>, completion: @escaping (T?) -> ()) {
        
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            
            if let data = data {
                DispatchQueue.main.async {
                   
                     completion(resource.parse(data))
                    //self.delegate?.finishedLoading()
                }
            } else {
                completion(nil)
            }
            
        }.resume()
        
    }
    
}
