import React from "react";
import SignupBox from "../../Components/Authentication/SignupBox";
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
      <SignupBox />
    </div>
  );
};
