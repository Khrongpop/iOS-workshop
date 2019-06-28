//
//  CreateController.swift
//  iOS-workshop
//
//  Created by Muang on 27/6/2562 BE.
//  Copyright © 2562 ict. All rights reserved.
//

import UIKit

class CreateController: UIViewController {
    
    @IBOutlet weak var titleTextfiled: UITextField!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var articleImageView: UIImageView!
    
    fileprivate var article: Article? = nil
    private var isUpdate: Bool = false
    private var updateImage: Bool = false
    private var ArticleDetailVC: ArticleDetailController? = nil
    
     private let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let article = self.article {
            setupView(article: article)
        }
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSubmit() {
        guard let title = titleTextfiled.text,
            let detail = detailTextView.text  else { return }
        
        var parms: [String: Any] = [
            "title" : title,
            "detail" : detail
        ]
        
        if isUpdate {
            parms["id"] =  article?.id
            ArticleDetailVC?.article?.title = title
            ArticleDetailVC?.article?.detail = detail
            if updateImage ,let image = articleImageView.image {
                
                ArticleService.updateArticle(withImage: image, parameters: parms) { (message,image) in
                    self.ArticleDetailVC?.article?.image = image
                    
                    let  alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                ArticleService.updateArticle(parameters: parms) { (message) in
                    let  alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            }
           
            
        } else {
            
            if let image = articleImageView.image {
                // have image
                ArticleService.createArticle(withImage: image, parameters: parms) { (message) in
                    let  alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                // don't have image
                ArticleService.createArticle(parameters: parms) { (message) in
                    let  alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                    let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.navigationController?.popViewController(animated: true)
                    })
                    alert.addAction(done)
                    self.present(alert, animated: true, completion: nil)
                }
            }
           
            
        }
    }
    
    @IBAction func clickDelete() {
        let  alert = UIAlertController(title: "Do you want to delete ?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
     
        alert.addAction(cancel)
        
        let delete = UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            let parms: [String: Any] = [
                "id" : self.article?.id
            ]
            
            ArticleService.deleteArticle(parameters: parms) { (message) in
                
                let  alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
                let done = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.navigationController?.popToRootViewController(animated: true)
                })
                alert.addAction(done)
                self.present(alert, animated: true, completion: nil)
            }
            
            
        })
        
        delete.setValue(UIColor.red, forKey: "titleTextColor")
        alert.addAction(delete)
        
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func initArticle(article: Article ,vc: ArticleDetailController?) {
        self.article = article
        if let vc = vc {
            self.ArticleDetailVC = vc
        }
    }
    func setupView(article: Article) {
        isUpdate = true
        submitButton.setTitle("Update", for: .normal)
        titleTextfiled.text = article.title
        detailTextView.text = article.detail
        deleteButton.isHidden = false
        
        if let image = article.image {
            articleImageView.kf.setImage(with: URL(string: UrlHelper.baseURL+image))
        }
    }
    

}
extension CreateController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func chooseImageAvatar() {
        
        let  alert = UIAlertController(title: "Select your options", message: nil, preferredStyle: .actionSheet)
        
        // Create action button
        let photolibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            self.openPhotoLibrary()
        }
        let CameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            self.openCamera()
        }
        
        alert.addAction(photolibraryAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) { //ตรวจว่าดีไวซ์ มี camera หรือเปล่า
            alert.addAction(CameraAction)
        }
        
        // Cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { 
        
        guard  (info[.originalImage] as? UIImage) != nil else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        let selectedImage = info[.originalImage] as! UIImage
        articleImageView.image = selectedImage
        updateImage = true
        dismiss(animated: true, completion: nil)
    }
    
    private func openPhotoLibrary() {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary //แหล่งข้อมูล
        picker.mediaTypes =  UIImagePickerController.availableMediaTypes(for: .photoLibrary)! // media อะไรบ้างที่รองรับ  รองรับทั้งหมดที่photolibraryรองรับได้
        self.present(picker, animated: true, completion: nil)
    }
    
    private func openCamera() {
        picker.allowsEditing = false
        picker.sourceType = .camera //แหล่งข้อมูล
        picker.mediaTypes =  UIImagePickerController.availableMediaTypes(for: .camera)! // media อะไรบ้างที่รองรับ  รองรับทั้งหมดที่photolibraryรองรับได้
        self.present(picker, animated: true, completion: nil)
    }
    
}
