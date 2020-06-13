import React from "react";
import { Link } from "react-router-dom";

export const CheckpointRow = props => {
  return (
    <tr key={props?.checkpoint?.id}>
      <td>{props?.checkpoint?.id}</td>
      <td>
        <Link to={`/project/${props?.checkpoint?.projectid}/checkpoint/${props?.checkpoint?.id}`}>
          {props?.checkpoint?.name}
        </Link>
      </td>
      <td>{props?.checkpoint?.landmark}</td>
      <td>
        N {props?.checkpoint?.north} E {props?.checkpoint?.east}
      </td>
      <td>{`${props?.checkpoint?.createddate.toDateString()} ${props?.checkpoint?.createddate.getHours()}:${props?.checkpoint?.createddate.getMinutes()}`}</td>
    </tr>
  );
};

export const CheckpointMobileRow = props => {
  return (
    <tr key={props?.checkpoint?.id}>
      <td>{props?.checkpoint?.id}</td>
      <td>
        <Link to={`/project/${props?.checkpoint?.projectid}/checkpoint/${props?.checkpoint?.id}`}> {props?.checkpoint?.name}</Link>
      </td>
      <td>{props?.checkpoint?.landmark}</td>
      <td>
        N {props?.checkpoint?.north} E {props?.checkpoint?.east}
      </td>
      <td>{props?.checkpoint?.uploadby}</td>
      <td>{`${props?.checkpoint?.createddate.toDateString()} ${props?.checkpoint?.createddate.getHours()}:${props?.checkpoint?.createddate.getMinutes()}`}</td>
    </tr>
  );
};
