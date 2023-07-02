class Board {
  int? id;
  String? boardName;
  int? color;
  int? isPredefined;

  Board({this.id, this.boardName, this.color, this.isPredefined});

  Board.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    boardName = json['boardName'];
    color = json['color'];
    isPredefined = json['isPredefined'];
  }

  setName(String updatedBoardName) {
    boardName = updatedBoardName;
  }

  setColor(int colorIndex) {
    color = colorIndex;
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['id'] = id;
    data['boardName'] = boardName;
    data['color'] = color;
    data['isPredefined'] = isPredefined;
    return data;
  }
}
