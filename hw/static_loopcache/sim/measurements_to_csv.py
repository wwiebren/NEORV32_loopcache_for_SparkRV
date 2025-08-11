import re

measurement_out_filename = "measurement.csv"
joules_log_filename = "joules_workspace/joules_work/joules.log"
joules_script_filename = "joules_script.tcl"
final_area_filename = "genus_workspace/reports/final_area.rpt"

joules_log_re = r"^\s*[0-9]+\s+[0-9.%]+\s+([0-9.e+-]+)\s+([0-9.e+-]+)\s+([0-9.e+-]+)\s+([0-9.e+-]+)\s+([0-9]+)\s+([\w/.\[\]]+)\s*$"
joules_script_re = r"-start\s+([0-9]+)ns\s+-end\s+([0-9]+)ns"
final_area_re = r"^\s*[\w.\[\]]+\s+\w+\s+[0-9]+\s+[0-9.]+\s+[0-9.]+\s+([0-9.]+)\s*$"

def readfile(filename):
    text = None
    with open(filename) as file:
        text = file.read()
    return text

power_measurement = re.findall(joules_log_re, readfile(joules_log_filename), re.RegexFlag.M)
final_area = re.findall(final_area_re, readfile(final_area_filename), re.RegexFlag.M)

joules_times = re.findall(joules_script_re, readfile(joules_script_filename))
pm_duration = float(joules_times[0][1])*1e-9 - float(joules_times[0][0])*1e-9 # starttime - endtime

# sort on instance name
power_measurement = sorted(power_measurement, key=lambda m:m[5])

# write to csv file
with open(measurement_out_filename, 'w') as file:
    file.write("instance,lvl,leakage[W],internal[W],switching[W],total[W],energy[J],area[um^2]\n")
    for (leakage, internal, switching, total, lvl, instance), area in zip(power_measurement, final_area):
        file.write(f"{instance},{lvl},{leakage},{internal},{switching},{float(total):.5e},{float(total)*pm_duration:.5e},{area}\n")
