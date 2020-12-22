// Playground - noun: a place where people can play

import UIKit

// MARK: - String Syntax
//  --------------------------------------

//String syntax: - no @ sign in front of quotes
"Some string"

// MARK: - Variables
//  --------------------------------------

//Mutable (regular) variables
//declaring variables - these here can ONLY ever be integers
var integer = 5
var otherInt : Int

//error:
//otherInt = "7"

//this can ONLY ever be Booleans
var aBool : Bool
aBool = true

// MARK: - Constants
//  --------------------------------------

//Constants - cannot be changed (immutable)
let someConstant = 5

//error: - cannot be modified
//someConstant = 2

// MARK: - Arrays
//  --------------------------------------

//Array syntax: - defined as [Int] array
var array = [2, 9, 4, 1, 3]
var otherArray = [Int]()

otherArray.append(5)
otherArray += array

//error: - cannot accept anything other than [Int]
//otherArray.append("Value")

// MARK: - Dictionaries
//  --------------------------------------

//Dictionary Syntax: - defined as a [String:String] dictionary
var dict = ["AZ" : "Arizona", "OH" : "Ohio", "CA" : "California"]

//defined as a [String:Int] dictionary
var otherDict = [String:Int]()

//set the value 5 to the key "Key1"
otherDict["Key1"] = 5

//error: - cannot accept anything other than [String:Int]
//otherDict["Key2"] = "Value2"

// MARK: - Range Operator
//  --------------------------------------

//Range operators

//closed range operator (includes both numbers)
0...100  // 101 times

//half-open (up to but NOT including the end value)
0..<100 // 100 times

// MARK: - If-syntax
//  --------------------------------------


//If-syntax: (No parenthesis)
var someBoolean = true
if someBoolean {
	println("it is true")
}

// MARK: - String Interpolation
//  --------------------------------------

//String interpolation: (basically String formatting).
//Simply use the “\” followed by the variable in ():
var number = 234
println("The number is \(number)")

// MARK: - For Loop
//  --------------------------------------

//For syntax
var total = 0
//up to but not including 100
for x in 0..<100 {
	total += x
}
total

let someArray = [52,976,294,14]
for index in someArray {
	println(index)
}

// MARK: - Optionals
//  --------------------------------------

//Optionals – can be nil OR the type – must check for this
var optionalString : String? = "5"

if optionalString != nil {
	println(optionalString)
}

//Unwrapping optionals
var optionalInt : Int?
optionalInt = 10

//will print "Optional(10)"
println("The value is \(optionalInt)")

//will print "10"
println("The value is \(optionalInt!)")


var nameString : String? //defaults to nil

//error – cannot unwarp a nil value. Will crash app
//let name = nameString!

// MARK: - Functions
//  --------------------------------------

//Function syntax:

func someMethod() {
	println("method call")
}

func returnsABoolean() -> Bool {
	return true
}

func methodWithParameters(argVariable : Int) {
	println("The value is \(argVariable)")
}

func methodWithTwoParameters(someVar : String, andAnotherParam otherVar : Int) {
	println("\(someVar) and \(otherVar) got passed in.")
}

methodWithTwoParameters("Value1", andAnotherParam: 4)

// MARK: - Closures
//  --------------------------------------

//Closures - Essentially a code block, but can be held in a variable

let myClosure = {
	println("print some stuff")
}

//function that takes a closer, and runs it 10 times
func takesClosure(closure : () -> () ) {
	for x in 1...10{
		closure()
	}
}

//first way to pass a closure
takesClosure(myClosure)

//other way to pass a closure
takesClosure({
	println("other stuff")
})

// MARK: - Tuples
//  --------------------------------------

//Tuples - Essentially a variable that has multiple values with any type

var str = "StringValue"
var num = 1892
let aTuple = (str,num) // passing in other variables

let otherTuple = ("Value1", 2, true, 3.2, "FinalValue") //explicitly creating



var states = ["AZ" : "Arizona", "OH" : "Ohio", "CA" : "California"]

//loop through each state array - using Tuple for the iteration of the Key/Value pairs
for (abbrv, full) in states {
	println("Abbreviation for \(full) is \(abbrv)")
}


//function that returns multiple values (aka, a Tuple)
func getHeightAndWeight() -> (Int, Double) {
	return (72, 154.2)
}

//this variable is a Tuple now
let returnedValue = getHeightAndWeight()

// MARK: - Any and AnyObject
//  --------------------------------------

//Any and AnyObject -- essentially allows all types
// "id" in Objective-C is the same as AnyObject

var aVar : Any //Any
aVar = 5
aVar = "other"
aVar = ("value1", 22)

var aObj : AnyObject
aObj = 2
//error - AnyObject cannot be a Tuple
//aObj = ("value2", 33)

//an array of type AnyObject
var arrAnyObjects : [AnyObject]

//use "is", "as", and "as?" for detecting what type the variable is
var someObject : AnyObject?

someObject = "String"
if someObject != nil && someObject is String {
	println("The value is a string")
}

// MARK: - Classes
//  --------------------------------------

//Class Syntax:

class Person {
	var age = 0
	var name = ""
	
	func someMethod() {
		//do something
	}
}
//  --------------------------------------

