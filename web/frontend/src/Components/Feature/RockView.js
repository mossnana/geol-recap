import React, { useState, useEffect } from 'react'
import MainLayout from '../../Layouts/Main/MainLayout'
import { Row, Col, FormGroup, Input } from "reactstrap";
import axios from "axios";
import { HOST } from '../../config'
import { useHistory, Link } from 'react-router-dom';
import {GoBackButton} from '../GoBack'

export const SedimentaryRockInfoView = (props) => {
    return (
        <>
            <h5>
                {props?.rock?.code} - {props?.rock?.name}
            </h5>
            <div>
                <p className="font-weight-bold text-gray">Code :</p>
                <p className="">{props?.rock?.code}</p>

                <p className="font-weight-bold">Name :</p>
                <p className="">{props?.rock?.name}</p>

                <p className="font-weight-bold">Lithology :</p>
                <p className="">{props?.rock?.lithology}</p>

                <p className="font-weight-bold">Lithology Description :</p>
                <p className="">{props?.rock?.lithologydescription}</p>

                <p className="font-weight-bold">Fossil :</p>
                <p className="">{props?.rock?.fossil}</p>

                <p className="font-weight-bold">Fossil Description :</p>
                <p className="">{props?.rock?.otherfossil}</p>

                <Row form>
                    <Col md={6}>
                        <p className="font-weight-bold">Dip :</p>
                        <p className="">{props?.rock?.dip}</p>
                    </Col>
                    <Col md={6}>
                        <p className="font-weight-bold">Strike :</p>
                        <p className="">{props?.rock?.strike}</p>
                    </Col>
                </Row>

                <p className="font-weight-bold">Structure :</p>
                <p className="">{props?.rock?.structure}</p>

                <p className="font-weight-bold">Grain Size :</p>
                <p className="">{props?.rock?.grainsize}</p>

                <p className="font-weight-bold">Grain Morphology :</p>
                <p className="">{props?.rock?.grainmorphology}</p>

                <p className="font-weight-bold">Description :</p>
                <p className="">{props?.rock?.description}</p>
            </div>
        </>
    )
}

export const IgneousRockInfoView = (props) => {
    return (
        <>
            <h5>
                {props?.rock?.code} - {props?.rock?.name}
            </h5>
            <div>
                <p className="font-weight-bold text-gray">Code :</p>
                <p className="">{props?.rock?.code}</p>

                <p className="font-weight-bold">Name :</p>
                <p className="">{props?.rock?.name}</p>

                <p className="font-weight-bold">Lithology Description :</p>
                <p className="">{props?.rock?.lithologydescription}</p>

                <p className="font-weight-bold">Field Relation :</p>
                <p className="">{props?.rock?.fieldrelation}</p>

                <p className="font-weight-bold">Field Relation Description :</p>
                <p className="">{props?.rock?.fieldrelationdescription}</p>

                <p className="font-weight-bold">Chemical Composition :</p>
                <p className="">{props?.rock?.composition}</p>


                <p className="font-weight-bold">Description :</p>
                <p className="">{props?.rock?.description}</p>
            </div>
        </>
    )
}

export const MetamorphicRockInfoView = (props) => {
    return (
        <>
            <h5>
                {props?.rock?.code} - {props?.rock?.name}
            </h5>
            <div>
                <p className="font-weight-bold text-gray">Code :</p>
                <p className="">{props?.rock?.code}</p>

                <p className="font-weight-bold">Name :</p>
                <p className="">{props?.rock?.name}</p>

                <p className="font-weight-bold">Lithology Description :</p>
                <p className="">{props?.rock?.lithologydescription}</p>

                <p className="font-weight-bold">Field Relation Description :</p>
                <p className="">{props?.rock?.fieldrelationdescription}</p>

                <p className="font-weight-bold">Foliation Description :</p>
                <p className="">{props?.rock?.foliationdescription}</p>

                <p className="font-weight-bold">Cleavage Description :</p>
                <p className="">{props?.rock?.cleavagedescription}</p>

                <p className="font-weight-bold">Boudin Description :</p>
                <p className="">{props?.rock?.boudindescription}</p>

                <p className="font-weight-bold">Chemical Composition :</p>
                <p className="">{props?.rock?.composition}</p>

                <p className="font-weight-bold">Description :</p>
                <p className="">{props?.rock?.description}</p>
            </div>
        </>
    )
}

export default (props) => {
    const [rock, setRock] = useState({})
    const history = useHistory()
    let projectid = props.match.params.projectid
    let checkpointid = props.match.params.checkpointid
    let rockid = props.match.params.id
    useEffect(() => {
        const fetchRock = async () => {
            const result = await axios.get(`${HOST}/web/rock/data/${rockid}`);
            setRock(result.data);
        };
        fetchRock()
    }, [])
    const onDelete = async () => {
        await axios.post(
            `${HOST}/web/rock/delete/${rockid}`
        );
        history.goBack();
    };
    if (rock?.type === 'sedimentary') {
        return (
            <MainLayout>
                <div className="row">
                    <div className="col-12 d-flex flex-row-reverse">
                        <GoBackButton history={history} />
                    </div>
                </div>
                <SedimentaryRockInfoView rock={rock} />
                <Link to={`/project/${projectid}/checkpoint/${checkpointid}/feature/rock/sedimentary/${rockid}/edit`} className='btn btn-primary btn-block'>Edit</Link>
                <button className='btn btn-danger btn-block' onClick={onDelete}>Delete</button>
            </MainLayout>
        )
    } else if (rock?.type === 'igneous') {
        return (
            <MainLayout>
                <div className="row">
                    <div className="col-12 d-flex flex-row-reverse">
                        <GoBackButton history={history} />
                    </div>
                </div>
                <IgneousRockInfoView rock={rock} />
                <Link to={`/project/${projectid}/checkpoint/${checkpointid}/feature/rock/igneous/${rockid}/edit`} className='btn btn-primary btn-block'>Edit</Link>
                <button className='btn btn-danger btn-block' onClick={onDelete}>Delete</button>
            </MainLayout>
        )
    } else if (rock?.type === 'metamorphic') {
        return (
            <MainLayout>
                <div className="row">
                    <div className="col-12 d-flex flex-row-reverse">
                        <GoBackButton history={history} />
                    </div>
                </div>
                <MetamorphicRockInfoView rock={rock} />
                <Link to={`/project/${projectid}/checkpoint/${checkpointid}/feature/rock/metamorphic/${rockid}/edit`} className='btn btn-primary btn-block'>Edit</Link>
                <button className='btn btn-danger btn-block' onClick={onDelete}>Delete</button>
            </MainLayout>
        )
    } else {
        return (
            <MainLayout>
                Loading ...
            </MainLayout>
        )
    }

}