import React, { useState, useEffect, useContext } from "react";
import { useHistory } from "react-router-dom";
import { Row, Col, FormGroup, Input } from "reactstrap";
import "../../styles/Grid.css";
import MainLayout from "../../Layouts/Main/MainLayout";
import { StructureFeatureReadOnlyView } from './CreateStructureFeature'
import UserContext from "../../Contexts/UserContext";
import axios from "axios";
import { HOST } from "../../config";
import {GoBackButton} from '../GoBack'

export const StructureEditView = props => {
    const [structure, setStructure] = useState({
        checkpointid: props.checkpointid,
        createdby: props.user.id,
        modifiedby: props.user.id,
        code: "",
        name: "",
        type: "structure",
        lithology: "",
        lithologydescription: "",
        fieldrelation: "",
        fieldrelationdescription: "",
        foliationdescription: "",
        cleavagedescription: "",
        boudindescription: "",
        composition: "",
        fossil: "",
        otherfossil: "",
        dip: "",
        strike: "",
        plunge: "",
        trend: "",
        structure: "",
        grainsize: "",
        grainmorphology: "",
        description: ""
    });
    useEffect(() => {
        const fetchStructure = async () => {

            const result = await axios.get(
                `${HOST}/web/structure/data/${props.structureid}`
            );
            setStructure(result.data);
        };
        fetchStructure()
    }, [])
    const onUpdate = async e => {
        e.preventDefault();
        await axios.post(
            `${HOST}/web/structure/update/${structure.id}`,
            structure
        );
        props.history.goBack();
    };
    return (
        <form>
            <p className="label">Code</p>
            <Input defaultValue={structure.code} onChange={(e) => setStructure({ ...structure, code: e.target.value })} />
            <p className="label">Name</p>
            <Input defaultValue={structure.name} onChange={(e) => setStructure({ ...structure, name: e.target.value })} />
            <p className="label">Structure Type</p>
            <Input defaultValue={structure.structure} onChange={(e) => setStructure({ ...structure, structure: e.target.value })} />
            <Row form>
                <Col md={6}>
                    <FormGroup>
                        <p className="label">Dip</p>
                        <Input defaultValue={structure.dip} onChange={(e) => setStructure({ ...structure, dip: e.target.value })} />
                    </FormGroup>
                </Col>
                <Col md={6}>
                    <FormGroup>
                        <p className="label">Strike</p>
                        <Input defaultValue={structure.strike} onChange={(e) => setStructure({ ...structure, strike: e.target.value })} />
                    </FormGroup>
                </Col>
            </Row>

            <Row form>
                <Col md={6}>
                    <FormGroup>
                        <p className="label">Plunge</p>
                        <Input defaultValue={structure.plunge} onChange={(e) => setStructure({ ...structure, plunge: e.target.value })} />
                    </FormGroup>
                </Col>
                <Col md={6}>
                    <FormGroup>
                        <p className="label">Trend</p>
                        <Input defaultValue={structure.trend} onChange={(e) => setStructure({ ...structure, trend: e.target.value })} />
                    </FormGroup>
                </Col>
            </Row>

            <p className="label">Description</p>
            <Input type="textarea" defaultValue={structure.description} onChange={(e) => setStructure({ ...structure, description: e.target.value })} />
            <button className="btn btn-primary" onClick={onUpdate}>Edit</button>
        </form>
    );
};

export default props => {
    const history = useHistory();
    const user = useContext(UserContext);
    const checkpointid = props.match.params.checkpointid;
    const projectid = props.match.params.projectid;
    const structureid = props.match.params.id;
    return (
        <MainLayout>
            <div className="row">
                <div className="col-12 d-flex flex-row-reverse">
                    <GoBackButton history={history} />
                </div>
            </div>
            <div className="row">
                <div className="col">
                    <StructureFeatureReadOnlyView type={1} user={user.user} projectid={projectid} checkpointid={checkpointid} history={history} />
                </div>
                <div className="col">
                    <StructureFeatureReadOnlyView type={2} user={user.user} projectid={projectid} checkpointid={checkpointid} history={history} />
                </div>
                <div className="col">
                    <StructureEditView
                        user={user.user}
                        structureid={structureid}
                        history={history}
                        checkpointid={checkpointid}
                        projectid={projectid}
                    />
                </div>
            </div>
        </MainLayout>
    );
};