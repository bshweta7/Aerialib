import os
import csv

ROOT = "uplift"
output_csv = "flashcard_data.csv"
file_data = []

level_names = ['intro', 'level1', 'level2', 'level3']
levels = [0.0, 1.0, 2.0, 3.0]

for i in range(4):
    level_path = os.path.join("uplift", level_names[i])
    level = levels[i]
    for filename in os.listdir(level_path):
        file_path = os.path.join(level_path, filename)
        if os.path.isfile(file_path):
            formatted_filename = filename.lower().replace(" ", "_")
            
            file_data.append({
                "path": f"{ROOT}/{formatted_filename}",
                "name": filename.split(".")[0],
                "level": level
            })

# Save to CSV
with open(output_csv, mode="w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=["path", "name", "level"])
    writer.writeheader()
    writer.writerows(file_data)

print(f"Saved {len(file_data)} files from Intro to {output_csv}")
