// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract StudentManager {
    struct Student {
        uint256 id;
        string name;
        uint8 age;
        string course;
    }

    Student[] private students;
    mapping(uint256 => uint256) private idx;
    uint256 public studentCount;

    event StudentAdded(uint256 indexed id, string name);
    event StudentUpdated(uint256 indexed id);
    event StudentRemoved(uint256 indexed id);

    function addStudent(
        string calldata _name,
        uint8 _age,
        string calldata _course
    ) external {
        studentCount++;
        students.push(Student(studentCount, _name, _age, _course));
        idx[studentCount] = students.length;
        emit StudentAdded(studentCount, _name);
    }

    function getStudent(uint256 _id) public view returns (Student memory) {
        uint256 i = idx[_id];
        require(i != 0, "Student not found");
        return students[i - 1];
    }

    function getAllStudents() external view returns (Student[] memory) {
        return students;
    }

    function updateStudent(
        uint256 _id,
        string calldata _name,
        uint8 _age,
        string calldata _course
    ) external {
        uint256 i = idx[_id];
        require(i != 0, "Student not found");

        Student storage s = students[i - 1];
        s.name = _name;
        s.age = _age;
        s.course = _course;

        emit StudentUpdated(_id);
    }

    function removeStudent(uint256 _id) external {
        uint256 i = idx[_id];
        require(i != 0, "Student not found");

        uint256 arrayIndex = i - 1;
        uint256 lastIndex = students.length - 1;

        if (arrayIndex != lastIndex) {
            Student memory lastStudent = students[lastIndex];
            students[arrayIndex] = lastStudent;
            idx[lastStudent.id] = arrayIndex + 1;
        }

        students.pop();
        idx[_id] = 0;

        emit StudentRemoved(_id);
    }

    // function getStudentsLength() external view returns (uint256) {
    //     return students.length;
    // }
}
