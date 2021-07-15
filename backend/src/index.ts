import express from 'express'
import auth from 'basic-auth'

// 環境変数からBASIC認証のID/PWを取得
const admin = {
    username: process.env.BASIC_AUTH_USERNAME,
    password: process.env.BASIC_AUTH_PASSWORD
};

const app: express.Express = express()
app.use(express.json())
app.use(express.urlencoded({ extended: true }))

// BASIC認証チェック
app.use((req: express.Request, res: express.Response, next: express.NextFunction)=>{
    const user = auth(req);

    if(!user || admin.username !== user.name || admin.password !== user.pass) {
        res.set('WWW-Authenticate', 'Basic realm="example"');
        return res.status(401).send();
    }
    next();
})

// CORS
app.use((req: express.Request, res: express.Response, next: express.NextFunction) => {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "*")
    res.header("Access-Control-Allow-Headers", "*");
    next();
})

// public配下をstatic file hosting
app.use(express.static('public'));

// backend api
app.get('/api/v1/', (req: express.Request, res: express.Response) => {
    res.send(JSON.stringify({}))
})

app.listen(3000, () => {
    console.log("Start on port 3000.")
})
