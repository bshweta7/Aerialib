import 'package:flutter/material.dart';

int calculateNewGridSize(
  int amount,
  int gridSize,
  Size windowSize,
  bool kDebugMode
) {
  /// Function to handle changing the size of the photo grid ///

  // Adjust this variable higher to allow less items on screen per a given width
  // Basically its doing (windowWidth / windowSizeFactor)
  int windowSizeFactor = 205;

  int gridSizeMax = (windowSize.width / windowSizeFactor).ceil();
  if (kDebugMode) {
    /////////print("Window Size: $windowSize");
    /////////print("Width: ${windowSize.width}");
    /////////print("Grid Size Max: $gridSizeMax");
  }

  // Set the grid size to the maximum on first startup
  if (gridSize == 0) {
    gridSize = gridSizeMax;
  }

  // Make sure the grid size isn't currently invalid (too many columns)
  // such as due to a window size change
  else if (gridSize > gridSizeMax) {
    gridSize = gridSizeMax;
  }

  // Otherwise adjust by provided amount
  else if (gridSize > 0) {
  // Scale the amount increase on larger screens
    amount *= gridSizeMax > 10 ? 2 : 1;

    // If removing columns
    if (amount < 0) {
      // Make sure the grid size can't go below 1
      if (gridSize + amount <= 0) {
        gridSize = 1;
      } else {
        gridSize += amount;
      }
    }

    // If adding columns
    else if (amount > 0) {
      // Make sure the grid size can't go above the max size
      if (gridSize + amount > gridSizeMax) {
        gridSize = gridSizeMax;
      } else {
        gridSize += amount;
      }
    }
  }
  return gridSize;
}