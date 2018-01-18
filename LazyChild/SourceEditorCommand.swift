//
//  SourceEditorCommand.swift
//  LazyChild
//
//  Created by Tiziano Coroneo on 19/01/2018.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    private let runner = Runner(withDiagnostic: nil)
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        // Implement your command here, invoking the completion handler when done. Pass it nil on success, and an NSError on failure.
        
        completionHandler(nil)
    }
    
}
