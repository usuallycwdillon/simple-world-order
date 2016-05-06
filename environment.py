'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'

from __future__ import division
from __future__ import print_function
import random
import collections
import math

class Land(object):
    def __init__(self, x, y, z):
        self.x = x
        self.y = y
        self.z = z
        self._has_population = []
        self._has_resources =

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
        self._has_population = value


class Population(object):
    def __init__(self):
        self.size = int(random.lognormvariate(8.5, .5))
        self.religion = random.choice(['A', 'B', 'C', 'D'])
        self.heritage =



# class Land(namedtuple('Land', 'x y z')):
#      __slots__ = ()
#     @property
#     def has_population(self):
#         '''The population of Europe was approximately 100M throughout the 17th C. Average /10k lands is ~10k/land'''
#         return int(random.lognormvariate(8.7, 1)
#
#     def has_resources(self):
#         '''Huge assumption! Even then, populations were drawn to resources, so f(population) = resources.'''
#         temp =
#         return int(random)
#
#
#     def directionOf(self):
#         rel_directions = [Land(1, 0, -1), Land(1, -1, 0), Land(0, -1, 1), Land(-1, 0, 1), Land(-1, 1, 0), Land(0, 1, -1)]
#         return
#
#     def diagonals(self):
#         return [self(2, -1, -1), self(1, -2, 1), self(-1, -1, 2), self(-2, 1, 1), self(-1, 2, -1), self(1, 1, -2)]
#
#     def inLine(self):
#         return -1 * (self.x - self.y)
#
#
#
#
#     EVEN = 1
#     ODD = -1
#
#     def addLand(self, adj):
#         return Land(self.x + adj.x, self.y + adj.y, self.z + adj.z)
#
#     def subractLand(self, adj):
#         return Land(self.x - adj.x, self.y - adj.y, self.z - adj.z)
#
#     def goDirection(direction):
#         return self.directions[direction]
#
#     def neighbor(self, direction):
#         return self.addLand(self.goDirection(direction))
#
#     def diagonal_neighbor(self, direction):
#         return self.addLand(self.diagonals[direction])
#
#     def getLength(self):
#         return (abs(self.x) + abs(self.y) + abs(self.z)) // 2
#
#     def getDistance(self, other):
#         return self.getLength(self.subtractLand(other))
#
#
# def qoffset_from_cube(offset, h):
#     col = h.q
#     row = h.r + (h.q + offset * (h.q & 1)) // 2
#     return OffsetCoord(col, row)
#
# def qoffset_to_cube(offset, h):
#     q = h.col
#     r = h.row - (h.col + offset * (h.col & 1)) // 2
#     s = -q - r
#     return Hex(q, r, s)
#
# def roffset_from_cube(offset, h):
#     col = h.q + (h.r + offset * (h.r & 1)) // 2
#     row = h.r
#     return OffsetCoord(col, row)
#
# def roffset_to_cube(offset, h):
#     q = h.col - (h.row + offset * (h.row & 1)) // 2
#     r = h.row
#     s = -q - r
#     return Hex(q, r, s)


class War(object, belig, opp):
    beligerant = beligerant
    opponent = opp

    def consume():