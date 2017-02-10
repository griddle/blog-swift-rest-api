//: Please build the scheme 'AlamofirePlayground' first

import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true


import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import PromiseKit



protocol BaseAPIModel: Mappable {
}

extension BaseAPIModel {
  static func api(
    _ path: String,
    method: HTTPMethod = .get,
    parameters: Parameters? = nil
    ) -> Promise<Self>
  {
    let url = "http://localhost:8000" + path
    
    return Promise { fulfill, reject in
      Alamofire.request(
        url,
        method: method,
        parameters: parameters
      )
      .validate(statusCode: 200..<300)
      .responseObject { (response: DataResponse<Self>) in
        switch response.result {
        case .success:
          fulfill(response.result.value!)
        case .failure(let error):
          reject(error)
        }
      }
    }
  }
}





class User: BaseAPIModel {
  var name: String!
  var email: String!
  
  init() {
  }
  
  convenience required init?(map: Map) {
    self.init()
  }
  
  func mapping(map: Map) {
    name <- map["name"]
    email <- map["email"]
  }
}




extension User {
  static var me: Promise<User> {
    return User.api("/me.json", method: .get)
  }
}



User.me.then { user -> Void in
  print(user.email)
  print(user.name)
}













