import random
import sys

# note that DGS/DGS2 are missing, because i haven't played them

PURSUITS = {
    4: {  # S TIER
        # casting magic isn't on spotify :'(
        'Pursuit: Lying Coldly': 'spotify:track:2WmchKjNtDdNdf88NRpy0N',
    },
    3: {  # A TIER
        'Pursuit: Cornered': 'spotify:track:4eKkLKZmNPu4yknLQlLowe',
        'Pursuit: Caught': 'spotify:track:1DDJEnio84M3QOaXdkOZ9g',
        '[GK2] Pursuit': 'spotify:track:4FkebXPfFd7uAm919xwFCC',
    },
    2: {  # B TIER
        'Pursuit: Keep Pressing On': 'spotify:track:1kQhd5vbS26viPpL1t5Snf',
    },
    1: {  # C TIER
        'Pressing Pursuit: Cornered': 'spotify:track:0RFqcEz2UQkBccRilC278S',
        'Pursuit: Cornering Together': 'spotify:track:6bUmtdSOCfxIVn3sXnYCyZ',
    },
    # F tier is Wanting To Question and is not allowed here
}

OBJECTIONS = {
    3: { # A TIER
        '2009': 'spotify:track:0PmFgGwoJylaJK7W99UYm3',
        '2011': 'spotify:track:6Hy1lUnx02GUwow46phlmK',
        '2016 [A New Chapter of Trials!]': 'spotify:track:0V7dRIPsYkKedEPueFilvn',
        '2016 [Courtroom Révolutionnaire]': 'spotify:track:2cMlr7x6Z2DQrm2mPDIIhF', # yeah fuck you get with the times and run python 3
    },
    2: { # B TIER
        # F in the chat for 2012
        '2013 [Objection!]': 'spotify:track:1URuAnhd7s5AhaQtq5XRV3',
        '2013 [Courtroom Révolutionnaire!]': 'spotify:track:4U8oxApWmLhoU2Ph0sb6x1',
    },
    1: { # C TIER
        '2013 [A New Chapter of Trials!]': 'spotify:track:4Xpz6DxQ2LsxjIPOT66bui',
        '2016 [Objection!]': 'spotify:track:1vwiPIPJ1NLYFlycvNxgeo',
        '2007': 'spotify:track:3PAfMCf5873Yoa8qK7Ahk4',
        '2001': 'spotify:track:7sVekkhtxOjv0c97ZK4uUM',
    },

    0.5: { # D TIER
        '2004': 'spotify:track:7foTK6Qax6wk8XfYou3zvO',
    }

    # 2002 is F tier
}

CROSS_EXAMINATIONS = {
    3: { # A TIER
        '2009 [Presto]': 'spotify:track:2qGr0iTKlNz4WLZPRbEXCx',
        '2011 [Presto]': 'spotify:track:4FkebXPfFd7uAm919xwFCC',
        '2016': 'spotify:track:0PojbJHbpzO4SqxoJyAQHD',
        '2011 [Logic Chess]': 'spotify:track:5ZRijdReR7dzETDTzgMsqZ',
        '2013 [Running Wild]': 'spotify:track:5aUy8wPd2i6uVcma88KMyy',
    },
    2: { # B TIER
        '2002': 'spotify:track:5nPCRV39AQjDWn8CChAdMY',
        '2004': 'spotify:track:63rOfxxITILSY8KuVaWgYc',
        '2007': 'spotify:track:7M27U3V1gEO4pXWDWNxECx',
    },
    1: { # C TIER
        '2001': 'spotify:track:2tZzovy8PzHWRBzpjBwrBr',
        '2013': 'spotify:track:0Ob886M75SjJatX5lUngtx',
        # for once i'm not sad 2012 isn't on spotify
    }
}

CONFESS_THE_TRUTH = {
    # gosh those two are just miles ahead
    9: { # A tier
        '2004': 'spotify:track:3UNRjQ4wwqYNwuDIcVu4U1',
        '2009': 'spotify:track:5Se1XHexElPGh3cjYUqNfG',
    },
    1: { # C tier
        '2001': 'spotify:track:0u2LtTowSQ0lCZOoEMh34u',
        '2002': 'spotify:track:6YyfXMLuZNaFeGtLsrPPkN',
        '2011': 'spotify:track:1PhmX677IiEI8trSxzrDp8',
        # 2012
        '2013': 'spotify:track:3vbYhRtUaxVD9xmXyiuxGT',
        '2016': 'spotify:track:6Bq7t1qHqfVct9hNRHT72G',
    },
    0: { # F tier
        '2007': 'spotify:track:5FkQqXka3XtK3p1LIJlNvh',
    }
}

SONG_MAPS = {
    'pursuit': PURSUITS,
    'objection': OBJECTIONS,
    'cross': CROSS_EXAMINATIONS,
    'confess': CONFESS_THE_TRUTH,
}


def main():
    if len(sys.argv) < 2:
        print('Usage: {} [pursuit|objection|cross|confess]'.format(sys.argv[0]))
        return
    songs = SONG_MAPS.get(sys.argv[1])
    if not songs:
        print('Usage: {} [pursuit|objection|cross|confess]'.format(sys.argv[0]))
        return
    total_weight = sum(songs.keys())
    t = random.random() * total_weight
    for k, v in songs.items():  # iteration order doesn't matter
        if t < k:
            print('_'.join(random.choice(list(v.items()))))
            return
        t -= k

if __name__ == '__main__':
    main()
