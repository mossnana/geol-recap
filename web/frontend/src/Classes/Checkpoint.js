export class Checkpoint {
  id;
  createdby;
  createddate;
  modifiedby;
  modifieddate;
  projectid;
  name;
  landmark;
  description;
  height;
  width;
  latitude;
  longitude;
  zone;
  north;
  east;
  elevation;
  source;
  uploadby;

  constructor(json) {
    this.id = json["id"];
    this.createdby = json["createdby"];
    this.createddate = new Date(json["createddate"]);
    this.modifiedby = json["modifiedby"];
    this.modifieddate = new Date(json["modifieddate"]);
    this.projectid = json["projectid"];
    this.name = json["name"];
    this.landmark = json["landmark"];
    this.description = json["description"];
    this.height = json["height"];
    this.width = json["width"];
    this.latitude = json["latitude"];
    this.longitude = json["longitude"];
    this.zone = json["zone"];
    this.north = json["north"];
    this.east = json["east"];
    this.elevation = json["elevation"];
    this.source = json["source"];
    this.uploadby = json["uploadby"];
  }

  toJson() {
    return {
      id: this.id,
      createdby: this.createdby,
      createddate: this.createddate?.getTime(),
      modifiedby: this.modifiedBy,
      modifieddate: this.modifieddate?.getTime(),
      name: this.name,
      landmark: this.landmark,
      description: this.description,
      height: this.height,
      width: this.width,
      latitude: this.latitude,
      longitude: this.longitude,
      zone: this.zone,
      north: this.north,
      east: this.east,
      elevation: this.elevation,
      source: this.source,
      uploadby: this.uploadby
    };
  }
}
