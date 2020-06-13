export class Project {
  id;
  createdby;
  createddate;
  modifiedby;
  modifieddate;
  code;
  name;
  location;
  description;

  constructor(json) {
    this.id = json["id"];
    this.createdby = json["createdby"];
    this.createddate = new Date(json["createddate"]);
    this.modifiedby = json["modifiedby"];
    this.modifieddate = new Date(json["modifieddate"]);
    this.code = json["code"];
    this.name = json["name"];
    this.location = json["location"];
    this.description = json["description"];
  }

  static defaultValues = () => new Project({
    id: 0,
    createdby: 0,
    createddate: new Date(),
    modifiedby: 0,
    modifieddate: new Date(),
    code: "",
    name: "",
    location: "",
    description: ""
  })

  toJson() {
    return {
      id: this.id,
      createdby: this.createdby,
      createddate: this.createddate,
      modifiedBy: this.modifiedby,
      modifieddate: this.modifieddate,
      code: this.code,
      name: this.name,
      location: this.location,
      description: this.description
    };
  }
}
