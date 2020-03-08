const { app } = require("./service.js")

const port = 8080

app.listen(port, () => {
    console.log('Listening on container port ' + port);
})