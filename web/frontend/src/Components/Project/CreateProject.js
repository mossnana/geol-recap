import React, { useState, useContext } from "react";
import { useHistory } from "react-router-dom";
import axios from "axios";
import UserContext from "../../Contexts/UserContext";
import { HOST } from "../../config";

export default () => {
  const user = useContext(UserContext);
  const history = useHistory();
  const [name, setName] = useState("");
  const [location, setLocation] = useState("");
  const [description, setDescription] = useState("");
  const onCreate = async e => {
    e.preventDefault();
    var result = await axios.post(
      `${HOST}/web/project/create`,
      {
        createdby: user.user.id,
        name,
        location,
        description
      }
    );
    history.push("/home");
  };
  return (
    <>
      <div>
        <form>
          <div className="form-group">
            <label>Project Name</label>
            <input
              type="text"
              className="form-control"
              onChange={e => setName(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label>Project Location</label>
            <input
              type="text"
              className="form-control"
              onChange={e => setLocation(e.target.value)}
            />
          </div>
          <div className="form-group">
            <label>Project Description</label>
            <textarea
              className="form-control"
              rows="3"
              onChange={e => setDescription(e.target.value)}
            />
          </div>
          <button className="btn btn-primary" onClick={onCreate}>
            Create
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
