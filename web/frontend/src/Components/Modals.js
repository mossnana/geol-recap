import React, {useState} from 'react'
import { Button, Modal, ModalHeader, ModalBody, ModalFooter } from 'reactstrap';

export const DeleteModal = (props) => {
    const {
        buttonLabel,
        title,
        body,
        deleteAction
    } = props;

    const [modal, setModal] = useState(false);

    const toggle = async () => {
        setModal(!modal);
    }

    const onDelete = async() => {
        await deleteAction()
        setModal(!modal);
    }

    return (
        <>
            <Button color="danger" size="sm" className="btn-cover" onClick={toggle}>{buttonLabel}</Button>
            <Modal isOpen={modal} toggle={toggle}>
                <ModalHeader toggle={toggle}>{title}</ModalHeader>
                <ModalBody>
                    {body}
                </ModalBody>
                <ModalFooter>
                    <Button color="danger" onClick={onDelete}>Delete</Button>{' '}
                    <Button color="secondary" onClick={toggle}>Cancel</Button>
                </ModalFooter>
            </Modal>
        </>
    );
}