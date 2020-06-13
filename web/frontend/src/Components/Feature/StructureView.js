import React, { useState, useEffect } from 'react'
import MainLayout from '../../Layouts/Main/MainLayout'
import { Row, Col, FormGroup, Input } from "reactstrap";
import axios from "axios";
import { HOST } from '../../config'
import { useHistory, Link } from 'react-router-dom';
import {GoBackButton} from '../GoBack'

export const StructureInfoView = (props) => {
    return (
        <>
            <h5>
                {props?.structure?.code} - {props?.structure?.name}
            </h5>
            <div>
                <p className="font-weight-bold text-gray">Code :</p>
                <p className="">{props?.structure?.code}</p>

                <p className="font-weight-bold">Name :</p>
                <p className="">{props?.structure?.name}</p>

                <p className="font-weight-bold">Structure Type :</p>
                <p className="">{props?.structure?.structure}</p>

                <Row form>
                    <Col md={6}>
                        <p className="font-weight-bold">Dip :</p>
                        <p className="">{props?.structure?.dip}</p>
                    </Col>
                    <Col md={6}>
                        <p className="font-weight-bold">Strike :</p>
                        <p className="">{props?.structure?.strike}</p>
                    </Col>
                </Row>

                <Row form>
                    <Col md={6}>
                        <p className="font-weight-bold">Plunge :</p>
                        <p className="">{props?.structure?.dip}</p>
                    </Col>
                    <Col md={6}>
                        <p className="font-weight-bold">Trend :</p>
                        <p className="">{props?.structure?.strike}</p>
                    </Col>
                </Row>

                <p className="font-weight-bold">Description :</p>
                <p className="">{props?.structure?.description}</p>
            </div>
        </>
    )
}

export default (props) => {
    const [structure, setStructure] = useState({})
    const history = useHistory()
    let projectid = props.match.params.projectid
    let checkpointid = props.match.params.checkpointid
    let structureid = props.match.params.id
    useEffect(() => {
        const fetchStructure = async () => {
            const result = await axios.get(`${HOST}/web/structure/data/${structureid}`);
            setStructure(result.data);
        };
        fetchStructure()
    }, [])
    const onDelete = async () => {
        await axios.post(
          `${HOST}/web/structure/delete/${structureid}`
        );
        history.goBack();
      };
    return (
        <MainLayout>
            <div className="row">
                <div className="col-12 d-flex flex-row-reverse">
                    <GoBackButton history={history} />
                </div>
            </div>
            <StructureInfoView key={structure.id} structure={structure} />
            <Link to={`/project/${projectid}/checkpoint/${checkpointid}/feature/structure/${structureid}/edit`} className='btn btn-primary btn-block'>Edit</Link>
            <button className='btn btn-danger btn-block' onClick={onDelete}>Delete</button>
            
        </MainLayout>
    )
}