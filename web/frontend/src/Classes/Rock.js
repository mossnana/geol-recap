export class Rock {
  id;
  createdby;
  createddate;
  modifiedby;
  modifieddate;
  code;
  name;
  description;
  lithodescription;
  type;

  constructor(json) {
    this.id = json["id"];
    this.createdby = json["createdby"];
    this.createddate = new Date(json["createddate"]);
    this.modifiedby = json["modifiedby"];
    this.modifieddate = new Date(json["modifieddate"]);
    this.code = json["code"];
    this.name = json["name"];
    this.description = json["description"];
    this.lithodescription = json["lithologydescription"];
    this.type = json["type"];
  }

  getType() {
    if(this.type === 'sedimentary') {
      return 'Sedimentary Rock'
    } else if(this.type === 'igneous') {
      return 'Igneous Rock'
    } else {
      return 'Metamorphic Rock'
    }
  }

  static fromJson(json) {
    let type = json['type']
    if(type === 'sedimentary') {
      return new SedimentaryRock(json)
    } else if(type === 'igneous') {
      return new IgneousRock(json);
    } else {
      return new MetamorphicRock(json)
    }
  }
}

export class SedimentaryRock extends Rock {
  lithology;
  fossil;
  otherfossil;
  dip;
  strike;
  structure;
  grainsize;
  grainmorphology;

  constructor(json) {
    super(json);
    this.lithology = json["lithology"];
    this.fossil = json["fossil"];
    this.otherfossil = json["otherfossil"];
    this.dip = json["dip"];
    this.strike = json["strike"];
    this.structure = json["structure"];
    this.grainsize = json["grainsize"];
    this.grainmorphology = json["grainmorphology"];
  }

  toJson() {
    return {
      id: this.id,
      createdby: this.createdby,
      createddate: this.createddate?.getTime(),
      modifiedby: this.modifiedby,
      modifieddate: this.modifieddate?.getTime(),
      code: this.code,
      name: this.name,
      type: "sedimentary",
      lithology: this.lithology,
      lithologydescription: this.lithologydescription,
      fieldrelation: "",
      fieldrelationdescription: "",
      foliationdescription: "",
      cleavagedescription: "",
      boudindescription: "",
      composition: "",
      fossil: this.fossil,
      otherfossil: this.otherfossil,
      dip: this.dip,
      strike: this.strike,
      structure: this.structure,
      grainsize: this.grainsize,
      grainmorphology: this.grainmorphology,
      description: this.description
    };
  }
}

export class IgneousRock extends Rock {
  texture;
  fieldrelation;
  fieldrelationdescription;
  composition;

  constructor(json) {
    super(json);
    this.texture = json["lithology"];
    this.fieldrelation = json["fieldrelation"];
    this.fieldrelationdescription = json["fieldrelationdescription"];
    this.composition = json["composition"];
  }

  toJson() {
    return {
      id: this.id,
      createdby: this.createdby,
      createddate: this.createddate?.getTime(),
      modifiedby: this.modifiedby,
      modifieddate: this.modifieddate?.getTime(),
      code: this.code,
      name: this.name,
      type: "igneous",
      lithology: this.texture,
      lithologydescription: this.lithodescription,
      fieldrelation: this.fieldrelation,
      fieldrelationdescription: this.fieldrelationdescription,
      foliationdescription: "",
      cleavagedescription: "",
      boudindescription: "",
      composition: this.composition,
      fossil: "",
      otherfossil: "",
      dip: "",
      strike: "",
      structure: "",
      grainsize: "",
      grainmorphology: "",
      description: this.description
    };
  }
}

export class MetamorphicRock extends Rock {
  fieldrelationdescription;
  foliationdescription;
  cleavagedescription;
  boudindescription;
  composition;

  constructor(json) {
    super(json);
    this.fieldrelationdescription = json["fieldrelationdescription"];
    this.foliationdescription = json["foliationdescription"];
    this.cleavagedescription = json["cleavagedescription"];
    this.boudindescription = json["boudindescription"];
    this.composition = json["composition"];
  }

  toJson() {
    return {
      id: this.id,
      createdby: this.createdby,
      createddate: this.createddate?.getTime(),
      modifiedby: this.modifiedby,
      modifieddate: this.modifieddate?.getTime(),
      code: this.code,
      name: this.name,
      type: "metamorphic",
      lithology: "",
      lithologydescription: this.lithologydescription,
      fieldrelation: "",
      fieldrelationdescription: this.fieldrelationdescription,
      foliationdescription: this.foliationdescription,
      cleavagedescription: this.cleavagedescription,
      boudindescription: this.boudindescription,
      composition: this.composition,
      fossil: "",
      otherfossil: "",
      dip: "",
      strike: "",
      structure: "",
      grainsize: "",
      grainmorphology: "",
      description: this.description
    };
  }
}
