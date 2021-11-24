const Koa = require('koa')
const Router = require('koa-router')
const sendfile = require('koa-sendfile')
const Mustache = require('mustache')
const fs = require('fs')
const path = require('path')

const app = new Koa()

app.use(async function (ctx, next) {
  await sendfile(ctx, path.join(__dirname, '../', ctx.path))
  if (ctx.status === 404) {
    await next()
  }
})

const router = new Router()

router.get('/', sendPage('Home'))
router.get('/login', sendPage('Login'))
router.get('/settings', sendPage('Settings'))
router.get('/profile/:username', sendPage('Profile'))
router.get('/register', sendPage('Register'))
router.get('/article', sendPage('Article'))
router.get('/editor', sendPage('ArticleEditor'))
router.get('/editor/:slug', sendPage('ArticleEditor'))

app.use(router.routes())

app.listen(3000)

const layout = fs.readFileSync(path.join(__dirname, '../layout.html'), { encoding: 'utf8' })

function sendPage (bundle) {
  return function (ctx) {
    ctx.status = 200
    ctx.headers['content-type'] = 'text/html'
    ctx.body = Mustache.render(layout, { bundle })
  }
}
