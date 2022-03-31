#!$$IOCTOP/bin/$$IF(ARCH,$$ARCH,linux-x86_64)/hpm900

< envPaths
epicsEnvSet( "ENGINEER" , "$$ENGINEER" )
epicsEnvSet( "IOCSH_PS1", "$$IOCNAME>" )
epicsEnvSet( "IOC_PV",    "$$IOC_PV"   )
epicsEnvSet( "LOCATION",  "$$LOCATION" )
epicsEnvSet( "IOCTOP",    "$$IOCTOP"   )
epicsEnvSet( "TOP",       "$$TOP"      )

cd( "$(IOCTOP)" )

# Run common startup commands for linux soft IOC's
< /reg/d/iocCommon/All/pre_linux.cmd

# Register all support components
dbLoadDatabase("dbd/hpm900.dbd")
hpm900_registerRecordDeviceDriver(pdbbase)

$$LOOP(HPM900)
drvAsynIPPortConfigure("$$PORT_NAME", "$$HOST:502", 0, 0, 1)
modbusInterposeConfig("$$PORT_NAME",0,5000,0)
$$ENDLOOP(HPM900)

#If function code 6 is used then the data will be written in multiple messages,
#and there will be a short time period in which the device has incorrect data.

#drvModbusAsynConfigure(modbusPort,      asynPort,     slave, func, startAdd, length, type, polltime,plcType)

$$LOOP(HPM900)
drvModbusAsynConfigure("hpm900_read_reg", "$$PORT_NAME",  1,   3,  0,  41,  0,  500, "Siemens")
drvModbusAsynConfigure("hpm900_set_reg",  "$$PORT_NAME",  1,  16, 60,  11,  0,  500, "Siemens")
$$ENDLOOP(HPM900)

# Load record instances
dbLoadRecords( "db/iocSoft.db",            "IOC=$(IOC_PV)" )
dbLoadRecords( "db/save_restoreStatus.db", "P=$(IOC_PV):" )
$$LOOP(HPM900)
dbLoadRecords("db/PlcInputs.db", "DEV=$$BASE,INP=PLC_INPUTS_RBV")
dbLoadRecords("db/PlcOutputs.db", "DEV=$$BASE,INP=PLC_OUTPUTS_RBV")
dbLoadRecords("db/RealNumbers.db", "DEV=$$BASE,DATA_TYPE=FLOAT32_BE")
dbLoadRecords("db/SystemAlarm.db", "DEV=$$BASE,INP=SYSTEM_ALARM_RBV")
dbLoadRecords("db/SystemWarning.db", "DEV=$$BASE,INP=SYSTEM_WARNING_RBV")
dbLoadRecords("db/ValveOutputs.db", "DEV=$$BASE,INP=VALVE_OUTPUTS_RBV")
dbLoadRecords("db/Hmi.db", "DEV=$$BASE")
dbLoadRecords("db/ModePanels.db", "DEV=$$BASE")
dbLoadRecords("db/SystemHeartbeat.db", "DEV=$$BASE")
$$IF(ONEPANEL)
dbLoadRecords("db/RealNumbers_onepanel.db", "DEV=$$BASE,DATA_TYPE=FLOAT32_BE")
$$ELSE(ONEPANEL)
dbLoadRecords("db/RealNumbers.db", "DEV=$$BASE,DATA_TYPE=FLOAT32_BE")
$$ENDIF(ONEPANEL)
$$ENDLOOP(HPM900)


# Setup autosave
set_savefile_path( "$(IOC_DATA)/$(IOC)/autosave")
set_requestfile_path( "$(TOP)/autosave")
save_restoreSet_status_prefix( "$(IOC_PV)" )
save_restoreSet_IncompleteSetsOk( 1 )
save_restoreSet_DatedBackupFiles( 1 )

# Just restore the settings
set_pass0_restoreFile( "$(IOC).sav" )
set_pass1_restoreFile( "$(IOC).sav" )

# Initialize the IOC and start processing records
iocInit()

# Start autosave backups
create_monitor_set( "$(IOC).req", 5, "" )

# All IOCs should dump some common info after initial startup.
< /reg/d/iocCommon/All/post_linux.cmd



