import React, { useState, useEffect, useContext } from "react";
import { useHistory } from "react-router-dom";
import { Row, Col, FormGroup, Input } from "reactstrap";
import { Typeahead } from "react-bootstrap-typeahead";
import { faRedo } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import "../../styles/Grid.css";
import MainLayout from "../../Layouts/Main/MainLayout";
import { RockFeatureMobileRow } from "./FeatureRow";
import UserContext from "../../Contexts/UserContext";
import axios from "axios";
import { HOST } from "../../config";
import { GoBackButton } from '../GoBack'
import { Rock } from '../../Classes/Rock'

export const SedimentaryRockReadOnlyView = (props) => {
  const [checkpoints, setCheckpoints] = useState([])
  const [selectedCheckpoint, setSelectedCheckpoint] = useState([])
  const [rocks, setRocks] = useState([])
  const [selectedRocks, setSelectedRocks] = useState({})
  useEffect(() => {
    const fetchMobileRocks = async () => {
      const result = await axios.get(
        `${HOST}/mobile/checkpoints?projectid=${props.projectid}`
      );
      setCheckpoints(result.data)
    };
    fetchMobileRocks()
  }, []);

  useEffect(() => {
    const fetchRocks = async () => {
      console.log(selectedCheckpoint[0]?.id)
      const result = await axios.get(
        `${HOST}/mobile/rocks?checkpointid=${selectedCheckpoint[0]?.id}`
      );
      let rocks = result.data.map(rock => Rock.fromJson(rock))
      
      setRocks(rocks)
    }
    if(selectedCheckpoint.length > 0) {
      fetchRocks()
    }
  }, [selectedCheckpoint])
  return (
    <>
      <h5>
        Rocks from Mobile App
        <span>
          <button type="button" className="btn btn-warning ml-2 text-white">
            <FontAwesomeIcon icon={faRedo} />
          </button>
        </span>
      </h5>
      <Typeahead
        labelKey="name"
        id={props.typeaheadId}
        multiple={false}
        onChange={setSelectedCheckpoint}
        options={checkpoints}
        placeholder="Select Checkpoint from mobile app"
        selected={selectedCheckpoint}
      />
      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Created By</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody>
            {rocks.map(rock => (
              <RockFeatureMobileRow rock={rock} key={rock?.id} projectid={props.projectid} checkpointid={props.checkpointid} uploadby={selectedCheckpoint[0]?.uploadby} setSelectedRocks={setSelectedRocks} />
            ))}
          </tbody>
        </table>
        <>
          <p className="font-weight-bold text-gray">Code :</p>
          <p className="">{selectedRocks?.code}</p>

          <p className="font-weight-bold">Name :</p>
          <p className="">{selectedRocks?.name}</p>

          <p className="font-weight-bold">Lithology :</p>
          <p className="">{selectedRocks?.lithology}</p>

          <p className="font-weight-bold">Lithology Description :</p>
          <p className="">{selectedRocks?.lithologydescription}</p>

          <p className="font-weight-bold">Fossil :</p>
          <p className="">{selectedRocks?.fossil}</p>

          <p className="font-weight-bold">Fossil Description :</p>
          <p className="">{selectedRocks?.otherfossil}</p>

          <Row form>
            <Col md={6}>
              <p className="font-weight-bold">Dip :</p>
              <p className="">{selectedRocks?.dip}</p>
            </Col>
            <Col md={6}>
              <p className="font-weight-bold">Strike :</p>
              <p className="">{selectedRocks?.strike}</p>
            </Col>
          </Row>

          <p className="font-weight-bold">Structure :</p>
          <p className="">{selectedRocks?.structure}</p>

          <p className="font-weight-bold">Grain Size :</p>
          <p className="">{selectedRocks?.grainsize}</p>

          <p className="font-weight-bold">Grain Morphology :</p>
          <p className="">{selectedRocks?.grainmorphology}</p>

          <p className="font-weight-bold">Description :</p>
          <p className="">{selectedRocks?.description}</p>
        </>
      </div>
    </>
  );
};

export const IgenousRockReadOnlyView = (props) => {
  const [checkpoints, setCheckpoints] = useState([])
  const [selectedCheckpoint, setSelectedCheckpoint] = useState([])
  const [rocks, setRocks] = useState([])
  const [selectedRocks, setSelectedRocks] = useState({})
  useEffect(() => {
    const fetchMobileRocks = async () => {
      const result = await axios.get(
        `${HOST}/mobile/checkpoints?projectid=${props.projectid}`
      );
      setCheckpoints(result.data)
    };
    fetchMobileRocks()
  }, []);

  useEffect(() => {
    const fetchRocks = async () => {
      console.log(selectedCheckpoint[0]?.id)
      const result = await axios.get(
        `${HOST}/mobile/rocks?checkpointid=${selectedCheckpoint[0]?.id}`
      );
      let rocks = result.data.map(rock => Rock.fromJson(rock))
      
      setRocks(rocks)
    }
    if(selectedCheckpoint.length > 0) {
      fetchRocks()
    }
  }, [selectedCheckpoint])
  return (
    <>
      <h5>
        Rocks from Mobile App
        <span>
          <button type="button" className="btn btn-warning ml-2 text-white">
            <FontAwesomeIcon icon={faRedo} />
          </button>
        </span>
      </h5>
      <Typeahead
        labelKey="name"
        id={props.typeaheadId}
        multiple={false}
        onChange={setSelectedCheckpoint}
        options={checkpoints}
        placeholder="Select Checkpoint from mobile app"
        selected={selectedCheckpoint}
      />
      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Created By</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody>
            {rocks.map(rock => (
              <RockFeatureMobileRow rock={rock} key={rock?.id} projectid={props.projectid} checkpointid={props.checkpointid} setSelectedRocks={setSelectedRocks} />
            ))}
          </tbody>
        </table>
        <>
          <p className="font-weight-bold text-gray">Code :</p>
          <p className="">{selectedRocks?.code}</p>

          <p className="font-weight-bold">Name :</p>
          <p className="">{selectedRocks?.name}</p>

          <p className="font-weight-bold">Texture :</p>
          <p className="">{selectedRocks?.texture}</p>

          <p className="font-weight-bold">Lithology Description :</p>
          <p className="">{selectedRocks?.lithodescription}</p>

          <p className="font-weight-bold">Field Relation :</p>
          <p className="">{selectedRocks?.fieldrelation}</p>

          <p className="font-weight-bold">Field Relation Description :</p>
          <p className="">{selectedRocks?.fieldrelationdescription}</p>

          <p className="font-weight-bold">Chemical Composition :</p>
          <p className="">{selectedRocks?.composition}</p>

          <p className="font-weight-bold">Description :</p>
          <p className="">{selectedRocks?.description}</p>
        </>
      </div>
    </>
  );
};

export const MetamorphicRockReadOnlyView = (props) => {
  const [checkpoints, setCheckpoints] = useState([])
  const [selectedCheckpoint, setSelectedCheckpoint] = useState([])
  const [rocks, setRocks] = useState([])
  const [selectedRocks, setSelectedRocks] = useState({})
  useEffect(() => {
    const fetchMobileRocks = async () => {
      const result = await axios.get(
        `${HOST}/mobile/checkpoints?projectid=${props.projectid}`
      );
      setCheckpoints(result.data)
    };
    fetchMobileRocks()
  }, []);

  useEffect(() => {
    const fetchRocks = async () => {
      console.log(selectedCheckpoint[0]?.id)
      const result = await axios.get(
        `${HOST}/mobile/rocks?checkpointid=${selectedCheckpoint[0]?.id}`
      );
      let rocks = result.data.map(rock => Rock.fromJson(rock))
      
      setRocks(rocks)
    }
    if(selectedCheckpoint.length > 0) {
      fetchRocks()
    }
  }, [selectedCheckpoint])
  return (
    <>
      <h5>
        Rocks from Mobile App
        <span>
          <button type="button" className="btn btn-warning ml-2 text-white">
            <FontAwesomeIcon icon={faRedo} />
          </button>
        </span>
      </h5>
      <Typeahead
        labelKey="name"
        id={props.typeaheadId}
        multiple={false}
        onChange={setSelectedCheckpoint}
        options={checkpoints}
        placeholder="Select Checkpoint from mobile app"
        selected={selectedCheckpoint}
      />
      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">Name</th>
              <th scope="col">Created By</th>
              <th scope="col"></th>
            </tr>
          </thead>
          <tbody>
            {rocks.map(rock => (
              <RockFeatureMobileRow rock={rock} key={rock?.id} projectid={props.projectid} checkpointid={props.checkpointid} setSelectedRocks={setSelectedRocks} />
            ))}
          </tbody>
        </table>
        <>
          <p className="font-weight-bold text-gray">Code :</p>
          <p className="">{selectedRocks?.code}</p>

          <p className="font-weight-bold">Name :</p>
          <p className="">{selectedRocks?.name}</p>

          <p className="font-weight-bold">Lithology Description :</p>
          <p className="">{selectedRocks?.lithologydescription}</p>

          <p className="font-weight-bold">Texture Description :</p>
          <p className="">{selectedRocks?.fieldrelationdescription}</p>

          <p className="font-weight-bold">Foliation Description :</p>
          <p className="">{selectedRocks?.foliationdescription}</p>

          <p className="font-weight-bold">Cleavage Description :</p>
          <p className="">{selectedRocks?.cleavagedescription}</p>

          <p className="font-weight-bold">Boudin Description :</p>
          <p className="">{selectedRocks?.boudindescription}</p>

          <p className="font-weight-bold">Chemical Composition :</p>
          <p className="">{selectedRocks?.composition}</p>

          <p className="font-weight-bold">Description :</p>
          <p className="">{selectedRocks?.description}</p>
        </>
      </div>
    </>
  );
};

export const SedimentaryRockInputView = props => {
  const [rocks, setRocks] = useState({
    checkpointid: props.checkpointid,
    createdby: props.user.id,
    createddate: new Date().getTime() * 0.001,
    modifiedby: props.user.id,
    modifieddate: new Date().getTime() * 0.001,
    code: "",
    name: "",
    type: "sedimentary",
    lithology: "",
    lithologydescription: "",
    fieldrelation: "",
    fieldrelationdescription: "",
    foliationdescription: "",
    cleavagedescription: "",
    boudindescription: "",
    composition: "",
    fossil: "",
    otherfossil: "",
    dip: "",
    strike: "",
    structure: "",
    grainsize: "",
    grainmorphology: "",
    description: ""
  });
  const onCreate = async e => {
    e.preventDefault();
    await axios.post(
      `${HOST}/web/rock/create`,
      rocks
    );
    props.history.goBack();
  };
  return (
    <form>
      <p className="label">Code</p>
      <Input onChange={e => setRocks({ ...rocks, code: e.target.value })} />
      <p className="label">Name</p>
      <Input onChange={e => setRocks({ ...rocks, name: e.target.value })} />
      <p className="label">Lithology</p>
      <Input
        onChange={e => setRocks({ ...rocks, lithology: e.target.value })}
      />
      <p className="label">Lithology Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, lithologydescription: e.target.value })
        }
      />
      <p className="label">Fossil</p>
      <Input onChange={e => setRocks({ ...rocks, fossil: e.target.value })} />
      <p className="label">Fossil Description</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, otherfossil: e.target.value })}
      />
      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Dip</p>
            <Input
              onChange={e => setRocks({ ...rocks, dip: e.target.value })}
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Strike</p>
            <Input
              onChange={e => setRocks({ ...rocks, strike: e.target.value })}
            />
          </FormGroup>
        </Col>
      </Row>

      <p className="label">Structure</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, structure: e.target.value })}
      />

      <p className="label">Grain Size</p>
      <Input
        onChange={e => setRocks({ ...rocks, grainsize: e.target.value })}
      />

      <p className="label">Grain Morphology</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, grainmorphology: e.target.value })}
      />

      <p className="label">Description</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, description: e.target.value })}
      />

      <button className="btn btn-primary" onClick={onCreate}>
        Create
      </button>
    </form>
  );
};

export const IgenousRockInputView = props => {
  console.log(props.checkpointid)
  const [rocks, setRocks] = useState({
    checkpointid: parseInt(props.checkpointid),
    createdby: props.user.id,
    code: "",
    name: "",
    type: "igneous",
    lithology: "",
    lithologydescription: "",
    fieldrelation: "",
    fieldrelationdescription: "",
    foliationdescription: "",
    cleavagedescription: "",
    boudindescription: "",
    composition: "",
    fossil: "",
    otherfossil: "",
    dip: "",
    strike: "",
    structure: "",
    grainsize: "",
    grainmorphology: "",
    description: ""
  });
  const onCreate = async e => {
    e.preventDefault();
    await axios.post(
      `${HOST}/web/rock/create`,
      rocks
    );
    props.history.push(`/project/${props.projectid}/checkpoint/${props.checkpointid}`);
  };
  return (
    <form>
      <p className="label">Code</p>
      <Input onChange={e => setRocks({ ...rocks, code: e.target.value })} />
      <p className="label">Name</p>
      <Input onChange={e => setRocks({ ...rocks, name: e.target.value })} />
      <p className="label">Texture</p>
      <Input
        onChange={e => setRocks({ ...rocks, lithology: e.target.value })}
      />
      <p className="label">Lithology Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, lithologydescription: e.target.value })
        }
      />
      <p className="label">Field Relation</p>
      <Input
        onChange={e => setRocks({ ...rocks, fieldrelation: e.target.value })}
      />
      <p className="label">Field Relation Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, fieldrelationdescription: e.target.value })
        }
      />
      <p className="label">Chemical Composition</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, composition: e.target.value })}
      />
      <p className="label">Description</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, description: e.target.value })}
      />
      <button className="btn btn-primary" onClick={onCreate}>
        Create
      </button>
    </form>
  );
};

export const MetamorphicRockInputView = props => {
  const [rocks, setRocks] = useState({
    checkpointid: props.checkpointid,
    createdby: props.user.id,
    modifiedby: props.user.id,
    code: "",
    name: "",
    type: "metamorphic",
    lithology: "",
    lithologydescription: "",
    fieldrelation: "",
    fieldrelationdescription: "",
    foliationdescription: "",
    cleavagedescription: "",
    boudindescription: "",
    composition: "",
    fossil: "",
    otherfossil: "",
    dip: "",
    strike: "",
    structure: "",
    grainsize: "",
    grainmorphology: "",
    description: ""
  });
  const onCreate = async e => {
    e.preventDefault();
    await axios.post(
      `${HOST}/web/rock/create`,
      rocks
    );
    props.history.push(`/project/${props.projectid}/checkpoint/${props.checkpointid}`);
  };
  return (
    <form>
      <p className="label">Code</p>
      <Input onChange={e => setRocks({ ...rocks, code: e.target.value })} />
      <p className="label">Name</p>
      <Input onChange={e => setRocks({ ...rocks, name: e.target.value })} />
      <p className="label">Lithology Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, lithologydescription: e.target.value })
        }
      />
      <p className="label">Field Relation Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, fieldrelationdescription: e.target.value })
        }
      />

      <p className="label">Foliation Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, foliationdescription: e.target.value })
        }
      />
      <p className="label">Cleavage Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, cleavagedescription: e.target.value })
        }
      />
      <p className="label">Boudin Description</p>
      <Input
        type="textarea"
        onChange={e =>
          setRocks({ ...rocks, boudindescription: e.target.value })
        }
      />
      <p className="label">Chemical Composition</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, composition: e.target.value })}
      />
      <p className="label">Description</p>
      <Input
        type="textarea"
        onChange={e => setRocks({ ...rocks, description: e.target.value })}
      />
      <button className="btn btn-primary" onClick={onCreate}>
        Create
      </button>
    </form>
  );
};

export default props => {
  const history = useHistory();
  const user = useContext(UserContext);
  const type = props.match.params.type;
  const checkpointid = props.match.params.checkpointid;
  const projectid = props.match.params.projectid;
  const mapView = () => {
    if (type === "sedimentary") {
      return (
        <SedimentaryRockInputView
          user={user.user}
          history={history}
          checkpointid={checkpointid}
          projectid={projectid}
        />
      );
    } else if (type === "igneous") {
      return (
        <IgenousRockInputView
          user={user.user}
          history={history}
          checkpointid={checkpointid}
          projectid={projectid}
        />
      );
    } else {
      return (
        <MetamorphicRockInputView
          user={user.user}
          history={history}
          checkpointid={checkpointid}
          projectid={projectid}
        />
      );
    }
  };
  const readOnlyView = (typeaheadId) => {
    if (type === "sedimentary") {
      return (
        <SedimentaryRockReadOnlyView
          user={user.user}
          history={history}
          checkpointid={checkpointid}
          projectid={projectid}
          typeaheadId={typeaheadId}
        />
      );
    } else if (type === "igneous") {
      return (
        <IgenousRockReadOnlyView
          user={user.user}
          history={history}
          checkpointid={checkpointid}
          projectid={projectid}
          typeaheadId={typeaheadId}
        />
      );
    } else {
      return (
        <MetamorphicRockReadOnlyView
          user={user.user}
          history={history}
          checkpointid={checkpointid}
          projectid={projectid}
          typeaheadId={typeaheadId}
        />
      );
    }
  }
  return (
    <MainLayout>
      <div className="row">
        <div className="col d-flex flex-row-reverse">
          <GoBackButton history={history} />
        </div>
      </div>
      <div className="row">
        <div className="col">New Rock</div>
      </div>
      <br />
      <div className="row">
        <div className="col">
          {readOnlyView(1)}
        </div>
        <div className="col">
          {readOnlyView(2)}
        </div>
        <div className="col">{mapView()}</div>
      </div>
    </MainLayout>
  );
};
