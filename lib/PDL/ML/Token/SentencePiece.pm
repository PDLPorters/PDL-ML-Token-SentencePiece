package PDL::ML::Token::SentencePiece;

use 5.010;
use strict;
use warnings;
use Carp qw(croak);
use XSLoader;
use PDL::Core ();
use PDL::Lite ();

our $VERSION = '0.011';

XSLoader::load('PDL::ML::Token::SentencePiece', $VERSION);

sub new {
    my ($class, %args) = @_;
    my $self = $class->_new();
    if (defined $args{model}) {
        $self->load($args{model});
    }
    return $self;
}

sub load {
    my ($self, $file) = @_;
    croak 'Model filename required' unless defined $file;
    $self->_load($file) or croak "Failed to load SentencePiece model '$file'";
    return $self;
}

sub encode {
    my ($self, $text) = @_;
    my $ids = $self->_encode_as_ids($text // '');
    return PDL::Core::pdl(PDL::long(), $ids);
}

sub decode {
    my ($self, $ids_pdl) = @_;
    my @ids = ref($ids_pdl) && eval { $ids_pdl->isa('PDL') }
        ? $ids_pdl->list
        : (ref($ids_pdl) eq 'ARRAY' ? @{$ids_pdl} : ());
    return $self->_decode_ids(\@ids);
}

1;

__END__

=head1 NAME

PDL::ML::Token::SentencePiece - SentencePiece C++17/XS tokenizer bindings for PDL ndarrays

=head1 SYNOPSIS

    use PDL::ML::Token::SentencePiece;

    my $sp  = PDL::ML::Token::SentencePiece->new(model => 'tokenizer.model');
    my $ids = $sp->encode('Hello, world!');  # PDL long ndarray
    my $txt = $sp->decode($ids);

=head1 DESCRIPTION

C<PDL::ML::Token::SentencePiece> provides C++17/XS bindings to Google's
C<libsentencepiece> library, encoding text directly into L<PDL> C<long>
token-ID ndarrays and decoding token ndarrays back to text.

=head1 TUTORIAL

This tutorial shows how to load a trained SentencePiece C<.model> file, inspect
its vocabulary size, encode text into a 1-D C<long> L<PDL> token-ID ndarray,
and decode token IDs back into text.

    use strict;
    use warnings;
    use PDL;
    use PDL::ML::Token::SentencePiece;

    # 1. Load a SentencePiece model (e.g. from Llama, Gemma, or T5)
    my $model_path = $ARGV[0] // 'tokenizer.model';
    my $sp = PDL::ML::Token::SentencePiece->new(model => $model_path);

    printf "Loaded SentencePiece vocabulary (%d pieces)\n", $sp->piece_size;

    # 2. Encode text into a 1-D PDL long ndarray of token IDs
    my $text = 'PDL brings fast n-dimensional arrays to Perl.';
    my $ids  = $sp->encode($text);
    print "Token IDs ($ids->nelem tokens): $ids\n";

    # 3. Decode the PDL ndarray (or an arrayref of IDs) back to text
    my $decoded = $sp->decode($ids);
    print "Decoded: $decoded\n";

See C<examples/quickstart.pl> in the distribution for a runnable version of this
tutorial.

=head1 TYPES

Returns 1-D integer token-ID ndarrays of type C<long> (32-bit signed integer)
matching SentencePiece's native C<int> vocabulary IDs.

=head1 AUTHOR

C.J. Collier E<lt>cjac@google.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2026 Google LLC

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut
