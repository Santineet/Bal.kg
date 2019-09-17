
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
    
    
    
    //MARK: Send Data Methods
    
    func sendData(id: String, status: Int, type: String, time: String, image: UIImage?, completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/move" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let header: HTTPHeaders = ["token": "\(token)"]
        
        var params = ["id": id,"status": status, "type": type, "time": time, "token": token] as [String:Any]
        
        if let image = image {
            params["file"] = image
            print(params["file"] as Any)
        }
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON
            { responseJSON in
                switch responseJSON.result {
                case .success:
                    completion(responseJSON.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    
        
        
        
       // собираюсь написать метод для post с файлом
        
        // надо подправить success repository и viewModel
        
        // удали предыдущий метод
        
  
        let parameters = ["id": id,"status": status, "type": type, "time": time, "token": token] as [String:Any]

        let headers: HTTPHeaders = [
            "token": "\(token)",
            "Content-type": "multipart/form-data"
        ]
        
        let imageData = image?.jpegData(compressionQuality: 0)
        let imageName = image?.imageAsset?.description
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            
            if let data = imageData{
                multipartFormData.append(data, withName: imageName!, fileName: "\(imageName!).png", mimeType: "\(imageName!)/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{

                        completion(nil, err)
                        return
                    }
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
        
        
        
        
        
        
        
        
        
        

    }


}



