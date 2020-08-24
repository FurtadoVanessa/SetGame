//
//  NetworkService.swift
//  SetGame
//
//  Created by Vanessa Furtado on 18/08/20.
//  Copyright © 2020 Vanessa Furtado. All rights reserved.
//

import Foundation
import Alamofire

class NetworkService {

    class func verifyIfHasMatch(in tableCards : [Card], completion: @escaping (Result<Int, Error>) -> ()) {
        let link : String = "https://vanessa-game.herokuapp.com/game/check"

         let params : NSMutableDictionary = prepareJSONToSend(using: tableCards)
        let JSON  = try? JSONSerialization.data(withJSONObject: params, options: [])
        if let result = JSON {
            let headers: HTTPHeaders = [
                "Content-Type": "application/json"
            ]
            let url = URL(string: link)!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.headers = headers
            request.httpBody = result

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    completion(.failure(error!))
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    if responseJSON["game"] != nil {
                        print("JSON value \(responseJSON["game"]!)")
                        DispatchQueue.main.async {
                            completion(.success(responseJSON["game"] as! Int))
                        }
                    }
                }
            }
            task.resume()
        }
    }

    class func prepareJSONToSend(using tableCards : [Card]) -> NSMutableDictionary {
        let para:NSMutableDictionary = NSMutableDictionary()
        let cardsDictionary = tableCards.map({ ["symbol": $0.symbol.rawValue, "color" : $0.color.rawValue, "shading": $0.shading.rawValue, "number_of_symbols" : $0.numberOfSymbols] })
        para.setValue(cardsDictionary, forKey: "cards")
        return para
    }


}
