import numpy as np
import matplotlib.pyplot as plt

# Define material properties
E = 200e9  # Young's modulus in Pa (200 GPa for steel)
yield_strength = 250e6  # Yield strength in Pa (250 MPa)
length = 1.0  # Length of the bar in meters
cross_sectional_area = 0.01  # Cross-sectional area in m² (10 cm²)
num_elements = 10  # Number of finite elements

# Generate mesh
element_length = length / num_elements
nodes = np.linspace(0, length, num_elements + 1)

# Load applied at the end of the bar
load = 10000  # Load in Newtons

def calculate_stress(load, area):
    return load / area

# Calculate stress for each element
stresses = [calculate_stress(load, cross_sectional_area) for _ in range(num_elements)]

# Check if any element yields
for stress in stresses:
    if stress > yield_strength:
        print(f"Yielding occurs at stress: {stress} Pa")
    else:
        print(f"Safe stress level: {stress} Pa")

# Visualize the stress distribution
plt.plot(nodes[:-1], stresses, marker='o')
plt.axhline(y=yield_strength, color='r', linestyle='--', label='Yield Strength')
plt.title('Stress Distribution in a 1D Bar')
plt.xlabel('Position along the bar (m)')
plt.ylabel('Stress (Pa)')
plt.legend()
plt.grid()
plt.show()
