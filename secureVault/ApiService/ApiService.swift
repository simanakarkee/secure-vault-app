//
//  ApiService.swift
//  secureVault
//
//  Created by Simana Karkee on 05/04/2025.
//

import Foundation
import UIKit

public class ApiService {
    static let shared = ApiService()
    let baseurl = "http://192.168.31.190:5555"
//    let baseurl = "http://127.0.0.1:5002"

    private init(){}
    
    enum SocialSite {
        case google
        case facebook
        case gmail
        case twitter
        case linkedin
        init? (logo: String) {
            switch logo {
            case "google":
                self = .google
            case "facebook":
                self = .facebook
            case "twitter":
                self = .twitter
            case "linkedin":
                self = .linkedin
            case "gmail":
                self = .gmail
            default:
                return nil
        }
    }
        var image: UIImage? {
            switch self {
                case .google:
                return UIImage(named: "google")
                case .facebook:
                return UIImage(named: "facebook")
                case .twitter:
                return UIImage(named: "twitter")
                case .linkedin:
                return UIImage(named: "linkedin")
                case .gmail:
                return UIImage(named: "gmail")
            }
        }
    }
    
    enum APIRoute {
        case login
        case register
        case savePassword
        case getAllPasswords
        case pawnedPasswords
        case editPassword
        case updatePassword
        case deleteAccount
        
        var path: String {
            switch self {
            case .login:
                return "/login"
            case .register:
                return "/register"
            case .savePassword:
                return "/savepassword"
            case .getAllPasswords:
                return "/getAllPasswords"
            case .pawnedPasswords:
                return "/checkPasswordIsPawned"
            case .editPassword:
                return "/update"
            case .updatePassword:
                return "/updatepassword"
            case .deleteAccount:
                return "/deleteaccount"
            }
        }
    }
    
    func request(route: APIRoute, method: String = "GET", parameters: [String: Any]? = nil, completion: @escaping (Data?, URLResponse?,Error?) -> Void) {
        guard let url = URL(string: ApiService.shared.baseurl + route.path) else {
            print("invalid url")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? [])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request, completionHandler: completion).resume()
    }
}

