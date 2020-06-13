import React, { useState } from "react";
import "../node_modules/bootstrap/dist/css/bootstrap.min.css";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Redirect
} from "react-router-dom";
import { User } from "./Classes/User";
import { UserProvider } from "./Contexts/UserContext";
import SigninLayout from "./Layouts/Authentication/SigninLayout";
import SignupLayout from "./Layouts/Authentication/SignupLayout";
import MainLayout from "./Layouts/Main/MainLayout";
import ProjectView from "./Components/Project/Project";
import MapView from "./Components/Map/Map";
import CheckpointList from "./Components/Checkpoint/Checkpoint";
import CreateProject from "./Components/Project/CreateProject";
import CreateCheckpoint from "./Components/Checkpoint/CreateCheckpoint";
import FeatureList from "./Components/Feature/Feature";
import CreateRockFeature from "./Components/Feature/CreateRockFeature";
import CreateStructureFeature from "./Components/Feature/CreateStructureFeature";
import Setting from "./Components/Setting/Setting";
import EditProject from "./Components/Project/EditProject";
import EditCheckpoint from './Components/Checkpoint/EditCheckpoint'
import RockView from './Components/Feature/RockView'
import StructureView from './Components/Feature/StructureView'
import EditRock from './Components/Feature/EditFeature'
import EditStructure from './Components/Feature/EditStructure'

export const getLocalUser = () => {
  var result = localStorage.getItem("user");
  if (result === null) {
    return undefined;
  } else {
    let jsonResult = JSON.parse(result);
    return new User(jsonResult);
  }
};

export default function App() {
  const [user, setUser] = useState(getLocalUser());
  return (
    <UserProvider
      value={{
        user,
        setUser
      }}
    >
      <Router>
        <Switch>
          <Route path="/" exact>
            {user !== undefined ? <Redirect to="/home" /> : <SigninLayout />}
          </Route>
          <Route path="/signup">
            <SignupLayout />
          </Route>
          <Route path="/home">
            <MainLayout currentLayout={1}>
              <ProjectView />
            </MainLayout>
          </Route>
          <Route path="/map">
            <MainLayout currentLayout={2}>
              <MapView />
            </MainLayout>
          </Route>
          <Route path="/setting">
            <MainLayout currentLayout={3}>
              <Setting />
            </MainLayout>
          </Route>
          <Route path="/project/new" exact>
            <MainLayout>
              <CreateProject />
            </MainLayout>
          </Route>
          <Route path="/project/:id/edit" component={EditProject} exact />
          <Route path="/project/:id" component={CheckpointList} exact />
          <Route path="/project/:projectid/checkpoint/new" component={CreateCheckpoint} exact />
          <Route path="/project/:projectid/checkpoint/:id" component={FeatureList} exact />
          <Route path="/project/:projectid/checkpoint/:id/edit" component={EditCheckpoint} exact />
          <Route
            path="/project/:projectid/checkpoint/:checkpointid/feature/rock/new/:type"
            component={CreateRockFeature}
            exact
          />
          <Route
            path="/project/:projectid/checkpoint/:checkpointid/feature/structure/new"
            component={CreateStructureFeature}
            exact
          />
          <Route
            path="/project/:projectid/checkpoint/:checkpointid/feature/rock/:id"
            component={RockView}
            exact
          />
          <Route
            path="/project/:projectid/checkpoint/:checkpointid/feature/structure/:id"
            component={StructureView}
            exact
          />
          <Route
            path="/project/:projectid/checkpoint/:checkpointid/feature/rock/:type/:id/edit"
            component={EditRock}
            exact
          />
          <Route
            path="/project/:projectid/checkpoint/:checkpointid/feature/structure/:id/edit"
            component={EditStructure}
            exact
          />
        </Switch>
      </Router>
    </UserProvider>
  );
}
