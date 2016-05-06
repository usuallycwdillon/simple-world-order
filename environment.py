'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'

from __future__ import division
from __future__ import print_function
import random
from collections import namedtuple
import math

class Land(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
        self._has_population = makePop()
        self._has_resources = random.randint(5, 100)

    @property
    def has_resources(self):
        return self._has_resources
    @has_resources.setter
    def has_resources(self, value):
        self._has_resources = value

    @property
    def has_population(self):
        return self._has_population
    @has_population.setter
    def (self, value):
        self._has_population = self.has_population.update(value)
    @has_population.deleter
    def (self, value):
        self.has_population = self.has_population.remove(value)

    def makePop():
        pop = []
        s = random.randint(1,3)
        for si in range(s):
            p = Population()
            pop.append(p)

    rel_directions = [(1, 0, -1), (1, -1, 0), (0, -1, 1), (-1, 0, 1), (-1, 1, 0), (0, 1, -1)]
    rel_diagonals = [(2, -1, -1), (1, -2, 1), (-1, -1, 2), (-2, 1, 1), (-1, 2, -1), (1, 1, -2)]

class Population(object):
    def __init__(self):
        self.name =
        self.size = int(random.lognormvariate(8.5, .5))
        self.religion = random.choice(['A', 'B', 'C', 'D'])
        self.heritage = random.choice(['A', 'B', 'C', 'D'])
        self.ideology = random.choice(['A', 'B', 'C', 'D'])
        self.culture = random.choice(['A', 'B', 'C', 'D'])


