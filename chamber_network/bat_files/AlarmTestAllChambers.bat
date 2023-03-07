set datetimef=%date:~-4%_%date:~4,2%_%date:~7,2%_%time:~0,2%%time:~3,2%
set datetimef=%datetimef: =%

IF EXIST \\Chamber--01\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber01.txt \\Chamber--01\alarm_files\chamber01_%datetimef%.txt) 

IF EXIST \\Chamber--02\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber02.txt \\Chamber--02\alarm_files\chamber02_%datetimef%.txt) 

IF EXIST \\Chamber--03\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber03.txt \\Chamber--03\alarm_files\chamber03_%datetimef%.txt) 

IF EXIST \\Chamber--04\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber04.txt \\Chamber--04\alarm_files\chamber04_%datetimef%.txt)

IF EXIST \\Chamber--05\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber05.txt \\Chamber--05\alarm_files\chamber05_%datetimef%.txt) 

IF EXIST \\Chamber--06\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber06.txt \\Chamber--06\alarm_files\chamber06_%datetimef%.txt) 

IF EXIST \\Chamber--07\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber07.txt \\Chamber--07\alarm_files\chamber07_%datetimef%.txt) 

IF EXIST \\Chamber--08\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber08.txt \\Chamber--08\alarm_files\chamber08_%datetimef%.txt) 

IF EXIST \\Chamber--09\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber09.txt \\Chamber--09\alarm_files\chamber09_%datetimef%.txt) 

IF EXIST \\Chamber--10\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber10.txt \\Chamber--10\alarm_files\chamber10_%datetimef%.txt)

echo

