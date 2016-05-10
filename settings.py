import datetime as dtg
from copy import deepcopy, copy

'''
Created 9 May 2016

'''
__author__ = 'usuallycwdillon@github.io'

def init():

    # experiment controls
    global debuging
    global verbosity
    global timestamp
    global populations_set
    global new_pops
    global world
    global free_world
    global all_agents
    global kingdoms
    global empires
    global church
    global church_size
    global emp_sizes

    global LANDS
    global POPS


    debuging = False
    verbosity = True
    timestamp = None

    # initialize configuration settings and globals
    populations_set = set()
    new_pops = 1
    world = []
    all_agents = []
    kingdoms = []
    empires = []

    LANDS = 33   # the number of hex lands on one side of the hex world; 33 --> 1189 lands
    POPS = int(2.1 * hex_rate(LANDS))
    church_size = int(hex_rate(LANDS) * 0.10)
    emp_sizes = [int(hex_rate(LANDS) * s) for s in [0.11, 0.09, 0.19, 0.20]]


def getTimeStamp(detail = 'short'):
    global timestamp
    timestamp = dtg.datetime.now()
    dt = str("%02d"%timestamp.hour) + str("%02d"%timestamp.minute) + "." + str("%02d"%timestamp.second) + "EDT"
    if detail != 'short':
        dt += "_" + str(timestamp.year) + str("%02d"%timestamp.month) + str("%02d"%timestamp.day)
    return dt


def hex_rate(s):
    r = range(s, 2*s)
    n = sum(r + r[0:-1])
    return n