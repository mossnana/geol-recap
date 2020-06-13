import React, { useState, useEffect, useContext } from "react";
import { compose, withProps } from "recompose";
import {
  withScriptjs,
  withGoogleMap,
  GoogleMap,
  Marker,
  InfoWindow
} from "react-google-maps";
import Axios from "axios";
import { HOST } from '../../config'
import { Checkpoint } from '../../Classes/Checkpoint'
import { Link } from "react-router-dom";
import { Project } from "../../Classes/Project";
import { Typeahead } from "react-bootstrap-typeahead";
import ProjectSelector from './ProjectSelector'
import UserContext from '../../Contexts/UserContext'

const MyMapComponent = compose(
  withProps({
    googleMapURL:
      "https://maps.googleapis.com/maps/api/js?key=AIzaSyAvwA_0q-mwU6FaaSciolDtwO1hhZTBheY&v=3.exp&libraries=geometry,drawing,places",
    loadingElement: <div style={{ height: `100%` }} />,
    containerElement: <div style={{ height: `400px` }} />,
    mapElement: <div style={{ height: `100%` }} />
  }),
  withScriptjs,
  withGoogleMap
)(props => {
  return (
    <>
      <GoogleMap defaultZoom={8} defaultCenter={{ lat: 13.785235, lng: 100.544727 }}>
        {props.isMarkerShown && (
          <>
            {props.markers?.map(marker => <Marker key={marker.id} position={{ lat: parseFloat(marker.latitude), lng: parseFloat(marker.longitude) }}>
              <InfoWindow>
                <div>
                  <Link to={`/project/${marker?.projectid}/checkpoint/${marker?.id}`}>{marker?.name}</Link>
                </div>
              </InfoWindow>
            </Marker>)}
          </>
        )}
      </GoogleMap>
    </>
  )
});


export default () => {
  const {user, setUser} = useContext(UserContext)
  const [projects, setProjects] = useState([])
  const [selectedProject, setSelectedProject] = useState([])
  const [markers, setMarkers] = useState([])

  useEffect(() => {
    const fetchProjects = async () => {
      let result = await Axios.get(`${HOST}/web/projects?userid=${user.id}`)
      let projects = result.data
      setProjects(projects)
    }
    fetchProjects()
  }, [])

  useEffect(() => {
    const fetchPoints = async () => {
      let result = await Axios.get(`${HOST}/web/checkpoints?projectid=${selectedProject[0]?.id}`)
      let checkpoints = result.data?.map((checkpoint) => new Checkpoint(checkpoint))
      setMarkers(checkpoints)
    }
    if(selectedProject?.length != 0) {fetchPoints()}
  }, [selectedProject])
  return (
    <>
      Map
      <br />
      <div>
        <p>Projects </p>
        <Typeahead 
          id='projects'
          labelKey="name"
          multiple={false}
          onChange={setSelectedProject}
          placeholder='Search Projects'
          options={projects}
          selected={selectedProject}
        />
        <button className='btn btn-danger' onClick={(e) => {
          e.preventDefault()
          setMarkers([])
          setSelectedProject([])
          
        }}>Clear</button>
      </div>
      <br />
      <MyMapComponent isMarkerShown markers={markers} />
    </>
  )
}
