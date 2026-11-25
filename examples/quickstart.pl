# Copyright 2026 Google LLC
use strict;
use warnings;
use PDL;
use PDL::ML::Token::SentencePiece;

my $model_path = $ARGV[0];
if (!defined $model_path) {
    die 'Usage: perl examples/quickstart.pl /path/to/tokenizer.model' . "\n";
}

# 1. Load a trained SentencePiece model
my $sp = PDL::ML::Token::SentencePiece->new(model => $model_path);
printf "Loaded SentencePiece vocabulary (%d pieces)\n", $sp->piece_size;

# 2. Encode text into a 1-D PDL long ndarray of token IDs
my $text = 'PDL brings fast n-dimensional arrays to Perl.';
my $ids  = $sp->encode($text);
printf "Encoded %d tokens: %s\n", $ids->nelem, $ids;

# 3. Decode the PDL ndarray back to text
my $decoded = $sp->decode($ids);
print 'Decoded: ', $decoded, "\n";
