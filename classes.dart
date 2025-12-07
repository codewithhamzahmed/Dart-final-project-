// class Person{
//   String name = "yousuf";
//   int age = 18;
  
//   // Person(this.name, this.age);
// }

// class Male extends Person{
//   walking(){
//     print("$name is walking");
//   }
// }


// void main() {
//   var person = Male();
//   print(person.walking());
// }

loginUser() {
  print("""
    ===**===========**===
    ||   Login Users   ||
    ===**===========**===
  """);

  int attempts = 0;

  while (attempts < 3) {
    stdout.write("username: ");
    String? username = stdin.readLineSync();

    stdout.write("password: ");
    String? password = stdin.readLineSync();

    final user = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => null,
    );

    if (user == null) {
      attempts++;
      print("Invalid username or password. Attempt $attempts/3");

      if (attempts == 3) {
        print("\nYou failed 3 times!");
        print("1. Try Again");
        print("2. Return to Auth Menu");

        stdout.write("Choose: ");
        String? again = stdin.readLineSync();

        if (again == "1") {
          attempts = 0;  
          continue;      
        } else {
          return false; // ❌ login failed → authMenu wapis
        }
      }

      continue;
    }

    /// SUCCESS LOGIN
    currentUser = user;
    print("Login Successful. Welcome ${user['username']}");
    return true; // success
  }

  return false;
}
