

import Foundation
import ChildBrain


let runner = Runner()

do {
    try runner.run(CommandLine.arguments)
} catch {
    print("Error! \(error)")
}
