import React from "react";
import SigninBox from "../../Components/Authentication/SigninBox";
import "../../styles.css";

const bodyStyle = {
  display: "flex",
  alignItems: "center",
  backgroundColor: "#f5f5f5",
  paddingTop: "40px",
  paddingBottom: "40px",
  height: "100%"
};

export default () => {
  return (
    <div style={bodyStyle}>
      <SigninBox />
    </div>
  );
};
