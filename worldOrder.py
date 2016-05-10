#! /usr/bin/env python
import settings

from environment import *
from agents import *

'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'


def run(ticks):
    ticks = ticks
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
    timestamp = settings.getTimeStamp()
    print timestamp
    print len(settings.world)
    world_pop = 0
    for l in settings.world:
        for p in l.has_populations:
            world_pop += p.size

    print "The world population is " + str(world_pop) + ", so we know the world exists and that it's populated."

    test = random.choice(settings.world)
    print "The land at ", test.location, " has neighbors at: "
    for n in test.neighbors:
        print n.location_string

    for em in settings.empires:
        print '\n', em.name

    print "The Church has lands:"
    for l in settings.church.lands:
        print l.location_string


    ## Use a geometric distribution to assert the probability that any attempt to make peace, treat, etc will result in
    #  success. http://www.math.wm.edu/~leemis/chart/UDR/PDFs/Geometric.pdf
    #  :: where the pdf is: f(x) = p(1-p)^x, and the cdf where P(X <= x) is: F(x) = 1-(1-p)^(x+1)



def setupWorld(): # canonical state K

    for p in range(settings.POPS):
        this_pop = Population("ppl" + str(p))
        settings.populations_set.add(this_pop)

    #  Create a world out of LANDS Lands
    side = -1 * settings.LANDS # The world is hexagonal with sides LANDS number of hexes long
    for lx in range(side, -(side-1), 1):
        dy = -1 * lx
        if lx < 0:
            for ly in range(dy, -1, -1):
                land = Land(lx, ly)
                land.addPopulations()    # Take populations from the list and put them on lands
                settings.world.append(land)      # Add the lands to the world
        else:
            for ly in range(dy, 1, 1):
                land = Land(lx, ly)
                land.addPopulations()
                settings.world.append(land)

    # OK to instantiate a disposable copy of the world for processing distribution of lands
    settings.free_world = list(settings.world)

    ## Create agents
    #  Create 1 Church, 10% of lands, religion 'A'
    settings.church = Church()
    settings.church.addLands(settings.church_size)

    #  Create 5 Empires to represent Sweden, England, France, Spain and the Holy Roman Empire (HRE)
    empire_names = ['Not_Sweden', 'Not_France', 'Not_Spain', 'Not_England', 'Not_HRE']
    settings.empires = [Kingdom(n, 'Empire') for n in empire_names]

    #  Create 100 other kingdoms
    kingdom_names = ["kingdom" + str(x) for x in range(1, 101, 1)]
    settings.kingdoms = [Kingdom(n, 'Kingdom') for n in kingdom_names]

    ## Assign lands to kingdoms, empires
    for k in settings.kingdoms:
        k.addLands(random.choice([1,2]))

    for em in settings.empires[0:-1]:
        em.addLands(random.choice(settings.emp_sizes))

    settings.empires[-1].addLands(0) # indicates that HRE gets the rest of the free world

    #  Assign 60 kingdoms to HRE as suzerent, 20 (random share) to other empires; 20 are independent
    for i in range(80):
        for k in settings.kingdoms:
            k.suzerent = random.choice(settings.empires)
    for k in settings.kingdoms:
        if k.religion == 'A':
            k.suzerent = settings.church


if __name__ == "__main__":
    settings.init()
    setupWorld()
    run(2400) # number of ticks. if tick = 1 month, then 200 years = 2400





