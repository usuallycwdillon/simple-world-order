#! /usr/bin/env python
'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'
import datetime as dtg
from environment import *
from agents import *

# experiment controls
debuging = False
verbosity = True
timestamp = None

# configurations
populations_set = set()
new_pops = 1
LANDS = 33   # the number of hex lands on one side of the hex world; 33 --> 1189 lands
world = []
global all_agents, kingdoms, empires, church


def run():
    global church, empires, kingdoms, all_agents
    '''
    Following the canonical theory, the Fast Process is:
    K: kingdoms, empires, the Church, etc (polities) exist --> C or ~C
        ~C: No change (or not enough change) occurs to cause conflict between polities; next step
       C: Conflict (internal or external) occurs
    --> Need for (each) Agent to (individually) respond to conflict is recognized or not; N or ~N
        ~N: Conflict affects Agent, their Lands, the Populations on those Lands
         N: Agent must choose whether to do something about the Change/Conflict
    --> Agent selects 0 or more responses from their behavior list
        ~U: Agent does not undertake any action, next step is P or ~P
         --> ~P: The conflict resolves itself; back to K
              P: The conflict continues
         U: each Agent offers/accepts to end conflict (add or eliminate behaviors, reduce army, give land or resources)
    --> ~P: The agreement does not lead to peace; back to C
         P: Peace through changes at U;
            This creates a new Institution or Agent may join an existing Institution, which requires behavior change and resources
    --> ~S: The Institution fails (party behaviors not eliminated, consumes too many resources, etc)
         S: Institution persists
    This process collects (or not) more polities until all (existing) polities are involved in compatible institutions or
    all under the same institution: The emergent world order.
    '''
    timestamp = getTimeStamp()
    print timestamp
    print len(world)
    world_pop = 0
    for l in world:
        for p in l.has_populations:
            world_pop += p.size

    print "The world population is " + str(world_pop) + ", so we know the world exists and that it's populated."

    test = random.choice(world)
    print "The land at ", test.location, " has neighbors at: "
    for n in test.neighbors:
        print n

    for em in empires:
        print '\n', em.name

    print "The Church has lands:"
    for l in church.lands:
        print l.location


    ## Use a geometric distribution to assert the probability that any attempt to make peace, treat, etc will result in
    #  success. http://www.math.wm.edu/~leemis/chart/UDR/PDFs/Geometric.pdf
    #  :: where the pdf is: f(x) = p(1-p)^x, and the cdf where P(X <= x) is: F(x) = 1-(1-p)^(x+1)



def setupWorld(): # canonical state K

    ## Create environment (includes populating lands)
    global populations_set, church, empires, kingdoms, all_agents

    POPS = int(2.1 * hex_rate(LANDS))

    for p in range(POPS):
        this_pop = Population("ppl" + str(p))
        populations_set.add(this_pop)

    #  Create a world out of LANDS Lands
    side = -1 * LANDS # The world is hexagonal with sides LANDS number of hexes long
    for lx in range(side, -(side-1), 1):
        dy = -1 * lx
        if lx < 0:
            for ly in range(dy, -1, -1):
                land = Land(lx, ly)
                addPopulations(land)    # Take populations from the list and put them on lands
                world.append(land)      # Add the lands to the world
        else:
            for ly in range(dy, 1, 1):
                land = Land(lx, ly)
                addPopulations(land)
                world.append(land)

    ## Create agents
    #  Create 1 Church, 10% of lands, religion 'A'
    church_lands = int(LANDS * 0.1)
    church = Church()
    addLands(church, church_lands)


    # land_distribution

    #  Create 5 Empires to represent Sweden, England, France, Spain and the Holy Roman Empire (HRE)
    empire_names = ['Not_Sweden', 'Not_France', 'Not_Spain', 'Not_England', 'Not_HRE']
    empires = [Kingdom(n, 'Empire') for n in empire_names]
    #  Create 100 other kingdoms

    ## Assign lands to kingdoms, empires

    #  Assign 60 kingdoms to HRE as suzerent, 20 (random share) to other empires; 20 are independent


def addLands(l, n):
    first = random.choice(world)
    these_lands = [first]
    world.remove(first)
    n -= 1
    for nn in range(n):
        try:
            here = random.choice(these_lands)
            there = random.choice(here.neighbors)
            if there in world and there not in l.lands:
                these_lands.append(there)
                world.remove(there)
            else:
                these_lands.append(any(w for w in world if w.x == there[0] and w.y == there[1]))
                nn -= 1
        except:
            if len(world) == 0:
                print 'There is not enough land in the world!'
                break
            else:
                these_lands.append(there.neighbors)
            pass
    l.lands.append(these_lands)

def addPopulations(l):
    '''
    Each land gets between 1 and 3 populations from (the bottom of) the populations list.
    :param l:
    :return: None
    '''
    global populations_set
    global new_pops
    s = random.randint(1, 3)
    for si in range(s):
        if len(populations_set) > 0:
            this_pop = populations_set.pop()
            l.has_populations = this_pop
        else:
            if verbosity: print 'Land at ' + " : ".join(l.location) + ' added a new population.'
            l.has_populations = Population("ppl" + str(POPS + new_pops))
            new_pops += 1


def getTimeStamp(detail = 'short'):
    timestamp = dtg.datetime.now()
    dt = str("%02d"%timestamp.hour) + str("%02d"%timestamp.minute) + "." + str("%02d"%timestamp.second) + "EDT"
    if detail != 'short':
        dt += "_" + str(timestamp.year) + str("%02d"%timestamp.month) + str("%02d"%timestamp.day)
    return dt

def hex_rate(s):
    r = range(s, 2*s)
    n = sum(r + r[0:-1])
    return n



if __name__ == "__main__":
    setupWorld()
    run()





