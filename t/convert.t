use strict;
use warnings;

use Test::More;
use Data::Convert::Hash::Rename;

my $rules = +{
    leave   => 'leave',
    before  => 'after',
    convert => sub {
        my ( $key, $value ) = @_;
        return {
            $key => $value,
            version => 'v1',
        };
    },
    combine => sub {
        my ( $key, $value, $before ) = @_;
        return {
            $key => {
                combine => $value,
                version => $before->{version},
            },
        };
    },
};

my $converter = Data::Convert::Hash::Rename->new($rules);

sub test_method {
    my (%specs) = @_;
    my ($input, $expects, $desc) = @specs{qw/input expects desc/};

    subtest $desc => sub {
        my $result = $converter->rename($input);
        is_deeply $result, $expects;
    };
}

test_method(
    input   => +{ leave => 'houchi' },
    expects => +{ leave => 'houchi' },
    desc    => 'not convert',
);

test_method(
    input   => +{ before => 'houchi' },
    expects => +{ after  => 'houchi' },
    desc    => 'rename field',
);

test_method(
    input   => +{ convert => 'houchi' },
    expects => +{ convert => 'houchi', version => 'v1' },
    desc    => 'adding',
);

test_method(
    input   => +{ combine => 'houchi', version => 'v2' },
    expects => +{ combine => { combine => 'houchi', version => 'v2' } },
    desc    => 'combine',
);

done_testing;
