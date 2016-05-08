'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'

import random
from collections import namedtuple
import math
from worldOrder import LANDS

class Land(object):
    global LANDS
    def __init__(self, x, y):
        self.x = x
        self.y = y
        self.z = -x - y
        if self.x + self.y + self.z != 0:
            return None
        self.q = self.x
        self.r = self.z
        self._has_populations = []
        self._has_resources = random.randint(30, 100)
        self.location = (str(self.x), str(self.y), str(self.z))
        self._neighbors = []

    @property
    def neighbors(self):
        # my_neighbors= []
        for d in self.directions:
            nx = self.x + d[0]
            ny = self.y + d[1]
            nz = self.z + d[2]
            if abs(nx) and abs(ny) and abs(nz) <= LANDS:
                neighbor = (nx, ny, nz)
                if neighbor in self._neighbors: pass
                else: self._neighbors.append(neighbor)
            else:
                pass
        return self._neighbors


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
        self.has_populations.append(value)
    @has_populations.deleter
    def has_populations(self, value):
        if len(self._has_populations) > 0:
            self.has_populations = self.has_populations.remove(value)

    @property
    def directions(self):
        return [(1, 0, -1), (1, -1, 0), (0, -1, 1), (-1, 0, 1), (-1, 1, 0), (0, 1, -1)]

    @property
    def diagonals(self):
        return [(2, -1, -1), (1, -2, 1), (-1, -1, 2), (-2, 1, 1), (-1, 2, -1), (1, 1, -2)]



class Population(object):
    def __init__(self, identifier):
        self.name = identifier
        self.size = int(random.lognormvariate(8.5, .5))
        self.religion = random.choice(['A', 'B', 'C', 'D'])
        self.heritage = random.choice(['A', 'B', 'C', 'D'])
        self.ideology = random.choice(['A', 'B', 'C', 'D'])
        self.culture = random.choice(['A', 'B', 'C', 'D'])

class Diet(object):
    def __init__(self):
        self.membership = []

