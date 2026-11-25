# PDL::ML::Token::SentencePiece

C++17/XS bindings to Google's `libsentencepiece` library for [PDL](https://pdl.perl.org/), encoding text directly into 1-D `long` PDL token-ID ndarrays and decoding token ndarrays back to text.

## Prerequisites

Install `libsentencepiece` development headers (e.g. `libsentencepiece-dev` on Debian/Ubuntu).

## Installation

```bash
cpanm .
```

Or via ExtUtils::MakeMaker:

```bash
perl Makefile.PL
make
make test
make install
```

## Quickstart

```perl
use strict;
use warnings;
use PDL;
use PDL::ML::Token::SentencePiece;

my $sp  = PDL::ML::Token::SentencePiece->new(model => 'tokenizer.model');
my $ids = $sp->encode('PDL brings fast n-dimensional arrays to Perl.');
my $txt = $sp->decode($ids);

printf "Vocab size: %d | Tokens: %s\n", $sp->piece_size, $ids;
print 'Decoded: ', $txt, "\n";
```

## Documentation & Examples

- Runnable tutorial: `perl examples/quickstart.pl /path/to/tokenizer.model` (see [`examples/quickstart.pl`](examples/quickstart.pl))
- Full POD documentation: `perldoc PDL::ML::Token::SentencePiece` (or [`lib/PDL/ML/Token/SentencePiece.pm`](lib/PDL/ML/Token/SentencePiece.pm))

## License

Copyright 2026 Google LLC. Licensed under the the same terms as Perl itself.
