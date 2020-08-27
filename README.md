
# Webserver log parser

This is a technical test for Smart Pension.

### Usage tips

To get help:

```bash
./parser.rb --help
./parser.rb # without arguments
```

output:

```text
Usage: parser.rb [options] [FILE]
        --report TYPE   Select report type (unique, total)
    -h, --help          Prints this help
```

There are two reports available: `total` and `unique`:

```bash
./parser.rb --report total webserver.log # default report
./parser.rb --report unique webserver.log
```

Parser accepts STDIN input and pipes:

```bash
cat webserver.log | ./parser.rb --report unique
./parser.rb --report total < webserver.log
./parser.rb < webserver.log
```

## Implementation

### The approach

DI is widely used in the project. Classes are usually instantiable. Instance variables and injected dependencies are exposed as getters to make the instances transparent.

### Classes

`BuildReport` is an abstraction layer that calls other classes to parse input, perform actual data transformation and output the result.
`CountTotalVisits` and `CountUniqueVisitors` are report builder classes. They build reports in memory, that may be sub-optimal if the input is really huge. It's fixable though. All other classes support streaming and allow to iterate through the records.
`PaddedColumnsPrinter` is an renderer class example. Renderers must return an enumerable object that can be read line by line. Output is aligned in columns, because.. why not?

### Extendibility

- New input sources, other than files/STDIN can be added.
- New types of reports can be added.
- New formats of input and output can be added.
- Console output format can be customized.

### Executable script

- Handles system I/O errors.
- Outputs errors to STDERR.
- Returns exit code 1 in case of an error.
- No external dependencies. Gemfile is needed for development/testing only.
- Autoloading of classes is used as it allows to avoid using `require`. Being merged, the source code will turn into a single working executable.
- Code in `parser.rb` uses procedural style without wrapping into an `App` or something. I think it's okay for compact console tools that contain non-reuseable code. The script has integration tests.

### Tests

- RSpec: unit tests, integration tests.
- ~100% coverage or so, according to [Simplecov](https://github.com/simplecov-ruby/simplecov) report.
- TDD with [Guard](https://github.com/guard/guard).
- To install dependencies run `bundler install --with test`
- Rubocop
