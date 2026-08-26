# SAP ABAP BTP Cloud Project 2
This is my second SAP ABAP Cloud project: Incident management system built with ABAP RAP (woth drafts) on SAP BTP. CDS views, behavior definitions, custom actions, validations, and a Fiori Elements UI via OData V4

## Tools
- Eclipse.
- BTP trial.
- My own notes from the Logali master's program manual.
- Claude Pro.

## Step 1: Domains
- ZDO_CHANGED_DATE_LGO
- ZDO_CREATION_DATE_LGO
- ZDO_CURR_STATUS_LGO
- ZDO_DESCRIPTION_LGO
- ZDO_HIS_ID_LGO
- ZDO_INCIDENT_ID_LGO
- ZDO_PREV_STATUS_LGO
- ZDO_PRIORITY_DESCRIPTION_LGO
- ZDO_PRIORITY_LGO
- ZDO_STATUS_DESCRIPTION_LGO
- ZDO_TEXT_LGO
- ZDO_TITLE_LGO

*Curr means current and prev means previous*

## Step 2: Data elements
- ZDE_CHANGED_DATE_LGO
- ZDE_CREATION_DATE_LGO
- ZDE_CURR_STATUS_LGO
- ZDE_DESCRIPTION_LGO
- ZDE_HIS_ID_LGO
- ZDE_INCIDENT_ID_LGO
- ZDE_PREV_STATUS_LGO
- ZDE_PRIORITY2_LGO (I called it like this because ZDE_PRIORITY_LGO already exists in Project 1)
- ZDE_PRIORITY_DESCRIPTION_LGO
- ZDE_STATUS_DESCRIPTION_LGO
- ZDE_TEXT_LGO
- ZDE_TITLE_LGO

## Step 3: Tables
- ZDT_INCT_LGO (with foreign key status and priority)
- ZDT_INCT_H_LGO (with foreign key inc_uuid)
- ZDT_STATUS_LGO
- ZDT_PRIORITY_LGO

## Step 4: Fill status and priority tables with data
I created ZCL_STATUS_PRIORITY_DATA, a class implementing IF_OO_ADT_CLASSRUN o INSERT the fixed master data values into ZDT_STATUS_LGO and ZDT_PRIORITY_LGO.

Results in screenshots:

![Status table filled](filled-status-table.png)

![Priority table filled](filled-priority-table.png)

## Step 5: Draft table
We need to create a draft table for ZDT_INCT_LGO because it's the only table which is going to be directly edited by the user.
Draft table is a mirror table of ZDT_INCT_LGO with same keys.
Foreign keys were removed.
Three standard draft technical fields were added.

## Step 6: CDSs
- CDS were created over their respective tables.
- INCT CDS: is the root view entity and has a composition to history view and associations to status and priority CDSs.
- History, status and priority CDSs: they are a simple view entity which has an association to the INCT view.

## Step 7: Behavior Definition
Behavior definition was auto-generated, but I added some necessary things:
- In the history section, his_uuid is its own key, so it needs numbering: managed to be auto-generated. inc_uuid, on the other hand, is a foreign key inherited from the root via composition, it's filled in automatically, so it only needs readonly, without numbering: managed.
- field ( mandatory ) title, description, priority; -> It's not allowed to save empty fields in INCT table.
- changeStatus declared.
- A line to force refresh after running changeStatus.
- setDefaultValues declared.

I had a problem during this process: I couldn't activate the behavior definition.

### The problem with behavior definition and how I fixed it
1. THE PROBLEM: I added the draft table to the behavior def. but the activation failed with these errors: "not activated for drafts" and "strict: every entity must be flagged as lock/authorization master or dependent". The code was correct but it never could be activated.
2. UNSUCCESSFUL TRIES:
   2.1. Activate all tables -> all CDS -> behavior def. in order.
   2.2. Activate them all at the same time (Ctrl+Shift+F3).
   2.3. Refresh project. Restart Eclipse and the PC.
   2.4. Rewrite several times the draft table.
3. THE ACTUAL ERROR: I wasn't familiar enough with the syntax yet, so I didn't know that the behavior definition needed "with draft;" in line 3, after strict ( 2 ); and also the child entity (history CDS) needed its own draft table.
4. SOLUTIONS: I added "with draft;", I created the history table's draft table and I added { with draft; } to the associations. Finally I could activate the behavior definition. It took about 2 hours to fix this.

## Step 8: Abstract CDS for status changing
I needed an abstract CDS specifically for the status changing.
Eventually the user will change status and a popup will appear with the status options, and that popup's fields are defined by the abstract CDS. Also needed because we will use that information for the history's update using the method changeStatus.
Not needed for priority because priority has normal change, with no consequences.

## Step 9: Behavior Implementation
Methods:
### setDefaultValues
When the user creates an incident, RAP automatically creates the draft entry, but at that point status and creation_date are empty (and status is marked as readonly, so the user can't fill it in manually anyway).

This method is a determination (on modify { create; }) that runs automatically at the moment the user creates the incidence. The method sets status to 'OP' and fills creation_date with the current system date using cl_abap_context_info=>get_system_date( ).

Result: every incident is created with these fields already filled, without the user having to (or being able to) set them by hand.
