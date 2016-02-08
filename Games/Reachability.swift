 import Foundation
 
 @objc public class Reachability : NSObject {
    
   class func isConnectedToNetwork()->Bool{
        
        var Status:Bool = true
        let url = NSURL(string: "http://google.com/")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "HEAD"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        request.timeoutInterval = 10.0
        
       var response: NSURLResponse?
    
        if let httpResponse = response as? NSHTTPURLResponse {
           if httpResponse.statusCode != 200 {
               Status = false
           }
        }
    
        return Status
    }
 }