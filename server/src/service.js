const express = require('express')
const app = express()

// purposefully add delay.
// app.use((req, res, next) => setTimeout(next, 6000))

app.get('/', (req, res) => {
    let body = "Hello"
    res.status(200).send(body)
})

app.get('*', function(req, res){
    res.send('Oops!', 404);
});

module.exports = {
    app
}