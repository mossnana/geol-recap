import React, { useState, useEffect } from "react";
import { useHistory } from "react-router-dom";
import axios from "axios";
import { HOST } from "../../config";

export default props => {
  const history = useHistory();
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [comfirmPassword, setConfirmPassword] = useState("");
  const [passwordValidated, setPasswordValidated] = useState(false);
  const [role, setRole] = useState("student");
  useEffect(() => {
    if (password !== comfirmPassword) {
      setPasswordValidated(false);
    } else {
      setPasswordValidated(true);
    }
  }, [password, comfirmPassword]);
  const handleSignup = async () => {
    var result = await axios.post(`${HOST}/web/signup`, {
      name,
      email,
      password,
      role
    });
    if (result) {
      history.goBack();
    } else {
      console.log("Error");
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
      <label>Your Name / Team Name</label>
      <input
        type="text"
        className="form-control"
        required
        autoFocus
        onChange={e => setName(e.target.value)}
      />
      <br />
      <label>Email</label>
      <input
        type="email"
        className="form-control"
        onChange={e => setEmail(e.target.value)}
        required
      />
      <br />
      <label>Password</label>
      <input
        type="password"
        className="form-control"
        onChange={e => setPassword(e.target.value)}
        placeholder="Password"
        required
      />
      <input
        type="password"
        onChange={e => setConfirmPassword(e.target.value)}
        className="form-control"
        placeholder="Confirm Password"
        required
      />
      {passwordValidated ? (
        <></>
      ) : (
        <>
          <br />
          <div className="alert alert-danger" role="alert">
            Password and Confirm Password didn't matched.
          </div>
        </>
      )}
      <br />
      {/* <label>Roles</label>
      <select
        className="form-control"
        defaultValue=""
        onChange={e => setRole(e.target.value)}
      >
        <option selected value="" />
        <option selected value="student">
          Student
        </option>
        <option value="teacher">Teacher</option>
      </select>
      <br /> */}

      {passwordValidated && password !== "" && role !== "" ? (
        <button
          onClick={handleSignup}
          className="btn btn-lg btn-success btn-block"
        >
          Sign up
        </button>
      ) : (
        <button disabled className="btn btn-lg btn-success btn-block">
          Sign up
        </button>
      )}
      <button
        className="btn btn-lg btn-danger btn-block"
        onClick={() => history.push("/")}
      >
        Go back
      </button>
    </div>
  );
};
