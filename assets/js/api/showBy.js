import { instance } from './localhost.instance'

export default (url, { query }) => instance.get(url, {
    params: {
        query
    }
})