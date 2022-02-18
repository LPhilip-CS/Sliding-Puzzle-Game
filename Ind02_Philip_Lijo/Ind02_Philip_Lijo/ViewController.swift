//
//  ViewController.swift
//  Ind02_Philip_Lijo
//
//  Created by Lijo Philip on 1/29/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Global Variables
    
    // Storing image tiles in an array
    var imageGrid:[UIImageView] = []
    // Number of rows and columns (4x5) - *can be customized
    var column:Int = 4
    var row:Int = 5
    // Initializing floating-point scalar
    var width: CGFloat!
    var height: CGFloat!
    // Timer to send an action to auto shuffle the puzzle
    var timer: Timer!
    // Initilizing count var
    var count:Int = 0
    
    
    
    // Override function
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        buildPuzzle()
    }
    
    
    
    // MARK: - Shuffle Tiles
    
    // Portion of the code was referenced and modified from https://shmoopi.net/tutorials/slider-puzzle-ios-game-tutorial-2/ (2/2/22)
    // Main shuffle functions
    @objc func shuffle() {
        // Keeps track of the number of tiles shuffled
        count += 1
        // shuffle tiles randomly 25 times
        if count >= 25 {
            // Stopping timer
            timer.invalidate()
        }
        
        let move = width/CGFloat(column)
        var imageViewsGrid = imageGrid
        
        // Moving tiles in the Grid at random
        while imageViewsGrid.count > 0 {
            let random = Int.random(in: 0...imageViewsGrid.count - 1)
            let image = imageViewsGrid[random]
            let x:CGFloat = image.frame.origin.x
            let y:CGFloat = image.frame.origin.y
            
            // Shuffles tiles left
            if viewMove(pos: CGPoint(x: x - move, y: y)) {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.x -= move
                }
                return
            }
            
            // Shuffles tiles right
            if viewMove(pos: CGPoint(x: x + move, y: y)) {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.x += move
                }
                return
            }
            
            // Shuffles tiles down
            if viewMove(pos: CGPoint(x: x, y: y + move)) {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.y += move
                }
                return
            }
            
            // Shuffles tiles up
            if viewMove(pos: CGPoint(x: x, y: y - move)) {
                UIView.animate(withDuration: 0.3) {
                    image.frame.origin.y -= move
                }
                return
            }
            
            //Removes and returns the element at random
            imageViewsGrid.remove(at: random)

        }
    }
    
    
    // Firing timer to use Shuffle fucntion
    @objc func autoShuffle() {
        timer = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(shuffle), userInfo: nil, repeats: true)
    }
    
    
    // Shuffle puzzle on button tap
    @IBAction func shuffleButton(_ sender: Any) {
        autoShuffle()
    }
    
    
    
    // MARK: - Build Puzzle
    
    // Function to create puzzle
    func buildPuzzle(){
        var count:Int = 0
        // confining image from assets to fit our grid frame
        let image = UIImage(named: "turing")!.resizeImage(imagesize: self.view.frame.width, row: CGFloat(row), col: CGFloat(column))
        width = image.size.width
        height = image.size.height
        let y = self.view.frame.height/2 - height/2
        let convertImage = image.cgImage
        let sizeImage = width/CGFloat(column)
        // Splitting and cropping the images into rows and colums
        for i in 0...row - 1{
            for j in 0...column - 1{
                // Addding grid lines and positioning the grid frame with the image
                let cropImage = convertImage!.cropping(to: CGRect(x: CGFloat(j)*sizeImage, y:CGFloat(i)*sizeImage, width: sizeImage, height: sizeImage))
                let imageView = UIImageView(image: UIImage(cgImage: cropImage!))
                imageView.layer.borderWidth = 1
                imageView.layer.borderColor = UIColor.black.cgColor
                imageView.frame.origin = CGPoint(x: CGFloat(j)*sizeImage, y: CGFloat(i)*sizeImage + y)
                view.addSubview(imageView)
                imageView.tag = count
                count += 1
                // Adding a tap functionality to the tiles in the view
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
                imageView.isUserInteractionEnabled = true
                imageGrid.append(imageView)
            }
        }
        
        imageGrid.last?.removeFromSuperview()
        imageGrid.removeLast()
        
    }

    
    
    // MARK: - Move Tiles
    
    // Funtion to move tiles on tap within grid
    @objc func imageTapped (gesture: UITapGestureRecognizer){
        let image = gesture.view as! UIImageView
        let x = image.frame.origin.x
        let y = image.frame.origin.y
        let move = width/CGFloat(column)
        
        print(image.tag)
        print(viewPosition(pos: CGPoint(x: x, y: y - move)))
        // Tap to move tile left
        if viewMove(pos: CGPoint(x: x - move, y: y)) {
            UIView.animate(withDuration: 0.3) {
                image.frame.origin.x -= move
            }
            return
        }
        
        // Tap to move tile right
        if viewMove(pos: CGPoint(x: x + move, y: y)) {
            UIView.animate(withDuration: 0.3) {
                image.frame.origin.x += move
            }
            return
        }
        
        // Tap to move tile down
        if viewMove(pos: CGPoint(x: x, y: y + move)) {
            UIView.animate(withDuration: 0.3) {
                image.frame.origin.y += move
            }
            return
        }
        
        // Tap to move tile up
        if viewMove(pos: CGPoint(x: x, y: y - move)) {
            UIView.animate(withDuration: 0.3) {
                image.frame.origin.y -= move
            }
            return
        }
    }
    
    
    
    // MARK: - View Moves & Positions
    
    // Portion of the code was referenced and modified from https://www.geeksforgeeks.org/check-instance-15-puzzle-solvable/ (2/4/22)
    // Function to check the position of the tile in the grid
    func viewPosition(pos:CGPoint) -> Bool {
        let left:CGFloat = -1
        let right:CGFloat = width - width/CGFloat(column) + 1
        let down:CGFloat = self.view.frame.height/2 + height/2 - width/CGFloat(column) + 1
        let up:CGFloat = self.view.frame.height/2 - height/2 - 1
        
        if pos.x < left || pos.x > right || pos.y < up || pos.y > down{
            return false
        }
        return true
    }
    
    
    // Portion of the code was referenced and modified from https://www.geeksforgeeks.org/check-instance-15-puzzle-solvable/ (2/4/22)
    // Function to check the movement of the tiles within the grid
    func viewMove(pos:CGPoint) -> Bool {
        var count:[UIImageView] = []
        count = imageGrid.filter{$0.frame.origin.x - pos.x > -1 && $0.frame.origin.x - pos.x < 1 && $0.frame.origin.y - pos.y > -1 && $0.frame.origin.y - pos.y < 1}
        
        if count == [] && viewPosition(pos: pos) {
            return true
        }
        return false
    }
    
}



// MARK: - UIImage

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

