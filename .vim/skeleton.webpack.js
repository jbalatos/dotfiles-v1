module.exports = {
	mode: 'development',
	context: __dirname+'',
	entry: '',
	output: {
		path: __dirname+'',
		filename: '-bundle.js'
	},
//	module: {
//		rules: [
//			{
//				test: /\.js/,
//				exclude: /node_modules/,
//				loader: 'babel-loader',
//				options: {
//					presets: ['@babel/preset-react']
//				}
//			}
//		]
//	}
}
