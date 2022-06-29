//
//  ViewController.swift
//  SwiftAysncAwait
//
//  Created by Genusys Inc on 6/29/22.
//

import UIKit

class ViewController: UIViewController {

    private let url = URL(string: "https://jsonplaceholder.typicode.com/users")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

struct User:Codable{
    var name:String
}

