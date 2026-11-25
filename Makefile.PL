use 5.010;
use strict;
use warnings;
use ExtUtils::MakeMaker;
use ExtUtils::CppGuess;

my $brew_prefix = '';
if ($^O eq 'darwin') {
    chomp($brew_prefix = `brew --prefix 2>/dev/null` || '');
}
my @inc_dirs = ('/usr/include', '/usr/local/include');
push @inc_dirs, "$brew_prefix/include" if $brew_prefix;
my $sp_inc;
for my $dir (@inc_dirs) {
    if (-f "$dir/sentencepiece_processor.h") {
        $sp_inc = $dir;
        last;
    }
}

if (!$sp_inc) {
    die "libsentencepiece-dev (sentencepiece_processor.h) is required to build PDL::ML::Token::SentencePiece.\n";
}
my $lib_flag = ($brew_prefix && $sp_inc && $sp_inc =~ m{^\$brew_prefix}) ? "-L$brew_prefix/lib " : '';

my $guess    = ExtUtils::CppGuess->new();
my %cpp_opts = $guess->makemaker_options();
$cpp_opts{CCFLAGS} = ($cpp_opts{CCFLAGS} // '') . ' -std=c++17';

WriteMakefile(
    NAME               => 'PDL::ML::Token::SentencePiece',
    AUTHOR             => q{C.J. Collier <cjac@google.com>},
    VERSION_FROM       => 'lib/PDL/ML/Token/SentencePiece.pm',
    ABSTRACT_FROM      => 'lib/PDL/ML/Token/SentencePiece.pm',
    LICENSE            => 'perl_5',
    MIN_PERL_VERSION   => '5.010',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
        'ExtUtils::CppGuess'  => '0.26',
    },
    TEST_REQUIRES => { 'Test::More' => '0.88' },
    PREREQ_PM     => { 'PDL' => '2.080', 'Carp' => '0' },
    %cpp_opts,
    INC           => '-I. -I' . $sp_inc,
    LIBS          => [ $lib_flag . '-lsentencepiece' ],
    ($brew_prefix ? (dynamic_lib => { OTHERLDFLAGS => "-L$brew_prefix/lib -Wl,-rpath,$brew_prefix/lib -lsentencepiece" }) : ()),
    XSOPT         => '-C++',
    clean         => { FILES => 'PDL-ML-Token-SentencePiece-* *.o SentencePiece.bs SentencePiece.c' },
    META_MERGE    => {
        'meta-spec' => { version => 2 },
        resources   => {
            repository => {
                type => 'git',
                url  => 'https://github.com/PDLPorters/PDL-ML-Token-SentencePiece.git',
                web  => 'https://github.com/PDLPorters/PDL-ML-Token-SentencePiece',
            },
            bugtracker => {
                web => 'https://github.com/PDLPorters/PDL-ML-Token-SentencePiece/issues',
            },
        },
    },
);
