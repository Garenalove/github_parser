import { instance } from './localhost.instance'

export default (url, { title }) => instance.get(url, {
    params: {
        title
    }
})