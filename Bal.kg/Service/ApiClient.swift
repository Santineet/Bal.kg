
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
    
    func sendData(id: String, status: Int, type: String, time: String, imageData: Data?,imageName: String?, completion: @escaping Completion){
        
        guard let url = URL(string: "https://bal.kg/api/move" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let header: HTTPHeaders = ["token": "\(token)"]
        let params = ["id": id,"status": String(status), "type": type, "time": time, "token": token] as [String:String]


        if let imageData = imageData {
            
            //Method для загрузки данных c image
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                
                guard let imageName = imageName else {return}
                
                multipartFormData.append(imageData, withName: "file", fileName: "\(imageName).jpeg", mimeType: "image/jpeg")
                
                for (key, value) in params {
                    multipartFormData.append(value.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!, withName: key)
                }
                
            }, to: url, headers: header)
            { (result) in
                switch result {
                case .success(let upload,_,_ ):
                    upload.uploadProgress(closure: { (progress) in
                        
                        print(progress)
                    })
                    upload.responseJSON
                        { responseJSON in
                            print(responseJSON.result)
                            if responseJSON.result.value != nil
                            {
                                completion(responseJSON.result.value, nil)
                            }
                    }
                case .failure(let encodingError):
                    print(encodingError.localizedDescription)
                    completion(nil, encodingError)
                    break
                }
            }

            //Method для загрузки данных без image
        } else {
            Alamofire.request(url, method: .post, parameters: nil, encoding: URLEncoding.default, headers: header).responseJSON
                { responseJSON in
                    switch responseJSON.result {
                    case .success:
                        completion(responseJSON.result.value, nil)
                        break
                    case .failure(let error):
                        completion(nil,error)
                    }
            }
        }

    }
    
    
}



