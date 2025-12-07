import 'dart:convert';
import 'dart:io';

void main() async {
  print("Welcome to the S-Care Management System");

  loadAllData();
  loadUsers();
  authMenu();
  
}

// Login system

const String userFile = 'users.json';
List users = [];
List patients = [];
List services = [];
List appointments = [];
List bills = [];
Map? currentUser;

// Load All Data

loadAllData() async {
  users = await readJsonFile('users.json');
  patients = await readJsonFile('patients.json');
  services = await readJsonFile('services.json');
  appointments = await readJsonFile('appointments.json');
  bills = await readJsonFile('bills.json');
}

// JSON File Reader

readJsonFile(String fileName) async {
  final file = File(fileName);

  if (!await file.exists()) {
    await file.writeAsString('[]'); // agar file empty ho tu list banado
  }

  final content = await file.readAsString();
  return jsonDecode(content);
}

// Load Users

loadUsers() {
  final file = File(userFile);

  if (!file.existsSync()) {
    file.writeAsStringSync(jsonEncode([]));
  }
  final usersString = file.readAsStringSync();
  users = jsonDecode(usersString);
}

// Save Users

saveUsers() {
  final file = File(userFile);
  file.writeAsStringSync(jsonEncode(users));
}

// Register Users for normal users not for doctor

registerUsers() {
  print("""
    =====**===========**====
    ||   Register Users   ||
    =====**===========**====
""");

  stdout.write("name: ");
  String? name = stdin.readLineSync();

  stdout.write("email: ");
  String? email = stdin.readLineSync();

  stdout.write("username: ");
  String? username = stdin.readLineSync();

  stdout.write("password: ");
  String? password = stdin.readLineSync();

  bool ifUserExists = users.any((u) => u['username'] == username);

  if (ifUserExists) {
    print("Username already exists. Please try again.");
    return;
  }

  users.add({"name": name, "email": email, "username": username, "password": password, "role": 'users' });
  saveUsers();
  print("User Registered Successfully. You can now log in.");
  return loginUser();
}

//Loign User

loginUser() {
  loadUsers();
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

    final ifUserFound = users.firstWhere(
      (u) => u['username'] == username && u['password'] == password,
      orElse: () => null,
    );

    if (ifUserFound == null) {
      attempts++;
      print("Invalid username or password. Please try again.");

      if (attempts == 3) {
        print("\nYou failed 3 times!");
        print("1. Try Again");
        print("2. Return to Auth Menu");

        stdout.write("Choose: ");
        final loginNullOptions = stdin.readLineSync();

        switch (loginNullOptions) {
          case "1":
            attempts = 0;
            return loginUser(); // reset attempts and try again

          case "2":
            return authMenu(); // return to auth menu
        }
      }

      continue;
    }

    currentUser = ifUserFound;

    print("Login Successful. Welcome ${currentUser?['username']}");
    return normalUserMenu();
  }
}

// Logout User

logoutUser() {
  currentUser = null;
  print("You have been logged out.");
  return authMenu();
}

//Auth Menu

authMenu() {
  print("""\n
    ====**===========**===
    ||   Auth Menu    ||
    ====**===========**===
""");
  print("1. Login");
  print("2. Register");
  print("0. Exit");

  stdout.write("Please Choose Option: ");
  final authMenuInput = stdin.readLineSync();

  switch (authMenuInput) {
    case "0":
      print("Exiting the system. Goodbye!🤗🌷");
      exit(0);
    case "1":
      loginUser();
      // if(currentUser != null)return normalUserMenu();
      break;
    case "2":
      registerUsers();
      break;
    default:
      print("Please try again.");
  }
}

myProfile() {
  print("\n==== My Profile ====");
  print("Name: ${currentUser?['name']}");
  print("Email: ${currentUser?['email']}");
  print("Username: ${currentUser?['username']}");
  print("Role: ${currentUser?['role']}");

  print("\nPress Enter to return to the Normal User Menu.");
  stdin.readLineSync();
  return normalUserMenu();
}
//User Profile Page menu
userProfileMenu() {
  print("""
    ====**================**===
    ||   Update My Profile   ||
    ====**================**===
""");
  if (currentUser != null) {
    print("No user is currently logged in.");
  }

  while (true) {
    print("Username: ${currentUser?['username']}");
    print("Role: ${currentUser?['role']}");
    
    print('\n 1. Update Name');
    print('2. Update Email');
    print('3. Update Password');
    print('4. Update Address');
    print('0. Back to Normal User Menu');

    stdout.write('Choose: ');
    final choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        // updateUserPassword();
        updateUserName();
        break;
      case '2':
        updateUserEmail();
        break;
      case '3':
        updateUserPassword();
        break;
      case '4':
        updateUserAdress();
        break;
      case '0':
        return;
      default:
        print('Invalid choice.');
    }
  }
}

/// Updating User Field start Here

updateUserName() {
  print("""
    ==***==********==***==
    || Update User Name ||
    ==***==********==***==
""");
  print("If this field is left empty, the current value will remain unchanged.");
  stdout.write("\n New name: ");
  final newName = stdin.readLineSync();
  if (newName != null && newName.isNotEmpty) {
    currentUser!['name'] = newName;}

  saveUsers();
  print("Name Updated Successfully!");
}

updateUserEmail() {
  print("""
    ==***==********==***==
    || Update User Email ||
    ==***==********==***==
""");
  print("If this field is left empty, the current value will remain unchanged.");
  stdout.write("\n New email: ");
  final newEmail = stdin.readLineSync();
  if (newEmail != null && newEmail.isNotEmpty) {
    currentUser!['email'] = newEmail;}
  saveUsers();
  print("Email Updated Successfully!");
}

updateUserPassword() {
  print("""
    ==***==********==***==
    || Update User Password ||
    ==***==********==***==
""");
  print("If this field is left empty, the current value will remain unchanged.");
  stdout.write("\n New password: ");
  final newPassword = stdin.readLineSync();
  if (newPassword != null && newPassword.isNotEmpty) {
    currentUser!['password'] = newPassword;}
  saveUsers();
  print("Password Updated Successfully!");
}

updateUserAdress() {
  print("""
    ==***==********==***==
    || Update User Address ||
    ==***==********==***==
""");
  print("(Optional) Leave blank to not change this field.");
  stdout.write("\n New address: ");
  currentUser!['address'] = stdin.readLineSync();
  saveUsers();
  print("Address Updated Successfully!");
}

/// Updating User Field Ends Here

serviceList(){
//   =======================
//   💆 Skin Clinic Services
//   =======================

// Temporary services data 
List services = [
  {
    "id": 1,
    "category": "Skin Treatment",
    "name": "Acne Treatment",
    "price": 3500
  },
  {
    "id": 2,
    "category": "Skin Treatment",
    "name": "Skin Whitening Facial",
    "price": 4500
  },
  {
    "id": 3,
    "category": "Hair Treatment",
    "name": "Hair PRP",
    "price": 8000
  },
  {
    "id": 4,
    "category": "Laser",
    "name": "Full Face Laser",
    "price": 6000
  },
  {
    "id": 5,
    "category": "Laser",
    "name": "Full Body Laser",
    "price": 16000
  },
];

}





patientMenu() {
  print("""
    ====**===========**===
    ||   Patient Menu   ||
    ====**===========**===
""");
  print("1. Add Patient");
  print("2. View Patients");
  print("3. Update Patient");
  print("4. Delete Patie====nt");
  print("0. Back to Normal User Menu");

  stdout.write("Plese Choose Option: ");
  final patientMenuInput = stdin.readLineSync();

  switch (patientMenuInput) {
    case "0":
      return;
    case "1":
      // addPtient();
      print('Adding patient...');
      break;
    case "2":
      // viewPatients();
      print('Viewing patients...');
      break;
    case "3":
      // updatePatient();
      print('Updating patient...');
      break;
    case "4":
      // deletePatient();
      print('Deleting patient...');
      break;
    default:
      print("Please try again.");
  }
}

serviceMenuD() {
  print("""
    ====**===========**===
    ||   Service Menu   ||
    ====**===========**===
""");
  print("1. Add Service");
  print("2. View Services");
  print("3. Update Service");
  print("4. Delete Service");
  print("5. Search Service");
  print("6. Hide Service");
  print("7. Show Hidden Services");
}

//user menu for patient
serviceMenuP() {
  print("""
    ====**===========**===
    ||   Service Menu   ||
    ====**===========**===
""");
  print("1. Add Service");
  print("2. View Services");
  print("3. Update Service");
  print("4. Delete Service");
  print("5. Search Service");
  print("6. Hide Service");
  print("7. Show Hidden Services");
}

appointmentMenu() {
  print("""
    ====**===============**===
    ||   Appointment Menu   ||
    ====**===============**===
""");
}

billingMenu() {
  print("""
    ====**===========**===
    ||   Billing Menu   ||
    ====**===========**===
""");
}

reportMenu() {
  print("""
    ====**===========**===
    ||   Report Menu   ||
    ====**===========**===
""");
}

normalUserMenu() {
  print("""
    ====**===============**===
    ||   Normal User Menu   ||
    ====**===============**===
""");
  print("1. Patient Management");
  print("2. Service Management");
  print("3. Appointment Management");
  print("4. Billing Management");
  print("5. Report Management");
  print("6. Logout");
  print("7. Update Profile");
  print("8. View Profile");

  stdout.write("Please select an option (0-8): ");
  final normalUserMenuInput = stdin.readLineSync();

  switch (normalUserMenuInput) {
    case "1":
      patientMenu();
      break;
    case "2":
      serviceMenuP();
      break;
    case "3":
      appointmentMenu();
      break;
    case "4":
      billingMenu();
      break;
    case "5":
      reportMenu();
      break;
    case "6":
      logoutUser();
      print("Thank you for using the S-Care Management System. Goodbye!🤗🌷");
      return;
    case "7":
      userProfileMenu();
      break;
    case "8":
      myProfile();
      break;
    default:
      print(" Please try again.");
  }
}
 

viewServicesForUser() {
  print("\n==== Available Services ====");
  
  if (services.isEmpty) {
    print("No services found.");
    return;
  }

  for (var s in services) {
    if (s["hidden"] == true) continue;

    print("""
           Service ID: ${s['id']}
           Name: ${s['name']}
           Price: ${s['price']}
           Description: ${s['description']}
          ---------------------------
""");
  }
}


bookAppointment() {
  print("\n==== Book Appointment ====");
  viewServicesForUser();  // show services first
  stdout.write("Enter Service ID to book: ");
  String? serviceId = stdin.readLineSync();

  var service = services.firstWhere(
    (s) => s["id"].toString() == serviceId && s["hidden"] != true,
    orElse: () => null,
  );

  if (service == null) {
    print("Invalid Service ID.");
    return;
  }

  stdout.write("Enter Appointment Date (DD-MM-YYYY): ");
  String? date = stdin.readLineSync();

  Map<String, dynamic> newAppt = {
    "id": appointments.length + 1,
    "user": currentUser!["username"],
    "service": service["name"],
    "date": date
  };

  appointments.add(newAppt);

  File("appointments.json")
      .writeAsStringSync(jsonEncode(appointments));

  print("Appointment booked successfully!");
}


viewMyAppointments() {
  print("\n==== My Appointments ====");

  var myList = appointments
      .where((a) => a["user"] == currentUser!["username"])
      .toList();

  if (myList.isEmpty) {
    print("You have no appointments.");
    return;
  }

  for (var a in myList) {
    print("""
Appointment ID: ${a["id"]}
Service: ${a["service"]}
Date: ${a["date"]}
-----------------------
""");
  }
}


cancelMyAppointment() {
  print("\n==== Cancel Appointment ====");

  viewMyAppointments();

  stdout.write("Enter Appointment ID to cancel: ");
  String? id = stdin.readLineSync();

  var appt = appointments.firstWhere(
    (a) => a["id"].toString() == id && a["user"] == currentUser!["username"],
    orElse: () => null,
  );

  if (appt == null) {
    print("Invalid Appointment ID.");
    return;
  }

  appointments.remove(appt);

  File("appointments.json")
      .writeAsStringSync(jsonEncode(appointments));

  print("Appointment cancelled successfully!");
}

viewMyBills() {
  print("\n==== My Bills ====");

  final userBills = bills.where(
    (b) => b['username'] == currentUser!['username']
  ).toList();

  if (userBills.isEmpty) {
    print("No bills found.");
    return;
  }

  for (var b in userBills) {
    print("Service: ${b['service']}");
    print("Amount: Rs ${b['amount']}");
    print("Status: ${b['status']}");
    print("------------------------");
  }
}











/***
 * ====**===========================**====
 * ||                                   ||
   ||   This is for just Doctor Role    ||
 * ||                                   ||
   ====**==========================**=====
 */