import React, { useState, useContext, useEffect } from "react";
import { Link } from "react-router-dom";
import UserContext from "../../Contexts/UserContext";
import "../../styles/Project.css";
import axios from "axios";
import ProjectRow from "./ProjectRow";
import { Project } from "../../Classes/Project";
import { HOST } from "../../config";

export const ProjectList = props => {
  return (
    <>
      <br />
      {props.isLoading ? <p>Loading ....</p> : <></>}
      <table className="table table-borderless">
        <thead>
          <tr className="text-center">
            <th scope="col">Code</th>
            <th scope="col">Name</th>
            <th scope="col">Location</th>
            <th scope="col">Description</th>
            <th scope="col">Actions</th>
          </tr>
        </thead>
        <tbody>
          {props.projects?.map(project => (
            <ProjectRow key={project.id} project={project} />
          ))}
        </tbody>
      </table>
    </>
  );
};

export const ProjectHeader = props => {
  return (
    <>
      <div className="h3">Projects</div>
      <br />
      <Link to="/project/new" type="button" className="btn btn-primary">
        Create project
      </Link>
    </>
  );
};

export default () => {
  const user = useContext(UserContext);
  const [projects, setProjects] = useState([]);
  const [isLoading, setLoading] = useState(false);
  useEffect(() => {
    setLoading(true);
    const fetchProjects = async () => {
      const result = await axios.get(
        `${HOST}/web/projects?userid=${user.user.id}`
      );
      let projects = result.data.map(project => new Project(project));
      setLoading(false);
      setProjects(projects);
    };
    fetchProjects();
    // eslint-disable-next-line
  }, []);
  return (
    <>
      <ProjectHeader projects={projects} />
      <br />
      <ProjectList projects={projects} isLoading={isLoading} />
    </>
  );
};
