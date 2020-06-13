import React, { useState, useEffect, useContext } from "react";
import { useHistory } from "react-router-dom";
import { Row, Col, FormGroup, Input } from "reactstrap";
import "../../styles/Grid.css";
import MainLayout from "../../Layouts/Main/MainLayout";
import { SedimentaryRockReadOnlyView, IgenousRockReadOnlyView, MetamorphicRockReadOnlyView } from './CreateRockFeature'
import UserContext from "../../Contexts/UserContext";
import axios from "axios";
import { HOST } from "../../config";
import {GoBackButton} from '../GoBack'

export const SedimentaryRockEditView = props => {
    const [rock, setRock] = useState({
        checkpointid: props.checkpointid,
        createdby: props.user.id,
        modifiedby: props.user.id,
        code: "",
        name: "",
        type: "sedimentary",
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
        structure: "",
        grainsize: "",
        grainmorphology: "",
        description: ""
    });
    useEffect(() => {
        const fetchRock = async () => {
            const result = await axios.get(
                `${HOST}/web/rock/data/${props.rockid}`
            );
            setRock(result.data);
        };
        fetchRock()
    }, [])
    const onUpdate = async e => {
        e.preventDefault();
        await axios.post(
            `${HOST}/web/rock/update/${rock.id}`,
            rock
        );
        props.history.push(`/project/${props.projectid}/checkpoint/${props.checkpointid}`);
    };
    return (
        <form>
            <p className="label">Code</p>
            <Input defaultValue={rock?.code} onChange={e => setRock({ ...rock, code: e.target.value })} />
            <p className="label">Name</p>
            <Input defaultValue={rock?.name} onChange={e => setRock({ ...rock, name: e.target.value })} />
            <p className="label">Lithology</p>
            <Input defaultValue={rock?.lithology}
                onChange={e => setRock({ ...rock, lithology: e.target.value })}
            />
            <p className="label">Lithology Description</p>
            <Input
                type="textarea"
                defaultValue={rock?.lithologydescription}
                onChange={e =>
                    setRock({ ...rock, lithologydescription: e.target.value })
                }
            />
            <p className="label">Fossil</p>
            <Input defaultValue={rock?.fossil} onChange={e => setRock({ ...rock, fossil: e.target.value })} />
            <p className="label">Fossil Description</p>
            <Input
                type="textarea"
                defaultValue={rock?.otherfossil}
                onChange={e => setRock({ ...rock, otherfossil: e.target.value })}
            />
            <Row form>
                <Col md={6}>
                    <FormGroup>
                        <p className="label">Dip</p>
                        <Input
                            defaultValue={rock?.dip}
                            onChange={e => setRock({ ...rock, dip: e.target.value })}
                        />
                    </FormGroup>
                </Col>
                <Col md={6}>
                    <FormGroup>
                        <p className="label">Strike</p>
                        <Input
                            defaultValue={rock?.strike}
                            onChange={e => setRock({ ...rock, strike: e.target.value })}
                        />
                    </FormGroup>
                </Col>
            </Row>

            <p className="label">Structure</p>
            <Input
                type="textarea"
                defaultValue={rock?.structure}
                onChange={e => setRock({ ...rock, structure: e.target.value })}
            />

            <p className="label">Grain Size</p>
            <Input
                defaultValue={rock?.grainsize}
                onChange={e => setRock({ ...rock, grainsize: e.target.value })}
            />

            <p className="label">Grain Morphology</p>
            <Input
                type="textarea"
                defaultValue={rock?.grainmorphology}
                onChange={e => setRock({ ...rock, grainmorphology: e.target.value })}
            />

            <p className="label">Description</p>
            <Input
                type="textarea"
                defaultValue={rock?.description}
                onChange={e => setRock({ ...rock, description: e.target.value })}
            />

            <button className="btn btn-primary" onClick={onUpdate}>
                Edit
      </button>
        </form>
    );
};

export const IgenousRockEditView = props => {
    const [rock, setRock] = useState({
        checkpointid: parseInt(props.checkpointid),
        createdby: props.user.id,
        modifiedby: props.user.id,
        code: "",
        name: "",
        type: "igneous",
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
        structure: "",
        grainsize: "",
        grainmorphology: "",
        description: ""
    });
    useEffect(() => {
        const fetchRock = async () => {
            const result = await axios.get(
                `${HOST}/web/rock/data/${props.rockid}`
            );
            setRock(result.data);
        };
        fetchRock()
    }, [])
    const onUpdate = async e => {
        e.preventDefault();
        console.log('ig update')
        await axios.post(
            `${HOST}/web/rock/update/${rock.id}`,
            rock
        );
        props.history.push(`/project/${props.projectid}/checkpoint/${props.checkpointid}`);
    };
    return (
        <form>
            <p className="label">Code</p>
            <Input defaultValue={rock?.code} onChange={e => setRock({ ...rock, code: e.target.value })} />
            <p className="label">Name</p>
            <Input defaultValue={rock?.name} onChange={e => setRock({ ...rock, name: e.target.value })} />
            <p className="label">Texture</p>
            <Input
                defaultValue={rock?.lithology}
                onChange={e => setRock({ ...rock, lithology: e.target.value })}
            />
            <p className="label">Lithology Description</p>
            <Input
                defaultValue={rock?.lithologydescription}
                type="textarea"
                onChange={e =>
                    setRock({ ...rock, lithologydescription: e.target.value })
                }
            />
            <p className="label">Field Relation</p>
            <Input
                defaultValue={rock?.fieldrelation}
                onChange={e => setRock({ ...rock, fieldrelation: e.target.value })}
            />
            <p className="label">Field Relation Description</p>
            <Input
                defaultValue={rock?.fieldrelationdescription}
                type="textarea"
                onChange={e =>
                    setRock({ ...rock, fieldrelationdescription: e.target.value })
                }
            />
            <p className="label">Chemical Composition</p>
            <Input
                defaultValue={rock?.composition}
                type="textarea"
                onChange={e => setRock({ ...rock, composition: e.target.value })}
            />
            <p className="label">Description</p>
            <Input
                defaultValue={rock?.description}
                type="textarea"
                onChange={e => setRock({ ...rock, description: e.target.value })}
            />
            <button className="btn btn-primary" onClick={onUpdate}>
                Edit
      </button>
        </form>
    );
};

export const MetamorphicRockEditView = props => {
    const [rock, setRock] = useState({
        checkpointid: props.checkpointid,
        createdby: props.user.id,
        modifiedby: props.user.id,
        code: "",
        name: "",
        type: "metamorphic",
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
        structure: "",
        grainsize: "",
        grainmorphology: "",
        description: ""
    });
    useEffect(() => {
        const fetchRock = async () => {
            const result = await axios.get(
                `${HOST}/web/rock/data/${props.rockid}`
            );
            setRock(result.data);
        };
        fetchRock()
    }, [])
    const onUpdate = async e => {
        e.preventDefault();
        await axios.post(
            `${HOST}/web/rock/update/${rock.id}`,
            rock
        );
        props.history.push(`/project/${props.projectid}/checkpoint/${props.checkpointid}`);
    };
    return (
        <form>
            <p className="label">Code</p>
            <Input defaultValue={rock?.code} onChange={e => setRock({ ...rock, code: e.target.value })} />
            <p className="label">Name</p>
            <Input defaultValue={rock?.name} onChange={e => setRock({ ...rock, name: e.target.value })} />
            <p className="label">Lithology Description</p>
            <Input
                defaultValue={rock?.lithologydescription}
                type="textarea"
                onChange={e =>
                    setRock({ ...rock, lithologydescription: e.target.value })
                }
            />
            <p className="label">Field Relation Description</p>
            <Input
                defaultValue={rock?.fieldrelationdescription}
                type="textarea"
                onChange={e =>
                    setRock({ ...rock, fieldrelationdescription: e.target.value })
                }
            />

            <p className="label">Foliation Description</p>
            <Input
                defaultValue={rock?.foliationdescription}
                type="textarea"
                onChange={e =>
                    setRock({ ...rock, foliationdescription: e.target.value })
                }
            />
            <p className="label">Cleavage Description</p>
            <Input
                defaultValue={rock?.cleavagedescription}
                type="textarea"
                onChange={e =>
                    setRock({ ...rock, cleavagedescription: e.target.value })
                }
            />
            <p className="label">Boudin Description</p>
            <Input
                defaultValue={rock?.boudindescription}
                type="textarea"
                onChange={e =>
                    setRock({ ...rock, boudindescription: e.target.value })
                }
            />
            <p className="label">Chemical Composition</p>
            <Input
                defaultValue={rock?.composition}
                type="textarea"
                onChange={e => setRock({ ...rock, composition: e.target.value })}
            />
            <p className="label">Description</p>
            <Input
                defaultValue={rock?.description}
                type="textarea"
                onChange={e => setRock({ ...rock, description: e.target.value })}
            />
            <button className="btn btn-primary" onClick={onUpdate}>
                Edit
            </button>
        </form>
    );
};

export default props => {
    const history = useHistory();
    const user = useContext(UserContext);
    const type = props.match.params.type;
    const checkpointid = props.match.params.checkpointid;
    const projectid = props.match.params.projectid;
    const rockid = props.match.params.id;
    const mapView = () => {
        if (type === "sedimentary") {
            return (
                <SedimentaryRockEditView
                    user={user.user}
                    rockid={rockid}
                    history={history}
                    checkpointid={checkpointid}
                    projectid={projectid}
                />
            );
        } else if (type === "igneous") {
            return (
                <IgenousRockEditView
                    user={user.user}
                    rockid={rockid}
                    history={history}
                    checkpointid={checkpointid}
                    projectid={projectid}
                />
            );
        } else {
            return (
                <MetamorphicRockEditView
                    user={user.user}
                    rockid={rockid}
                    history={history}
                    checkpointid={checkpointid}
                    projectid={projectid}
                />
            );
        }
    };
    const readOnlyView = (typeaheadId) => {
        if (type === "sedimentary") {
            return (
                <SedimentaryRockReadOnlyView typeaheadId={typeaheadId}
                    user={user.user}
                    history={history}
                    checkpointid={checkpointid}
                    projectid={projectid} />
            );
        } else if (type === "igneous") {
            return (
                <IgenousRockReadOnlyView typeaheadId={typeaheadId}
                    user={user.user}
                    history={history}
                    checkpointid={checkpointid}
                    projectid={projectid} />
            );
        } else {
            return (
                <MetamorphicRockReadOnlyView
                    typeaheadId={typeaheadId}
                    user={user.user}
                    history={history}
                    checkpointid={checkpointid}
                    projectid={projectid}
                />
            );
        }
    }
    return (
        <MainLayout>
            <div className="row">
                <div className="col-12 d-flex flex-row-reverse">
                    <GoBackButton history={history} />
                </div>
            </div>
            <div className="row">
                <div className="col">Edit</div>
            </div>
            <br />
            <div className="row">
                <div className="col">
                    {readOnlyView(1)}
                </div>
                <div className="col">
                    {readOnlyView(2)}
                </div>
                <div className="col">{mapView()}</div>
            </div>
        </MainLayout>
    );
};
