import React, { useState, useEffect } from "react";
import styled from 'styled-components';
import { RepoInfo, SearchRepo, Button } from './components'
import { showAll, showBy, updateAll } from './api'

const Container = styled.div`
  display: flex;
  flex-direction: column;
  width: 100%;
`
const ListContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
`

const IteractionContainer = styled.div`
  display: flex;
  justify-content: space-between;
  border-bottom: 1px solid #eaeaea;
  padding-bottom: 2rem;
`

export default function App() {

  const [dataLoading, setLoading] = useState(true)

  const [repoList, setList] = useState([ ])

  useEffect(() => {
    showAllRepos()
  }, [])

  const showAllRepos = () => {
    if(!dataLoading) {
      setLoading(true)
    }
    showAll('/api/getRepos').then(res => {
      if(res.data.length > 0) {
        setList(res.data)
      }
    }).finally(() => setLoading(false))
  }

  const searchRepo = (repoQuery) => {
    if(!dataLoading) {
      setLoading(true)
    }
    showBy('/api/getRepoBy', { query: repoQuery }).then(res => {
      if(res.data) {
        setList([res.data])
      }
    })
    .catch(() => setList([]))
    .finally(() => setLoading(false))
  }

  const updateRepos = () => {
    updateAll('/api/updateRepos')
      .then(() => alert('Proccess terminated'))
      .catch(() => alert('Error'))
  }

  return <Container>
    <IteractionContainer>
      <Button color="#1BE351" onClick={showAllRepos}>Show all</Button>
      <SearchRepo onSubmit={(query) => searchRepo(query)} color="#FAD30B"></SearchRepo>
      <Button color="#4DBCF4" onClick={updateRepos}>Update all</Button>
    </IteractionContainer>
    <ListContainer>
      <p>List of Repositories</p>
      {repoList.length > 0 
        ? repoList.map((repo, index) => <RepoInfo key={index} {...repo} />)
        : !dataLoading && <p>Not exist</p>
      }
    </ListContainer>
  </Container>
}