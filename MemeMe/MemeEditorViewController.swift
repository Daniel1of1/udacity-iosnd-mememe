//
//  ViewController.swift
//  MemeMe
//
//  Created by Daniel Haight on 09/08/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    open override var prefersStatusBarHidden: Bool {
        return true
    }
}

class MemeEditorViewController: UIViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    var selectedImage: UIImage? = nil
    var memes: [Meme] = []
    
    //MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dismissRecogniser = UITapGestureRecognizer(target: self.view, action:#selector(UIView.endEditing(_:)))
        dismissRecogniser.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissRecogniser)

        setup(textField:self.topTextField, text:"TOP")
        setup(textField:self.bottomTextField, text:"BOTTOM")

        self.configureUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        unSubscribeToKeyboardNotifications()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: UI

    func setToolbars(hidden:Bool) {
        self.topToolbar.isHidden = hidden
        self.bottomToolbar.isHidden = hidden
    }

    func setup(textField: UITextField, text: String) {

        textField.defaultTextAttributes = MemeTextAttributes.defaultAttritubes
        textField.text = text

    }
    
    func configureUI() {
        self.imageView.image = selectedImage
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = (imageView.image != nil)
    }
    
    
    //MARK: IBActions

    
    @IBAction func share(_ sender: Any) {
        let memedImage = generateMeme()
        let activityController = UIActivityViewController(activityItems: [memedImage as Any], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = { _, _, _, _ in
            self.save(memedImage:memedImage)
        }
        
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.selectedImage = nil
        self.view.endEditing(false)
        self.configureUI()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        showImagePicker(sourceType: .camera)
    }
    
    @IBAction func openAlbum(_ sender: Any) {
        showImagePicker(sourceType: .photoLibrary)
    }

    //MARK: UIImagePickerControllerPresentation

    func showImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = sourceType
        imagePickerVC.delegate = self
        self.present(imagePickerVC, animated: true, completion: nil)
    }


    //MARK: UIKeyboard Handling
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unSubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:NSNotification) {
        
        if self.bottomTextField.isFirstResponder {
            view.frame.origin.y -= keyboardHeight(from: notification)
        }
    }

    @objc func keyboardWillHide(_ notification:NSNotification) {
        view.frame.origin.y = 0
    }
    
    func keyboardHeight(from notification: NSNotification) -> CGFloat {
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let height = rect.cgRectValue.height
        
        return height

    }
    
    //MARK: Meme Generation
    
    func generateMeme() -> UIImage {
        setToolbars(hidden: true)
        let image = drawViewInImage()
        setToolbars(hidden: false)

        return image
        
    }

    func drawViewInImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }


    //MARK: Meme Saving

    func save(memedImage: UIImage) {
        guard
            let topText = topTextField.text,
            let bottomText = bottomTextField.text,
            let image = selectedImage
            else {
            return
        }

        let meme = Meme(
            topText: topText,
            bottomText: bottomText,
            originalImage: image,
            memedImage: memedImage
        )
        
        appDelegate.memes.append(meme)
        self.dismiss(animated: true, completion: nil)

    }
    
}

//MARK: UIImagePickerControllerDelegate

extension MemeEditorViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.selectedImage = image
        self.configureUI()
        self.dismiss(animated: true, completion: nil)
    }

}

//MARK: UITextFieldDelegate

extension MemeEditorViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.configureUI()
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
