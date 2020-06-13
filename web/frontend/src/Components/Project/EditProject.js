import React, { useState, useContext, useEffect } from "react";
import { useHistory } from "react-router-dom";
import axios from "axios";
import UserContext from "../../Contexts/UserContext";
import MainLayout from "../../Layouts/Main/MainLayout";
import { HOST } from "../../config";

export const EditProject = props => {
  const user = useContext(UserContext);
  const history = useHistory();
  const [project, setProject] = useState({
    name: "",
    location: "",
    description: "",
    code: ""
  });
  useEffect(() => {
    const fetchProjectDetail = async () => {
      const result = await axios.get(
        `${HOST}/web/project/data/${props.id}`
      );
      const project = result.data;
      setProject(project);
    };
    fetchProjectDetail();
  }, []);
  const onEdit = async e => {
    e.preventDefault();
    await axios.post(
      `${HOST}/web/project/update/${props.id}`,
      {
        modifiedby: user.user.id,
        name: project.name,
        location: project.location,
        description: project.description
      }
    );
    history.push("/home");
  };
  return (
    <>
      <div>
        <form>
          <div className="form-group">
            <label>Project Code</label>
            <input
              type="text"
              className="form-control"
              defaultValue={project.code}
              onChange = {(e) => {
                setProject({...project, code: e.target.value})
              }}
              disabled
            />
          </div>
          <div className="form-group">
            <label>Project Name</label>
            <input
              type="text"
              className="form-control"
              defaultValue={project.name}
              onChange = {(e) => {
                setProject({...project, name: e.target.value})
              }}
            />
          </div>
          <div className="form-group">
            <label>Project Location</label>
            <input
              type="text"
              className="form-control"
              defaultValue={project.location}
              onChange = {(e) => {
                setProject({...project, location: e.target.value})
              }}
            />
          </div>
          <div className="form-group">
            <label>Project Description</label>
            <textarea
              className="form-control"
              rows="3"
              defaultValue={project.description}
              onChange = {(e) => {
                setProject({...project, description: e.target.value})
              }}
            />
          </div>
          <button className="btn btn-warning text-white" onClick={onEdit}>
            Edit
          </button>
          <button
            onClick={() => history.push("/home")}
            className="btn btn-danger ml-2"
          >
            Back
          </button>
        </form>
      </div>
    </>
  );
};

export default props => {
  return (
    <MainLayout>
      <EditProject id={props.match.params.id} />
    </MainLayout>
  );
};
