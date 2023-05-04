//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit

public extension UIImageView {
    func setImage(path: String?, placeHolder: UIImage?) {
        self.image = placeHolder
        guard let path = path?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: path) else {
            self.image = placeHolder
            return
        }
        setImage(url: url, placeHolder: placeHolder)
    }
    
    func setImage(url: URL, placeHolder: UIImage?) {
        self.image = placeHolder
        ImageLoader.shared.load(url: url as NSURL) { image in
            DispatchQueue.main.async {
                if let image = image {
                    self.image = image
                } else {
                    self.image = placeHolder
                }
            }
        }
    }
}

private final class ImageLoader {
    private static var privateShared: ImageLoader?
    
    class var shared: ImageLoader {
        guard let shared = privateShared else {
            privateShared = ImageLoader()
            return privateShared!
        }
        return shared
    }
    
    private let cachedImages = NSCache<NSURL, UIImage>()
    private var loadingResponses = [NSURL: [(UIImage?) -> Void]]()
    
    private func image(url: NSURL) -> UIImage? {
        return cachedImages.object(forKey: url)
    }
    
    final func load(url: NSURL, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = image(url: url) {
            completion(cachedImage)
            return
        }
        
        if loadingResponses[url] != nil {
            loadingResponses[url]?.append(completion)
            return
        } else {
            loadingResponses[url] = [completion]
        }
        
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url as URL) { data, response, error in
                guard let data = data, let image = UIImage(data: data),
                      let blocks = self.loadingResponses[url], error == nil else {
                    completion(nil)
                    return
                }
                self.cachedImages.setObject(image, forKey: url, cost: data.count)
                
                blocks.forEach { block in
                    block(image)
                }
                self.loadingResponses.removeValue(forKey: url)
            }.resume()
        }
    }
}
