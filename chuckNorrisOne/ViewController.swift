//
//  ViewController.swift
//  chuckNorrisOne
//
//  Created by Ishaq Amin on 28/01/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//
//
//  ViewController.swift
//  chuckNorris
//
//  Created by Ishaq Amin on 27/01/2020.
//  Copyright © 2020 Ishaq Amin. All rights reserved.
//

import UIKit


// MARK: - Welcome
struct Welcome: Codable {
    let type: String
    let value: Value
}

// MARK: - Value
struct Value: Codable {
    let id: Int
    let joke: String
    let categories: [String]
}

enum ApiError: Error {
    case noDateError
}



class ViewController: UIViewController {
    
    let urlString = "http://api.icndb.com/jokes/random?"
    @IBOutlet weak var jokeOutLabel: UILabel!
    
    @IBAction func randomJokeButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "This Is Funny", message:
            "\(jokeOutLabel.text)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: " HAHAHA, Tell Me Another", style: .default))
        alertController.addAction(UIAlertAction(title: "Not Funny, Try Again!", style: .default))
        
        self.present(alertController, animated: true, completion: nil)
       
        
        fetchJokesJSON { [weak self] (res) in
            DispatchQueue.main.async {
                switch res {
                case .success(let welcome):
                    self?.jokeOutLabel.text = welcome.value.joke
                case .failure(let err):
                    print("Sorry, we are all laughed out! \(err)")
                }
            }
        }
    }
    
//    func jokeAlert() {
//
//    let alertController = UIAlertController(title: "This Is Funny", message:
//                 "\(jokeOutLabel.text)", preferredStyle: .alert)
//             alertController.addAction(UIAlertAction(title: " HAHAHA, Tell Me Another", style: .default))
//             alertController.addAction(UIAlertAction(title: "Not Funny, Try Again!", style: .default))
//
//             self.present(alertController, animated: true, completion: nil)
//
//    }
    
    
    fileprivate func fetchJokesJSON(completion: @escaping (Result<Welcome, Error>) -> ()) {
        
        //        let urlString = "http://api.icndb.com/jokes/random?firstName=Ishaq&amp;lastName=Amin"
        
        
//        let urlString = "http://api.icndb.com/jokes/random"
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                completion(.failure(ApiError.noDateError))
                return
            }
            
            do {
                let jokes = try JSONDecoder().decode(Welcome.self, from:data)
                completion(.success(jokes))
            } catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


