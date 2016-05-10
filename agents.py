import settings
from abc import ABCMeta
import datetime as dtg
from environment import *
import random

'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'


class Agent(object):
    '''
    The Agent meta-class defines attributes (properties) and common methods for all agents.
    '''
    __metaclass__ = ABCMeta

    def __init__(self, name, pol_type = ''):
        self._name = name
        self._pol_type = pol_type
        self._suzerents = []
        self._tributaries = []
        self._lands = []
        self._religion = random.choice(['A', 'B', 'C', 'D'])
        self._heritage = random.choice(['A', 'B', 'C', 'D'])
        self._ideology = random.choice(['A', 'B', 'C', 'D'])
        self._culture = random.choice(['A', 'B', 'C', 'D'])

    @property
    def name(self):
        return self._name

    @property
    def pol_type(self):
        return self._pol_type

    @pol_type.setter
    def pol_type(self, newType):
        self._pol_type = newType

    @property
    def suzerents(self):
        return self._suzerents

    @suzerents.setter
    def suzerents(self, other):
        self.suzerents.append(other)

    @suzerents.deleter
    def suzerents(self, other):
        self.suzerents.remove(other)

    @property
    def tributaries(self):
        return self._tributaries

    @tributaries.setter
    def tributaries(self, other):
        self._tributaries.append(other)
        if len(self.tributaries) > 2:
            self._pol_type = 'Empire'

    @tributaries.deleter
    def tributaries(self, other):
        if len(self.tributaries) < 2:
            self.pol_type = 'Kingdom'

    @property
    def lands(self):
        return self._lands

    @lands.setter
    def lands(self, land):
        self._lands.append(land)

    def addLands(self, m):
        if m == 0:
            self._lands.append(settings.free_world)
            return
        else:
            n = m
            self.lands = random.choice(settings.free_world)
            settings.free_world.remove(self.lands[0])
            for nn in range(n):
                here = random.choice(self._lands)
                if isinstance(here, bool):
                    pass
                if len(here.neighbors) > 0:
                    there = random.choice(here.neighbors)
                else:
                    pass
                if there in settings.free_world and there not in self.lands:
                    self._lands.append(there)
                    settings.free_world.remove(there)
                else:
                    if any(w for w in settings.free_world):
                        pass
                    else: print 'There is not enough land in the world!'

    @property
    def religion(self):
        return self._religion

    @property
    def heritage(self):
        return self._heritage

    @property
    def ideology(self):
        return self._ideology

    @property
    def culture(self):
        return self._culture

    # TODO: Add agent changes (demographics, religion, wealth; population satisfaction...

    # TODO: Add agent behaviors (attack, defend, interfere, abstain, treat, surrender...



class Institution(object):
    '''
    Institutions have methods but their only attributes are participatory. Agents gain access to new methods
    if they are part of an institution (but they also have to maintain the cost).
    '''
    def __init__(self):
        pass

    # TODO: Institutions increase Opportunity to have peace, negotiate; reduce probability of agression...


class Kingdom(Agent):
    """
    :param pol_type
    :param name
    """
    def __init__(self, name, pol_type='Kingdom'):
        super(Agent, self).__init__()
        self._name = name
        self._pol_type = pol_type
        self._suzerents = []
        self._tributaries = []
        self._lands = []
        self._religion = random.choice(['A', 'B', 'C', 'D'])
        self._heritage = random.choice(['A', 'B', 'C', 'D'])
        self._ideology = random.choice(['A', 'B', 'C', 'D'])
        self._culture =  random.choice(['A', 'B', 'C', 'D'])

class Church(Agent, Institution):
    '''
    The Church was somewhat unique in that (at least in 1648) it held territory but also controlled access to the Diet
    which served as a forum in which to solve (or have the Pope or HRE resolve) conflicts.
    :param pol_type
    '''
    def __init__(self, name='Church', pol_type = 'Church'):
        super(Agent, self).__init__()
        self._pol_type = 'Church'
        self._name = name
        self._pol_type = pol_type
        self._tributaries = []
        self._lands = []
        self._religion = 'A'
        self._heritage = 'A'
        self._ideology = 'A'
        self._culture =  'A'
