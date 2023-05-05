//
//  File.swift
//  
//
//  Created by Tan Vo on 04/05/2023.
//

import UIKit
import SwiftDate
import AVFoundation
import CoreLocation
import MobileCoreServices
import RxSwift
import RxCocoa
import Photos
import SwiftyAttributes

public extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var osVersion: String {
        return UIDevice.current.systemVersion
    }
}

public extension UIDevice {
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        return mapToDevice(identifier: identifier)
    }()
    
    var hasTopNotch: Bool {
        if #available(iOS 13.0,  *) {
            return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0 > 20
        }else{
         return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
    }
}

// MARK: - UIWindow
public extension UIWindow {
    var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
    }
    
    static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(pvc)
            } else {
                return vc
            }
        }
    }
}

public extension UINavigationController {
    func rootViewController() -> UIViewController? {
        return self.viewControllers.first
    }
}

// MARK: - UIViewController
public extension UIViewController {
    func addChild(viewController vc:UIViewController, inView contentView: UIView) {
        self.addChild(vc)
        contentView.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    
    func removeFromSuperViewController() {
        self.view.removeFromSuperview()
        self.removeFromParent()
        self.didMove(toParent: self.parent)
    }
}

// MARK: - UIView
public extension UIView {
    // Corner radius
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    // Border width
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // Border color
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    // Shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    // Shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    // Shadow Offset
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    // Shadow color
    @IBInspectable var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func origin() -> CGPoint {
        return self.frame.origin
    }
    
    func setOrigin(newOrigin:CGPoint) {
        var newFrame = self.frame
        newFrame.origin = newOrigin
        self.frame = newFrame
    }
    
    func size() -> CGSize {
        return self.frame.size
    }
    
    func setSize(newSize: CGSize) {
        var newFrame = self.frame
        newFrame.size = newSize
        self.frame = newFrame
    }
    
    func x() -> CGFloat {
        return self.frame.origin.x
    }
    
    func setX(newX:CGFloat) {
        var newFrame = self.frame
        newFrame.origin.x = newX
        self.frame = newFrame
    }
    
    func y() -> CGFloat {
        return self.frame.origin.y
    }
    
    func setY(newY: CGFloat) {
        var newFrame = self.frame
        newFrame.origin.y = newY
        self.frame = newFrame
    }
    
    func height() -> CGFloat {
        return self.frame.size.height
    }
    
    func setHeight(newHeight: CGFloat) {
        var newFrame = self.frame
        newFrame.size.height = newHeight
        self.frame = newFrame
    }
    
    func width() -> CGFloat {
        return self.frame.size.width
    }
    
    func setWidth(newWidth: CGFloat) {
        var newFrame = self.frame
        newFrame.size.width = newWidth
        self.frame = newFrame
    }
    
    func animateView(toFront subView: UIView, duration: TimeInterval = 0.2, completion: ((Bool) -> Void)? = nil) {
        subView.alpha = 0
        self.bringSubviewToFront(subView)
        UIView.animate(withDuration: duration, animations: {
            subView.alpha = 1
        }, completion: completion)
    }
    
    func animatedDisappear(duration: TimeInterval = 0.2, completion: ((Bool) -> Void)? = nil) {
        self.endEditing(true)
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { _ in
            self.superview?.sendSubviewToBack(self)
        }
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    static func viewFromNib() -> UIView {
        let nibName = self.description().components(separatedBy: ".").last! //Must get the last part of the description behind "." because description might return something like "myBundle.MyViewClass" can cause a crash
        let nib = UINib.init(nibName: nibName, bundle: Bundle(for: self))
        let objectsFromNib = nib.instantiate(withOwner: nil, options: nil)
        return objectsFromNib.first as! UIView
    }
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        self.layer.add(animation, forKey: nil)
    }
    
    func rotate(rotationAngle: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    func transform(to value: CGFloat) {
        self.transform = CGAffineTransform(rotationAngle: value)
    }
    
    func removeFromSuperview(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0.0
        }) { (_) in
            self.removeFromSuperview()
            completion?()
        }
    }
    
    func removeAllSubviews() {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
    }
}

public extension UITextField {
    @IBInspectable var placeholderOpacity: Float {
        get {
            return 0.5
        }
        set {
            if newValue > 0 {
                self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                                attributes: [
                                                                    NSAttributedString.Key.foregroundColor: self.textColor?.withAlphaComponent(CGFloat(newValue)) ?? .white, NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 14)])
            }
        }
    }
}

public extension UICollectionView {
    func centerVisibleIndex() -> IndexPath? {
        let visibleRect = CGRect(origin: self.contentOffset, size: self.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = self.indexPathForItem(at: visiblePoint)
        
        return visibleIndexPath
    }
}

public extension UIScrollView {
    func scrollToTop(withOffset offset: CGPoint = CGPoint(x: 0, y: 0), animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let sf = self else { return }
            sf.setContentOffset(CGPoint(x: -offset.x, y: offset.y), animated: animated)
        }
    }
    
    func scrollToBottom(withOffset offset: CGPoint = CGPoint(x: 0, y: 0), animated: Bool = true) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            guard let sf = self else { return }
            if sf.contentSize.height > sf.height()/2 {
                sf.setContentOffset(CGPoint(x: -offset.x, y: sf.contentSize.height - sf.height() + offset.y), animated: animated)
            }
        }
    }
}

public extension Bool {
    var toInt: Int {
        if self {
            return 1
        } else {
            return 0
        }
    }
}

public extension String {
    
    var validPostContent: String {
        var content = self
        let _ = content.trimmingCharacters(in: CharacterSet.newlines)
        while let rangeToReplace = content.range(of: "\n\n") {
            content.replaceSubrange(rangeToReplace, with: "\n")
        }
        return content
    }
    
    var extractLinks: [NSTextCheckingResult]? {
        let types: NSTextCheckingResult.CheckingType = .link
        let detector = try? NSDataDetector(types: types.rawValue)
        let matches = detector?.matches(in: self, options: .reportCompletion, range: NSMakeRange(0, self.count))
        return matches
    }
    
    func substring(_ from: Int) -> String {
        let str = self[(self.index(self.startIndex, offsetBy: from))...]
        return String(str)
    }
    
    func replace(string string1: String, by string2: String) -> String {
        return self.replacingOccurrences(of: string1, with: string2)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        let str = "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 14\">\(self)</span>"
        guard let data = str.data(using: .utf16) else { return NSAttributedString() }
        do {
            let att = try NSMutableAttributedString(data: data,
                                                    options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                              NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf16.rawValue],
                                                    documentAttributes: nil)
            return att
        } catch {
            log.error(error.localizedDescription)
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    var htmlApplyFont: String {
        let str = "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 40\">\(self)</span>"
        return str
    }
    
    func replaceBracket(by string: String) -> String {
        return self.replace(string: "{{}}", by: string)
    }
    
    func heightForHtmlString(labelWidth:CGFloat) -> CGFloat{
        let label:UILabel = UILabel.init(frame: .init(x: 0, y: 0, width: labelWidth, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16)
        label.attributedText = self.htmlToAttributedString
        label.sizeToFit()
        return label.frame.height
    }
}

public extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: font],
                                            context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [.font: font],
                                            context: nil)
        
        return ceil(boundingBox.width)
    }
}

public extension String {
    func toDouble() -> Double? {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = "."
        return numberFormatter.number(from: self)?.doubleValue
    }
    
    func toInt() -> Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    static func randomStringForID(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! }) + "\(Date().millisecondsSince1970)"
    }
    
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func currencyFormatString() -> String {
        let currencySymbol = Locale.current.groupingSeparator ?? "."
        let str = self.replace(string: currencySymbol, by: "").reversed()
        var result = ""
        for (index, char) in str.enumerated() {
            if (index > 0) && (index % 3 == 0) {
                result += currencySymbol
                result += String(char)
            } else {
                result += String(char)
            }
        }
        
        return String(result.reversed())
    }
    
    func uppercaseFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

public extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: CharacterSet.whitespaces).isEmpty
    }
}

public extension String {
    /// Creates a QR code for the current URL in the given color.
    func qrImage(using color: UIColor, logo: UIImage? = nil) -> UIImage? {

       guard let tintedQRImage = qrImage?.tinted(using: color) else {
          return nil
       }

       guard let logo = logo?.cgImage else {
          return UIImage(ciImage: tintedQRImage)
       }

       guard let final = tintedQRImage.combined(with: CIImage(cgImage: logo)) else {
         return UIImage(ciImage: tintedQRImage)
       }

     return UIImage(ciImage: final)
   }

   /// Returns a black and white QR code for this URL.
   var qrImage: CIImage? {
     guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
     let qrData = self.data(using: String.Encoding.ascii)
     qrFilter.setValue(qrData, forKey: "inputMessage")

     let qrTransform = CGAffineTransform(scaleX: 12, y: 12)
     return qrFilter.outputImage?.transformed(by: qrTransform)
   }
    
    func barCode() -> UIImage? {
        let data = self.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
}

public extension String {
    func width(font: UIFont) -> CGFloat {
        let fontAttributes = [kCTFontAttributeName: font]
        return (self as NSString).size(withAttributes: fontAttributes as [NSAttributedString.Key : Any]).width
    }
    
    func height(font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    var toBool: Bool {
        if self == "0" {
            return false
        } else {
            return true
        }
    }
    
    func isValidPassword() -> Bool {
        if self.count >= 6 {
            return true
        } else {
            return false
        }
    }
    
    func isValidEmailAddress() -> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = self as NSString
            let results = regex.matches(in: self, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
        } catch {
            returnValue = false
        }
        
        return  returnValue
    }
    
    func phoneFormat() -> String {
        if self.count >= 7 {
            var str = self
            str.insert(" ", at: str.index(str.startIndex, offsetBy: 3))
            str.insert(" ", at: str.index(str.startIndex, offsetBy: 7))
            return str
        } else {
            return self
        }
    }
    
    func isValidPhone() -> Bool {
        if self.hasSpecialCharacters(){
            return false
        }
        
        guard self.count == 10 || self.count == 9 else {
            return false
        }
        
        let charcterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
    
    func hasSpecialCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }

        } catch {
            debugPrint(error.localizedDescription)
            return false
        }

        return false
    }
    
    func duplicateWhiteSpace(_ spacing: Int) -> String{
        var str = ""
        for _ in 0...(spacing) {
            str += " "
        }
        return str
    }
}

public extension String {
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = ""
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
    
    func urls() -> [String] {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        var str = [String]()
        for match in matches {
            guard let range = Range(match.range, in: self) else { continue }
            str.append(String(self[range]))
        }
        
        return str
    }
    
    func isContainURL() -> Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
        
        for match in matches {
            if Range(match.range, in: self) != nil {
                return true
            }
        }
        
        return false
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
    
    func isUrl() -> Bool {
        if let url = NSURL(string: self) {
            return UIApplication.shared.canOpenURL(url as URL)
        }
        return false
    }
}

public extension UIImage {
    func resized(maxSize: CGFloat) -> UIImage? {
        let scale: CGFloat
        if size.width > size.height {
            scale = maxSize / size.width
        }
        else {
            scale = maxSize / size.height
        }
        
        let newWidth = size.width * scale
        let newHeight = size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func toData(compressionQuality: CGFloat = 1.0) -> Data? {
        return self.jpegData(compressionQuality: compressionQuality)
    }
    
    var ratio: CGFloat {
        return size.width / size.height
    }
    
    var ratioString: String {
        return "\(Int(size.width)):\(Int(size.height))"
    }
    
    func cropSquare() -> UIImage? {
        var point = CGPoint(x: 0, y: 0)
        let width = self.size.width
        let heigh = self.size.height
        let est = width - heigh
        if est > 0 {
            point = CGPoint(x: est / 2, y: 0)
        } else {
            point = CGPoint(x: 0, y: abs(est / 2))
        }
        let frame = CGRect(x: point.x, y: point.y, width: width, height: width)
        if let cgimage = self.cgImage?.cropping(to: frame) {
            return UIImage(cgImage: cgimage)
        } else {
            return nil
        }
    }
    
    func compressionQuality(imageLimitSize: Double = 1000000.0) -> Data? {
        var quality: CGFloat = 1.0
        var count = self.jpegData(compressionQuality: quality)?.sizeBytes() ?? 0
        while count > imageLimitSize, quality > 0 {
            quality -= 0.1
            autoreleasepool {
                count = self.jpegData(compressionQuality: quality)?.sizeBytes() ?? 0
            }
        }
        return self.jpegData(compressionQuality: quality)
    }
}

public extension UILabel {
    func setAttributedText(_ text: String?, font: UIFont?, color: UIColor? = nil, lineSpacing: CGFloat = 4) {
        let attributedString = NSMutableAttributedString(string: "\(text ?? "")")
        
        if let font = font {
            attributedString.addAttribute(.font, value: font, range: .init(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttribute(.font, value: self.font!, range: .init(location: 0, length: attributedString.length))
        }
        
        if let color = color {
            attributedString.addAttribute(.foregroundColor, value: color, range: .init(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttribute(.foregroundColor, value: self.textColor!, range: .init(location: 0, length: attributedString.length))
        }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    func setText(_ text: String? = nil, font: UIFont? = nil, color: UIColor? = nil) {
        self.text = text
        if let font = font {
            self.font = font
        }
        if let color = color {
            self.textColor = color
        }
    }
    
    func appendImage(image: UIImage?, spacing: Int? = 0) {
        // create an NSMutableAttributedString that we'll append everything to
        let fullString = NSMutableAttributedString(string: self.text ?? "")

        // create our NSTextAttachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image

        // wrap the attachment in its own attributed string so we can append it
        let imageString = NSAttributedString(attachment: imageAttachment)

        // add the NSTextAttachment wrapper to our full string, then add some more text.
        if let spacing = spacing{
            fullString.append(NSAttributedString(string: "".duplicateWhiteSpace(spacing)))
        }
        fullString.append(imageString)


        // draw the result in a label
        self.attributedText = fullString
    }
    
    func addTrailing(with trailingText: String, moreText: String, moreTextFont: UIFont, moreTextColor: UIColor) {
        if (self.text?.isEmpty ?? false){
            return
        }
        let readMoreText: String = trailingText + moreText

        let lengthForVisibleString: Int = self.vissibleTextLength
        let mutableString: String = self.text!
        let trimmedString: String? = (mutableString as NSString).replacingCharacters(in: NSRange(location: lengthForVisibleString, length: ((self.text?.count)! - lengthForVisibleString)), with: "")
        let readMoreLength: Int = (readMoreText.count)
        let trimmedForReadMore: String = (trimmedString! as NSString).replacingCharacters(in: NSRange(location: ((trimmedString?.count ?? 0) - readMoreLength), length: readMoreLength), with: "") + trailingText
        let answerAttributed = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font ?? .systemFont(ofSize: 14)])
        let readMoreAttributed = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont, NSAttributedString.Key.foregroundColor: moreTextColor])
        answerAttributed.append(readMoreAttributed)
        self.attributedText = answerAttributed
    }

    var vissibleTextLength: Int {
        let font: UIFont = self.font
        let mode: NSLineBreakMode = self.lineBreakMode
        let labelWidth: CGFloat = self.frame.size.width
        let labelHeight: CGFloat = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)

        let attributes: [AnyHashable: Any] = [NSAttributedString.Key.font: font]
        let attributedText = NSAttributedString(string: self.text!, attributes: attributes as? [NSAttributedString.Key : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)

        if boundingRect.size.height > labelHeight {
            var index: Int = 0
            var prev: Int = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == NSLineBreakMode.byCharWrapping {
                    index += 1
                } else {
                    index = (self.text! as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: self.text!.count - index - 1)).location
                }
            } while index != NSNotFound && index < self.text!.count && (self.text! as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as? [NSAttributedString.Key : Any], context: nil).size.height <= labelHeight
            return prev
        }
        return self.text!.count
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? .systemFont(ofSize: 14)], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    var isTruncated: Bool {
        guard let labelText = text else { return false }
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size

        return labelTextSize.height > bounds.size.height
    }
    
    func underline() {
        guard let text = self.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.textColor ?? .black, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.textColor ?? .black, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.attributedText = attributedString
    }
}

public extension UITextView {
    func estimateHeightOfComposingView() -> CGFloat{
        let fixedWidth = self.frame.size.width
        self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        return newSize.height <= 100 ? (newSize.height < 45 ? 45 : newSize.height) : 100
    }
    
    func setText(_ text: String?, font: UIFont?, color: UIColor? = nil) {
        self.text = text
        self.font = font
        self.textColor = color
    }
}

public extension UITextField {
    func setText(_ text: String?, placeholder: String?, font: UIFont?, color: UIColor? = nil) {
        self.text = text
        self.font = font
        self.placeholder = placeholder
        self.textColor = color
    }
    
    func setPlaceholderColor(color: UIColor? = nil) {
        if let color = color{
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "",
                                                            attributes: [NSAttributedString.Key.foregroundColor: color])
        }
    }
}

public extension UIButton {
    
    func setText(_ text: String?, font: UIFont?, color: UIColor? = nil, for state: UIButton.State = .normal) {
        if let font = font {
            self.titleLabel?.font = font
        }
        if let color = color {
            self.setTitleColor(color, for: state)
        }
        if let text = text {
            self.setTitle(text, for: state)
        }
    }
    
    func setAttributedText(_ text: String?, font: UIFont?, color: UIColor? = nil) {
        let attributedString = NSMutableAttributedString(string: "\(text ?? "")")
        
        if let font = font {
            attributedString.addAttribute(.font, value: font, range: .init(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttribute(.font, value: self.titleLabel?.font ?? UIFont.semibold(size: 14), range: .init(location: 0, length: attributedString.length))
        }
        
        if let color = color {
            attributedString.addAttribute(.foregroundColor, value: color, range: .init(location: 0, length: attributedString.length))
        } else {
            attributedString.addAttribute(.foregroundColor, value: self.titleLabel?.textColor ?? UIColor.black, range: .init(location: 0, length: attributedString.length))
        }
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

public extension UIImageView {
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
    func setImage(url: URL, placeHolder: UIImage?, completion: (() -> Void)? = nil) {
        self.image = placeHolder
        DispatchQueue.global(qos: .background).async {
            do {
                let imageData = try Data(contentsOf: url)
                self.image = UIImage(data: imageData)
                completion?()
            } catch {
                log.error(error.localizedDescription)
                completion?()
            }
        }
    }
    
    func setThumbnailVideo(url: URL) {
        do {
            let asset = AVURLAsset(url: url, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            self.image = UIImage(cgImage: cgImage)
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
    }
    
    func setImage(asset: PHAsset, completion: ((UIImage?) -> Void)? = nil) {
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        PHCachingImageManager().requestImage(for: asset,
                                             targetSize: .init(width: UIScreen.main.bounds.width,
                                                               height: UIScreen.main.bounds.width),
                                             contentMode: .aspectFill, options: options) { [weak self] (image, dict) in
            if let result = dict?["PHImageResultIsDegradedKey"] as? Int, result == 0 {
                DispatchQueue.main.async { [weak self] in
                    self?.image = image
                    completion?(image)
                }
            }
        }
    }
}

public extension Date {
    func toString(format: String) -> String {
        return self.toString(DateToStringStyles.custom(format))
    }
    
    func toStringDate(withFormat stringFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.autoupdatingCurrent
        formatter.dateFormat = stringFormat
        
        return formatter.string(from: self)
    }
    
    func durationString(to date: Date) -> String {
        let formatter = DateComponentsFormatter()
        if self + 1.days < date {
            formatter.allowedUnits = [.day, .hour]
        }else if self + 1.hours < date {
            formatter.allowedUnits = [.hour, .minute]
        } else if self + 1.minutes < date {
            formatter.allowedUnits = [.minute, .second]
        } else {
            formatter.allowedUnits = [.second]
        }
        formatter.unitsStyle = .full
        let formattedString = formatter.string(from: self, to: date) ?? ""
        return formattedString
    }
    
}

public extension Date {
    var millisecondsSince1970: Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

public extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}

public extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func roundToStar() -> Double {
        let divisor = pow(10.0, Double(1))
        let rounded = (self * divisor).rounded() / divisor
        
        let num = Int(rounded)
        let modulo = self - Double(num)
        
        if modulo == 0 {
            return Double(num)
        } else if modulo > 0.5 {
           return Double(num + 1)
        } else{
            return Double(Double(num) + 0.5)
        }
    }
    
    func toDistanceString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        if self < 100 {
            return "text_very_near".localized
        }
        if self < 1000 {
            return "\(formatter.string(from: (self.roundTo(places: 1) as NSNumber))!) m"
        } else {
            let km = self/1000
            
            return "\(formatter.string(from: (km.roundTo(places: 1) as NSNumber))!) km"
        }
    }
    
    func toDistanceMapExploreString() -> String{
        let distance = self
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        
        var result = 0.0
        
        
        if distance < 1000{
            if (1...10).contains(distance) {
                result = distance
            } else {
                
            }
            
            if (10...99).contains(distance) {
                let modulo = Int(distance) % 10
                result = distance - Double(modulo)
            }
            
            if (100...999).contains(distance) {
                let modulo = Int(distance) % 100
                result = distance - Double(modulo)
                return "\(Int(result)) m"
            }
            return "\(formatter.string(from: (result.roundTo(places: 1) as NSNumber))!)m"
        } else {
            let km = distance/1000
            return "\(formatter.string(from: (km.roundTo(places: 1) as NSNumber))!)km"
        }
    }
    
    func toNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        let num: Double = self
        return "\(formatter.string(from: (num.roundTo(places: 1) as NSNumber))!)"
    }
    
    func toSnapbleString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return "\(formatter.string(from: (self.roundTo(places: 1) as NSNumber))!)"
    }
    
    func toDurationString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .full
        let formattedString = formatter.string(from: TimeInterval(self))!
        return formattedString
    }
    
    func toDurationString(unit: DurationUnit = .seconds) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        
        var seconds = self
        if unit == .minute {
            seconds = self * 60
        } else if unit == .hour {
            seconds = self * 60 * 60
        }
        
        let formattedString = formatter.string(from: TimeInterval(seconds))!
        return formattedString
    }
    
    func audioDurationString() -> String {
        let min = Int(self/60)
        let sec = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
    
    func durationString() -> String {
        let min = Int(self/60)
        let sec = Int(self.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", min, sec)
    }
    
    enum DurationUnit {
        case seconds
        case minute
        case hour
    }
    
    func size() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        if self < 1024 {
            return "\(formatter.string(from: (self as NSNumber))!) B"
        } else if self < (1024 * 1024) {
            return "\(formatter.string(from: ((self / 1024).roundTo(places: 2) as NSNumber))!) KB"
        } else {
            return "\(formatter.string(from: ((self / 1024 / 1024).roundTo(places: 2) as NSNumber))!) MB"
        }
    }
    
    var kmFormatted: String {
        
        if self >= 1000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }
        
        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }
        
        return String(format: "%.0f", locale: Locale.current,self)
    }
}

public extension UIView {
    func asImage() -> UIImage? {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            guard let currentContext = UIGraphicsGetCurrentContext() else {
                return nil
            }
            self.layer.render(in: currentContext)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    }
    
    func blur(_ blurRadius: Double = 2.5) {
        let blurredImage = getBlurryImage(blurRadius)
        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = 100
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor = .white
        addSubview(blurredImageView)
        NSLayoutConstraint.activate([
            blurredImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurredImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    private func getBlurryImage(_ blurRadius: Double = 2.5) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }
}

public extension Int {
    var toBool: Bool {
        if self == 0 {
            return false
        } else {
            return true
        }
    }
    
    var toString: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        return "\(formatter.string(from: (self as NSNumber))!)"
    }
}

public extension CLLocationCoordinate2D {
    static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        func distance(from coor1: CLLocationCoordinate2D, to coor2: CLLocationCoordinate2D) -> Double {
            let location1 = CLLocation(latitude: coor1.latitude, longitude: coor1.longitude)
            let location2 = CLLocation(latitude: coor2.latitude, longitude: coor2.longitude)
            
            return location1.distance(from: location2)
        }
        
        return distance(from: left, to: right) < 10 ? true : false
    }
    
    static func != (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return !(left == right)
    }
    
    func distance(to coor2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: coor2.latitude, longitude: coor2.longitude)
        
        return location1.distance(from: location2)
    }
}

public extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

public extension Data {
    func sizeMB() -> Double? {
        let bytes: Int = self.count
        return (Double(bytes) / 1024.0)/1024.0
    }
    
    func sizeBytes() -> Double? {
        return Double(self.count)
    }
}

public extension URL {
    func thumbnailFromVideoUrl(completion: @escaping ((_ image: UIImage?) -> Void)) -> Void {
        DispatchQueue.global().async {
            let avAssetImageGenerator = AVAssetImageGenerator(asset: AVAsset(url: self))
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                DispatchQueue.main.async {
                    completion(thumbImage)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
    var isCanOpenURLScheme: Bool {
        return UIApplication.shared.canOpenURL(self)
    }
    
    func durationVideoUrl() -> Double {
        let asset = AVAsset(url: self)
        let duration = asset.duration
        return duration.seconds
    }
    
    func getVideoResolution() -> String? {
        guard let track = AVURLAsset(url: self).tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return "\(abs(size.height)):\(abs(size.width))"
    }
    
    func mimeType() -> String {
        let pathExtension = self.pathExtension
        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                return mimetype as String
            }
        }
        return "application/octet-stream"
    }
}

public extension UITapGestureRecognizer {
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

public extension UIButton {
    func alignTextBelow(spacing: CGFloat = 4.0) {
        if let image = self.imageView?.image {
            let imageSize: CGSize = image.size
            
            let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: (self.titleLabel!.font)!])
            
            self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width + 2, bottom: -(imageSize.height), right: 0.0)
            
            self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
        }
    }
}

public extension UIFont {
    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(self.fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}

public extension Dictionary {
    var json: String {
        let invalidJson = "Not a valid JSON"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? invalidJson
        } catch {
            return invalidJson
        }
    }
}

public extension Dictionary {
    func toData() -> Data? {
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        } catch {
            return nil
        }
    }
}

public extension String {
    func toJSON() -> [String: Any]? {
        let str = self.replacingOccurrences(of: "\0", with: "")
        if let jsonData = str.data(using: .utf8) {
            let dictionary = try? JSONSerialization.jsonObject(with: jsonData, options: [])
            return dictionary as? [String : Any]
        }
        return nil
    }
}

public extension Data {
    var unarchiveToDictionary: [String: Any]? {
        do {
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(self) as? [String: Any]
        } catch {
            return nil
        }
    }
    
    var toDictionary: [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: [])).flatMap { $0 as? [String: Any] }
    }
}

public extension Data {
    var mimeType: String {
        var values = [UInt8](repeating: 0, count: 1)
        copyBytes(to: &values, count: 1)
        
        switch values[0] {
        case 0xFF:
            return "image/jpeg"
        case 0x89:
            return "image/png"
        case 0x47:
            return "image/gif"
        case 0x49, 0x4D:
            return "image/tiff"
        default:
            return "undefine"
        }
    }
}

public extension NSAttributedString {
    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }
    
    func width(containerHeight: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.width)
    }
}

public extension UIStackView {
    func removeAllArrangedSubview() {
        for view in self.arrangedSubviews {
            removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
}

public extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}

public extension NSAttributedString {
    func replacingCharacters(in range: NSRange, with attributedString: NSAttributedString) -> NSMutableAttributedString {
        let ns = NSMutableAttributedString(attributedString: self)
        ns.replaceCharacters(in: range, with: attributedString)
        return ns
    }
    
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        lhs = ns
    }
    
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
        let ns = NSMutableAttributedString(attributedString: lhs)
        ns.append(rhs)
        return NSAttributedString(attributedString: ns)
    }
}

public extension UIImage {
    func fixOrientation() -> UIImage {
        guard let cgImage = cgImage else { return self }
        if imageOrientation == .up { return self }
        var transform = CGAffineTransform.identity
        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        case .up, .upMirrored:
            break
        @unknown default:
            fatalError()
        }
        switch imageOrientation {
        case .upMirrored, .downMirrored:
            let _ = transform.translatedBy(x: size.width, y: 0)
            let _ = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            let _ = transform.translatedBy(x: size.height, y: 0)
            let _ = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            fatalError()
        }
        if let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            ctx.concatenate(transform)
            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            if let finalImage = ctx.makeImage() {
                return (UIImage(cgImage: finalImage))
            }
        }
        return self
    }
}

public extension UIFont {
    class func semibold(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    class func regular(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    class func medium(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .medium)
    }
}

public extension UICollectionView {
    func register<T>(type: T.Type) where T: UICollectionViewCell {
        register(T.self,forCellWithReuseIdentifier: String(describing: T.self))
    }
    
    func registerFromNib<T>(type: T.Type) where T: UICollectionViewCell {
        let nibName = String(describing: T.self) // LMAO
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type))
        register(nib, forCellWithReuseIdentifier: nibName)
    }
    
    func register<T>(type: T.Type,
                     forSupplementaryViewOfKind kind: String) where T: UICollectionReusableView {
        register(T.self,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: String(describing: T.self))
    }
    
    func registerFromNibForSupplementaryView<T>(type: T.Type,
                                                forSupplementaryViewOfKind kind: String) where T: UICollectionReusableView {
        let nibName = String(describing: T.self) // LMAO
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type))
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: T.self))
    }
    
    func dequeue<T>(_ type: T.Type, at indexPath: IndexPath) -> T? where T: UICollectionViewCell {
        dequeueReusableCell(withReuseIdentifier: String(describing: T.self), for: indexPath) as? T
    }
    
    func dequeue<T>(_ type: T.Type, ofKind elementKind: String, at indexPath: IndexPath) -> T? where T: UICollectionReusableView {
        return dequeueReusableSupplementaryView(
            ofKind: elementKind,
            withReuseIdentifier: String(describing: T.self),
            for: indexPath) as? T
    }
}

public extension UITableView {
    func register<T>(type: T.Type) where T: UITableViewCell {
        register(T.self, forCellReuseIdentifier: String(describing: T.self))
    }
    
    func registerFromNib<T>(type: T.Type) where T: UITableViewCell {
        let nibName = String(describing: T.self) // LMAO
        let nib = UINib(nibName: nibName, bundle: Bundle(for: type))
        register(nib, forCellReuseIdentifier: nibName)
    }
    
    func dequeue<T>(_ type: T.Type, at indexPath: IndexPath) -> T? where T: UITableViewCell {
        dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as? T
    }
}

public extension Reactive where Base: UICollectionView {

    func loadMore(withOffsetY offset: CGFloat) -> Observable<Void> {
        return self.contentOffset.map { (point) -> Bool in
            let maximumOffset = self.base.contentSize.height - self.base.frame.size.height
            return maximumOffset - point.y <= offset
        }
        .filter { $0 }
        .mapToVoid()
    }

    func loadMore(withOffsetX offset: CGFloat) -> Observable<Void> {
        return contentOffset.map { (point) -> Bool in
            let maximumOffset = self.base.contentSize.width - self.base.frame.size.width
            return maximumOffset - point.x <= offset
        }
        .filter { $0 }
        .mapToVoid()
    }
}

public extension Reactive where Base: UIScrollView {
    func refresh() -> Observable<Void> {
        if base.refreshControl == nil {
            base.refreshControl = .init()
        }
        return didEndDragging.withLatestFrom(base.refreshControl!.rx.controlEvent(.valueChanged))
            .map { (_) -> Bool in
                let isRefreshing = self.base.refreshControl!.isRefreshing
                self.base.refreshControl!.endRefreshing()
                return isRefreshing
            }
            .filter({ $0 })
            .mapToVoid()
    }

    var scrolling: Observable<Bool> {
        return contentOffset.map { (point) -> Bool in
            if (point.y >= (self.base.contentSize.height - self.base.frame.size.height - 1)) {
                return true
            }
            return false
        }
    }
}

public extension Reactive where Base: UITableView {
    func loadMore(offset: CGFloat) -> Observable<Void> {
        return contentOffset.map { (point) -> Bool in
            let maximumOffset = self.base.contentSize.height - self.base.frame.size.height
            return (maximumOffset - point.y) <= offset
        }
        .filter { $0 }
        .mapToVoid()
    }
}

public extension ObservableType {
    func currentAndPrevious() -> Observable<(current: Element, previous: Element?)> {
        return self.multicast({ () -> PublishSubject<Element> in PublishSubject<Element>() }) { (values: Observable<Element>) -> Observable<(current: Element, previous: Element?)> in
            let pastValues = values.asObservable()
                .map { previous -> Element? in previous }
                .startWith(nil)
            return Observable.zip(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}

public extension StringProtocol {
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
    
    func indices<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Index] {
        var indices: [Index] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
                .range(of: string, options: options) {
            indices.append(range.lowerBound)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return indices
    }
    
    func ranges<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var startIndex = self.startIndex
        while startIndex < endIndex,
              let range = self[startIndex...]
                .range(of: string, options: options) {
            result.append(range)
            startIndex = range.lowerBound < range.upperBound ? range.upperBound :
                index(range.lowerBound, offsetBy: 1, limitedBy: endIndex) ?? endIndex
        }
        return result
    }
}

public extension UITableView {
    func animateScrollToRow(at indexPath: IndexPath, at position: ScrollPosition) {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.3, 1)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        UIView.animate(withDuration: 0.7) {
            self.scrollToRow(at: indexPath, at: position, animated: true)
        }
        CATransaction.commit()
    }
}

public extension UIScrollView {
    func animateScrollToRow(at point: CGPoint) {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.8, 0.3, 1)
        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        UIView.animate(withDuration: 0.7) {
            self.setContentOffset(point, animated: false)
        }
        CATransaction.commit()
    }
}

public extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
    
    var resolution: CGSize? {
        guard let track = self.tracks(withMediaType: AVMediaType.video).first else { return nil }
        let size = track.naturalSize.applying(track.preferredTransform)
        return CGSize(width: abs(size.width), height: abs(size.height))
    }
}

public extension UIAlertController {
    
    private func setText(_ text: String, font: UIFont?, color: UIColor?) -> NSAttributedString {
        var attributedString = NSAttributedString(string: text)
        if let font = font {
            attributedString = attributedString.withFont(font)
        }
        if let color = color {
            attributedString = attributedString.withTextColor(color)
        }
        
        return attributedString
    }
    
    func setTitle(title: String, font: UIFont?, color: UIColor?) {
        self.setValue(setText(title, font: font, color: color), forKey: "attributedTitle")
    }
    
    func setMessage(message: String, font: UIFont?, color: UIColor?) {
        self.setValue(setText(message, font: font, color: color), forKey: "attributedMessage")
    }
}

public extension UIAlertAction {
    func setColor(color: UIColor?){
        self.setValue(color, forKey: "titleTextColor")
    }
}

public extension Array where Element:Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()

        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }

        return result
    }
}

public extension FileManager {
    
    @discardableResult
    func write(any: Any, toPath path: String, withName name: String) -> Bool {
        let fullPath = "\(path)/\(name)"
        if !self.isDirectoryExisted(atPath: path) {
            do {
                try self.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
                self.createFile(atPath: fullPath, contents: nil, attributes: nil)
            } catch {
                return false
            }
        } else {
            if !self.fileExists(atPath: fullPath) {
                self.createFile(atPath: fullPath, contents: nil, attributes: nil)
            }
        }
        
        let file = FileHandle(forWritingAtPath: "\(fullPath)")
        if file != nil {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: any, options: [.prettyPrinted])
                file?.write(jsonData)
            } catch {
                return false
            }
            file?.closeFile()
            return true
        }
        return false
    }
    
    func read(fromFilePath filePath: String) -> Any? {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: filePath), options: [.mappedIfSafe])
            let json = try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves])
            return json
        } catch {
            return nil
        }
    }
    
    @discardableResult
    func removeItem(in directoryPath: String) -> Bool {
        do {
            try self.removeItem(atPath: directoryPath)
            return true
        } catch {
            return false
        }
    }
    
    @discardableResult
    func removeFile(_ fileName: String, inDirectory directoryPath: String) -> Bool {
        do {
            try self.removeItem(atPath: "\(directoryPath)/\(fileName)")
            return true
        } catch {
            return false
        }
    }
    
    func contents(atPath path: String) -> [String] {
        do {
            let items = try self.contentsOfDirectory(atPath: path)
            return items
        } catch {
            return [String]()
        }
    }
    
    var documentsDirectoryURL: URL {
        let paths = self.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    var temporaryDirectoryURL: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
    }
    
    func deleteFile(_ filePath:URL) {
        guard self.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try self.removeItem(atPath: filePath.path)
        } catch {
            fatalError("Unable to delete file: \(error) : \(#function).")
        }
    }
    
    func isFileExist(atPath: String) -> Bool {
        return self.fileExists(atPath: atPath)
    }
    
    func createDirectory(url: URL) {
        if self.isDirectoryExisted(atPath: url.relativePath) == false {
            do {
                try self.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                log.error("createDirectory - \(url.relativePath)")
            }
        }
    }
    
    var rootCacheDirectory: URL {
        let cacheDir = documentsDirectoryURL.appendingPathComponent("root_cache")
        createDirectory(url: cacheDir)
        return cacheDir
    }
    
    func isDirectoryExisted(atPath path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        
        return exists && isDirectory.boolValue
    }
    
    func storePNGImage(_ image: UIImage?, toFile fileURL: URL) {
        do {
            try image?.pngData()?.write(to: fileURL)
        } catch {
            log.error(error.localizedDescription)
        }
    }
    
    func storeJPGImage(_ image: UIImage?, toFile fileURL: URL, imageLimitSize: Double = 1000000.0) {
        guard let img = image else { return }
        var quality: CGFloat = 1.0
        var count = img.jpegData(compressionQuality: quality)?.sizeBytes() ?? 0
        while count > imageLimitSize, quality > 0 {
            quality -= 0.1
            autoreleasepool {
                count = img.jpegData(compressionQuality: quality)?.sizeBytes() ?? 0
            }
        }
        do {
            try img.jpegData(compressionQuality: quality)?.write(to: fileURL)
        } catch {
            log.error("storeImage \(error)")
        }
    }
}

public extension CIImage {
  /// Inverts the colors and creates a transparent image by converting the mask to alpha.
  /// Input image should be black and white.
  var transparent: CIImage? {
     return inverted?.blackTransparent
  }

  /// Inverts the colors.
  var inverted: CIImage? {
      guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

    invertedColorFilter.setValue(self, forKey: "inputImage")
    return invertedColorFilter.outputImage
  }

  /// Converts all black to transparent.
  var blackTransparent: CIImage? {
      guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
    blackTransparentFilter.setValue(self, forKey: "inputImage")
    return blackTransparentFilter.outputImage
  }

  /// Applies the given color as a tint color.
  func tinted(using color: UIColor) -> CIImage? {
     guard
        let transparentQRImage = transparent,
        let filter = CIFilter(name: "CIMultiplyCompositing"),
        let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

    let ciColor = CIColor(color: color)
    colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
    let colorImage = colorFilter.outputImage

    filter.setValue(colorImage, forKey: kCIInputImageKey)
    filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

    return filter.outputImage!
  }
    
    /// Combines the current image with the given image centered.
    func combined(with image: CIImage) -> CIImage? {
      guard let combinedFilter = CIFilter(name: "CISourceOverCompositing") else { return nil }
      let centerTransform = CGAffineTransform(translationX: extent.midX - (image.extent.size.width / 2), y: extent.midY - (image.extent.size.height / 2))
      combinedFilter.setValue(image.transformed(by: centerTransform), forKey: "inputImage")
      combinedFilter.setValue(self, forKey: "inputBackgroundImage")
      return combinedFilter.outputImage!
    }
}

public extension Array {
    func item(at index: Int) -> Element? {
        if index < self.count {
            return self[index]
        }
        return nil
    }
}

public extension CGSize {
    var ratio: String {
        if height == 0 || width == 0 {
            return "1:1"
        }
        return "\(Int(width)):\(Int(height))"
    }
}

public extension String {
    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    mutating func trim() {
        self = self.trimmed
    }
}

public extension Int {
    func toDouble() -> Double {
        Double(self)
    }
}

public extension Double {
    func toInt() -> Int {
        Int(self)
    }
}

public extension String {
    var asCoordinates: CLLocationCoordinate2D? {
        let components = self.components(separatedBy: ",")
        if components.count != 2 { return nil }
        let strLat = components[0].trimmed
        let strLng = components[1].trimmed
        if let dLat = Double(strLat),
            let dLng = Double(strLng) {
            return CLLocationCoordinate2D(latitude: dLat, longitude: dLng)
        }
        return nil
    }
}

public extension String {
    var asURL: URL? {
        URL(string: self)
    }
}

public extension String {
    var containsOnlyDigits: Bool {
        let notDigits = NSCharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: String.CompareOptions.literal, range: nil) == nil
    }
}

public extension String {
    var isAlphanumeric: Bool {
        !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

public extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
}

public extension UIImage {
    var squared: UIImage? {
        let originalWidth  = size.width
        let originalHeight = size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var edge: CGFloat = 0.0
        
        if (originalWidth > originalHeight) {
            // landscape
            edge = originalHeight
            x = (originalWidth - edge) / 2.0
            y = 0.0
            
        } else if (originalHeight > originalWidth) {
            // portrait
            edge = originalWidth
            x = 0.0
            y = (originalHeight - originalWidth) / 2.0
        } else {
            // square
            edge = originalWidth
        }
        
        let cropSquare = CGRect(x: x, y: y, width: edge, height: edge)
        guard let imageRef = cgImage?.cropping(to: cropSquare) else { return nil }
        
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
}

public extension Double {
    var toString: String {
        return String(format: "%.1f", self)
    }
}

public extension Double {
    func toPrice(currency: String = "đ") -> String {
        let nf = NumberFormatter()
        nf.decimalSeparator = ","
        nf.groupingSeparator = "."
        nf.groupingSize = 3
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 0
        return (nf.string(from: NSNumber(value: self)) ?? "?") + currency
    }
}

public extension String {
    var asDict: [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}

public extension String {
    var asArray: [Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Any]
    }
}

public extension String {
    var asAttributedString: NSAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
}

public extension Bundle {
    var appVersion: String? {
        self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    static var mainAppVersion: String? {
        Bundle.main.appVersion
    }
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }
}

public extension Encodable {
    func asDictionary(encoder: JSONEncoder = JSONEncoder()) -> [String: Any]? {
        guard let data = try? encoder.encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
