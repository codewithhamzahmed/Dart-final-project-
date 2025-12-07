
serviceMenuD() {
  print("""
    ====**===========**===
    ||   Service Menu   ||
    ====**===========**===
""");
  print(  "1. Add Service");
  print(  "2. View Services");
  print(  "3. Update Service");
  print(  "4. Delete Service");
  print(  "5. Search Service");
  print(  "6. Hide Service");
  print(  "7. Show Hidden Services");
}

//user menu for patient
serviceMenuP() {
  print("""
    ====**===========**===
    ||   Service Menu   ||
    ====**===========**===
""");
  print(  "1. Add Service");
  print(  "2. View Services");
  print(  "3. Update Service");
  print(  "4. Delete Service");
  print(  "5. Search Service");
  print(  "6. Hide Service");
  print(  "7. Show Hidden Services");
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

mainMenu() {
  print("""
    ====**===========**===
    ||   Main Menu   ||
    ====**===========**===
""");
  print("2. All Service");
  print("3. Appointment Management");
  print("4. Billing Management");
  print("5. Report Management");
  print("6. Logout");

  stdout.write("Please select an option (0-6): ");
  final mainMenuInput = stdin.readLineSync();

  switch (mainMenuInput){
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
    default:
      print(" Please try again.");
  }
}









/***
 * ====**===========================**====
 * ||                                   ||
   ||   This is for just Doctor Role    ||
 * ||                                   ||
   ====**==========================**=====
 */


mainMenuDoctor() {
  print("""
    ====**===========**===
    ||   Main Menu   ||
    ====**===========**===
""");
  print("1. Patient Management");
  print("2. Service Management");
  print("3. Appointment Management");
  print("4. Billing Management");
  print("5. Report Management");
  print("6. Logout");

  stdout.write("Please select an option (0-6): ");
  final mainMenuInput = stdin.readLineSync();

  switch (mainMenuInput){
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
    default:
      print(" Please try again.");
  }
}
