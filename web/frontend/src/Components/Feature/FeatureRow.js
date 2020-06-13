import React from "react";
import { Link } from "react-router-dom";

export const RockFeatureRow = props => {
  return (
    <tr>
      <td>
        <Link to={`/project/${props.projectid}/checkpoint/${props.checkpointid}/feature/rock/${props.rock.id}`}>{props.rock?.code}</Link>
      </td>
      <td>{props.rock?.name}</td>
      <td>{props.rock.getType()}</td>
    </tr>
  );
};

export const RockFeatureMobileRow = props => {
    return (
      <tr>
      <td>
        <Link to={`/project/${props.projectid}/checkpoint/${props.checkpointid}/feature/rock/${props.rock.id}`}>{props.rock?.name}</Link>
      </td>
      <td>{props.rock?.uploadby}</td>
      <td><button className='btn btn-primary' onClick={() => props.setSelectedRocks(props.rock)}>Select</button></td>
    </tr>
    )
};

export const StructureFeatureRow = props => {
  return (
    <tr>
      <td>
        <Link to={`/project/${props.projectid}/checkpoint/${props.checkpointid}/feature/structure/${props.structure.id}`}>{props.structure?.code}</Link>
      </td>
      <td>{props.structure?.name}</td>
      <td>{props.structure?.structure}</td>
    </tr>
  );
};

export const StructureFeatureMobileRow = props => {
  return (
    <tr>
      <td>
        <Link to={`/project/${props.projectid}/checkpoint/${props.checkpointid}/feature/structure/${props.structure.id}`}>{props.structure?.code}</Link>
      </td>
      <td>{props.structure?.name}</td>
      <td>{props.structure?.uploadby}</td>
      <td><button className='btn btn-primary' onClick={() => props.setSelectedStructure(props.structure)}>Select</button></td>
    </tr>
  );
};
