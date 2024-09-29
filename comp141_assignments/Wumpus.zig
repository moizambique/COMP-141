const std = @import("std");
const print = std.debug.print;
var gameEnd = false;
const reader = std.io.getStdIn().reader();
var buffer: [16]u8 = undefined;
//creates a buffer to hold 16 characters
var choice: u8 = '1';

var maze = [4][6]u8{
    .{ 'o', 'o', 'o', 'o', 'o', 'o' },
    .{ 'o', 'o', 'o', 'o', 'o', 'o' },
    .{ 'o', 'o', 'o', 'o', 'o', 'o' },
    .{ 'o', 'o', 'o', 'o', 'o', 'o' },
};

//first write a printmare fuaction
//second write an initMaze function (modify random CharInArray fron test.zig)
// w = wumpus
// x = player
// p = pit
// b = breeze
// s = stench
// z = breeze + stench
//this function returns wumpus's location on the map
pub fn initMaze() void {
    const rand = std.crypto.random;
    var col: usize = 0;
    var row: usize = 0;

    //place four pits - placing one per row row
    for (0..4) |r| {
        col = rand.intRangeAtMost(u8, 1, 5);
        maze[r][col] = 'p';
        if (r != 0) {
            maze[r - 1][col] = 'b';
        }
        if (r != 3) {
            maze[r + 1][col] = 'b';
        }
        if (col != 0) {
            maze[r][col - 1] = 'b';
        }
        if (col != 5) {
            maze[r][col + 1] = 'b';
        }
    }

    //place the wunpus
    col = rand.intRangeAtMost(u8, 1, 5);
    row = rand.intRangeAtMost(u8, 0, 3);
    while (maze[row][col] == 'p' or maze[row][col] == 'b') {
        col = rand.intRangeAtMost(u8, 1, 5);
        row = rand.intRangeAtMost(u8, 0, 3);
    }
    maze[row][col] = 'w';
    if (row != 0 and maze[row - 1][col] != 'p') {
        if (maze[row - 1][col] == 'b') {
            maze[row - 1][col] = 'z';
        } else {
            maze[row - 1][col] = 's';
        }
    }
    if (row != 3 and maze[row + 1][col] != 'p') {
        if (maze[row + 1][col] == 'b') {
            maze[row + 1][col] = 'z';
        } else {
            maze[row + 1][col] = 's';
        }
    }
    if (col != 0 and maze[row][col - 1] != 'p') {
        if (maze[row][col - 1] == 'b') {
            maze[row][col - 1] = 'z';
        } else {
            maze[row][col - 1] = 's';
        }
    }
    if (col != 5 and maze[row][col + 1] != 'p') {
        if (maze[row][col + 1] == 'b') {
            maze[row][col + 1] = 'z';
        } else {
            maze[row][col + 1] = 's';
        }
    }
}

//function to print the contents of the array
pub fn printMaze(playerRow: usize, playerCol: usize) void {
    print("\n", .{});
    if (gameEnd == false) {
        for (0..4) |r| {
            for (0..6) |c| {
                if (r == playerRow and c == playerCol) {
                    print("x", .{});
                } else {
                    print("o", .{});
                }
            }
            print("\n", .{});
        }
    } else if (gameEnd == true) { // prints end game map
        for (0..4) |r| {
            for (0..6) |c| {
                if (maze[r][c] == 'b' or maze[r][c] == 's' or maze[r][c] == 'z') {
                    print("o", .{});
                } else {
                    print("{c}", .{maze[r][c]});
                }
            }
            print("\n", .{});
        }
    } else { // prints debug mode map
        for (0..4) |r| {
            for (0..6) |c| {
                if (r == playerRow and c == playerCol) {
                    print("x", .{});
                } else {
                    print("{c}", .{maze[r][c]});
                }
            }
            print("\n", .{});
        }
    }
}

pub fn giveFeedback(playerRow: usize, playerCol: usize) void {
    if (maze[playerRow][playerCol] == 'p') {
        print("you fell in pit\n", .{});
        gameEnd = true;
    } else if (maze[playerRow][playerCol] == 'w') {
        print("Wumpus ate you\n", .{});
        gameEnd = true;
    } else if (maze[playerRow][playerCol] == 'b') {
        print("you feel a breeze\n", .{});
    } else if (maze[playerRow][playerCol] == 's') {
        print("you smell a stench\n", .{});
    } else if (maze[playerRow][playerCol] == 'z') {
        print("you feel a breeze\n", .{});
        print("you smell a stench\n", .{});
    }
}

pub fn shootArrow(playerRow: usize, playerCol: usize, arrowsLeft: usize) !void {
    print("What direction do you want to shoot your arrow:\n u) up\n d) down\n", .{});
    print(" l) left\n r) right\nENTER CHOICE: ", .{});

    try readinput();
    if (choice == 'u') {
        if (playerRow > 0) {
            // playerRow = playerRow - 1;
            if (maze[playerRow - 1][playerCol] == 'w') {
                print("You killed the wumpus! You win the game.\n", .{});
                gameEnd = true;
            } else {
                print("You missed the wumpus!\n", .{});
            }
        } else {
            print("your arrow bumped into the wall\n", .{});
        }
    } else if (choice == 'd') {
        if (playerRow < 3) {
            // playerRow = playerRow + 1;
            if (maze[playerRow + 1][playerCol] == 'w') {
                print("You killed the wumpus! You win the game.\n", .{});
                gameEnd = true;
            } else {
                print("You missed the wumpus!\n", .{});
            }
        } else {
            print("your arrow bumped into the wall\n", .{});
        }
    } else if (choice == 'l') {
        if (playerCol > 0) {
            // playerCol = playerCol - 1;
            if (maze[playerRow][playerCol - 1] == 'w') {
                print("You killed the wumpus! You win the game.\n", .{});
                gameEnd = true;
            } else {
                print("You missed the wumpus!\n", .{});
            }
        } else {
            print("your arrow bumped into the wall\n", .{});
        }
    } else if (choice == 'r') {
        if (playerCol < 5) {
            // playerCol = playerCol + 1;
            if (maze[playerRow][playerCol + 1] == 'w') {
                print("You killed the wumpus! You win the game.\n", .{});
                gameEnd = true;
            } else {
                print("You missed the wumpus!\n", .{});
            }
        } else {
            print("your arrow bumped into the wall\n", .{});
        }
    } else {
        print("\nInvalid input\n", .{});
        try shootArrow(playerRow, playerCol, arrowsLeft);
    }
    if (arrowsLeft == 0) {
        gameEnd = true;
    }
}

pub fn readinput() !void {
    const input = try reader.readUntilDelimiter(&buffer, '\n');
    choice = input[0];
}

pub fn main() !void {
    //player's location
    var playerRow: usize = 3;
    var playerCol: usize = 0;
    var arrowsLeft: usize = 2;
    initMaze();
    printMaze(playerRow, playerCol);

    print("Hunt down the wumpus and try to shoot it with your arrow!\n", .{});
    while (gameEnd != true) {
        print("What do you want to do:\n u) move up\n d) move down\n", .{});
        print(" l) move left\n r) move right\n s) shoot arrow\nENTER CHOICE: ", .{});
        try readinput();
        if (choice == 'u') {
            if (playerRow > 0) {
                playerRow = playerRow - 1;
                giveFeedback(playerRow, playerCol);
            } else {
                print("you bumped into the wall", .{});
            }
        } else if (choice == 'd') {
            if (playerRow < 3) {
                playerRow = playerRow + 1;
                giveFeedback(playerRow, playerCol);
            } else {
                print("you bumped into the wall", .{});
            }
        } else if (choice == 'l') {
            if (playerCol > 0) {
                playerCol = playerCol - 1;
                giveFeedback(playerRow, playerCol);
            } else {
                print("you bumped into the wall", .{});
            }
        } else if (choice == 'r') {
            if (playerCol < 5) {
                playerCol = playerCol + 1;
                giveFeedback(playerRow, playerCol);
            } else {
                print("you bumped into the wall", .{});
            }
        } else if (choice == 's') {
            arrowsLeft = arrowsLeft - 1;
            try shootArrow(playerRow, playerCol, arrowsLeft);
        } else {
            print("\nInvalid input\n", .{});
        }
        printMaze(playerRow, playerCol);
    }
}
