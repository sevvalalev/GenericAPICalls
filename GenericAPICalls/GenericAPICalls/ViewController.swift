//
//  ViewController.swift
//  GenericAPICalls
//
//  Created by Şevval Alev on 26.06.2023.
//

import UIKit

struct PlayerResponse: Codable {
    let data: [Player]
}

struct Player: Codable {
    let first_name: String?
    let last_name: String?
}

struct TeamResponse: Codable {
    let data: [Team]
}

struct Team: Codable {
    let full_name: String
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Constants {
        static let teamsUrl = URL(string: "https://www.balldontlie.io/api/v1/teams")
        static let playersUrl = URL(string: "https://www.balldontlie.io/api/v1/players")
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models: [Codable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        //fetchPlayer()
        fetchTeams()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func fetchPlayer() { //custom function we made
        URLSession.shared.request(
            url: Constants.playersUrl,
            expecting: PlayerResponse.self
            ) { [weak self] result in
            switch result {
            case .success(let players):
                DispatchQueue.main.async {
                    self?.models = players.data
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
        
        func fetchTeams() {
            URLSession.shared.request(
                url: Constants.teamsUrl,
                expecting: TeamResponse.self
                ) { [weak self] result in
                switch result {
                case .success(let teams):
                    DispatchQueue.main.async {
                        self?.models = teams.data
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = (models[indexPath.row] as? Team)?.full_name
        //cell.textLabel?.text = (models[indexPath.row] as? Player)?.first_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
}

extension URLSession {
    
    enum CustomError: Error {
        case invalidUrl
        case invaildData
    }
    
    func request<T: Codable>(url: URL?, expecting: T.Type , completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task  = self.dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }else{
                    completion(.failure(CustomError.invaildData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
}
