import React, { useState, useContext, useEffect } from "react";
import { Input } from 'reactstrap'
import UserContext from "../../Contexts/UserContext";
import Axios from "axios";
import { HOST } from '../../config'

export default () => {
  const { user, setUser } = useContext(UserContext)
  const [userInfo, setUserInfo] = useState({
    name: user?.name,
    email: user?.email
  })
  const [currentPassword, setCurrentPassword] = useState("")
  const [password, setPassword] = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [passwordValidated, setValidated] = useState(true)
  const [message, setMessage] = useState("")
  useEffect(() => {
    if (password === confirmPassword) {
      setValidated(true)
    } else {
      setValidated(false)
    }
  }, [password, confirmPassword])
  const onUpdate = async (e) => {
    e.preventDefault()
    let result = await Axios.post(`${HOST}/web/user/update`, {
      name: userInfo.name,
      email: userInfo.email,
      id: user.id
    })
    setUser(result.data)
  }
  const onUpdatePassword = async (e) => {
    e.preventDefault()
    if (password === "" || confirmPassword === "") return false
    let result = await Axios.post(`${HOST}/web/user/updatepassword`, {
      id: user.id,
      currentpassword: currentPassword,
      password: password
    })
    if(result.data?.message === "error") {
      setMessage("error")
      setTimeout(() => {
        setMessage("")
      }, 1000)
    }
  }
  return <>
    Profile
    <p style={{
      marginBottom: "0px"
    }}>Name / Team's Name</p>
    <Input defaultValue={userInfo?.name} onChange={e => {
      setUserInfo({ ...userInfo, name: e.target.value })
    }} />
    <p style={{
      marginBottom: "0px"
    }}>Email</p>
    <Input defaultValue={userInfo?.email} onChange={e => {
      setUserInfo({ ...userInfo, email: e.target.value })
    }} />
    <button onClick={onUpdate} className="btn btn-primary">Update Profile</button>
    <br />
    <br />
    <p style={{
      marginBottom: "0px"
    }}>Current Password</p>
    <Input onChange={e => {
      setCurrentPassword(e.target.value)
    }} type="password" />
    <p style={{
      marginBottom: "0px"
    }}>New Password</p>
    <Input onChange={e => {
      setPassword(e.target.value)
    }} type="password" />
    <p style={{
      marginBottom: "0px"
    }}>Confirm New Password</p>
    <Input onChange={e => {
      setConfirmPassword(e.target.value)
    }} type="password" />
    {passwordValidated ? (
      <></>
    ) : (
        <>
          <br />
          <div className="alert alert-danger" role="alert">
            <p>Password and Confirm Password didn't matched.</p>
          </div>
        </>
      )}
    <button onClick={onUpdatePassword} className="btn btn-primary">Update Password</button>
    {message !== "" ?
      <>
        <br />
        <div className="alert alert-danger" role="alert">
          <p>Your Current Password and New Password didn't matched.</p>
        </div>
      </> :
      <></>
    }
  </>;
};
