import React, { useContext } from "react";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faFile,
  faFolder,
  faDoorOpen,
  faUser,
  faMapSigns
} from "@fortawesome/free-solid-svg-icons";
import "../../styles/Sidebar.css";
import { Link, useHistory } from "react-router-dom";
import UserContext from "../../Contexts/UserContext";

const SidebarMenu = ({ title, icon, currentLayout, link }) => {
  return (
    <Link
      to={link}
      className={currentLayout ? "menu-button-current" : "menu-button"}
    >
      <div className="row">
        <div className="col-1">
          <FontAwesomeIcon icon={icon} />
        </div>
        <div className="col-5">{title}</div>
      </div>
    </Link>
  );
};

export default props => {
  const currentLayout = props.currentLayout;
  const history = useHistory();
  const user = useContext(UserContext);
  const logout = () => {
    localStorage.removeItem("user");
    user.setUser(undefined);
    history.push("/");
  };
  return (
    <div className="sidenav">
      <p className="text-white text-center ml-2 mr-2">GEOL RECAP PORTAL</p>
      <div className="m-2">
        <SidebarMenu
          title="Projects"
          icon={faFolder}
          currentLayout={currentLayout === 1}
          link="/home"
        />
        <SidebarMenu
          title="Map"
          icon={faMapSigns}
          currentLayout={currentLayout === 2}
          link="/map"
        />
        <SidebarMenu
          title="Profile"
          icon={faUser}
          currentLayout={currentLayout === 3}
          link="/setting"
        />

        <div
          onClick={logout}
          className={
            currentLayout === 4 ? "menu-button-current" : "menu-button"
          }
        >
          <div className="row">
            <div className="col-1">
              <FontAwesomeIcon icon={faDoorOpen} />
            </div>
            <div className="col-5">Logout</div>
          </div>
        </div>
      </div>
    </div>
  );
};
