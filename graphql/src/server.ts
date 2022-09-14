import * as http from 'http';
import { postgraphile, watchPostGraphileSchema } from 'postgraphile';
import PostGraphileConnectionFilterPlugin  from 'postgraphile-plugin-connection-filter';
import BlogPostTitleImagePlugin from './BlogPostTitleImagePlugin';



http.createServer(
    postgraphile(
        {
            host: process.env.PGHOST,
            user: process.env.PGUSER,
            password: process.env.PGPASSWORD,
            database: process.env.PGDATABASE,
            
        },
        "public", {
            watchPg: true,
            graphiql: true,
            ownerConnectionString: 'postgres://postgres:postgres@localhost/postgres',
            enhanceGraphiql: true,
            jwtPgTypeIdentifier: 'public.jwt_token',
            jwtSecret: 'Supersecret',
            pgDefaultRole: 'anonymous',
            appendPlugins: 
                [PostGraphileConnectionFilterPlugin, BlogPostTitleImagePlugin]
    }
    )
).listen(5000);