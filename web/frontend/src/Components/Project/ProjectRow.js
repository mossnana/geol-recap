import React from "react";
import { Link, useHistory } from "react-router-dom";
import axios from "axios";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faTrash, faEdit } from "@fortawesome/free-solid-svg-icons";
import { HOST } from "../../config";
import { DeleteModal } from '../Modals'

export default props => {
  const { project } = props;
  const history = useHistory();
  const onDelete = async () => {
    await axios.get(
      `${HOST}/web/project/delete/${project.id}`
    );
    history.push("/");
  };
  return (
    <tr key={project.code} className="text-left" style={{lineHeight: '1.5em'}}>
      <td>{project.code}</td>
      <td>
        <Link to={`/project/${project.id}`}> {project.name} </Link>
      </td>
      <td>{project.location}</td>
      <td>{project.description}</td>
      <td>
        <div className='row'>
        <div className='col'>
            <Link
              to={`/project/${project.id}/edit`}
              className="btn btn-warning btn-sm text-white"
            >
              Edit
            </Link>
          </div>
          <div className='col'>
            <DeleteModal title='Confirm ?' buttonLabel='Delete' deleteAction={onDelete} body='Do you want to delete this project ?' />
          </div>
        </div>
      </td>
    </tr>
  );
};
