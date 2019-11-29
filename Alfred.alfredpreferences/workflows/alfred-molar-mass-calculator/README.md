# alfred-molar-mass-calculator [![Build Status](https://travis-ci.org/ariporad/alfred-molar-mass-calculator.svg?branch=master)](https://travis-ci.org/ariporad/alfred-molar-mass-calculator)

> Automatically compute the molar masses of molecules.


## Install

```
$ npm install --global alfred-molar-mass-calculator
```

*Requires [Node.js](https://nodejs.org) 4+ and the Alfred [Powerpack](https://www.alfredapp.com/powerpack/).*


## Usage

In Alfred, type `molm <MOLECULAR FORMULA>` (for example, `molm NaOH` or `molm H2O`),
and the molar mass will be calculated. Press <kbd>Enter</kbd> to copy the result
to your clipboard.


## Data

The data used in this workflow was provided by the [NIST](https://catalog.data.gov/dataset/nist-atomic-weights-and-isotopic-compositions-srd-144).
All uncertainties were ignored, and anywhere that a range of acceptable values was
provided, the average was used.


## License

MIT © [Ari Porad](https://ariporad.com). The data used by this workflow was
produced by NIST. Please see [LICENSE.md](LICENSE.md) for details.

The author of this software bares no responsibilty for incorrect information
provided by this plugin. He cannot be held responsible in any way, shape, or
form for any problems, damage, discomfort, bad grades, or anything else arising
from the use, nonuse, misuse, or abuse of this software or the data contained
within or produced by it in any way.
