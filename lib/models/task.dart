class Task {
  int? id;
  String? title;
  String? note;
  String? date;
  String? startTime;
  String? endTime;
  int? isCompleted;
  int? boardId;
  int? remind;
  String? repeat;
  String? taskStatusUpdatedOn;

  Task(
      {this.id,
      this.title,
      this.note,
      this.date,
      this.startTime,
      this.endTime,
      this.isCompleted,
      this.boardId,
      this.remind,
      this.repeat,
      this.taskStatusUpdatedOn});

  setRemind(int updatedRemind) {
    remind = updatedRemind;
  }

  setRepeat(String updatedRepeat) {
    repeat = updatedRepeat;
  }

  setBoardId(int updatedBoardId) {
    boardId = updatedBoardId;
  }

  setStartTime(String updatedStartTime) {
    startTime = updatedStartTime;
  }

  setEndTime(String updatedEndTime) {
    endTime = updatedEndTime;
  }

  setTitle(String updatedTitle) {
    title = updatedTitle;
  }

  setNote(String updatedNote) {
    note = updatedNote;
  }

  setDate(String updatedDate) {
    date = updatedDate;
  }

  setTaskStatusUpdatedOn(String updatedDate) {
    taskStatusUpdatedOn = updatedDate;
  }

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    isCompleted = json['isCompleted'];
    boardId = json['boardId'];
    remind = json['remind'];
    repeat = json['repeat'];
    taskStatusUpdatedOn = json['taskStatusUpdatedOn'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['isCompleted'] = isCompleted;
    data['boardId'] = boardId;
    data['remind'] = remind;
    data['repeat'] = repeat;
    data['taskStatusUpdatedOn'] = taskStatusUpdatedOn;
    return data;
  }
}
