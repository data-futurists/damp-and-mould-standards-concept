# Example of damp and mould warranting emergency repairs

This example shows how our data model helps you respond to cases like those covered by Awaab’s Law, where there are strict timescales for repairing damp and mould in social housing.

Explore other examples in the [consultation on timescales for repairs in the social rented sector](https://www.gov.uk/government/consultations/awaabs-law-consultation-on-timescales-for-repairs-in-the-social-rented-sector/awaabs-law-consultation-on-timescales-for-repairs-in-the-social-rented-sector#annex-b-examples-of-hazards-emergency-awaabs-law-and-routine%20).

## Example

A resident has reported that their property is affected by extensive wide-spread damp and mould. They have sent photos of the property to the landlord.

The living room has both rising and penetrating dampness with visible tide marks. The kitchen has condensation damp surrounding the wall with the window and visible mould growth as well as mould spots throughout the walls and on the ceiling.

> This maps to the [investigation component](https://github.com/data-futurists/damp-and-mould-standards-concept/blob/main/Data%20Definition%20Language%20(DDL)/investigation_component.sql) of our data model, giving you the information you need to investigate the issue by:
>
> * recording property ID, tenant ID and date reported  
> * storing investigation notes, photos and links to support documents, such as hazard reports  
> * connecting to other components such as [work order](https://github.com/data-futurists/damp-and-mould-standards-concept/blob/main/Data%20Definition%20Language%20(DDL)/work_order_component.sql) to show what was done, when and why

The exterior of the property shows some cracking on the back wall with the kitchen, the pattern of dampness is consistent with the cracking of the exterior wall. The second bedroom of the property has visible penetrating damp and mould growth linked to the cracked exterior wall.

The property is poorly ventilated with ill-fitting and poorly installed double-glazed windows without trickle vents. The property has central heating with radiators in every room, but they do not have thermostatic valves meaning that the property cannot be effectively heated.

A child with asthma lives in the property and their parents have reported that they are struggling to breathe. The lack of extract ventilation, inadequate insulation, structural damage and an inefficient heating system is exacerbating the condensation, dampness and mould growth in the affected rooms.

| The presence of a child with asthma triggers Awaab’s Law emergency repairs requirement. To support this process, the model includes: a vulnerability flag to indicate whether a person is vulnerable code lists to help define different types of vulnerability This maps to the [tenant](http://ten) and [investigation](http://inv) components of our data model by: linking the investigation component to a high health risk rating and severity code automatically connecting to work order to make sure repairs are logged and prioritised correctly |
| :---- |

As there is a significant level of mould growth on all walls of the property including in a risk room, and a vulnerable individual is struggling to breath, this property would warrant emergency repairs. 

It is worth noting that because dampness and mould accumulates over time (unlike other emergency hazards that can materialise suddenly) the Government expects that damp and mould would never be allowed to deteriorate to this level.

| Our data model makes it easier to spot patterns in your properties. For example, if you notice recurring damp issues in homes built with concrete panels, you can quickly identify other properties that might have the same risk. This allows you to take preventative action, plan inspections and prioritise maintenance based on the patterns you identify. |
| :---- |

Unfortunately, as we know from the tragic death of Awaab Ishak, some social properties do have widespread and dangerous levels of dampness.
