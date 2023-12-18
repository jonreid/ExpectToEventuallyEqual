// ExpectToEventuallyEqual by Jon Reid, https://qualitycoding.org
// Copyright 2023 Jonathan M. Reid. https://github.com/jonreid/ExpectToEventuallyEqual/blob/main/LICENSE.txt
// SPDX-License-Identifier: MIT

func describeMismatch<T>(_ type: T.Type, expected: T, actual: T) -> String {
    return "Expected \(describe(type, value: expected)), but was \(describe(type, value: actual))"
}

func describe<T>(_ type: T.Type, value: T) -> String {
    let description = String(describing: value)
    if type == String.self {
        return toCSyntaxString(description)
    }
    return description
}

private func toCSyntaxString(_ unformatted: String) -> String {
    let formattedChars = unformatted.map { toCSyntax($0) }
    return "\"\(formattedChars.joined())\""
}

private func toCSyntax(_ char: Character) -> String {
    switch char {
    case "\"":
        return "\\\""
    case "\n":
        return "\\n"
    case "\r":
        return "\\r"
    case "\t":
        return "\\t"
    default:
        return String(char)
    }
}