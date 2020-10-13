import React, { useState } from "react";
import styled from 'styled-components';
import { RepoInfo, SearchRepo, Button } from './components'
import { showAll, showByTitle, updateAll } from './api'

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
    showAll()
  }, [])

  const showAll = () => {
    if(!dataLoading) {
      setLoading(true)
    }
    showAll('/api/getRepos').then(res => {
      if(res.length > 0) {
        setList(res)
      }
    }).finally(() => setLoading(false))
  }

  const searchRepo = (repoName) => {
    if(!dataLoading) {
      setLoading(true)
    }
    showByTitle('/api/getRepoByTitle', { title: repoName }).then(res => {
      if(res) {
        setList([res])
      }
    }).finally(() => setLoading(false))
  }

  const updateRepos = () => {
    updateAll('/api/updateRepos')
      .then(() => alert('Proccess terminated'))
      .catch(() => alert('Error'))
  }

  console.log('repo list', repoList)
  return <Container>
    <IteractionContainer>
      <Button color="#1BE351" onClick={showAll}>Show all</Button>
      <SearchRepo onSubmit={(name) => searchRepo(name)} color="#FAD30B"></SearchRepo>
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