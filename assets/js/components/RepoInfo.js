import React from 'react'
import styled from 'styled-components'

const RepoInfoContainer = styled.div`
  display: flex;
  justify-content: space-between;
  align-items: center;
  max-width: 1000px;
  width: 100%;
  padding: 8px;
  border: 1px solid black;
  border-bottom: none;

  &:first-of-type {
    border-top-left-radius: 5px;
    border-top-right-radius: 5px;
  }
  &:last-of-type {
    border-bottom-left-radius: 5px;
    border-bottom-right-radius: 5px;
    border-bottom: 1px solid black;
  }

`
const StyledContent = styled.div`
  display: flex;
  flex-direction: column;
`
const StyledTitle = styled.a`
  font-size: 18px;
`
const StyledDesc = styled.p`
  margin-bottom: 0;
  color: #0000008a;
`
const StyledRepoContent = styled.p`
  margin-bottom: 0;
  padding: 0 3px;
  border-right: 1px solid #0000008a;
  &:last-of-type {
    border-right: none;
  }
`

const NoteContainer = styled.div`
  display: flex;
`

const LanguageText = styled.p`
  margin-bottom: 0;
  border-right: 1px solid #0000008a;
  padding-right: 3px;
  color: ${props => props.color};
`

const StyledAvatar = styled.div`
  background: url(${props => props.src}) no-repeat;
  min-width: 95px;
  max-width: 95px;
  min-height: 95px;
  max-height: 95px;
  border-radius: 100%;
  background-size: cover;
`

export default ({
    avatar_url,
    title,
    description,
    url,
    stars,
    daily_stars,
    forks,
    language,
    language_color
    }) => {
    return <RepoInfoContainer>
        <StyledContent>
        <StyledTitle href={url}>{title}</StyledTitle>
        <StyledDesc>{description}</StyledDesc>
        <NoteContainer>
            <LanguageText color={"#" + language_color}>{language}</LanguageText>
            <StyledRepoContent>{stars} stars</StyledRepoContent>
            <StyledRepoContent>{daily_stars} stars of last day</StyledRepoContent>
            <StyledRepoContent>{forks} forks</StyledRepoContent>
        </NoteContainer>
        </StyledContent>
        <StyledContent>
        <StyledAvatar src={avatar_url} />
        </StyledContent>
    </RepoInfoContainer>
}