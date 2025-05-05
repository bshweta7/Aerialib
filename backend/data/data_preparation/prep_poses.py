import os
import csv
from uuid6 import uuid6

output_csv = "poses_data_lowercase_names.csv"
file_data = []

level_names = ['intro', 'level1', 'level2', 'level3']
levels = [0.0, 1.0, 2.0, 3.0]

for i in range(4):
    level_path = os.path.join("../uplift_level_sorted_lowercase", level_names[i])
    for filename in os.listdir(level_path):
        file_path = os.path.join(level_path, filename)
        if os.path.isfile(file_path):
            formatted_filename = filename.lower().replace(" ", "_")
            file_size = os.path.getsize(file_path)

            file_data.append({
                "id": str(uuid6()),
                "name": os.path.splitext(formatted_filename)[0],
                "apparatus": "lyra",
                "level": levels[i],
                "primary_media_id": "",  # leave blank if adding later
                "description": "Joanne's Flashcards",
                "teaching_cues": "",
                "safety_cues": "",
                "progressions": "",
                "created_by": "35327f2b-9205-440f-8e38-f6da18f4dd54",
                "updated_by": "35327f2b-9205-440f-8e38-f6da18f4dd54",
                "created_at": "2025-05-02T18:15:17.755Z",
                "updated_at": "2025-05-02T18:15:17.755Z",
                "is_synced": 0,
            })

# Corrected CSV headers
csv_headers = [
    "id",
    "name",
    "apparatus",
    "level",
    "primary_media_id",
    "description",
    "teaching_cues",
    "safety_cues",
    "progressions",
    "created_by",
    "updated_by",
    "created_at",
    "updated_at",
    "is_synced"
]

# Write to CSV
with open(output_csv, mode="w", newline="") as f:
    writer = csv.DictWriter(f, fieldnames=csv_headers)
    writer.writeheader()
    writer.writerows(file_data)

print(f"Saved {len(file_data)} pose entries to {output_csv}")
