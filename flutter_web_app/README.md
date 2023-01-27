# Web Application
A web-app to work with an NBA Ontology, made with Flutter.

## Avoid CORS problems
If **Android Studio** or **VSCode** are used to **debug** the Web Application, some related CORS errors can occur. 
To **solve** this problem, according to this [page](https://pub.dev/packages/flutter_cors/),  just run those two commands :
```
dart pub global activate flutter_cors
fluttercors --disable
```
Remember that, if you want to **undo** such an operation you just need to type :
```
fluttercors --enable
```