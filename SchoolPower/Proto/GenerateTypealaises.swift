//
//  setup.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/5/21.
//

import Foundation

let protoDirectory = URL(fileURLWithPath: CommandLine.arguments[1])
let typealiasFileName = "ProtoTypealiases.swift"
let protoFiles = ["powerschool.proto"]
let fileManager = FileManager.default

func generateTypealaises() {

    var typealiases: [String] = [
        "//",
        "//  ProtoTypealiases.swift",
        "",
        "/* GENERATED CODE */",
        "",
        "import Foundation",
        "",
        "// MARK: - Proto+Typealiases",
        ""
    ]

    for protoFile in protoFiles {
        let outputFileName = protoFile.replacingOccurrences(of: ".proto", with: ".pb.swift")

        let fileURL = protoDirectory.appendingPathComponent(outputFileName)

        guard let data = fileManager.contents(atPath: fileURL.relativePath) else {
            print("Could not find file at \(fileURL)")
            exit(EXIT_FAILURE)
        }

        let contents = String(decoding: data, as: UTF8.self)
        let lines = contents.components(separatedBy: .newlines)

        for line in lines {
            let prefix = "struct "
            let suffix = " {"
            guard line.hasPrefix(prefix), line.hasSuffix(suffix) else { continue }

            let structName = String(line.dropFirst(prefix.count).dropLast(suffix.count))
            let typealiasName = structName.components(separatedBy: "_").last ?? structName

            typealiases.append("typealias \(typealiasName) = \(structName)")
        }
    }

    typealiases.append("")

    let outputString = typealiases.joined(separator: "\n")
    let outputURL = protoDirectory.appendingPathComponent(typealiasFileName)

    do {
        try outputString.write(to: outputURL, atomically: false, encoding: .utf8)
    } catch {
        print(error)
        exit(EXIT_FAILURE)
    }
}

generateTypealaises()
