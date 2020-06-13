import React, { useState, useEffect } from "react";
import { Link, useHistory } from "react-router-dom";
import moment from 'moment'
import axios from "axios";
import { HOST } from "../../config";
import "../../styles/Project.css";
import MainLayout from "../../Layouts/Main/MainLayout";
import { faRedo } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { Checkpoint } from "../../Classes/Checkpoint";
import { CheckpointRow, CheckpointMobileRow } from "./CheckpointRow";
import { CheckpointFilterDropdown } from './FilterDropdown'
import { GoBackButton } from '../GoBack'

export const CheckpointFromMobileList = props => {
  const [checkpoints, setCheckpoints] = useState([]);

  useEffect(() => {
    const fetchCheckpoints = async () => {
      const result = await axios.get(
        `${HOST}/mobile/checkpoints?projectid=${props.projectid}`
      );
      let checkpoints = result.data.map(project => new Checkpoint(project));
      setCheckpoints(checkpoints);
    };
    fetchCheckpoints()
  }, []);

  const onReload = async () => {
    const result = await axios.get(
      `${HOST}/mobile/checkpoints?projectid=${props.projectid}`
    );
    let checkpoints = result.data.map(project => new Checkpoint(project));
    setCheckpoints(checkpoints);
  };

  const onClearMobileCheckpoints = async (e) => {
    e.preventDefault()
    await axios.post(
      `${HOST}/mobile/checkpoints/clear`,
      {projectid: props.projectid}
    );
    props.history.goBack();
  }

  return (
    <>
      <h5>
        Checkpoints From Mobile App
        <span>
          <button
            onClick={onReload}
            className="btn btn-warning ml-2 text-white"
          >
            <FontAwesomeIcon icon={faRedo} />
          </button>
          <button className="btn btn-danger ml-2" onClick={onClearMobileCheckpoints}>
            Clear Mobile Checkpoint
          </button>
        </span>
      </h5>
      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">ID</th>
              <th scope="col">Name</th>
              <th scope="col">Landmark</th>
              <th scope="col">Location</th>
              <th scope="col">Upload By</th>
              <th scope="col">Created Date</th>
            </tr>
          </thead>
          <tbody>
            {checkpoints.map(checkpoint => (
              <CheckpointMobileRow key={checkpoint.id} checkpoint={checkpoint} />
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
};

export const CheckpointList = props => {
  const [checkpoints, setCheckpoints] = useState([]);
  const [isToday, setToday] = useState(true)
  const [sort, setSort] = useState('newest_to_oldest')
  useEffect(() => {
    const fetchTodayCheckpoints = async () => {
      const result = await axios.get(
        `${HOST}/web/checkpoints/today?projectid=${props.projectid}&sortby=${sort}`
      );
      let checkpoints = result.data.map(project => new Checkpoint(project));
      setCheckpoints(checkpoints);
    };
    fetchTodayCheckpoints();
  }, []);

  useEffect(() => {
    const fetchCheckpoints = async () => {
      const result = await axios.get(
        `${HOST}/web/checkpoints?projectid=${props.projectid}&sortby=${sort}`
      );
      let checkpoints = result.data.map(project => new Checkpoint(project));
      setCheckpoints(checkpoints);
    };
    const fetchTodayCheckpoints = async () => {
      const result = await axios.get(
        `${HOST}/web/checkpoints/today?projectid=${props.projectid}&sortby=${sort}`
      );
      let checkpoints = result.data.map(project => new Checkpoint(project));
      setCheckpoints(checkpoints);
    };
    if (isToday) {
      fetchTodayCheckpoints();
    } else {
      fetchCheckpoints();
    }
  }, [sort, isToday]);

  return (
    <>
      <h5>Checkpoints</h5>
      <CheckpointFilterDropdown setSort={setSort} />
      {
        isToday ?
          <button className='btn btn-danger ml-2' onClick={() => setToday(false)}>All Times</button> :
          <button className='btn btn-primary ml-2' onClick={() => setToday(true)}>Today</button>
      }
      <div>
        <table className="table table-borderless">
          <thead>
            <tr>
              <th scope="col">ID</th>
              <th scope="col">Name</th>
              <th scope="col">Landmark</th>
              <th scope="col">Location</th>
              <th scope="col">Created Date</th>
            </tr>
          </thead>
          <tbody>
            {checkpoints.map(checkpoint => (
              <CheckpointRow key={checkpoint.id} checkpoint={checkpoint} />
            ))}
          </tbody>
        </table>
      </div>
    </>
  );
};

export const CheckpointHeader = props => {
  const [project, setProject] = useState({
    code: "",
    name: "",
    location: "",
    description: ""
  });

  useEffect(() => {
    const fetchProjectDetail = async () => {
      const result = await axios.get(`${HOST}/web/project/data/${props.projectid}`);
      setProject(result.data);
    };
    fetchProjectDetail();
  }, []);

  return (
    <>
      <div className="h3">
        {project.code} - {project.name}
      </div>
      <p>{project.location}</p>
      <p>{project.description}</p>
      <Link
        to={`/project/${props.projectid}/checkpoint/new`}
        type="button"
        className="btn btn-primary"
      >
        Create Checkpoint
      </Link>
      <br />
    </>
  );
};

export default props => {
  let projectid = props.match.params.id;
  const history = useHistory();
  return (
    <MainLayout>
      <div className="row">
        <div className="col-12 d-flex flex-row-reverse">
          <GoBackButton history={history} />
        </div>
      </div>
      <div className="row">
        <div className="col">
          <CheckpointHeader projectid={projectid} />
        </div>
      </div>
      <br />
      <CheckpointList projectid={projectid} />
      <br />
      <CheckpointFromMobileList history={history} projectid={projectid} />
    </MainLayout>
  );
};
