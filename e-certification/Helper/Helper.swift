//
//  Helper.swift
//  MTG
//
//  Created by Syarif on 6/6/17.
//  Copyright © 2017 Pistarlabs. All rights reserved.
//

import Foundation
import UIKit
import MKSpinner
import SwiftMessages
import Arrow

class Helper {
    
    //Screen size
    let screenSize: CGRect = UIScreen.main.bounds
    
    func screenScaleWidth() -> CGFloat {
        //base screen iphone 6
        let baseScreeenwidth:CGFloat = 375
        return abs(CGFloat(self.getScreenWidth() / baseScreeenwidth))
    }
    
    func screenScaleHeight() -> CGFloat {
        //base screen iphone 6
        let baseScreeenHeight:CGFloat = 667
        return abs(CGFloat(self.getScreenWidth() / baseScreeenHeight))
    }
    
    func getScreenHeight() -> CGFloat{
        return screenSize.height
    }
    
    func getScreenWidth() -> CGFloat{
        return screenSize.width
    }
    
    func isSmallScreenWidth() -> Bool{
        return screenSize.width <= 320
    }
    
    func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    func getVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "Version \(version) - Build Version \(build)"
    }
}

class FileHelper {
    func getNameFromUrl(url:String) -> String {
        let fullNameArr = url.components(separatedBy: "/")
        return fullNameArr.last!
    }
    
//    func isFileExist(name:String)->Bool{
//        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
//        let url = NSURL(fileURLWithPath: path)
//        if let pathComponent = url.appendingPathComponent("\(name)") {
//            let filePath = pathComponent.path
//            print("filePath \(filePath)")
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: filePath) {
//                print("FILE AVAILABLE")
//                return true
//            } else {
//                print("FILE NOT AVAILABLE")
//                return false
//            }
//        } else {
//            print("FILE PATH NOT AVAILABLE")
//            return false
//        }
//    }
    func isFileExist(name:String)->Bool{
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        let url = NSURL(fileURLWithPath: path)
        if let pathComponent = url.appendingPathComponent("Digger/\(name)") {
            let filePath = pathComponent.path
//            print("filePath \(filePath)")
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: filePath) {
//                print("FILE AVAILABLE")
                return true
            } else {
//                print("FILE NOT AVAILABLE")
                return false
            }
        } else {
//            print("FILE PATH NOT AVAILABLE")
            return false
        }
    }
    
    func getFilePath(name:String)->String{
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        let url = NSURL(fileURLWithPath: path)
        let pathComponent = url.appendingPathComponent("Digger/\(name)")
        let filePath = pathComponent?.path
        return filePath!
    }
}

class HUD: NSObject {
    
    // MARK: Show HUD
    func show() {
        _ = MKNSpinner.show("Loading..", animated: true)
    }
    
    // MARK: Hide HUD
    func hide() {
        MKNSpinner.hide()
    }
}

class CustomAlert: NSObject {
    
    // MARK: Show HUD
    func Success(message:String) {
        let view: AlertDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.bodyLabel?.text = message
        view.lblColorMessage.backgroundColor = Theme.successColor
        view.imgAlert.image = UIImage(named: "ico-success")
        let path = UIBezierPath(roundedRect:view.lblColorMessage.bounds,
                                byRoundingCorners:[.topLeft,.bottomLeft],
                                cornerRadii: CGSize(width: 5, height:  5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.lblColorMessage.layer.mask = maskLayer
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .automatic
        config.duration = .automatic
        config.presentationStyle = .bottom
        config.dimMode = .none
        SwiftMessages.show(config: config, view: view)
    }
    
    // MARK: Show HUD
    func Error(message:String) {
        let view: AlertDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        view.bodyLabel?.text = message
        view.lblColorMessage.backgroundColor = Theme.errorColor
        let path = UIBezierPath(roundedRect:view.lblColorMessage.bounds,
                                byRoundingCorners:[.topLeft,.bottomLeft],
                                cornerRadii: CGSize(width: 5, height:  5))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        view.lblColorMessage.layer.mask = maskLayer
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .automatic
        config.duration = .automatic
        config.presentationStyle = .bottom
        config.dimMode = .none
        SwiftMessages.show(config: config, view: view)
    }
}

extension Date {
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        
        let currentCalendar = Calendar.current
        
        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }
        
        return end - start
    }
    
    func timeElapsed(_ dateNow: Date) -> String {
        
        let date1:Date = self
        let date2: Date = dateNow // Same you did before with timeNow variable
        
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
//        print(components)
        var returnString:String = "Just now"
        
        //        print(components.second!)
//        print("components.day \(components.day!)")
        if components.minute! > 1{
            returnString = String(describing: components.minute!) + " mins ago"
        }else if components.minute! == 1 {
            returnString = "A minute ago"
        }
        
        if components.hour! > 1{
            returnString = String(describing: components.hour!) + " hours ago"
        }else if components.hour == 1 {
            returnString = "An hour ago"
        }
        
        if components.day! >= 1{
            returnString = "ShowDate"
        }
        
        //        else if components.day! == 1 {
        //
        //            returnString = "Yesterday"
        //        }
        
//        if components.month! > 1{
//            returnString = String(describing: components.month!)+" months ago"
//        }
//        else if components.month! == 1 {
//            
//            returnString = "A month ago"
//        }
//        
//        if components.year! > 1 {
//            returnString = String(describing: components.year!)+" years ago"
//        }
//        else if components.year! == 1 {
//            
//            returnString = "A year ago"
//        }
        
        return returnString
    }
    
    func dayTimeDifference(_ dateNow: Date) -> String {
        
        let date1:Date = self
        let date2: Date = dateNow // Same you did before with timeNow variable
        
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date1, to: date2)
//        print(components)
        var returnString:String = ""
        
//        print("components.day \(components.day!)")
        if components.minute! >= 1{
            returnString = String(describing: components.minute!) + "m"
        }
        
        if components.hour! >= 1{
            returnString = String(describing: components.hour!) + "h"
        }
        
        if components.day! >= 1{
            returnString = String(describing: components.day!) + "d"
        }
        
        return returnString
    }
    
    func dayDifference(_ dateNow: Date) -> Int {
        let date1:Date = self
        let date2: Date = dateNow // Same you did before with timeNow variable
        
        let calender:Calendar = Calendar.current
        let components: DateComponents = calender.dateComponents([.day], from: date1, to: date2)
        return components.day!
    }
}

extension UIView {
    func applyGradient(_ colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        //        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        //        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        //        gradient.locations = [0.0, 0.2, 0.3, 0.7, 0.8, 1.0]
        //        self.layer.insertSublayer(gradient, at: 0)
        
        gradient.locations = [0.0, 0.75, 0.75, 1.0]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyBorderGradient(_ colours:[UIColor]) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = colours.map { $0.cgColor }
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(rect: self.bounds).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
    
    func applyBorderGradient(_ colours:[UIColor],cornerRadius:Float) -> Void {
        
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        
        let gradient = CAGradientLayer()
        gradient.frame =  self.bounds
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = colours.map { $0.cgColor }
        
        let shape = CAShapeLayer()
        shape.lineWidth = 2
        shape.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: CGFloat(cornerRadius)).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        
        self.layer.addSublayer(gradient)
    }
    
    func applyGradient(_ colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow(scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = Theme.secondaryColor.cgColor
        self.layer.shadowOpacity = 0.3
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 10
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(scale: Bool = true , radius:Int) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = Theme.secondaryColor.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = CGFloat(radius)
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func difuseShadow(scale: Bool = true) {
        let radius: CGFloat = self.frame.height / 2.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = Theme.secondaryColor.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0.5, height: 0.4)  //Here you control x and y
        self.layer.shadowRadius = 10.0 //Here your control your blur
        self.layer.cornerRadius = 8.0
        
        self.layer.shadowPath = UIBezierPath(rect: CGRect(x: 10, y: 10, width: self.frame.width - 20, height: 2.009 * radius)).cgPath
        //Change 2.1 to amount of spread you need and for height replace the code for height
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension String
{
    func toDate() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Parse into NSDate
        let date = dateFormatter.date(from:self)
        
        //Return Parsed Date
        return date!
    }
    
    func toDateActivity() -> Date
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //Parse into NSDate
        let date = dateFormatter.date(from:self)
        
        //Return Parsed Date
        return date!
    }
    
    func toStringDateTime() -> String {
        
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        //Parse into NSDate
        let date = self.toDate()
        
        // Return String
        return dateFormatter.string(from: date)
    }
    
    func toStringDate() -> String {
        
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        //Parse into NSDate
        let date = self.toDateActivity()
        
        // Return String
        return dateFormatter.string(from: date)
    }
    
    func toQuestPointHistoryDateFormat() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //Parse into NSDate
        let date = dateFormatter.date(from:self)
        
        dateFormatter.dateFormat = "dd MMM"
        
        let newDate = dateFormatter.string(from: date!)
        
        //Return Parsed Date
        return newDate
    }
    
    func toQuestDateFormat() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        //Parse into NSDate
        let date = dateFormatter.date(from:self)
        
        dateFormatter.dateFormat = "dd MMM"
        
        let newDate = dateFormatter.string(from: date!)
        
        //Return Parsed Date
        return newDate
    }
    
    func toQuestCompleteDateFormat() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //Parse into NSDate
        let date = dateFormatter.date(from:self)
        
        dateFormatter.dateFormat = "dd MMMM"
        
        let newDate = dateFormatter.string(from: date!)
        
        //Return Parsed Date
        return newDate
    }
    
    func getYear() -> String {
        
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "yyyy"
        
        //Parse into NSDate
        let date = self.toDate()
        
        // Return String
        return dateFormatter.string(from: date)
    }
    
    func atTime() -> String
    {
        //Create Date Formatter
        let dateFormatter = DateFormatter()
        
        //Specify Format of String to Parse
        dateFormatter.dateFormat = "HH:mm:ss"
        
        //Parse into NSDate
        let date = dateFormatter.date(from:self)
        
        dateFormatter.dateFormat = "HH:mm"
        
        let newDate = dateFormatter.string(from: date!)
        
        //Return Parsed Date
        return newDate
    }
    
    func isUrl () -> Bool {
        // create NSURL instance
        if let url = URL(string: self) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
    
    func getYoutubeId() -> String{
        return (URLComponents(string: self)?.queryItems?.first(where: { $0.name == "v" })?.value)!
    }
    
    func stripHTML() -> String {
        let a = self.replacingOccurrences(of: "<[^>]+>", with: "", options:.regularExpression , range: nil)
        let b = a.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return b
    }
}

extension String {
//    var html2AttributedString: NSAttributedString? {
//        do {
//            return try NSAttributedString(data: Data(utf8), options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            print(error)
//            return nil
//        }
//    }
//    
//    var html2String: String {
//        return html2AttributedString?.string ?? ""
//    }
    
    public func capitalLetters() -> [Character] {
        return self.characters.filter { ("A"..."Z").contains($0) }
    }
    
    public func getAcronyms(separator: String = "") -> String
    {
        let acronyms = self.components(separatedBy: " ").map({ String($0.characters.first!) }).joined(separator: separator);
        return acronyms;
    }
    
    public func isValidEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

//extension String {
//    func nsRange(from range: Range<String.Index>) -> NSRange {
//        let from = range.lowerBound.samePosition(in: utf16)
//        let to = range.upperBound.samePosition(in: utf16)
//        return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
//                       length: utf16.distance(from: from, to: to))
//    }
//}

extension String {
    func range(from nsRange: NSRange) -> Range<String.Index>? {
        guard
            let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self)
            else { return nil }
        return from ..< to
    }
}

extension UIPageViewController {
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for subV in self.view.subviews {
            if type(of: subV).description() == "UIPageControl" {
                let pos = CGPoint(x: 0, y: subV.frame.origin.y)
                subV.frame = CGRect(origin: pos, size: subV.frame.size)
            }
        }
    }
}

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension UIImage{
    
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    //UIImage Rotation
    public func imageRotatedByDegrees(_ degrees: CGFloat, flip: Bool) -> UIImage {
        //        let radiansToDegrees: (CGFloat) -> CGFloat = {
        //            return $0 * (180.0 / CGFloat(M_PI))
        //        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * .pi
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPoint.zero, size: size))
        let t = CGAffineTransform(rotationAngle: degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap!.translateBy(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        bitmap!.rotate(by: degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        bitmap!.scaleBy(x: yFlip, y: -1.0)
        bitmap!.draw(cgImage!, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func convertToGrayScale() -> UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectTonal")
        currentFilter!.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter!.outputImage
        let cgimg = context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
}

extension UILabel {
    func setLineHeight(lineHeight: CGFloat = 1.3) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.2
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        let attrString = NSMutableAttributedString(string: self.text!)
        attrString.addAttribute(NSAttributedStringKey.font, value: self.font, range: NSMakeRange(0, attrString.length))
        attrString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
}

extension UIApplication {
    
    class func openAppSettings() {
        UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}

extension String {
    
    //Enables replacement of the character at a specified position within a string
    func replace(_ index: Int, _ newChar: Character) -> String {
        var chars = Array(characters)
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
}

extension Array {
    
    /**
     * Shuffles the elements in the Array in-place using the
     * [Fisher-Yates shuffle](https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle).
     */
    mutating func shuffle() {
        guard self.count >= 1 else { return }
        
        for i in (1..<self.count).reversed() {
            let j = (0...i).sample!
            self.swapAt(j, i)
        }
    }
    
    /**
     * Returns a new Array with the elements in random order.
     */
    var shuffled : [Element] {
        var elements = self
        elements.shuffle()
        return elements
    }
    
}

import Darwin

extension Collection {
    
    /**
     * Returns a random element of the Array or nil if the Array is empty.
     */
    var sample : Element? {
        guard !isEmpty else { return nil }
        let offset = arc4random_uniform(numericCast(self.count))
        let idx = self.index(self.startIndex, offsetBy: numericCast(offset))
        return self[idx]
    }
    
    /**
     * Returns `count` random elements from the array.
     * If there are not enough elements in the Array, a smaller Array is returned.
     * Elements will not be returned twice except when there are duplicate elements in the original Array.
     */
    func sample(_ count : UInt) -> [Element] {
        let sampleCount = Swift.min(numericCast(count), self.count)
        
        var elements = Array(self)
        var samples : [Element] = []
        
        while samples.count < sampleCount {
            let idx = (0..<elements.count).sample!
            samples.append(elements.remove(at: idx))
        }
        
        return samples
    }
    
}
