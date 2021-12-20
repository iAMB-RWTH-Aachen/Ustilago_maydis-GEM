PathwayToolsAnnotationParser
============================

Matlab script that parses files exported from Pathway Tools for common annotations in order to complete models created with the COBRA Toolbox. This script finds those annotations that are missed by COBRA's standard parser. With an existing model struct In Matlab, start the script by typing:

	AnnotatedModel=AnnotatePthwTlsModel(YourModel)


