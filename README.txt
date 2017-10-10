A 'minimal working example' of a world system.

Conceptually, starts with emergence of 'states' at the Peace of Westphalia in 1648 and applies the canonical theory of
social development to the process by which institutions form and an order (the world order) emerges.

### Detailed Plan
Simplified model of world order development.
The model assumes the emergence of the state system, beginning with the Peace of Westphalia, 1648.
There exist approximately 100 kingdoms, most of which are very small (cities) and a few of which are large (England, France, Spain, Sweden).
There exists the remnant of the Holy Roman Empire--the suzerent---to which most small kingdoms owe tribute.
There exists the Church, but different factions within the church and other religions which are not the Church.
There is territory, which is controlled by a kingdom or the Empire. The church does not hold territory (except the See).
The kingdoms and the empire are polities which exist in networks with several relations:

 - Political border networks (the territories that share borders)
 - Political affinity networks (political ideology, which could also be tradition/heritage)
 - Suzerenty networks: which kingdoms pay tribute to other kingdoms/empires

Each plot of territory has people and productivity attribute
The people are represented as a list/dict of bitstring arrays that represent:
0000, 2^4 culture/language
0000, 2^4 heritage (three generations of insider/outsider)
0000, 2^4 religions; 1111 is the Church and 0000 is any anti- position (iconoclasts, calvinists)
0000, 2^4 political ideologies
000, 2^3 satisfaction with government, where 000 is completely dissatisfied and 111 is completely satisfied

kings, emperors control people through the territory
kingdoms get along based in large part by similarity of the descriptive chunks (e.g., the language may be similar or very different;
polities can get along or not based on any of culutral, religious or political ideological dimension

In each step, kings encourage the populations to have religion and political idology similar to their own by punishing and rewarding.
Some kings adopt the language or rightmost culture bit of their their population (maybje a majority of or a community within)...
People change ideology each geeration by dropping the left-most bit and probablistically picking up the rightmost bit of the ruler or
the most common rightmost bit of people in their territory.

Territories can be more or less productive. Kings' wealth increases by consuming a percentaage of the production of their lands. The higher
percentage they consume, the more dissatisfied people are maknig them less likely to adopt the king's rightmost bits.

Kings poll the territories along their borders looking for border territories with high dissatisfaction and cultural similarity or communities with religions similar to that of their country. They may or may not try to acquire these by force.

With every tick of the clock, leaders look around their territories and inject some policy (internal affairs). Satisfied people/territories return tax without any additional cost. Dissatisfied communities incur an extra cost of tax collection (slower, courts, etc). They are also targets of foreign interference (another kingdom or the Church).

With every tick of the clock, leaders assess the level of interference from other leaders and decide whether to attack, defend, or interfere in that other kingdom. They may also take action to improve satisfaction among their own territories. Attacks come from competing kingdoms, not from allies (except in the case of misalignment with religion).

Challenges come along in the form of foreign intervention, natural disaster, and wars. War has a cost in addition to losing the productivity of a territory where battle is occurring.

Canonical theory rules the process by which polities respond to challenges.

Rulers can make alliances with any other kingdom that shares a common enemy or has similar cultural, religious, or historical tradition.

Rulers can treat with any other kingdom with which they are at war or have an adversarial relationship so long as they have access. They get access by several turns of mutual diplomacy or through common institutions.

An institution is created by perpetual collective action between two or more kingdoms.

Access to institutions comes about through investment, through introduction (FOAF) or as the result of a treaty.

This uses canonical theory.