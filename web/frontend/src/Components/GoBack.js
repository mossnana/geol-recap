import React from 'react'
import '../styles/Button.css'

export const GoBackButton = (props) => {
    return (
        <button className="btn goback" onClick={() => props.history.goBack()}>
            {'<'} Back
        </button>
    )
}