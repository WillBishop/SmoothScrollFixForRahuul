//
//  CapturePicture.swift
//  ClassRoom Attendance
//
//  Created by Rahul Roy on 13/05/22.
//

import UIKit

class CapturePictureView: UIViewController {
    
    @IBOutlet var displayCapturedImage: UIImageView!
    @IBOutlet var finderText: UILabel!
    @IBOutlet var captureScanButton: UIButton!
    
    var faceIDArray: [String] = []
    var imageFinder: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayCapturedImage.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    @IBAction func imageCaptureButton(_ sender: UIButton) {
        if captureScanButton.titleLabel?.text == "Capture"
        {
            DispatchQueue.main.async
            { [unowned self] in
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                present(picker, animated: true)
            }
        }
        else
        {
            var studentFaceDic: [String: Student] = [:]
            let students = currentSection.students //Gives data of all students
                for student in students
                {
                    guard let image = UIImage(data:student.image! as Data) else
                    {
                        return
                    }
                    
                    //Compress Normal
    //                let data = NSData(data: image.jpegData(compressionQuality: 0.0)!)
                    //Compress Baap
                    let data = image.compress(to: 200)
                    //No Compress
    //                let data = NSData(data: image.jpegData(compressionQuality: 1.0)!)
    //                let data = NSData(data: img!.jpegData(compressionQuality: 1.0)!)
                    
                    if let faceId = AzureFaceRecognition.shared.syncDetectFaceIds(imageData: data as Data).first
                    {
                     
                        
                        studentFaceDic[faceId] = student
                        
                        
                        self.faceIDArray.append(faceId)
                    }
                }
                let dataOfFinder = self.imageFinder!.compress(to: 200)
                guard let faceIdOfFinder = AzureFaceRecognition.shared.syncDetectFaceIds(imageData: dataOfFinder as Data).first else
                {
                    return
                }
                AzureFaceRecognition.shared.findSimilars(faceId: faceIdOfFinder, faceIds: self.faceIDArray) { (faceIds) in
                    if faceIds.isEmpty
                    {
                        DispatchQueue.main.async
                        { [unowned self] in
                            self.view.backgroundColor = .red
                        }
                    }
                    else
                    {
                        
//                        self.imageView.image = UIImage(data:studentFaceDic[faceIds.first!]!.image! as Data)
//                        currentSection.students
                        studentFaceDic[faceIds.first!]!.isPresent = true
                        DispatchQueue.main.async
                        { [unowned self] in
                            self.view.backgroundColor = .green
                        }
//                        self.numberOfFaces.text = String(faceIds.count)
                    }
                    
                }
            captureScanButton.setTitle("Capture", for: .normal)
        }
    }
}

extension CapturePictureView: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else
        {
            return
        }
        self.finderText.text = ""
        displayCapturedImage.image = image
        captureScanButton.setTitle("Scan", for: .normal)
        imageFinder = image
    }
}


extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}
