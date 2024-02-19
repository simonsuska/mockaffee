<div align="center">
  <img src="Mockaffee.svg" alt="Mockaffee" width="168"><br><br>

  **Mockaffee** is a lightweight mocking library for unit tests in Swift.

  [![GitHub Release](https://img.shields.io/github/v/release/simonsuska/Mockaffee?color=F05138)](https://github.com/simonsuska/mockaffee/releases)
  [![Static Badge](https://img.shields.io/badge/swift-5.9-important?style=flat&color=F05138)](https://swift.org)
  [![GitHub License](https://img.shields.io/github/license/simonsuska/Mockaffee)](https://github.com/simonsuska/mockaffee/blob/main/LICENSE)
</div>

---

## 🔎 Table of Contents

- [🎯 About](#about)
- [🚀 Getting Started](#getting_started)
- [💫 Usage](#usage)
- [🚫 Limitations](#limitations)
- [⚖️ License](#license)

<div id="about"/>

## 🎯 About

Mockaffee will boost your tests like a cup of coffee boosts your power of writing code 😁!
That's where the name *Mockaffee* comes from: It's a hybride of *Mock* and *Kaffee*, the
German word for coffee.

The API of this library is partly inspired by [Mockito](https://github.com/mockito/mockito), 
a popular mocking framework for unit tests in Java. Mockaffee provides a subset of those
functionality for unit tests in Swift, including:

- Creating a mock
- Verify function calls
- Record custom return behaviors
- Record custom errors to be thrown

<div id="getting_started"/>

## 🚀 Getting Started

To get started, add a dependency to your project in Xcode. You may proceed as follows\*:

#### If you want to add a dependency to a Xcode project

1. From the menu bar in Xcode, choose *File* &#8594; *Add Package Dependencies...*
2. A dialog opens where you can add the dependency by pasting the URL of the repository 
   into the search bar in Xcode. \
   If you cloned this repository, you can add a dependency to the repository on your
   machine by choosing *Add Local...*
3. Add the package dependency to the test target

#### If you want to add a dependency to another Swift package

Customize your `Package.swift` file according to the following code.
You may specify a version number instead of a branch.

```swift
let package = Package(
    name: "SomeSwiftPackage",
    dependencies: [
        .package(url: "https://github.com/simonsuska/mockaffee.git", branch: "main")
    ],
    targets: [
        .testTarget(
            name: "SomeSwiftPackageTests",
            dependencies: ["Mockaffee"]),
    ]
)
```

\*Done with Xcode Version 15.0

<div id="usage"/>

## 💫 Usage

### First Taste

```swift
class EnrollmentTests: XCTestCase {
    private var enrollment: Enrollment!
    private var dbConnMock = DatabaseConnectionMock()
    
    override func setUp() {
        enrollment = Enrollment(dbConn: dbConnMock)
    }

    func testMatriculate() throws {
        enrollment.matriculate(studentID: 033174, name: "John Doe")
        
        // Record custom return behavior
        when(using: dbConnMock, thenReturn: "").select("*", from: "students", where: "id = 033174")
        
        // Record custom throw behavior
        try when(using: dbConnMock, thenThrow: DatabaseError.reconnection).reconnect()
        
        // Verify function calls
        try verify(on: dbConnMock, called: exactly(1)).connect()
        verify(on: dbConnMock, called: exactly(1)).insert(into: "students", values: 033174, "John Doe")
        verify(on: dbConnMock, called: never()).delete(from: "students", where: "id = 033174")
        try verify(on: dbConnMock, called: atLeast(1)).close()
    }
}
```

### In Detail

To create a mock, simply inherit from the `Mock` class. Subsequently you can implement the
methods. To be able to verify certain function calls and make use of recorded behaviors,
you have to call exactly one of the following methods in your method properly.

- `called(fsignature:with:)`
- `calledReturning(fsignature:with:)`
- `calledThrowing(fsignature:with:)`
- `calledThrowReturning(fsignature:with:)`

Each method addresses a specific use case. In the following example, a mock is created 
which implements a `DatabaseConnection` protocol and uses the above methods to track their 
calls and use registered behaviors.

```swift
class DatabaseConnectionMock: Mock, DatabaseConnection {
    func connect() throws {
        try calledThrowing()
    }
    
    func reconnect() throws {
        try calledThrowing()
    }
    
    func insert(into table: String, values: Any...) {
        called(with: table, values)
    }
    
    @discardableResult
    func select(_ content: String, from table: String, where condition: String) -> String {
        // "" is the default return value
        calledReturning(with: content, table, condition) as? String ?? ""
    }
    
    func delete(from table: String, where condition: String) {
        called(with: table, condition)
    }
    
    func close() throws {
        try calledThrowing()
    }
}
```

After creating a mock properly, you are able to verify function calls and record
custom behaviors. The following struct is used to enroll students in a university. For 
this purpose, a database connection is injected.

```swift
struct Enrollment {
    private let dbConn: any DatabaseConnection
    
    init(dbConn: any DatabaseConnection) {
        self.dbConn = dbConn
    }
    
    func matriculate(studentID: UInt, name: String) {
        do {
            try dbConn.connect()
            dbConn.insert(into: "students", values: studentID, name)
            try dbConn.close()
        } catch { /* Catch possible errors */ }
    }
}
```

**Verify**

To verify that the `matriculate(studentID:name:)` method behaves properly and calls the 
underlying methods accordingly, you can use the `verify(on:called:_:_:)` function.

```swift
// Verifies that `connect()` has been called exactly once on `dbConnMock`
try verify(on: dbConnMock, called: exactly(1)).connect()

// Verifies that `insert(into:values:)` has been called exactly once with the
// specified parameters on `dbConnMock`
verify(on: dbConnMock, called: exactly(1)).insert(into: "students", values: 033174, "John Doe")

// Verifies that `delete(from:where:)` has never been called with the specified
// parameters on `dbConnMock`
verify(on: dbConnMock, called: never()).delete(from: "students", where: "id = 033174")

// Verifies that `close()` has been called at least once on `dbConnMock`
try verify(on: dbConnMock, called: atLeast(1)).close()
```

**When**

To record a custom return behavior, let's say for the `select(_:from:where:)`
method, you can use the `when(using:thenReturn:)` function.

```swift
// The call `dbConnMock.select("*", from: "students", where: "id = 033174")` will return 
// an empty string. Note that any other call of the `select(_:from:where:)` method on the 
// `dbConnMock` object will return the specified default value. The specified parameters are relevant.
when(using: dbConnMock, thenReturn: "").select("*", from: "students", where: "id = 033174")
```

To register a custom throw-behavior, let's say for the `reconnect()` method, you can use
the `when(using:thenThrow:)` function.

```swift
// The call `dbConnMock.reconnect()` will throw a `DatabaseError.reconnection` error.
// Again, the specified parameters are relevant in general.
when(using: dbConnMock, thenThrow: DatabaseError.reconnection).reconnect()
```

<div id="limitations"/>

## 🚫 Limitations

The provided functionality still has its limitations. The following use cases are 
currently not covered and may result in an undefined behavior.

1. Verifying overloading functions with an array-typed and variadic parameter

    ```swift
    // Currently, the verify(on:called:_:_:) function can not distinguish between the following 
    // two functions  
    
    func foo<T>(param: T...) {}
    func foo<T>(param: [T]) {}
    ```
    
2. Verifying a collection of complex types, e.g. an array of classes or a set of structs

3. Verifying a complex type containing a property of a complex type

    ```swift
    struct SomeStruct {}
    
    class SomeClass {
        var someProperty: SomeStruct // Currently not verifiable
        
        init(someProperty: SomeStruct) {
            self.someProperty = someProperty
        }
    }
    ```

<div id="license"/>

## ⚖️ License

Mockaffee is released under the GNU GPL-3.0 license. See [LICENSE](LICENSE) for details.
