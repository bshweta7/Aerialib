from rembg import remove
from PIL import Image
import os

input_folder = "input"
output_folder = "output"

os.makedirs(output_folder, exist_ok=True)

for filename in os.listdir(input_folder):
    if filename.lower().endswith((".png", ".jpg", ".jpeg")):
        with open(os.path.join(input_folder, filename), "rb") as i:
            input_data = i.read()
            output_data = remove(input_data)
            with open(os.path.join(output_folder, filename), "wb") as o:
                o.write(output_data)
