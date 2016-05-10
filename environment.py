import settings

from collections import namedtuple
import math
import random

'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'


class Land(object):

    def __init__(self, x, y):
        z = -x - y
        self._location = x, y, z
        self._axial = x, z
        self._has_populations = []
        self._has_resources = random.randint(30, 100)
        self._location_string = "land at " + str(self._location)
        self._neighbors = self.find_neighbors()

    @property
    def neighbors(self):
        return self._neighbors

    @property
    def location(self):
        return self._location

    @property
    def location_string(self):
        return self._location_string

    @property
    def has_resources(self):
        return self._has_resources

    @has_resources.setter
    def has_resources(self, value):
        self._has_resources = value

    @property
    def has_populations(self):
        return self._has_populations

    @has_populations.setter
    def has_populations(self, value):
        self._has_populations.append(value)

    @has_populations.deleter
    def has_populations(self, value):
        if len(self._has_populations) > 0:
            self._has_populations.remove(value)

    @property
    def directions(self):
        return [(1, 0, -1), (1, -1, 0), (0, -1, 1), (-1, 0, 1), (-1, 1, 0), (0, 1, -1)]

    @property
    def diagonals(self):
        return [(2, -1, -1), (1, -2, 1), (-1, -1, 2), (-2, 1, 1), (-1, 2, -1), (1, 1, -2)]

    def find_neighbors(self):
        neighborhood = []
        for d in self.directions:
            n = tuple(map(sum, zip(self._location, d)))
            for w in settings.world:
                if cmp(w.location, n) == 0:
                    neighborhood.append(w)
        return neighborhood


    def addPopulations(self):
        '''
        Each land gets between 1 and 3 populations from (the bottom of) the populations list.
        :param l:
        :return: None
        '''
        s = random.randint(1, 3)
        for si in range(s):
            if len(settings.populations_set) > 0:
                this_pop = settings.populations_set.pop()
                self._has_populations = [this_pop]
            else:
                if verbosity: print 'Land at ' + " : ".join(l.location) + ' added a new population.'
                self._has_populations = Population("ppl" + str(settings.POPS + settings.new_pops))
                settings.new_pops += 1


class Population(object):
    def __init__(self, identifier):
        self.name = identifier
        self.size = int(random.lognormvariate(8.5, .5))
        self._religion = random.choice(['A', 'B', 'C', 'D'])
        self._heritage = random.choice(['A', 'B', 'C', 'D'])
        self._ideology = random.choice(['A', 'B', 'C', 'D'])
        self._culture = random.choice(['A', 'B', 'C', 'D'])

class Diet(object):
    def __init__(self):
        self.membership = []

