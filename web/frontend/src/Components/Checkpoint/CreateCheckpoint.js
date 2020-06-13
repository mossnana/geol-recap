import React, { useState, Fragment, useEffect, useContext } from "react";
import { useHistory } from "react-router-dom";
import { Row, Col, FormGroup, Input } from "reactstrap";
import { Typeahead } from "react-bootstrap-typeahead";
import "../../styles/Grid.css";
import MainLayout from "../../Layouts/Main/MainLayout";
import { Checkpoint } from "../../Classes/Checkpoint";
import axios from "axios";
import UserContext from "../../Contexts/UserContext";
import { HOST } from "../../config";
import { GoBackButton } from '../GoBack'

export const CheckpointReadOnlyView = props => {
  const [selected, setSelected] = useState([]);
  const [checkpoints, setCheckpoints] = useState([]);
  useEffect(() => {
    const fetchCheckpoints = async () => {

      const result = await axios.get(
        `${HOST}/mobile/checkpoints?projectid=${
        props.projectid
        }`
      );
      let checkpoints = result.data.map(project => new Checkpoint(project));
      console.log(checkpoints)
      setCheckpoints(checkpoints);
    };
    fetchCheckpoints()
  }, []);
  return (
    <Fragment>
      <p className="label">Checkpoint from mobile</p>
      <Typeahead
        id={props.id}
        labelKey="name"
        multiple={false}
        onChange={setSelected}
        options={checkpoints}
        placeholder="Get Mobile Checkpoint"
        selected={selected}
      />
      <FormGroup />
      {selected.length === 0 ? (
        ""
      ) : (
          <>
            <div className="row">
              <div className="col">Data by {selected[0].uploadby}</div>
            </div>

            <div className="row info">
              <div className="col">Name:</div>
              <div className="col">{selected[0].name}</div>
            </div>

            <div className="row info">
              <div className="col">Landmark:</div>
              <div className="col">{selected[0].landmark}</div>
            </div>

            <div className="row info">
              <div className="col">Description:</div>
              <div className="col">{selected[0].description}</div>
            </div>

            <div className="row info">
              <div className="col">Height:</div>
              <div className="col">{selected[0].height}</div>
            </div>

            <div className="row info">
              <div className="col">Width:</div>
              <div className="col">{selected[0].width}</div>
            </div>

            <div className="row info">
              <div className="col">Latitude:</div>
              <div className="col">{selected[0].latitude}</div>
              <div className="col">Longitude:</div>
              <div className="col">{selected[0].longitude}</div>
            </div>

            <div className="row info">
              <div className="col">Zone:</div>
              <div className="col">{selected[0].zone}</div>
              <div className="col">Elevation:</div>
              <div className="col">{selected[0].elevation}</div>
            </div>

            <div className="row info">
              <div className="col">North:</div>
              <div className="col">{selected[0].north}</div>
              <div className="col">East:</div>
              <div className="col">{selected[0].east}</div>
            </div>
          </>
        )}
    </Fragment>
  );
};

export const CheckpointInputView = props => {
  const history = useHistory();
  const [project, setProject] = useState({
    id: 0,
    projectid: parseFloat(props.projectid),
    createdby: props.user.id,
    createddate: new Date().getTime(),
    modifiedby: props.user.id,
    modifieddate: new Date().getTime(),
    name: "",
    landmark: "",
    description: "",
    height: 0,
    width: 0,
    latitude: 0,
    longitude: 0,
    zone: "",
    north: 0,
    east: 0,
    elevation: 0,
    source: "web",
    uploadby: ""
  });
  const onCreate = async e => {
    e.preventDefault();
    var result = await axios.post(
      `${HOST}/web/checkpoint/create`,
      project
    );
    props.history.goBack();
  };

  return (
    <form>
      <p className="label">Name</p>
      <Input onChange={e => setProject({ ...project, name: e.target.value })} />
      <p className="label">Landmark</p>
      <Input
        onChange={e => setProject({ ...project, landmark: e.target.value })}
      />
      
      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Width</p>
            <Input
              type="number"
              onChange={e =>
                setProject({ ...project, width: parseFloat(e.target.value) })
              }
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Height</p>
            <Input
              type="number"
              onChange={e =>
                setProject({
                  ...project,
                  height: parseFloat(e.target.value)
                })
              }
            />
          </FormGroup>
        </Col>
      </Row>

      <p className="label">Description</p>
      <Input
        type="textarea"
        onChange={e => setProject({ ...project, description: e.target.value })}
      />
      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Latitude</p>
            <Input
              type="number"
              onChange={e =>
                setProject({ ...project, latitude: parseFloat(e.target.value) })
              }
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Longtitude</p>
            <Input
              type="number"
              onChange={e =>
                setProject({
                  ...project,
                  longitude: parseFloat(e.target.value)
                })
              }
            />
          </FormGroup>
        </Col>
      </Row>

      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Zone</p>
            <Input
              onChange={e => setProject({ ...project, zone: e.target.value })}
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Elevation</p>
            <Input
              type="number"
              onChange={e =>
                setProject({
                  ...project,
                  elevation: parseFloat(e.target.value)
                })
              }
            />
          </FormGroup>
        </Col>
      </Row>

      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">North</p>
            <Input
              type="number"
              onChange={e =>
                setProject({
                  ...project,
                  north: parseFloat(e.target.value)
                })
              }
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">East</p>
            <Input
              type="number"
              onChange={e =>
                setProject({
                  ...project,
                  east: parseFloat(e.target.value)
                })
              }
            />
          </FormGroup>
        </Col>
      </Row>

      <button onClick={onCreate} className="btn btn-primary">
        Create
      </button>
    </form>
  );
};

export default props => {
  const history = useHistory();
  const user = useContext(UserContext);
  let projectid = props.match.params.projectid;
  return (
    <MainLayout>
      <div className="row">
        <div className="col-11">New Checkpoint</div>
        <div className="col-1">
          <GoBackButton history={history} />
        </div>
      </div>
      <br />
      <div className="row">
        <div className="col">
          <CheckpointReadOnlyView projectid={projectid} id={1} />
        </div>
        <div className="col">
          <CheckpointReadOnlyView projectid={projectid} id={2} />
        </div>
        <div className="col">
          <CheckpointInputView projectid={projectid} user={user.user} history={history} />
        </div>
      </div>
    </MainLayout>
  );
};
