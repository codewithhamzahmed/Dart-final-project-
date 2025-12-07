import 'dart:io';

// ===================================================================
// TEMPORARY STORAGE (NO JSON FILES)
// ===================================================================
List users = [];
Map? currentUser;

List services = [
  {
    "id": 1,
    "name": "Acne Treatment",
    "category": "Skin Treatment",
    "price": 3500,
    "detail":
        "This treatment helps remove acne, reduce marks, and clean your skin deeply."
  },
  {
    "id": 2,
    "name": "Skin Whitening Facial",
    "category": "Skin Treatment",
    "price": 4500,
    "detail":
        "This facial improves skin tone, gives glow, and removes dullness from your face."
  },
  {
    "id": 3,
    "name": "Hair PRP",
    "category": "Hair Treatment",
    "price": 8000,
    "detail":
        "This treatment helps in hair regrowth, reduces hair fall, and strengthens hair roots."
  },
  {
    "id": 4,
    "name": "Full Face Laser",
    "category": "Laser",
    "price": 6000,
    "detail":
        "This laser treatment removes unwanted facial hair and gives smooth skin."
  },
  {
    "id": 5,
    "name": "Full Body Laser",
    "category": "Laser",
    "price": 16000,
    "detail":
        "A complete laser session for your full body to remove unwanted hair permanently."
  },
];

List bookings = [];

void main() {
  while (true) {
    print("""
=======================
||   Skin Clinic App  ||
=======================
1. Login
2. Signup
3. Exit
""");

    stdout.write("Choose option: ");
    String choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        loginUser();
        break;
      case '2':
        signupUser();
        break;
      case '3':
        print("Exiting... Goodbye!");
        return;
      default:
        print("Invalid option. Try again.");
    }
  }
}

// ===================================================================
// USER SIGNUP
// ===================================================================
signupUser() {
  print("\n====== User Signup ======");
  stdout.write("Enter name: ");
  String name = stdin.readLineSync() ?? '';

  stdout.write("Enter email: ");
  String email = stdin.readLineSync() ?? '';

  stdout.write("Enter password: ");
  String pass = stdin.readLineSync() ?? '';

  Map newUser = {
    "name": name,
    "email": email,
    "password": pass,
    "address": "",
  };

  users.add(newUser);

  print("\nSignup successful! You can now login.\n");
}

// ===================================================================
// USER LOGIN
// ===================================================================
loginUser() {
  print("\n====== Login ======");
  stdout.write("Email: ");
  String email = stdin.readLineSync() ?? '';

  stdout.write("Password: ");
  String pass = stdin.readLineSync() ?? '';

  for (var u in users) {
    if (u['email'] == email && u['password'] == pass) {
      currentUser = u;
      print("\nLogin successful!\n");
      userMenu();
      return;
    }
  }

  print("\nIncorrect email or password.\n");
}

// ===================================================================
// USER MENU
// ===================================================================
userMenu() {
  while (true) {
    print("""
====**===============**===
||   Normal User Menu   ||
====**===============**===

1. View All Services
2. Search Service by ID
3. Search Service by Name
4. View My Bookings
5. View My Profile
6. Update My Profile
7. Logout
""");

    stdout.write("Choose option: ");
    String choice = stdin.readLineSync() ?? '';

    if (choice == '1') viewAllServices();
    else if (choice == '2') searchServiceByID();
    else if (choice == '3') searchServiceByName();
    else if (choice == '4') viewMyBookings();
    else if (choice == '5') viewMyProfile();
    else if (choice == '6') updateMyProfile();
    else if (choice == '7') {
      currentUser = null;
      print("\nLogged out.\n");
      return;
    } else {
      print("Invalid option. Try again.");
    }
  }
}

// ===================================================================
// VIEW ALL SERVICES
// ===================================================================
viewAllServices() {
  print("\n======= All Services =======\n");

  for (var s in services) {
    print("${s['id']}. ${s['name']} — Rs ${s['price']}");
  }

  stdout.write("\nEnter service ID to view details (or 0 to go back): ");
  String input = stdin.readLineSync() ?? '';
  int id = int.tryParse(input) ?? -1;

  if (id == 0) return;

  var service = services.firstWhere(
    (s) => s['id'] == id,
    orElse: () => null,
  );

  if (service == null) {
    print("Service not found.");
    return;
  }

  serviceDetail(service);
}

// ===================================================================
// SEARCH BY ID
// ===================================================================
searchServiceByID() {
  stdout.write("\nEnter Service ID: ");
  int id = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

  var s = services.firstWhere(
    (x) => x['id'] == id,
    orElse: () => null,
  );

  if (s == null) print("No service found.");
  else serviceDetail(s);
}

// ===================================================================
// SEARCH BY NAME
// ===================================================================
searchServiceByName() {
  stdout.write("\nEnter service name: ");
  String name = stdin.readLineSync()!.toLowerCase();

  var results = services.where(
    (s) => s['name'].toLowerCase().contains(name),
  ).toList();

  if (results.isEmpty) {
    print("No matching services found.");
    return;
  }

  for (var s in results) {
    print("${s['id']}. ${s['name']} — Rs ${s['price']}");
  }

  stdout.write("\nSelect Service ID to view details: ");
  int id = int.tryParse(stdin.readLineSync() ?? '') ?? -1;

  var chosen = results.firstWhere(
    (x) => x['id'] == id,
    orElse: () => null,
  );

  if (chosen == null) print("Invalid ID.");
  else serviceDetail(chosen);
}

// ===================================================================
// SERVICE DETAILS + READ MORE + BOOK
// ===================================================================
serviceDetail(Map s) {
  bool expanded = false;

  while (true) {
    print("\n======= Service Details =======");
    print("Name    : ${s['name']}");
    print("Category: ${s['category']}");
    print("Price   : Rs ${s['price']}");

    String d = s['detail'];

    if (!expanded && d.length > 80) {
      print("\nDescription: ${d.substring(0, 80)}...");
      print("1. Read More");
    } else {
      print("\nDescription: $d");
      if (d.length > 80) print("1. Read Less");
    }

    print("2. Book Service");
    print("3. Back");

    stdout.write("Choose option: ");
    String c = stdin.readLineSync() ?? '';

    if (c == '1') expanded = !expanded;
    else if (c == '2') {
      bookService(s);
      return;
    } else if (c == '3') return;
    else print("Invalid choice.");
  }
}

// ===================================================================
// BOOK SERVICE (Temporary store)
// ===================================================================
bookService(Map s) {
  bookings.add({
    "user": currentUser!['email'],
    "service": s['name'],
    "price": s['price'],
    "time": DateTime.now().toString(),
  });

  print("\nService booked successfully!\n");
}

// ===================================================================
// VIEW MY BOOKINGS (BILLS)
// ===================================================================
viewMyBookings() {
  print("\n====== My Bookings ======\n");

  var my = bookings.where(
    (b) => b['user'] == currentUser!['email'],
  );

  if (my.isEmpty) {
    print("No bookings yet.");
    return;
  }

  for (var b in my) {
    print("- ${b['service']} — Rs ${b['price']}  (${b['time']})");
  }
}

// ===================================================================
// VIEW PROFILE
// ===================================================================
viewMyProfile() {
  print("""
====== My Profile ======

Name     : ${currentUser!['name']}
Username : ${currentUser!['username']}
Email    : ${currentUser!['email']}
Address  : ${currentUser!['address']}
""");
}

// ===================================================================
// UPDATE PROFILE 
// ===================================================================
updateMyProfile() {
  print("\n====== Update Profile ======");

  stdout.write("New name (press Enter to keep current): ");
  String name = stdin.readLineSync() ?? '';
  if (name.isNotEmpty) currentUser!['name'] = name;

  stdout.write("New email (press Enter to keep current): ");
  String email = stdin.readLineSync() ?? '';
  if (email.isNotEmpty) currentUser!['email'] = email;

  stdout.write("New address (press Enter to keep current): ");
  String address = stdin.readLineSync() ?? '';
  if (address.isNotEmpty) currentUser!['address'] = address;
  
  stdout.write("New password (press Enter to keep current): ");
  String password = stdin.readLineSync() ?? '';
  if (password.isNotEmpty) currentUser!['password'] = password;

  print("\nProfile updated!\n");
}
