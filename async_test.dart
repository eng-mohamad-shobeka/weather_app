import 'dart:io';

void main() {
  task1();
  // oTask2and3();
  Future<String> dataInFuture = task2();
  dataInFuture.then((value) => task3(value));
  task4();
}

/*void doTask2and3() async {
  String data = await task2();
  task3(data);
}*/

void task1() {
  print("Task1 complete");
}

Future<String> task2() async {
  String data = "initial data";
  await Future.delayed(Duration(seconds: 3), () {
    print("Task2 complete");
    data = "Task 2 Data";
  });
  return data;
}

void task3(String data) {
  print("Task3 complete with $data");
}

void task4() {
  print("Task4 complete");
}
