import React, { useState, useEffect,Fragment, useContext } from "react";
import { useHistory } from "react-router-dom";
import "../../styles/Grid.css";
import { Row, Col, FormGroup, Input } from "reactstrap";
import { Typeahead } from "react-bootstrap-typeahead";
import { faRedo } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import "../../styles/Grid.css";
import UserContext from "../../Contexts/UserContext";
import axios from "axios";
import { HOST } from "../../config";
import MainLayout from "../../Layouts/Main/MainLayout";
import {StructureFeatureMobileRow} from '../Feature/FeatureRow'
import {Structure} from '../../Classes/Structure'

export const StructureFeatureReadOnlyView = (props) => {
  const [checkpoints, setCheckpoints] = useState([])
  const [selectedCheckpoint, setSelectedCheckpoint] = useState([])
  const [structures, setStructures] = useState([])
  const [selectedStructure, setSelectedStructure] = useState({})
  useEffect(() => {
    const fetchMobileStructures = async () => {
      const result = await axios.get(
        `${HOST}/mobile/checkpoints?projectid=${props.projectid}`
      );
      setCheckpoints(result.data)
    };
    fetchMobileStructures()
  }, []);

  useEffect(() => {
    const fetchStructures = async () => {
      const result = await axios.get(
        `${HOST}/mobile/structures?checkpointid=${selectedCheckpoint[0]?.id}`
      );
      console.log(result)
      let structures = result.data.map(structure => new Structure(structure))
      setStructures(structures)
    }
    if(selectedCheckpoint.length > 0) {
      fetchStructures()
    }
  }, [selectedCheckpoint.length])
  return (
    <>
      <h5>
        Structures from Mobile App
        <span>
          <button type="button" className="btn btn-warning ml-2 text-white">
            <FontAwesomeIcon icon={faRedo} />
          </button>
        </span>
      </h5>
      <Typeahead
        labelKey="name"
        id={props.type}
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
            {structures.map(structure => (
              <StructureFeatureMobileRow structure={structure} key={structure?.id} projectid={props.projectid} checkpointid={props.checkpointid} setSelectedStructure={setSelectedStructure} />
            ))}
          </tbody>
        </table>
        <>
          <p className="font-weight-bold text-gray">Code :</p>
          <p className="">{selectedStructure?.code}</p>

          <p className="font-weight-bold">Name :</p>
          <p className="">{selectedStructure?.name}</p>

          <p className="font-weight-bold">Structure Type :</p>
          <p className="">{selectedStructure?.structure}</p>
          <Row form>
            <Col md={6}>
              <p className="font-weight-bold">Dip :</p>
              <p className="">{selectedStructure?.dip}</p>
            </Col>
            <Col md={6}>
              <p className="font-weight-bold">Strike :</p>
              <p className="">{selectedStructure?.strike}</p>
            </Col>
          </Row>
          <Row form>
            <Col md={6}>
              <p className="font-weight-bold">Plunge :</p>
              <p className="">{selectedStructure?.plunge}</p>
            </Col>
            <Col md={6}>
              <p className="font-weight-bold">Trend :</p>
              <p className="">{selectedStructure?.trend}</p>
            </Col>
          </Row>
          <p className="font-weight-bold">Description :</p>
          <p className="">{selectedStructure?.description}</p>
        </>
      </div>
    </>
  );
};

export const StructureFeatureInputView = (props) => {
  const [structure, setStructure] = useState({
    createdby: props.user.id,
    modifiedby: props.user.id,
    checkpointid: props.checkpointid,
    createdby: props.user.id,
    createddate: new Date().getTime() * 0.001,
    modifiedby: props.user.id,
    modifieddate: new Date().getTime() * 0.001,
    code: "",
    name: "",
    type: "structure",
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
  })
  const onCreate = async e => {
    e.preventDefault();
    await axios.post(
      `${HOST}/web/structure/create`,
      structure
    );
    props.history.goBack();
  };
  return (
    <form>
      <p className="label">Code</p>
      <Input onChange={(e) => setStructure({ ...structure, code: e.target.value })} />
      <p className="label">Name</p>
      <Input onChange={(e) => setStructure({ ...structure, name: e.target.value })} />
      <p className="label">Structure Type</p>
      <Input onChange={(e) => setStructure({ ...structure, structure: e.target.value })}/>
      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Dip</p>
            <Input onChange={(e) => setStructure({ ...structure, dip: e.target.value })}/>
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Strike</p>
            <Input onChange={(e) => setStructure({ ...structure, strike: e.target.value })}/>
          </FormGroup>
        </Col>
      </Row>

      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Plunge</p>
            <Input onChange={(e) => setStructure({ ...structure, plunge: e.target.value })}/>
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Trend</p>
            <Input onChange={(e) => setStructure({ ...structure, trend: e.target.value })}/>
          </FormGroup>
        </Col>
      </Row>

      <p className="label">Description</p>
      <Input type="textarea" onChange={(e) => setStructure({ ...structure, description: e.target.value })}/>
      <button className="btn btn-primary" onClick={onCreate}>Create</button>
    </form>
  );
};

export default (props) => {
  const history = useHistory();
  const user = useContext(UserContext);
  const projectid = props.match.params.projectid
  const checkpointid = props.match.params.checkpointid
  return (
    <MainLayout>
      <div className="row">
        <div className="col-11">New Structure</div>
        <div className="col-1">
          <button className="btn btn-danger" onClick={() => history.goBack()}>
            Back
          </button>
        </div>
      </div>
      <br />
      <div class="row">
        <div class="col">
          <StructureFeatureReadOnlyView type={1} user={user.user} projectid={projectid} checkpointid={checkpointid} history={history}/>
        </div>
        <div class="col">
          <StructureFeatureReadOnlyView type={2} user={user.user} projectid={projectid} checkpointid={checkpointid} history={history}/>
        </div>
        <div class="col">
          <StructureFeatureInputView user={user.user} projectid={projectid} checkpointid={checkpointid} history={history}/>
        </div>
      </div>
    </MainLayout>
  );
};
