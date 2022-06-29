//
//  ViewController.swift
//  SwiftAysncAwait
//
//  Created by Genusys Inc on 6/29/22.
//

import UIKit

class ViewController: UIViewController {

    private let url = URL(string: "https://jsonplaceholder.typicode.com/users")

    let table : UITableView  = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    } ()
    var userlist :[User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.frame = view.bounds
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        
        
        Task {
            let result = await getUserlist()
            print("result")
            
            let result1 = await getUserlist()
            print("result1")

            let result2 = await getUserlist()
            print("result2")

            let result3 = await getUserlist()
            print("result3")

            switch result {
                
            case .success(let users):
                print("success")
                //print(users)
                self.userlist = users
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
             
            case .failure(let error):
                print("failure")
                print(error)
            }
        }
    }

    enum MyError:Error{
        case failToGetUser
    }
    func getUserlist() async ->Result<[User],Error>{
        guard let url = self.url else{
            return .failure(MyError.failToGetUser)
        }
        do {
            let (data, _) =  try  await URLSession.shared.data(from: url)
           // self.prityPrint(data)
            let users = try JSONDecoder().decode([User].self, from: data)
        
            for i in 0...10000000{
                
            }
            
            return .success(users)
            
        } catch  {
            return .failure(MyError.failToGetUser)
        }
    }
    
    func prityPrint(_ data:Data){
        do{
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
                print(String(decoding: jsonData!, as: UTF8.self))

        }catch{
            print(error.localizedDescription)
        }
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = self.userlist[indexPath.row].name
        return cell
    }
    
    
    
}

struct User:Codable{
    var name:String
}

