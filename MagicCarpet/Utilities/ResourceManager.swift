//
//  ResourceManager.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//


import UIKit

class ResourceManager: NSObject {
    
    static let shared           = ResourceManager()
    private let cache           = NSCache<NSString, UIImage>()
    
    private override init() {}

    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}
