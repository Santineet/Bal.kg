
import UIKit
import Alamofire
import ObjectMapper


class ServiceManager: NSObject {
    
    static let sharedInstance = ServiceManager()
    typealias Completion = (_ response: Any?, _ error: Error?) -> ()


    //MARK: Login Methods
    
    func login(email: String, password: String,completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/auth" ) else { return }
        
        let params = ["login": email, "pass": password] as [String:Any]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
            { responseJSON in
                switch responseJSON.result {
                case .success:
                    completion(responseJSON.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    //MARK: Logout Methods
    
    func logout(completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/logout" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let header: HTTPHeaders = ["token": "\(token)"]
        
        let params = ["token": token] as [String:Any]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON
            { responseJSON in
                switch responseJSON.result {
                case .success:
                    completion(responseJSON.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
//    //MARK: Запрос новостей
//    //MARK: News Request
//    func getNews(completion: @escaping Completion) {
//
//        guard let newsUrl = URL(string: "http://apiprod.htlife.biz/api/news/") else { return }
//
//        Alamofire.request(newsUrl, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (responseJSON) in
//            switch responseJSON.result {
//            case .success:
//                completion(responseJSON.result.value, nil)
//            case .failure(let error):
//                completion(nil, error)
//            }
//        }
//    }
    
    
   
    
    
    
}
