export class Structure {
  id;
  createdby;
  createddate;
  modifiedby;
  modifieddate;
  code;
  name;
  type;
  strike;
  dip;
  plunge;
  trend;
  description;

  constructor(json) {
    this.id = json["id"];
    this.createdby = json["createdby"];
    this.createdDate = new Date(json["createddate"]);
    this.modifiedby = json["modifiedby"];
    this.modifieddate = new Date(json["modifieddate"]);
    this.code = json["code"];
    this.name = json["name"];
    this.type = json["type"];
    this.dip = json["dip"];
    this.strike = json["strike"];
    this.plunge = json["plunge"];
    this.trend = json["trend"];
    this.structure = json['structure']
    this.description = json["description"];
  }

  toJson() {
    return {
      id: this.id,
      createdby: this.createdBy,
      createddate: this.createdDate?.getTime(),
      modifiedby: this.modifiedBy,
      modifieddate: this.modifiedDate?.getTime(),
      code: this.code,
      name: this.name,
      type: this.type,
      dip: this.dip,
      strike: this.strike,
      plunge: this.plunge,
      trend: this.trend,
      description: this.description
    };
  }
}
