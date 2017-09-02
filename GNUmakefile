#
# GNUmakefile
#
# Build the Yape editor.
#
# Copyright (C) 2004 Stefan Kleine Stegemann
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#

ifeq ($(GNUSTEP_MAKEFILES),)
  $(error You need to run the GNUstep configuration script before compiling)
endif

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#

APP_NAME                                = Fortunate
${APP_NAME}_CURRENT_VERSION_NAME        = $(VERSION)
${APP_NAME}_DEPLOY_WITH_CURRENT_VERSION = yes
${APP_NAME}_APPLICATION_ICON            = Fortunate.tiff
${APP_NAME}_MAIN_MODEL_FILE             = Fortunate.gorm

#
# Subprojects
#

ifeq ($(with-fortune), yes)
SUBPROJECTS = fortune
endif


#
# Resources
#

${APP_NAME}_Languages  =	\
   English

${APP_NAME}_LOCALIZED_RESOURCE_FILES =	\
	Fortunate.gorm 

${APP_NAME}_RESOURCE_FILES = \
	FortunateInfo.plist \
        Fortunate.tiff
# \
#        datfiles

ifeq ($(with-fortune), yes)
${APP_NAME}_RESOURCE_FILES += fortune/obj/fortune
endif

#
# Libararies
# 
#
${APP_NAME}_GUI_LIBS = \

#
# Class files
#

${APP_NAME}_OBJC_FILES =	\
   ApplicationDelegate.m        \
   FontomaticPanel.m            \
   FortuneTextView.m            \
   MainDocument.m               \
   PreferencesController.m      \
   main.m   


#
# Additional Settings
#

ifeq ($(with-fortune), yes)
ADDITIONAL_OBJCFLAGS += -DWITH_FORTUNE_PROGRAM
endif

-include GNUmakefile.preamble
-include GNUmakefile.local

include $(GNUSTEP_MAKEFILES)/aggregate.make
include $(GNUSTEP_MAKEFILES)/application.make

-include GNUmakefile.postamble
