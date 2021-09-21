import express from 'express';

const app = express();
const port = process.env.PORT || 8080;

app.use();

app.get('/', (req, res) => {});

app.listen(port, () => {
	console.log(`Server running on port ${port}`);
});
