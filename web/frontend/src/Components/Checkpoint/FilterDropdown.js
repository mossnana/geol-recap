import React, { useState } from "react";
import {
  ButtonDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from "reactstrap";

export const CheckpointFilterDropdown = props => {
  const [dropdownOpen, setOpen] = useState(false);
  const toggle = () => setOpen(!dropdownOpen);

  return (
    <ButtonDropdown isOpen={dropdownOpen} toggle={toggle}>
      <DropdownToggle caret color="primary">
        Order by
      </DropdownToggle>
      <DropdownMenu>
        <DropdownItem onClick={() => props.setSort('newest_to_oldest')}>Newest to Oldest</DropdownItem>
        <DropdownItem divider />
        <DropdownItem onClick={() => props.setSort('oldest_to_newest')}>Oldest to Newest</DropdownItem>
      </DropdownMenu>
    </ButtonDropdown>
  );
};
