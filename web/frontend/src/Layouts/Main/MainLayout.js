import React from "react";
import "../../styles/Sidebar.css";
import Sidebar from "../../Components/Main/Sidebar";

const bodyStyle = {
  display: "flex",
  alignItems: "center",
  backgroundColor: "#f5f5f5",
  paddingTop: "40px",
  paddingBottom: "40px",
  height: "100%"
};

export default props => {
  return (
    <div className={bodyStyle}>
      <Sidebar currentLayout={props.currentLayout} />
      <div className="main">{props.children}</div>
    </div>
  );
};
