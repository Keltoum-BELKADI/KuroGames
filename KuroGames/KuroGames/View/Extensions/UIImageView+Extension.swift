//
//  UIImageView+Extension.swift
//  MyGamesLibrary
//
//  Created by Kel_Jellysh on 14/02/2022.
//
import UIKit
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    //MARK: convert url to imageView and Cache Image
  func cacheImage(urlString: String){
    let url = URL(string: urlString)
    image = nil
    if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
        self.image = imageFromCache
        return
    }
      guard let urlImage = url else { return }
    URLSession.shared.dataTask(with: urlImage) {
        data, response, error in
        if data != nil {
              DispatchQueue.main.async {
                  guard let imageData = data else { return }
                  guard  let imageToCache = UIImage(data: imageData) else { return }
                  imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                  self.image = imageToCache
              }
          }
     }.resume()
  }
    
    //MARK: convert url to imageView
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleToFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix(""),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() {
                self?.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
