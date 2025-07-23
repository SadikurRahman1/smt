class DataModel {
  String? id;
  String? name;
  Data? data;

  DataModel({this.id, this.name, this.data});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? color;
  String? capacity;
  // String? price;

  Data({this.color, this.capacity, });

  Data.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    capacity = json['capacity'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['capacity'] = capacity;

    return data;
  }
}
