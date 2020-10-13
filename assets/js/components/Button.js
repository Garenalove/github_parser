import React from 'react'
import styled from 'styled-components'

const Button = styled.button`
    color: white;
    padding: 2px 15px;
    border: none;
    border-radius: 5px;
    background-color: ${props => props.color};
    transition: .5s all;
    margin-bottom: 0;
    &:hover, &:hover:active {
        background-color: ${props => props.color};
        opacity: 0.7;
        color: black;
    }
    &:focus { 
        background-color: ${props => props.color};
   
    }
`
export default ({ color, children }) => <Button color={color}>{children}</Button>

