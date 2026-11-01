@icon("stat_sheet.svg")
class_name StatSheet
extends Resource
## A character's list of stat definitions, editable in the inspector.
##
## Assign a sheet to [member StatContainer.sheet] and the container builds one [Stat]
## for each definition. A sheet can be shared by every character of the same kind
## (all goblins, for example), because the [StatDefinition]s inside it are read-only templates.

## The stats this character has. Each entry's name must be unique within the sheet.
@export var stat_definitions: Array[StatDefinition] = []
