import { gql, makeExtendSchemaPlugin } from "postgraphile";
import axios from 'axios';

const BlogPostTitleImagePlugin = makeExtendSchemaPlugin(build => {
  return {
    typeDefs: gql`
    extend type Blogpost {
      titleImageUrl: String!
    }`,
    resolvers: {
      Blogpost: {
        titleImageUrl: async () => {
          const cat = await axios.get('https://api.thecatapi.com/v1/images/search?limit=1', {headers: {[ 'x-api-key']: process.env['CAT_API_KEY']!, 'Accept': 'application/json' } } )
          return cat.data[0]['url']
        }
      }

    }
  }
})
export default BlogPostTitleImagePlugin;