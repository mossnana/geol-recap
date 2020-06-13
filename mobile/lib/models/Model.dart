class Project {
  int id;
  String name;
  String location;
  String description;
  int createdBy;
  DateTime createdDate;
  int modifiedBy;
  DateTime modifiedDate;

  Project({
    this.id,
    this.name,
    this.location,
    this.description,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory Project.fromJson(Map project) => Project(
    id: project['id'],
    name: project.nullProtect('name', 'Unknown'),
    location: project.nullProtect('location', 'Unknown'),
    description: project.nullProtect('description', 'Unknown'),
    createdBy: project.nullProtect('createdBy', 1),
    createdDate: DateTime.fromMillisecondsSinceEpoch(project.nullProtect('createdDate', 1000)),
    modifiedBy: project.nullProtect('modifiedBy', 1),
    modifiedDate: DateTime.fromMillisecondsSinceEpoch(project.nullProtect('modifiedDate', 1000))
  );

  Map toJson() => {
    'id': this.id,
    'name': this.name,
    'location': this.location,
    'description': this.description,
    'createdBy': this.createdBy,
    'createdDate': this.createdDate.millisecondsSinceEpoch,
    'modifiedBy': this.modifiedBy,
    'modifiedDate': this.modifiedDate.millisecondsSinceEpoch,
  };
}

class Checkpoint {
  int id;
  int projectId;
  String name;
  String landmark;
  String description;
  double height;
  double width;
  double latitude;
  double longitude;
  String zone;
  double north;
  double east;
  int createdBy;
  DateTime createdDate;
  int modifiedBy;
  DateTime modifiedDate;

  Checkpoint({
    this.id,
    this.projectId,
    this.name,
    this.landmark,
    this.description,
    this.height,
    this.width,
    this.latitude,
    this.longitude,
    this.zone,
    this.north,
    this.east,
    this.createdBy,
    this.createdDate,
    this.modifiedBy,
    this.modifiedDate,
  });

  factory Checkpoint.fromJson(Map checkpoint) => Checkpoint(
    id: checkpoint['id'],
    projectId: checkpoint['projectId'],
    name: checkpoint['name'],
    landmark: checkpoint['landmark'],
    description: checkpoint['description'],
    height: checkpoint['height'],
    width: checkpoint['width'],
    latitude: checkpoint['latitude'],
    longitude: checkpoint['longitude'],
    zone: checkpoint['zone'],
    north: checkpoint['north'],
    east: checkpoint['east'],
    createdBy: checkpoint['createdBy'],
    createdDate: checkpoint['createdDate'],
    modifiedBy: checkpoint['modifiedBy'],
    modifiedDate: checkpoint['modifiedDate'],
  );

  Map<String, dynamic> toJson() => {
    'id': this.id,
    'projectId': this.projectId,
    'name': this.name,
    'landmark': this.landmark,
    'description':this.description,
    'height': this.height,
    'width': this.width,
    'latitude': this.latitude,
    'longitude': this.longitude,
    'zone': this.zone,
    'north': this.north,
    'east': this.east,
    'createdBy': this.createdBy,
    'createdDate': this.createdDate,
    'modifiedBy': this.modifiedBy,
    'modifiedDate': this.modifiedDate,
  };
}

extension MapExtensions<T, K> on Map<T, K> {
  K getOrNull(T key) {
    if (this == null || !this.containsKey(key)) {
      return null;
    } else {
      return this[key];
    }
  }

  K nullProtect(T key, K fallback) {
    return this.getOrNull(key) ?? fallback;
  }
}