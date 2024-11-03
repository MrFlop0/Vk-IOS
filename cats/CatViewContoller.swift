//
//  CatViewContoller.swift
//  cats
//
//  Created by Aleksandr Kaplenkov on 03.11.2024.
//

import UIKit

class CatViewContoller: UIViewController {

    @IBOutlet weak var catImageHolder: UIImageView!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()

        statusLabel.text = "Ready to download"
        activityIndicator.hidesWhenStopped = true
        
    }
    
    
    @IBAction func onClick(_ sender: Any) {
        generateButton.isEnabled = false
        activityIndicator.startAnimating()
        statusLabel.text = "Downloading..."
        downloadCat()
    }
    
    private func downloadCat() {
        guard let url = URL(string: "https://cataas.com/cat") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                self.onDowloaded("Download failed, please try again")
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.catImageHolder.image = UIImage(data: data)
                self?.onDowloaded("Downloaded successfully")
            }
        }
        
        task.resume()
    }
    
    private func onDowloaded(_ statusText: String) {
        DispatchQueue.main.async { [weak self] in
            self?.statusLabel.text = statusText
            self?.activityIndicator.stopAnimating()
            self?.generateButton.isEnabled = true
        }
    }
    
}
