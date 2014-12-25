#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DateTime;

zci answer_type => 'date_math';
zci is_cached   => 1;

my @overjan = (
    '01 Jan 2012 + 32 days is 02 Feb 2012',
    structured_answer => {
        input     => ['01 Jan 2012 + 32 days'],
        operation => 'date math',
        result    => '02 Feb 2012',
    },
);

my @first_sec = (
    '01 Jan 2012 + 1 day is 02 Jan 2012',
    structured_answer => {
        input     => ['01 Jan 2012 + 1 day'],
        operation => 'date math',
        result    => '02 Jan 2012',
    },
);

my $six_weeks_ago = DateTime->now->subtract(weeks => 6)->strftime('%d %b %Y');

my $two_weeks_from_today = DateTime->now->add(weeks => 2)->strftime('%d %b %Y');

my $today = DateTime->now->strftime('%d %b %Y');

ddg_goodie_test([qw(
          DDG::Goodie::DateMath
          )
    ],
    'Jan 1 2012 plus 32 days'       => test_zci(@overjan),
    'January 1 2012 plus 32 days'   => test_zci(@overjan),
    'January 1, 2012 plus 32 days'  => test_zci(@overjan),
    'January 1st 2012 plus 32 days' => test_zci(@overjan),
    '32 days from January 1st 2012' => test_zci(@overjan),
    'January 1st plus 32 days'      => test_zci(
        qr/01 Jan [0-9]{4} \+ 32 days is 02 Feb [0-9]{4}/,
        structured_answer => {
            input     => '-ANY-',
            operation => 'date math',
            result    => qr/02 Feb [0-9]{4}/,
        },
    ),
    'date January 1st'      => test_zci(
        qr/01 Jan [0-9]{4}/,
        structured_answer => {
            input     => ['january 1st'],
            operation => 'date math',
            result    => qr/01 Jan [0-9]{4}/,
        }
    ),
    '6 weeks ago'      => test_zci(
        $six_weeks_ago,
        structured_answer => {
            input     => ['6 weeks ago'],
            operation => 'date math',
            result    => $six_weeks_ago,
        }
    ),
    '2 weeks from today'      => test_zci(
        "$today + 2 weeks is $two_weeks_from_today",
        structured_answer => {
            input     => ["$today + 2 weeks"],
            operation => 'date math',
            result    => $two_weeks_from_today,
        }
    ),
    'date today'      => test_zci(
        $today,
        structured_answer => {
            input     => ['today'],
            operation => 'date math',
            result    => $today,
        }
    ),
    '1/1/2012 plus 32 days' => test_zci(@overjan),
    '1/1/2012 plus 5 weeks' => test_zci(
        '01 Jan 2012 + 5 weeks is 05 Feb 2012',
        structured_answer => {
            input     => ['01 Jan 2012 + 5 weeks'],
            operation => 'date math',
            result    => '05 Feb 2012',
        },
    ),
    '1/1/2012 PlUs 5 months' => test_zci(
        '01 Jan 2012 + 5 months is 01 Jun 2012',
        structured_answer => {
            input     => ['01 Jan 2012 + 5 months'],
            operation => 'date math',
            result    => '01 Jun 2012',
        },
    ),
    '1/1/2012 PLUS 5 years' => test_zci(
        '01 Jan 2012 + 5 years is 01 Jan 2017',
        structured_answer => {
            input     => ['01 Jan 2012 + 5 years'],
            operation => 'date math',
            result    => '01 Jan 2017',
        },
    ),
    '1 day from 1/1/2012'     => test_zci(@first_sec),
    '1/1/2012 plus 1 day'     => test_zci(@first_sec),
    '1/1/2012 plus 1 days'    => test_zci(@first_sec),
    '01/01/2012 + 1 day'      => test_zci(@first_sec),
    '1/1/2012 minus ten days' => test_zci(
        '01 Jan 2012 - 10 days is 22 Dec 2011',
        structured_answer => {
            input     => ['01 Jan 2012 - 10 days'],
            operation => 'date math',
            result    => '22 Dec 2011',
        },
    ),
    '1 jan 2014 plus 2 weeks' => test_zci(
        '01 Jan 2014 + 2 weeks is 15 Jan 2014',
        structured_answer => {
            input     => ['01 Jan 2014 + 2 weeks'],
            operation => 'date math',
            result    => '15 Jan 2014',
        },
    ),
    
    'yesterday' => undef,
    'today' => undef,
    'five years' => undef,
    'two months' => undef,
    '2 months' => undef,
    '5 years' => undef,
);

done_testing;

