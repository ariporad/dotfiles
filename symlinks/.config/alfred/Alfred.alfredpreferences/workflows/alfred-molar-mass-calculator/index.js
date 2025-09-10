const weights = require('./weights');

const DIGITS = 3;
const hasProp = {}.hasOwnProperty;
const sum = arr => arr.reduce((acc, x) => x + acc, 0);

function run(alfy) {
	const elements = alfy.input.match(/([A-Z][a-z]*[0-9]*)/g);

	if (!elements) {
		throw new Error(`Error: Invalid molecular formula: ${alfy.input}!`);
	}

	const mass = sum(
		elements.map(elementExpression => {
			let [_, element, num] = /^([A-Z][a-z]*)([0-9]*)$/g.exec(elementExpression);
			if (!hasProp.call(weights, element)) {
				throw new Error(`Error! Can't find element: ${element}!`);
			}
			if (!num) {
				num = 1;
			}
			return weights[element] * num;
		})
	);

	const formattedMass = mass.toFixed(DIGITS);
	return alfy.output([
		{
			title: `The Molar Mass of ${alfy.input} is ${formattedMass} g/mol`,
			subtitle: 'Press Enter to Copy',
			arg: formattedMass
		}
	]);
}

run(require('alfy'));
