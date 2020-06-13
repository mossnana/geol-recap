import React, { useState } from 'react'
import {
    ButtonDropdown,
    DropdownToggle,
    DropdownMenu,
    DropdownItem
} from "reactstrap";

export default props => {
    const [dropdownOpen, setOpen] = useState(false);
    const toggle = () => setOpen(!dropdownOpen);
    return (
        <ButtonDropdown isOpen={dropdownOpen} toggle={toggle}>
            <DropdownToggle caret size="sm" color="success">
                {props.selectedProject?.name}
            </DropdownToggle>
            <DropdownMenu>
                {props.projects?.map(project => <DropdownItem onClick={e => {
                    e.preventDefault()
                    console.log(e.target)
                    props.setSelectedProject(e.target.value)
                }} value={project} key={project?.id}>{project?.name}</DropdownItem>)}
            </DropdownMenu>
        </ButtonDropdown>
    );
}