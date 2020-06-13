import React, { useState, useEffect, useContext } from "react";
import { useHistory } from "react-router-dom";
import { Row, Col, FormGroup, Input } from "reactstrap";
import "../../styles/Grid.css";
import MainLayout from "../../Layouts/Main/MainLayout";
import axios from "axios";
import UserContext from "../../Contexts/UserContext";
import { HOST } from "../../config";
import { CheckpointReadOnlyView } from './CreateCheckpoint'
import { GoBackButton } from '../GoBack'

export const CheckpointEditInputView = props => {
  const [checkpoint, setCheckpoint] = useState({
    id: parseInt(props.checkpointid),
    projectid: parseInt(props.projectid),
    createdby: props.user.id,
    createddate: new Date().getTime(),
    modifiedby: props.user.id,
    modifieddate: new Date().getTime(),
    name: "",
    landmark: "",
    description: "",
    height: "",
    width: "",
    latitude: "",
    longitude: "",
    zone: "",
    north: "",
    east: "",
    elevation: "",
    source: "web",
    uploadby: ""
  });

  useEffect(() => {
    const fetchCheckpointDetail = async () => {
      const result = await axios.get(
        `${HOST}/web/checkpoint/data/${props.checkpointid}`
      );
      setCheckpoint(result.data);
    };
    fetchCheckpointDetail()
  }, [])

  const onEdit = async e => {
    e.preventDefault();
    await axios.post(
      `${HOST}/web/checkpoint/update/${checkpoint.id}`,
      checkpoint
    );
    props.history.goBack();
  };

  return (
    <form>
      <p className="label">Name</p>
      <Input defaultValue={checkpoint?.name} onChange={e => setCheckpoint({ ...checkpoint, name: e.target.value })} />
      <p className="label">Landmark</p>
      <Input
        defaultValue={checkpoint?.landmark}
        onChange={e => setCheckpoint({ ...checkpoint, landmark: e.target.value })}
      />


      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Width</p>
            <Input
              type="number"
              defaultValue={checkpoint?.width}
              onChange={e =>
                setCheckpoint({ ...checkpoint, width: parseFloat(e.target.value) })
              }
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Height</p>
            <Input
              type="number"
              defaultValue={checkpoint?.height}
              onChange={e =>
                setCheckpoint({
                  ...checkpoint,
                  height: parseFloat(e.target.value)
                })
              }
            />
          </FormGroup>
        </Col>
      </Row>


      <p className="label">Description</p>
      <Input
        defaultValue={checkpoint?.description}
        type="textarea"
        onChange={e => setCheckpoint({ ...checkpoint, description: e.target.value })}
      />
      <Row form>
        <Col md={6}>
          <FormGroup>
            <p className="label">Latitude</p>
            <Input
              defaultValue={`${checkpoint?.latitude}`}
              type="number"
              onChange={e =>
                setCheckpoint({ ...checkpoint, latitude: parseFloat(e.target.value) })
              }
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Longtitude</p>
            <Input
              defaultValue={`${checkpoint?.longitude}`}
              type="number"
              onChange={e =>
                setCheckpoint({
                  ...checkpoint,
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
              defaultValue={checkpoint?.zone}
              onChange={e => setCheckpoint({ ...checkpoint, zone: e.target.value })}
            />
          </FormGroup>
        </Col>
        <Col md={6}>
          <FormGroup>
            <p className="label">Elevation</p>
            <Input
              type="number"
              defaultValue={`${checkpoint?.elevation}`}
              onChange={e =>
                setCheckpoint({
                  ...checkpoint,
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
              defaultValue={`${checkpoint?.north}`}
              onChange={e =>
                setCheckpoint({
                  ...checkpoint,
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
              defaultValue={`${checkpoint?.east}`}
              onChange={e =>
                setCheckpoint({
                  ...checkpoint,
                  east: parseFloat(e.target.value)
                })
              }
            />
          </FormGroup>
        </Col>
      </Row>

      <button onClick={onEdit} className="btn btn-primary">
        Edit
      </button>
    </form>
  );
};

export default props => {
  const history = useHistory();
  const user = useContext(UserContext);
  let projectid = props.match.params.projectid;
  let checkpointid = props.match.params.id
  return (
    <MainLayout>
      <div className="row">
        <div className="col-12 d-flex flex-row-reverse">
          <GoBackButton history={history} />
        </div>
      </div>
      <div className="row">
        <div className="col">Edit Checkpoint</div>
      </div>
      <br />
      <div class="row">
        <div class="col">
          <CheckpointReadOnlyView projectid={projectid} checkpointid={checkpointid} />
        </div>
        <div class="col">
          <CheckpointReadOnlyView projectid={projectid} checkpointid={checkpointid} />
        </div>
        <div class="col">
          <CheckpointEditInputView history={history} projectid={projectid} checkpointid={checkpointid} user={user.user} />
        </div>
      </div>
    </MainLayout>
  );
};
