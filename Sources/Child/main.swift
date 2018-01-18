

import Foundation
import ChildBrain

let runner = Runner { print($0) }

do {
    try runner.runCommandLine(
        CommandLine.arguments,
        completion: { print($0) })
} catch {
    print("Error! \(error)")
}
