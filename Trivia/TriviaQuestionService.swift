//
//  TriviaQuestionService.swift
//  Trivia
//
//  Created by Ngoc Nhu Y Banh on 2023-10-12.
//

import Foundation

class TriviaQuestionService{
    static func fetchTriviaQuestion(amount: Int,
                                    completion: (([TriviaQuestion]) -> Void)? = nil) {
        let parameters = "amount=\(amount)"
        let url = URL(string: "https://opentdb.com/api.php?\(parameters)")!
        // Create data task and pass in the URL
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                assertionFailure("Error: \(error!.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                assertionFailure("Invalid response")
                return
            }
            guard let data = data, httpResponse.statusCode == 200 else{
                assertionFailure("Invalid response status code: \(httpResponse.statusCode)")
                return
            }
            if let jsonData = try! JSONSerialization.jsonObject(with: data) as? [String: Any], let results = jsonData["results"] {
                let resultsData = try! JSONSerialization.data(withJSONObject: results)
                let questions = try! JSONDecoder().decode([TriviaQuestion].self, from: resultsData)
                
                DispatchQueue.main.async {
                    completion!(questions)
                }
            }
        }
        task.resume()
    }
    
    
}

extension String {
    var htmlDecoded: String {
        guard let data = data(using: .utf8) else {return self}
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [.documentType:NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil){
            return attributedString.string
        }
        return self
    }
}
