//
//  ViewController.swift
//  GenericAPICalls
//
//  Created by Şevval Alev on 26.06.2023.
//

import UIKit

class ViewController: UIViewController {

    struct Constants {
        static let teamsUrl = URL(string: "https://www.balldontlie.io/api/v1/teams")
        static let playersUrl = URL(string: "https://www.balldontlie.io/api/v1/players")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension URLSession {
    
    func request<T: Codable>(url: URL?, expecting: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        
    }
    
}
