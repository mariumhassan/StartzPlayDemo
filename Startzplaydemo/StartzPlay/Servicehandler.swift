//
//  ViewController.swift
//  StartzPlay
//
//  Created by Marim Hassan on 13/07/2021.
//

import Alamofire
import Foundation

enum actionUrl :String{
    
    case baseUrl = "https://api.themoviedb.org/3/"
    case baseUrlImg = "https://image.tmdb.org/t/p/original"
}


class Servicehandler {

    var parameters: [String: Any]
    
    
    init() {
        parameters = [String:Any]()
        self.parameters["api_key"] = "3d0cda4466f269e793e9283f6ce0b75e"
    }
    
    func execute<T:Codable>(action:String,modelType:T.Type,completionHandler responseBlock: @escaping (T) -> ()) {
         let actionurl = actionUrl.baseUrl.rawValue + action
        let request = AF.request(actionurl,parameters: self.parameters)
            
            request.responseJSON { (response) in
                
                switch (response.result) {
                case .success:
                               if let data = response.data {
                                   do {
                                       let serverdata = try JSONDecoder().decode(modelType.self, from: data)
                                       responseBlock(serverdata)
                                   }
                                   catch {
                                       print(error.localizedDescription)
                                   }
                               }
                           case .failure( let error):
                               print(error)
                           }
                
                
                
                      }
            
    }
    
    class func downloaddata(action: String,completionHandler responseBlock: @escaping (AFDataResponse<Data>) -> ()) {
        let request = AF.request(action)
            
        request.responseData { (response) in
                responseBlock(response)
                
                      }
            
    }

    
}

