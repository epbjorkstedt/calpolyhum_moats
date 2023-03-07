set datetimef=%date:~-4%_%date:~4,2%_%date:~7,2%_%time:~0,2%%time:~3,2%
set datetimef=%datetimef: =%

IF EXIST \\Chamber--05\alarm_files\ (copy C:\Users\chamber\Documents\AlarmTestBat\AlarmTestText\chamber05.txt \\Chamber--05\alarm_files\chamber05_%datetimef%.txt)