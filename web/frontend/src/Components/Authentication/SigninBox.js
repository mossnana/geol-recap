import React, { useState, useContext } from "react";
import { Link, useHistory } from "react-router-dom";
import UserContext from "../../Contexts/UserContext";
import axios from "axios";
import { HOST } from "../../config";
import {User} from '../../Classes/User'

export default () => {
  const history = useHistory();
  const [isLoading, setLoading] = useState(false);
  const [isError, setError] = useState(false);
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const user = useContext(UserContext);
  const onClick = async e => {
    e.preventDefault();
    setLoading(true);
    setTimeout(() => {
      setLoading(false);
    }, 1000);
    var result = await axios.post(`${HOST}/web/signin`, {
      email,
      password
    });
    if (result.data?.hasOwnProperty('id')) {
      localStorage.setItem("user", JSON.stringify(result.data));
      user.setUser(new User(result.data));
      history.push("/home");
    } else {
      setError(true);
      setTimeout(() => {
        setError(false);
      }, 2000);
    }
  };
  return (
    <div
      style={{
        width: "20em",
        maxWidth: "900px",
        margin: "auto",
        alignItems: "center"
      }}
    >
      <h1 className="h4 mb-3 font-weight-normal text-center">
        GEOL RECAP PORTAL
      </h1>
      <br />
      <input
        type="text"
        className="form-control"
        placeholder="Email"
        onChange={e => setEmail(e.target.value)}
        required
        autoFocus
      />
      <br />
      <input
        type="password"
        className="form-control"
        onChange={e => setPassword(e.target.value)}
        placeholder="Password"
        required
      />
      <br />
      {isLoading ? (
        <div className="alert alert-primary" role="alert">
          Signing ...
        </div>
      ) : (
          <></>
        )}
      {isError ? (
        <div className="alert alert-danger" role="alert">
          Your Email or password has wrong.
        </div>
      ) : (
          <></>
        )}
      <br />
      <div onClick={onClick} className="btn btn-lg btn-primary btn-block">
        Sign in
      </div>
      <Link to="/signup" className="btn btn-lg btn-success btn-block">
        Sign up
      </Link>
    </div>
  );
};
