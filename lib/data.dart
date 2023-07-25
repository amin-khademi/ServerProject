import 'package:dio/dio.dart';

class StudentData {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final int score;
  final String createAt;
  final String updateAt;

  StudentData(this.id, this.firstName, this.lastName, this.course, this.score,
      this.createAt, this.updateAt);

  StudentData.fromjson(Map<String, dynamic> json)
      : id = json["id"],
        firstName = json["first_name"],
        lastName = json["last_name"],
        course = json["course"],
        score = json["score"],
        createAt = json["created_at"],
        updateAt = json["updated_at"];
}

class Httpclient {
  static Dio instance =
      Dio(BaseOptions(baseUrl: "http://expertdevelopers.ir/api/v1/"));
}

Future<List<StudentData>> getstudents() async {
  final response = await Httpclient.instance.get("experts/student");
  print(response.data);
  final List<StudentData> students = [];
  if (response.data is List<dynamic>) {
    (response.data as List<dynamic>).forEach((element) {
      students.add(StudentData.fromjson(element));
    });
  }
  print(students.toString());
  return students;
}

Future<StudentData> saveStudent(
    String firstname, String lastname, String course, int score) async {
  final response = await Httpclient.instance.post("experts/student", data: {
    "first_name": firstname,
    "last_name": lastname,
    "course": lastname,
    "score": score
  });
  if (response.statusCode == 200) {
    return StudentData.fromjson(response.data);
  } else {
    throw Exception();
  }
}
