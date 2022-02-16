//
//  ViewController.swift
//  Ind02_Philip_Lijo
//
//  Created by Lijo Philip on 1/29/22.
//

import UIKit

class ViewController: UIViewController {
    
    // Storing tiles in an array
    var imageViews:[UIImageView] = []
    // Number of rows and columns can be customized
    var row:Int = 5
    var col:Int = 4
    // Initializing floating-point scalar
    var width: CGFloat!
    var height: CGFloat!
    // Timer to send an action to auto shuffle the puzzle
    var Timeauto: Timer!
    // Initilizing count var
    var count:Int = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        create_Puzzle()
    }
    
    
    
    // Shuffle puzzle on button tap
    @IBAction func shuffleButton(_ sender: Any) {
        autoShuffle()
    }
    
    
    
    // Firing timer to use Shuffle fucntion
    @objc func autoShuffle() {
        Timeauto = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(shuffle), userInfo: nil, repeats: true)
    }
    
    
    
    // Main shuffle functions
    @objc func shuffle() {
        // Keeps track of the number of tiles shuffled
        count += 1
        // shuffle tiles randomly 25 times
        if count >= 25 {
            // Stopping timer
            Timeauto.invalidate()
        }
        
        let move = width/CGFloat(col)
        var imageViewsGrid = imageViews
        
        // Moving tiles in the Grid at random
        while imageViewsGrid.count > 0 {
            let random = Int.random(in: 0...imageViewsGrid.count - 1)
            let image = imageViewsGrid[random]
            let x:CGFloat = image.frame.origin.x
            let y:CGFloat = image.frame.origin.y
            
            // Shuffles tiles left
            if checkMove(pos: CGPoint(x: x - move, y: y)) {
                UIView.animate(withDuration: 0.2) {
                    image.frame.origin.x -= move
                }
                return
            }
            
            // Shuffles tiles right
            if checkMove(pos: CGPoint(x: x + move, y: y)) {
                UIView.animate(withDuration: 0.2) {
                    image.frame.origin.x += move
                }
                return
            }
            
            // Shuffles tiles down
            if checkMove(pos: CGPoint(x: x, y: y + move)) {
                UIView.animate(withDuration: 0.2) {
                    image.frame.origin.y += move
                }
                return
            }
            
            // Shuffles tiles up
            if checkMove(pos: CGPoint(x: x, y: y - move)) {
                UIView.animate(withDuration: 0.2) {
                    image.frame.origin.y -= move
                }
                return
            }
            
            //Removes and returns the element at random
            imageViewsGrid.remove(at: random)

        }
    }
    
    
    
    // Function to create puzzle
    func create_Puzzle(){
        var count:Int = 0
        // Portion of the code was referenced and modified from https://shmoopi.net/tutorials/slider-puzzle-ios-game-tutorial-2/ (2/2/22)
        // confining image from assets to fit our grid frame
        let image = UIImage(named: "turing")!.resizeImage(imagesize: self.view.frame.width, row: CGFloat(row), col: CGFloat(col))
        width = image.size.width
        height = image.size.height
        let y = self.view.frame.height/2 - height/2
        let imageConvert = image.cgImage
        let sizeImage = width/CGFloat(col)
        
        // Splitting and cropping the images into rows and colums
        for i in 0...row - 1{
            for j in 0...col - 1{
                // Addding grid lines and positioning the grid frame with the image
                let cropImage = imageConvert!.cropping(to: CGRect(x: CGFloat(j)*sizeImage, y:CGFloat(i)*sizeImage, width: sizeImage, height: sizeImage))
                let imageView = UIImageView(image: UIImage(cgImage: cropImage!))
                imageView.layer.borderWidth = 1
                imageView.layer.borderColor = UIColor.black.cgColor
                imageView.frame.origin = CGPoint(x: CGFloat(j)*sizeImage, y: CGFloat(i)*sizeImage + y)
                view.addSubview(imageView)
                imageView.tag = count
                count += 1
                // Adding a tap functionality to the tiles in the view
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapImage(gesture:))))
                imageView.isUserInteractionEnabled = true
                imageViews.append(imageView)
            }
        }
        imageViews.last?.removeFromSuperview()
        imageViews.removeLast()
        
    }
    
    
    
    // Funtion to move tiles on tap within grid
    @objc func tapImage (gesture: UITapGestureRecognizer){
        let image = gesture.view as! UIImageView
        let x = image.frame.origin.x
        let y = image.frame.origin.y
        let move = width/CGFloat(col)
        print(image.tag)
        print(checkOut(pos: CGPoint(x: x, y: y - move)))
        
        // Tap to move tile left
        if checkMove(pos: CGPoint(x: x - move, y: y)) {
            UIView.animate(withDuration: 0.2) {
                image.frame.origin.x -= move
            }
            return
        }
        
        // Tap to move tile right
        if checkMove(pos: CGPoint(x: x + move, y: y)) {
            UIView.animate(withDuration: 0.2) {
                image.frame.origin.x += move
            }
            return
        }
        
        // Tap to move tile down
        if checkMove(pos: CGPoint(x: x, y: y + move)) {
            UIView.animate(withDuration: 0.2) {
                image.frame.origin.y += move
            }
            return
        }
        
        // Tap to move tile up
        if checkMove(pos: CGPoint(x: x, y: y - move)) {
            UIView.animate(withDuration: 0.2) {
                image.frame.origin.y -= move
            }
            return
        }
    }
    
    
    // Portion of the code was referenced https://www.geeksforgeeks.org/check-instance-15-puzzle-solvable/ (2/4/22)
    // Function to check the movement of the tiles within the grid
    func checkMove(pos:CGPoint) -> Bool {
        var count:[UIImageView] = []
        count = imageViews.filter{$0.frame.origin.x - pos.x > -1 && $0.frame.origin.x - pos.x < 1 && $0.frame.origin.y - pos.y > -1 && $0.frame.origin.y - pos.y < 1}
        if count == [] && checkOut(pos: pos) {
            return true
        }
        return false
    }
    
    
    // Portion of the code was referenced https://www.openbookproject.net/py4fun/tiles/tiles.html (2/4/22)
    // Function to check the position of the tile in the grid
    func checkOut(pos:CGPoint) -> Bool {
        let top:CGFloat = self.view.frame.height/2 - height/2 - 1
        let left:CGFloat = -1
        let right:CGFloat = width - width/CGFloat(col) + 1
        let bottom:CGFloat = self.view.frame.height/2 + height/2 - width/CGFloat(col) + 1
        if pos.x < left || pos.x > right || pos.y < top || pos.y > bottom{
            return false
        }
        return true
    }
    

}



// Managing the image in the UIView to fit the constraints of the frame
extension UIImage{
    // Resizing the puzzle image keeping aspect ratio
    func resizeImage(imagesize:CGFloat,row:CGFloat,col:CGFloat) -> UIImage {
        let newSize = CGSize(width: imagesize, height:imagesize + (row - col)*imagesize/col)
        let rect = CGRect(x:0, y:0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1)
        // Draws the entire image in the specified rectangle
        self.draw(in:rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
   
}

