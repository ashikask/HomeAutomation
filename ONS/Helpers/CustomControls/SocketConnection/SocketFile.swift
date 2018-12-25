//
//  SocketManager.swift
//
//
//  Created by Grimi on 6/21/15.
//
//
import UIKit
import CoreFoundation
import CoreData

@objc protocol SocketStreamDelegate{
    func socketDidConnect(stream:Stream)
    @objc optional func socketDidDisconnet(stream:Stream, message:String)
    @objc optional func socketDidReceiveMessage(stream:Stream, message:String)
    @objc optional func socketDidReceiveBeginMessage(stream:Stream, message:String)
    @objc optional func socketDidReceivePopMessage(stream:Stream, message:String)
    @objc optional func socketDidEndConnection()
}

public class Socket: NSObject, StreamDelegate {
    static let soketmanager = Socket()
    var delegate:SocketStreamDelegate?
    private var _messagesQueue:Array<String> = [String]()
    private let bufferSize = 1024
     var _host:String?
     var _port:Int?
   
    private var _streamHasSpace:Bool = false
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    private var token: String = "0"
    var isClosed = false
    var isOpen = false
    
    private override init() {
        super.init()
    }
    
    var host:String?{
        get{
            return self._host
        }
    }
    
    var port:Int?{
        get{
            return self._port
        }
    }
    
    deinit{
        if let inputStr = self.inputStream{
            inputStr.close()
            inputStr.remove(from: .main, forMode: RunLoopMode.defaultRunLoopMode)
        }
        if let outputStr = self.outputStream{
            outputStr.close()
            outputStr.remove(from: .main, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
    /**
     Opens streaming for both reading and writing, error will be thrown if you try to send a message and streaming hasn't been opened
     :param: host String with host portion
     :param: port Port
     */
    final func open(host:String!, port:Int!){
        self._host = host
        self._port = port
        
        if #available(iOS 8.0, *) {
            Stream.getStreamsToHost(withName: self._host!, port: self._port!, inputStream: &inputStream, outputStream: &outputStream)
        } else {
            var inStreamUnmanaged:Unmanaged<CFReadStream>?
            var outStreamUnmanaged:Unmanaged<CFWriteStream>?
            CFStreamCreatePairWithSocketToHost(nil, host! as CFString, UInt32(port), &inStreamUnmanaged, &outStreamUnmanaged)
            inputStream = inStreamUnmanaged?.takeRetainedValue()
            outputStream = outStreamUnmanaged?.takeRetainedValue()
        }
        
        if inputStream != nil && outputStream != nil {
            
            inputStream!.delegate = self
            outputStream!.delegate = self
            
            inputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
            outputStream!.schedule(in: .main, forMode: RunLoopMode.defaultRunLoopMode)
            
            print("[SCKT]: Open Stream")
            
            self._messagesQueue = Array()
            
            inputStream!.open()
            outputStream!.open()
        } else {
            print("[SCKT]: Failed Getting Streams")
        }
    }
    
    final func close(){
        if let inputStr = self.inputStream{
            inputStr.delegate = nil
            inputStr.close()
            inputStr.remove(from: .main, forMode: RunLoopMode.defaultRunLoopMode)
        }
        if let outputStr = self.outputStream{
            outputStr.delegate = nil
            outputStr.close()
            outputStr.remove(from: .main, forMode: RunLoopMode.defaultRunLoopMode)
        }
        isClosed = true
        isOpen = false
    }
    
    /**
     NSStream Delegate Method where we handle errors, read and write data from input and output streams
     :param: stream NStream that called delegate method
     :param: eventCode      Event Code
     */
    
    public func stream(_ stream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.endEncountered:
            endEncountered(stream: stream)
            
        case Stream.Event.errorOccurred:
            self.isOpen = false
            self.close()
            print("[SCKT]: ErrorOccurred: \(stream.streamError.debugDescription)")
            
            
        case Stream.Event.openCompleted:
            openCompleted(stream: stream)
            
        case Stream.Event.hasBytesAvailable:
            handleIncommingStream(stream: stream)
            
        case Stream.Event.hasSpaceAvailable:
            print("space available")
            writeToStream()
            break;
            
        default:
            break;
        }
    }
    
    final func endEncountered(stream:Stream){
        
    }
    
    final func openCompleted(stream:Stream){
        if(self.inputStream?.streamStatus == .open && self.outputStream?.streamStatus == .open){
            DispatchQueue.once {
                self.isOpen = true
                self.delegate?.socketDidConnect(stream: stream)
            }
           
        }
    }
    
    /**
     Reads bytes asynchronously from incomming stream and calls delegate method socketDidReceiveMessage
     :param: stream An InputStream
     */
    final func handleIncommingStream(stream: Stream){
        if let inputStream = stream as? InputStream {
            var buffer = Array<UInt8>(repeating: 0, count: bufferSize)
         
            let background = DispatchQueue.global()
             background.async {
                let bytesRead = inputStream.read(&buffer, maxLength: 1024)
                
                if bytesRead >= 0 {
                    if let output = NSString(bytes: &buffer, length: bytesRead, encoding: String.Encoding.utf8.rawValue){
                        if output != "" || !output.contains("SUCCESS"){
                            
                            if output.contains("FAILURE"){
                                if let delegate = self.delegate {
                                    if let theMethod = delegate.socketDidReceivePopMessage?(stream: stream, message: output as String) {
                                        theMethod
                                       
                                    }
                                }

                            }
                        else if let delegate = self.delegate{
                                if let theMethod = delegate.socketDidReceiveMessage?(stream: stream, message: output as String) {
                                    theMethod
                                    
                                }
                                else if let theMethodBegin = delegate.socketDidReceiveBeginMessage?(stream: stream, message: output as String) {
                                    theMethodBegin
                                    
                                }
                                else{
                                    DispatchQueue.main.async {
                                        CoreDataUtility().receivedMessage(message: output as String)
                                    }
                                }
                            
                        }
                        else{
                            DispatchQueue.main.async {
                                CoreDataUtility().receivedMessage(message: output as String)
                            }
                        }
                        }
                    }
                } else {
                    // Handle error
                }
                
            }
//            dispatch_async(DispatchQueue.global(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
//                let bytesRead = inputStream.read(&buffer, maxLength: 1024)
//
//                if bytesRead >= 0 {
//                    if let output = NSString(bytes: &buffer, length: bytesRead, encoding: NSUTF8StringEncoding){
//                        self.delegate?.socketDidReceiveMessage!(stream, message: output as String)
//                    }
//                } else {
//                    // Handle error
//                }
//
//            })
        } else {
            print("[SCKT]: \(#function) : Incorrect stream received")
        }
        
    }
    
    /**
     If messages exist in _messagesQueue it will remove and it and send it, if there is an error
     it will return the message to the queue
     */
    final func writeToStream(){
        if _messagesQueue.count > 0 && self.outputStream!.hasSpaceAvailable  {
            
            let background = DispatchQueue.global()
            background.async {
                let message = self._messagesQueue.removeLast()
                let data: NSData = message.data(using: String.Encoding.utf8)! as NSData
                var buffer = [UInt8](repeating:0, count:data.length)
//                data.getBytes(&buffer, length:data.length * UIFontDescriptorSizeAttribute(UInt8))
                data.getBytes(&buffer, length: data.length)
                //An error ocurred when writing
                if self.outputStream!.write(&buffer, maxLength: data.length) == -1 {
                    self._messagesQueue.append(message)
                }
            }


            
        }
    }
    
    final func send(message:String){
        _messagesQueue.insert(message, at: 0)
        
        writeToStream()
    }
    
    
    
}
public extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block:()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }
    
    /**
     Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
     only execute the code once even in the presence of multithreaded calls.
     
     - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
     - parameter block: Block to execute once
     */
    public class func once(token: String, block:()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
//extension SocketStreamDelegate {
//    public func socketDidReceiveMessage(stream:Stream, message:String) {}
//    
//}
