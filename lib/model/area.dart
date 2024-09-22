class Area {
  final String name;

  Area({
    required this.name,
  });

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      name: json['strArea'],
    );
  }
}

class AreaList {
  final List<Area> areas;

  AreaList({required this.areas});

  factory AreaList.fromJson(Map<String, dynamic> json) {
    var areasJson = json['meals'] as List;
    List<Area> areaList = areasJson.map((area) => Area.fromJson(area)).toList();

    return AreaList(areas: areaList);
  }
}
