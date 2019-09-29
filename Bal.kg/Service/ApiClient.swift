
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
    
    //MARK: TEACHER -------------------////////////////-------------------
    
    //MARK: Get Classes
    
    func getClasses(completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/classes" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let header: HTTPHeaders = ["token": "\(token)"]
        
        let params = ["token": token] as [String:Any]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON
            { responseJSON in
                switch responseJSON.result {
                case .success:
                    completion(responseJSON.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    //MARK: Get Timetable
    
    func getTimetable(classId: String, completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/childschedule" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let header: HTTPHeaders = ["token": "\(token)"]
        
        let params = ["token": token, "class_id": classId] as [String:Any]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: header).responseJSON
            { responseJSON in
                switch responseJSON.result {
                case .success:
                    completion(responseJSON.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    //MARK: Get Childrens List
    
    func getChildrens(classId: String, completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/childrens" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        
        let params = ["token": token, "class_id": classId] as [String:Any]
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
            { responseJSON in
                switch responseJSON.result {
                case .success:
                    completion(responseJSON.result.value, nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    //MARK: Post Homework
    
    func postHomework(classId: String, subjectId: String, date: String, text: String, completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/homework" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
     
        let params = ["token": token, "class_id" : classId, "subject_id": subjectId, "date": date, "text": text] as [String: String]
        
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
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
    
    //MARK: Post Marks
    
    func postMarks(marksObjc: [String: String], subjectId: String, date: String, comment: String, part: String, typeMark: String, completion: @escaping Completion){
        guard let url = URL(string: "https://bal.kg/api/marks" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        
        for i in 0..<marksObjc.count {
            let id = Array(marksObjc)[i].key
            let mark = Array(marksObjc)[i].value
            print("id \(id)")
            print("mark \(mark)")
            print("------------------")
            print("part \(part)")
            print("comment \(comment)")
            print("subjectId \(subjectId)")
            print("typeMark \(typeMark)")
            print("date \(date)")


            let params = ["token": token, "id" : id, "subject_id": subjectId, "mark": mark, "part": part,"type_mark": typeMark, "date": date, "comm": comment] as [String: Any]
            
            print(params.count)
            
            //Задержка для масства в 200 миллисекунд
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
                { responseJSON in
                    if i == marksObjc.count - 1 {
                        switch responseJSON.result {
                        case .success:
                            completion(responseJSON.result.value, nil)
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                            print("error")
                            completion(nil,error)
                        }
                    }
            }

            usleep(200000)

        }
        
        

    }
    
    //MARK: GUARD ---------------/////////////////-----------------
    
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
    
    
    //MARK: PARENT --------------////////////////--------------
    
    //MARK: get kids
    
    func getMyChildrens(completion: @escaping Completion){
        
        guard let url = URL(string: "https://bal.kg/api/mychildrens" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let params = ["token": token] as [String: String]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
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
    
    func getNotifictions(completion: @escaping Completion){
        
        guard let url = URL(string: "https://bal.kg/api/mychildrens" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let params = ["token": token] as [String: String]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
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
    
    //MARK: get childs info
    
    func getChildsInfo(id: String, completion: @escaping Completion){
        
        guard let url = URL(string: "https://bal.kg/api/childinfo" ) else { return }
        let token = UserDefaults.standard.value(forKey: "token") as! String
        let params = ["token": token, "id": id] as [String: String]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).responseJSON
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



