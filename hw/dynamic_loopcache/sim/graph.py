import numpy as np
import matplotlib.pyplot as plt

measurement_filename = "measurement.csv"

def findInMeasurement(measurement, lvl = None, instance = None):
    result = measurement
    if lvl != None:
        result = result[result["lvl"] == lvl]
    else:
        lvl = 0
    if instance != None:
        result = result[[instance in m for m in result["instance"]]]
    else:
        instance = ""
    
    if len(result) == 0:
        return np.void((instance, lvl, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), dtype=measurement.dtype)
    elif len(result) == 1:
        return result[0]
    else:
        return result

# read csv file
measurement = np.loadtxt(measurement_filename, delimiter=',', skiprows=1, dtype=[('instance', 'O'), ('lvl', int), ('leakage', float), ('internal', float), ('switching', float), ('power', float), ('energy', float), ('area', float)])

# select data to view in graphs
alu = findInMeasurement(measurement, lvl=3, instance="alu")
imem = findInMeasurement(measurement, lvl=2, instance="imem")
dmem = findInMeasurement(measurement, lvl=2, instance="dmem")
loopcache = findInMeasurement(measurement, lvl=4, instance="loopcache")
fetch_engine = findInMeasurement(measurement, instance="fetch_engine")

control = findInMeasurement(measurement, lvl=3, instance="cpu_control")
inside_control = findInMeasurement(measurement, lvl=4, instance="cpu_control")

execute_engine = [control[field] - np.sum(inside_control[field]) for field in measurement.dtype[["leakage", "internal", "switching", "power", "energy", "area"]].names]
execute_engine.insert(0, 4)
execute_engine.insert(0, "execute engine")
execute_engine = np.void(tuple(execute_engine), dtype=measurement.dtype)

regfile = findInMeasurement(measurement, lvl=3, instance="regfile")

data = np.array([
    imem,
    dmem,
    execute_engine,
    loopcache,
    fetch_engine,
    regfile,
    alu,
], dtype=measurement.dtype)

other = [measurement[0][field] - np.sum(data[field]) for field in measurement.dtype[["leakage", "internal", "switching", "power", "energy", "area"]].names]
# other = [measurement[0][field] - np.sum(data[field]) - dmem[field] for field in measurement.dtype[["leakage", "internal", "switching", "power", "energy", "area"]].names]
other.insert(0, 2)
other.insert(0, "other")
other = np.void(tuple(other), dtype=measurement.dtype)

data = np.append(data, other)

data["instance"] = [
    "imem",
    "dmem",
    "execute engine",
    "loopcache",
    "fetch engine",
    "regfile",
    "alu",
    "other",
]

# show graphs
plt.figure("Power plot")

# show pi chart
plt.subplot(1, 2, 2)
plt.title("Power")
plt.pie(data["power"])

# show bar chart
plt.subplot(1, 2, 1)
bottom = 0
for instance, power in zip(data["instance"], data["power"]*1e6):
    plt.bar("Power", power, label=instance, bottom=bottom)
    bottom += power
plt.legend()
plt.ylabel(r"Power ($\mu W$)")

plt.savefig("power_plot.png")

plt.figure("Power plots")

# show in one bar plot
# plt.title("Power distribution")

# bottom = np.zeros(3)
# for instance, leakage, internal, switching in zip(data["instance"], data["leakage"]*1e6, data["internal"]*1e6, data["switching"]*1e6):
#     plt.bar(["Leakage", "Internal", "Switching"], (leakage, internal, switching), label=instance, bottom=bottom)
#     bottom += np.array([leakage, internal, switching])
# plt.legend()
# plt.ylabel(r"power ($\mu W$)")

# plt.savefig("power_plots.png")

# show in separate bar plots
plt.subplot(1, 3, 1)
plt.title("Leakage")

# show bar chart
bottom = 0
for instance, measurement in zip(data["instance"], data["leakage"]*1e6):
    plt.bar("Leakage", measurement, label=instance, bottom=bottom)
    bottom += measurement
plt.legend()
plt.ylabel(r"power ($\mu W$)")

plt.subplot(1, 3, 2)
plt.title("Internal")

# show bar chart
bottom = 0
for instance, measurement in zip(data["instance"], data["internal"]*1e6):
    plt.bar("Internal", measurement, label=instance, bottom=bottom)
    bottom += measurement
plt.legend()
plt.ylabel(r"power ($\mu W$)")

plt.subplot(1, 3, 3)
plt.title("Switching")

# show bar chart
bottom = 0
for instance, measurement in zip(data["instance"], data["switching"]*1e6):
    plt.bar("Switching", measurement, label=instance, bottom=bottom)
    bottom += measurement
plt.legend()
plt.ylabel(r"power ($\mu W$)")

# plt.savefig("power_plots.png")

plt.figure("Energy plot")

# show pi chart
# plt.subplot(1, 2, 2)
# plt.title("Energy")

def autopct_func(pct):
    return '{:.1f}%'.format(pct) if pct > 5 else ''

plt.pie(data["energy"], labels=data["instance"], autopct=autopct_func)

# show bar chart
# plt.subplot(1, 2, 1)
# bottom = 0
# for instance, energy in zip(data["instance"], data["energy"]*1e6):
#     plt.bar("Energy", energy, label=instance, bottom=bottom)
#     bottom += energy
# plt.legend()
# plt.ylabel(r"energy ($\mu J$)")

plt.savefig("energy_plot.png")

plt.figure("Area plot")

# show pi chart
plt.subplot(1, 2, 2)
plt.title("Area")
plt.pie(data["area"])

# show bar chart
plt.subplot(1, 2, 1)
bottom = 0
for instance, area in zip(data["instance"], data["area"]*1e-6):
    plt.bar("Area", area, label=instance, bottom=bottom)
    bottom += area
plt.legend()
plt.ylabel(r"Area ($mm^2$)")

plt.tight_layout()
plt.savefig("area_plot.png")

plt.show()
