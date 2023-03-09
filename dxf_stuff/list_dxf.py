from turtle import Vec2D
import ezdxf
import sys

if (len(sys.argv) < 3):
    sys.exit("Need to give a file argument, and output argument")

# Open file
f = open(sys.argv[1])

# Get file as string
file_string = f.read()

# Split string into points
point_strs = file_string.split()

# Iterate through points and split into array of float arrays
float_vecs = [[float(coord_str) for coord_str in point_str.split(',')] for point_str in point_strs]

# Convert the 2d array into a Vec2 array
points = [ezdxf.math.Vec2(v=(float_vec[0], float_vec[1])) for float_vec in float_vecs]

doc = ezdxf.new()

msp = doc.modelspace()

msp.add_lwpolyline(points, close = True)

doc.saveas(sys.arvgv[2])