#! /usr/bin/env python
'''
Created 29 April 2016

'''
__author__ = 'usuallycwdillon@github.io'
import datetime as dtg
import agents
import environment

debuging = False
verbosity = False
timestamp = None

def run():
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
    global timestamp = getTimeStamp()



    ## Use a geometric distribution to assert the probability that any attempt to make peace, treat, etc will result in
    #  success. http://www.math.wm.edu/~leemis/chart/UDR/PDFs/Geometric.pdf
    #  :: where the pdf is: f(x) = p(1-p)^x, and the cdf where P(X ≤ x) is: F(x) = 1-(1-p)^(x+1)





def setupWorld(): # canonical state K

    ## Create environment
    #  Create a field of 10,000 Lands
    #  Each Land gets 1, 2, or 3 Populations, which have culture, ideology, religion and heritage.


    ## Create agents
    #  Create 1 Church with religion 'A'
    #  Create 5 Empires to represent Sweden, England, France, Spain and the Holy Roman Empire
    #  Create 100 other kingdoms
    ## Assign lands to kingdoms, empires; not the church (for simplicity)
    #  Assign 60 kingdoms to HRE as suzerent, 20 (random share) to other empires; 20 are independent






def getTimeStamp(detail = 'short'):
    timestamp = dtg.datetime.now()
    dt = str("%02d"%timestamp.hour) + str("%02d"%timestamp.minute) + "." + str("%02d"%timestamp.second) + "EDT"
    if detail != 'short':
        dt += "_" + str(timestamp.year) + str("%02d"%timestamp.month) + str("%02d"%timestamp.day)
    return dt





if __name__ == "__main__":
    setupWorld()
    run()