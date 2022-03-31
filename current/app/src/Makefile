TOP=../..

include $(TOP)/configure/CONFIG
#----------------------------------------
#  ADD MACRO DEFINITIONS AFTER THIS LINE
#=============================

#=============================
# Build an ioc application
# Use PROD_IOC_RTEMS for RTEMS only
# Use PROD_IOC_Linux for Linux only
PROD_IOC_Linux = hpm900

# hpm900.dbd will be created and installed
DBD += hpm900.dbd

hpm900_DBD += base.dbd
hpm900_DBD += iocAdmin.dbd
hpm900_DBD += asSupport.dbd
hpm900_DBD += asyn.dbd
hpm900_DBD += modbus.dbd
hpm900_DBD += modbusSupport.dbd
hpm900_DBD += caPutLog.dbd

# <name>_registerRecordDeviceDriver.cpp will be created from <name>.dbd
hpm900_SRCS += hpm900_registerRecordDeviceDriver.cpp
hpm900_SRCS_DEFAULT += hpm900Main.cpp

# Add locally compiled object code
#hpm900_SRCS += dbSubExample.c

#hpm900_LIBS += calc

hpm900_LIBS += autosave
hpm900_LIBS += devIocStats
hpm900_LIBS += modbus
hpm900_LIBS += caPutLog
hpm900_LIBS += asyn
hpm900_LIBS += $(EPICS_BASE_IOC_LIBS)

#===========================

include $(TOP)/configure/RULES
#----------------------------------------
#  ADD RULES AFTER THIS LINE

