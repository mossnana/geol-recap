import React, { useState } from "react";
import {
  ButtonDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from "reactstrap";

const AddFeature = props => {
  const [dropdownOpen, setOpen] = useState(false);

  const toggle = () => setOpen(!dropdownOpen);

  return (
    <ButtonDropdown isOpen={dropdownOpen} toggle={toggle} >
      <DropdownToggle caret size="sm" color="success">
        Add Feature
      </DropdownToggle>
      <DropdownMenu>
        <DropdownItem header>Rocks</DropdownItem>
        <DropdownItem>{props.sedimentary()}</DropdownItem>
        <DropdownItem>{props.igneous()}</DropdownItem>
        <DropdownItem>{props.metamorphic()}</DropdownItem>
        <DropdownItem divider />
        <DropdownItem header>Others</DropdownItem>
        <DropdownItem>{props.structure()}</DropdownItem>
      </DropdownMenu>
    </ButtonDropdown>
  );
};

export default AddFeature;
