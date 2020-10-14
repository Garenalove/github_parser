import React, { useState } from 'react'
import Button from './Button'
import styled from 'styled-components'


const StyledInput = styled.input`
  margin-bottom: 0;
  max-width: 150px;
  font-size: 13px;
  padding: 2px 4px;
  border-radius: 5px;
  border: none;
  box-shadow: 0px 1px 3px;
  outline: none;
`

const SearchContainer = styled.div`
  display: flex;
  justify-content: space-between;
  width: 260px;
`

export default ({
    color,
    onSubmit
  }) => {
    const [repoName, setName] = useState('')
    return <SearchContainer>
      <StyledInput value={repoName} onChange={(e) => setName(e.target.value)}/>
      <Button onClick={() => onSubmit(repoName)} color={color}>
        Find repo
      </Button>
    </SearchContainer>
}