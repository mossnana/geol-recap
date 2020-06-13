import React, { useState, useEffect } from "react";
import { Link, useHistory } from "react-router-dom";
import { Typeahead } from "react-bootstrap-typeahead";
import "../../styles/Project.css";
import MainLayout from "../../Layouts/Main/MainLayout";
import { faRedo } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import AddFeature from "./AddFeature";
import axios from "axios";
import { RockFeatureRow, RockFeatureMobileRow, StructureFeatureRow } from "./FeatureRow";
import { HOST } from "../../config";
import { Checkpoint } from '../../Classes/Checkpoint'
import { Rock } from '../../Classes/Rock'
import { GoBackButton } from '../GoBack'
import { DeleteModal } from "../Modals";

export const RockFeature = props => {
  const [rocks, setRocks] = useState([]);
  useEffect(() => {
    const fetchFeatures = async () => {
      const result = await axios.get(
        `${HOST}/web/rocks?checkpointid=${props.checkpointid}`
      );
      let rocks = result.data.map(rock => Rock.fromJson(rock));
      setRocks(rocks);
    };
    fetchFeatures();
  }, []);
  return (
    <>
      <h5>Rocks in Checkpoint</h5>
      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">Example Code</th>
              <th scope="col">Name</th>
              <th scope="col">Type</th>
            </tr>
          </thead>
          <tbody>
            {rocks.map(rock => (
              <RockFeatureRow projectid={props.projectid} checkpointid={props.checkpointid} rock={rock} key={rock?.id} />
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
};

export const RockFeatureMobile = (props) => {
  const [sort, setSort] = useState('newest_to_oldest')
  const [checkpoints, setCheckpoints] = useState([])
  const [selectedCheckpoint, setSelectedCheckpoint] = useState([])
  const [rocks, setRocks] = useState([])
  const [selectedRocks, setSelectedRocks] = useState([])
  useEffect(() => {
    const fetchMobileRocks = async () => {
      const result = await axios.get(
        `${HOST}/mobile/checkpoint`
      );
      setCheckpoints(result.data)
    };
  }, []);
  useEffect(() => {
    const fetchRocks = async () => {

      const result = await axios.get(
        `${HOST}/mobile/feature/rock?checkpointId=${selectedCheckpoint[0]?.id}`
      );
      console.clear()
      console.log(result.data)
      setRocks(result.data)
    }
    fetchRocks()
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
        id='feature-view-checkpoint-mobile'
        multiple={false}
        onChange={setSelectedCheckpoint}
        options={checkpoints}
        placeholder="Select Checkpoint from mobile app"
        selected={selectedCheckpoint}
      />

      {
        rocks.length > 0 ?
          <Typeahead
            id='feature-view-rock-mobile'
            labelKey="name"
            multiple={false}
            onChange={setSelectedRocks}
            options={rocks}
            placeholder={`Select Rocks from ${selectedCheckpoint[0]?.name}`}
            selected={selectedRocks}
          /> :
          <></>
      }

      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">Code</th>
              <th scope="col">Type</th>
              <th scope="col">Created By</th>
            </tr>
          </thead>
          <tbody>
            {selectedRocks.map(rock => (
              <RockFeatureMobileRow rock={rock} key={rock?.id} />
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
};

export const StructureFeature = (props) => {
  const [structures, setStructures] = useState([]);
  useEffect(() => {
    const fetchFeatures = async () => {
      const result = await axios.get(
        `${HOST}/web/structures?checkpointid=${
        props.checkpointid
        }`
      );
      let structures = result.data;
      setStructures(structures);
    };
    fetchFeatures();
  }, []);
  return (
    <>
      <h5>Structures in Checkpoint</h5>
      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">Code</th>
              <th scope="col">Name</th>
              <th scope="col">Type</th>
            </tr>
          </thead>
          <tbody>
            {
              structures.map((structure) => <StructureFeatureRow
                checkpointid={props.checkpointid}
                projectid={props.projectid}
                structure={structure}
                key={structure.id}
              />
              )
            }
          </tbody>
        </table>
      </div>
    </>
  );
};

export const StructureFeatureMobile = () => {
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

      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">Code</th>
              <th scope="col">Type</th>
              <th scope="col">Created By</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <Link to="/project/5a6c5f"> SEDI-101 </Link>
              </td>
              <td>Fault</td>
              <td>Teera</td>
            </tr>
            <tr>
              <td>
                <Link to="/project/5a6c5f"> META-102 </Link>
              </td>
              <td>Unconformity</td>
              <td>Teera</td>
            </tr>
          </tbody>
        </table>
      </div>
    </>
  );
};

export const FeatureHeader = props => {
  const [checkpoint, setCheckpoint] = useState({})
  useEffect(() => {
    const fetchCheckpoint = async () => {
      const result = await axios.get(
        `${HOST}/web/checkpoint/data/${props.checkpointid}`
      );
      let checkpoint = new Checkpoint(result.data)
      setCheckpoint(checkpoint);
    };
    fetchCheckpoint();
  }, []);
  const onDelete = async () => {
    await axios.post(
      `${HOST}/web/checkpoint/delete/${props.checkpointid}`
    );
    props.history.goBack();
  };
  return (
    <>
      <div className="h3">{checkpoint?.id} - {checkpoint?.name}</div>
      <div className="h6">{checkpoint?.landmark}</div>
      <div className="h6">Width: {checkpoint?.width}  Height: {checkpoint?.height}</div>
      <div className="h6">{checkpoint?.description}</div>
      <div className="h6">
        <span>Latitude {checkpoint?.latitude} </span>
        <span>Longitude {checkpoint?.longitude} </span>
      </div>
      <div className="h6">
        <span>{checkpoint?.zone} </span>
        <span>N {checkpoint?.north} </span>
        <span>E {checkpoint?.east}</span>
      </div>
      <div className="row">
        <div className="col">
          <Link to={`/project/${props.projectid}/checkpoint/${props.checkpointid}/edit`} className="btn btn-primary btn-sm">
            Edit
          </Link>
          {' '}
          <DeleteModal title='Confirm ?' buttonLabel='Delete' deleteAction={onDelete} body='Do you want to delete this checkpoint ?' />
        </div>
      </div>
      <AddFeature
        sedimentary={() => (
          <Link
            to={`/project/${props?.projectid}/checkpoint/${props?.checkpointid}/feature/rock/new/sedimentary`}
            type="button"
            className="btn btn-transparent"
          >
            Sedimentary Rock
          </Link>
        )}
        igneous={() => (
          <Link
            to={`/project/${props?.projectid}/checkpoint/${props?.checkpointid}/feature/rock/new/igneous`}
            type="button"
            className="btn btn-transparent"
          >
            Igneous Rock
          </Link>
        )}
        metamorphic={() => (
          <Link
            to={`/project/${props?.projectid}/checkpoint/${props?.checkpointid}/feature/rock/new/metamorphic`}
            type="button"
            className="btn btn-transparent"
          >
            Metamorphic Rock
          </Link>
        )}
        structure={() => (
          <Link
            to={`/project/${props?.projectid}/checkpoint/${props?.checkpointid}/feature/structure/new`}
            type="button"
            className="btn btn-transparent"
          >
            Structure
          </Link>
        )}
      />
    </>
  );
};

export default props => {
  let projectid = props.match.params.projectid
  let checkpointid = props.match.params.id;
  const history = useHistory();

  return (
    <MainLayout>
      <div className="row">
        <div className="col-12 d-flex flex-row-reverse">
          <GoBackButton history={history} />
        </div>
      </div>
      <div className="row">
        <div className="col-12">
          <FeatureHeader history={history} projectid={projectid} checkpointid={checkpointid} />
        </div>
      </div>
      <br />
      <div className="row">
        <div className="col-6">
          <RockFeature projectid={projectid} checkpointid={checkpointid} />
        </div>
        <div className="col-6">
          <StructureFeature projectid={projectid} checkpointid={checkpointid} />
        </div>
      </div>
    </MainLayout>
  );
};
