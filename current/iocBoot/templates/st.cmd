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
drvAsynIPPortConfigure("HPM900$$INDEX", "$$HOST:502", 0, 0, 1)
modbusInterposeConfig("HPM900$$INDEX",0,2000,0)
$$ENDLOOP(HPM900)

#If function code 6 is used then the data will be written in multiple messages,
#and there will be a short time period in which the device has incorrect data.

#drvModbusAsynConfigure(modbusPort,      asynPort,     slave, func, startAdd, length, type, polltime,plcType)

$$LOOP(HPM900)
drvModbusAsynConfigure("HPM900$$(INDEX)_read_reg", "HPM900$$INDEX",  1,   3,  0,  41,  0,  500, "Siemens")
drvModbusAsynConfigure("HPM900$$(INDEX)_set_reg",  "HPM900$$INDEX",  1,  16, 60,  11,  0,  500, "Siemens")
$$ENDLOOP(HPM900)

# Load record instances
dbLoadRecords("db/iocSoft.db",            "IOC=$(IOC_PV)")
dbLoadRecords("db/save_restoreStatus.db", "P=$(IOC_PV):")
$$LOOP(HPM900)
dbLoadRecords("db/PlcInputs.db", "DEV=$$BASE,N=$$(INDEX),INP=PLC_INPUTS_RBV")
dbLoadRecords("db/PlcOutputs.db", "DEV=$$BASE,N=$$(INDEX),INP=PLC_OUTPUTS_RBV")
dbLoadRecords("db/SystemAlarm.db", "DEV=$$BASE,N=$$(INDEX),INP=SYSTEM_ALARM_RBV")
dbLoadRecords("db/ValveOutputs.db", "DEV=$$BASE,N=$$(INDEX),INP=VALVE_OUTPUTS_RBV")
dbLoadRecords("db/Hmi.db", "DEV=$$BASE,N=$$(INDEX)")
dbLoadRecords("db/ModePanels.db", "DEV=$$BASE,N=$$(INDEX)")
dbLoadRecords("db/SystemHeartbeat.db", "DEV=$$BASE,N=$$(INDEX)")
$$IF(ONEPANEL)
dbLoadRecords("db/RealNumbers_onepanel.db", "DEV=$$BASE,N=$$(INDEX)")
$$ELSE(ONEPANEL)
dbLoadRecords("db/RealNumbers.db", "DEV=$$BASE,N=$$(INDEX)")
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



