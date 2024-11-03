//
//  TextedCatViewController.swift
//  cats
//
//  Created by Aleksandr Kaplenkov on 03.11.2024.
//

import UIKit

class TextedCatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var catImageHolder: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            setupKeyboardObservers()
            setupGestureRecognizers()
        }
        
        private func setupUI() {
            statusLabel.text = "Ready to download"
            activityIndicator.hidesWhenStopped = true
            textField.delegate = self
        }
        
        private func setupKeyboardObservers() {
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        private func setupGestureRecognizers() {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleViewTap))
            view.addGestureRecognizer(tapRecognizer)
        }
        
        @objc private func handleKeyboardShow(notification: NSNotification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            scrollView.contentInset.bottom = keyboardFrame.height
        }
        
        @objc private func handleKeyboardHide(notification: NSNotification) {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            scrollView.contentInset.bottom = -keyboardFrame.height
        }
        
        @objc private func handleViewTap() {
            view.endEditing(true)
        }

        @IBAction private func onClick(_ sender: Any) {
            startImageDownload()
        }
        
        private func startImageDownload() {
            guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else {
                updateUIAfterDownload(statusText: "Please enter some text")
                return
            }
            
            toggleLoadingState(isLoading: true)
            statusLabel.text = "Downloading..."
            
            let urlString = "https://cataas.com/cat/says/\(text)?fontSize=50&fontColor=white"
            guard let url = URL(string: urlString) else {
                updateUIAfterDownload(statusText: "Invalid URL")
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                guard let data = data, error == nil else {
                    self.updateUIAfterDownload(statusText: "Download failed, please try again")
                    return
                }
                DispatchQueue.main.async {
                    self.catImageHolder.image = UIImage(data: data)
                    self.updateUIAfterDownload(statusText: "Downloaded successfully")
                }
            }.resume()
        }
        
        private func updateUIAfterDownload(statusText: String) {
            DispatchQueue.main.async { [weak self] in
                self?.statusLabel.text = statusText
                self?.toggleLoadingState(isLoading: false)
            }
        }
        
        private func toggleLoadingState(isLoading: Bool) {
            generateButton.isEnabled = !isLoading
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            view.endEditing(true)
            return true
        }

}
