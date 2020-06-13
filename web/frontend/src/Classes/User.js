export class User {
    id;
    createdby;
    createddate;
    modifiedby;
    modifieddate;
    name;
    role;
    location;
    description;
  
    constructor(json) {
      this.id = json["id"];
      this.createdby = json["createdby"];
      this.createddate = new Date(json["createddate"]);
      this.modifiedby = json["modifiedby"];
      this.modifieddate = new Date(json["modifieddate"]);
      this.name = json["name"];
      this.role = json["role"];
      this.email = json["email"];
      this.password = json["password"];
    }
  
    toJson() {
      return {
        id: this.id,
        createdby: this.createdby,
        createddate: this.createddate,
        modifiedby: this.modifiedby,
        modifieddate: this.modifieddate,
        name: this.name,
        role: this.role,
        email: this.email,
        password: this.password
      };
    }
  }
  