# jael
[![Pub](https://img.shields.io/pub/v/jael.svg)](https://pub.dartlang.org/packages/jael)
[![build status](https://travis-ci.org/angel-dart/jael.svg)](https://travis-ci.org/angel-dart/jael)

A simple server-side HTML templating engine for Dart.

Though its syntax is but a superset of HTML, it supports features such as:
* Loops
* Conditionals
* Template inheritance
* Block scoping
* `switch` syntax
* Interpolation of any Dart expression

Jael is a good choice for applications of any scale, especially when the development team is small,
or the time invested in building an SPA would be too much.

## This Repository
Within this repository are three packages:

* `package:jael` - Contains the Jael parser, AST, and HTML renderer.
* `package:jael_preprocessor` - Handles template inheritance, and facilitates the use of "compile-time" constructs.
* `package:angel_jael` - [Angel](https://angel-dart.github.io) support for Jael. Angel contains other
facilities to speed up application development, so something like Jael is right at home.