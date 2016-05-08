__author__ = 'usuallycwdillon@github.io'

from abc import ABCMeta


class Agent(object):
    """

    """
    __metaclass__ = ABCMeta

    def __init__(self, type = ''):
        self.pol_type = type
        self.has_suzerents = []
        self.has_tributes = []
        self.has_lands = []

    @property
    def pol_type(self):
        return self.pol_type
    @pol_type.setter
    def pol_type(self, newType):
        self.pol_type = newType


class Kingdom(Agent):
    """
    :param pol_type
    """
    def __init__(self, type):
        self.pol_type = 'Kingdom'


class Empire(Agent):
    """
    :param pol_type
    """
    def __init__(self, type):
        self.pol_type = 'Empire'

class Church(Agent):
    """
    :param pol_type
    """
    def __init__(self):
        self.pol_type = 'Church'



