/*
 MUGWUMP 2D
 ----------
 A graphical version of MUGWUMP from BASIC COMPUTER GAMES
 by Bob Albrecht, Bud Valenti, Edited by David H. Ahl
 ported by SeggiePants
*/

settings = {
    GAME_TITLE: 'MUGWUMP 2D'
    , TEXT_SIZE: 18
    , BORDER_W: 18
    , BORDER_H: 18
    , COUNT_MUGWUMPS: 4
    , MAX_GUESSES: 10
    , GRID_W: 10
    , GRID_H: 10
    , SCREEN_W: 720
    , SCREEN_H: 400
};

// Colors
BLACK = 'rgb(0, 0, 0)';
DARK_GRAY = 'rgb(64, 64, 64)';
LIGHT_BLUE = 'rgb(128, 128, 255)';
LIGHT_GRAY = 'rgb(192, 192, 192)';
ORANGE = 'rgb(255, 128, 0)';
PINK = 'rgb(255, 0, 128)';
RED = 'rgb(255, 0, 0)';
TEAL = 'rgb(12, 140, 127)';
VIOLET = 'rgb(192, 0, 255)';
WHITE = 'rgb(255, 255, 255)';

bodyColors = [PINK, VIOLET, LIGHT_BLUE, ORANGE];

var mugwumps = [];
var guesses = [];

let elem = document.getElementById('test');
elem.style.backgroundColor = PINK

function appendMugwump(parentId, bodyColor, eyeColor, pupilColor, mouthColor) {
    var parent = document.getElementById(parentId);
    var body = document.createElement('div');
    var eyeLeft = document.createElement('div');
    var eyeRight = document.createElement('div');
    var pupilLeft = document.createElement('div');
    var pupilRight = document.createElement('div');
    var mouth = document.createElement('div');

    body.className = 'mugwump_body';
    eyeLeft.className = 'mugwump_eye eye_left';
    eyeRight.className = 'mugwump_eye eye_right';
    pupilLeft.className = 'mugwump_pupil pupil';
    pupilRight.className = 'mugwump_pupil pupil';
    mouth.className = 'mugwump_mouth';

    body.style.backgroundColor = bodyColor;
    eyeLeft.style.backgroundColor = eyeColor;
    eyeRight.style.backgroundColor = eyeColor;
    pupilLeft.style.backgroundColor = pupilColor;
    pupilRight.style.backgroundColor = pupilColor;
    mouth.style.backgroundColor = mouthColor;

    body.appendChild(eyeLeft);
    eyeLeft.appendChild(pupilLeft);
    body.appendChild(eyeRight);
    eyeRight.appendChild(pupilRight);
    body.appendChild(mouth);
    parent.appendChild(body);
}

function buildGrid(parentId, settings) {
    var elem;
    var parent = document.getElementById(parentId);

    // Clear out any children
    removeChildren(parent);
    parent.style.gridTemplateColumns = 'auto repeat(' + settings.GRID_W.toString() + ', 1fr)';
    parent.style.gridTemplateRows = 'repeat(' + settings.GRID_H.toString() + ', 1fr) auto';

    for(var j = settings.GRID_H - 1; j >= 0; j--) {
        // Add the row counter.
        elem = document.createElement('span');
        elem.innerText = j.toString();
        elem.id = 'row_' + j.toString();
        elem.className = 'cell_index';
        parent.appendChild(elem);
        for(var i = 0; i < settings.GRID_W; i++) {
            elem = document.createElement('span');
            elem.id = 'cell_' + j.toString() + '_' + i.toString();
            elem.className = 'cell';
            elem.onclick = cellClick;
            parent.appendChild(elem);
        }
    }
    // axis divider
    elem = document.createElement('span');
    elem.innerHtml = '&nbsp;';
    parent.appendChild(elem);
    for(var i = 0; i < settings.GRID_W; i++) {
        elem = document.createElement('span');
        elem.innerText = i.toString();
        elem.id = 'col_' + i.toString();
        elem.className = 'cell_index';
        parent.appendChild(elem);
    }
}

function removeChildren(elem) {
    while (elem.firstChild){
	elem.removeChild(elem.lastChild);
    }
}

function cellClick(event) {
    if (event.srcElement.id.startsWith('cell_')) {
        parts = event.srcElement.id.split('_');
        pos.x = parseInt(parts[2]);
        pos.y = parseInt(parts[1]);
        // cell is parts[0]
        updateSelection();
        select();
    }
}

function keyUpHandler(event) {
    switch(event.code) {
    case 'KeyW':
    case 'ArrowUp':
    case 'KeyA':
    case 'ArrowLeft':
    case 'KeyS':
    case 'ArrowDown':
    case 'KeyD':
    case 'ArrowRight':
        switch(event.code) {
        case 'KeyW':
        case 'ArrowUp':
            pos.y = Math.min(settings.GRID_H - 1, pos.y + 1);
            break;
        case 'KeyA':
        case 'ArrowLeft':
            pos.x = Math.max(0, pos.x - 1);
            break;
        case 'KeyS':
        case 'ArrowDown':
            pos.y = Math.max(0, pos.y - 1);
            break;
        case 'KeyD':
        case 'ArrowRight':
            pos.x = Math.min(settings.GRID_W - 1, pos.x + 1);
            break;
        }
        updateSelection();
        break;
    case 'Space':
    case 'Enter':
        // select current cell.
        select();
        break;
    // default:
    }
}

function updateSelection() {
    let selection = document.getElementById('selection');
    if (selection != null) {
	selection.parentNode.removeChild(selection);
    }
    let selected = document.getElementById('cell_' + pos.y.toString() + '_' + pos.x.toString());
    selection = document.createElement('div');
    selection.id = 'selection';
    selection.className = 'cell_selected';
    selected.appendChild(selection);
}

function isGuessOK(x, y) {
    // Guess is not ok if we already have one at the same position.
    var i, guessOK = true;
    for(i = 0; i < guesses.length; i++) {
        if (guesses[i].x == x && guesses[i].y == y) {
            guessOK = false;
            break;
        }
    }
    return guessOK;
}

function newGame() {
    var i, j, positionOK, x, y;
    guesses = [];
    mugwumps = [];
    for (i = 0; i < settings.COUNT_MUGWUMPS; i++) {
        positionOK = false;
        x = 0;
        y = 0;
        while (!positionOK) {
            x = Math.floor(Math.random() * settings.GRID_W);
            y = Math.floor(Math.random() * settings.GRID_H);
            positionOK = true;
            for(j = 0; j < mugwumps.length; j++) {
                positionOK = positionOK && (mugwumps[j].x != x || mugwumps[j].y != y);
                if (!positionOK) 
                    break;
            }
        }
        color = bodyColors[i % bodyColors.length]
        mugwumps.push({found: false, x: x, y: y, bodyColor: color, eyeColor: WHITE, pupilColor: BLACK, mouthColor: BLACK});
    }
}

function select() {
    var i, id, x, y
    x = pos.x;
    y = pos.y;
    if (isGuessOK(x, y)) {
        guesses.push({x: x, y: y});
        id = "cell_" + y.toString() + '_' + x.toString();
        document.getElementById(id).className += ' cell_open';
        for(i = 0; i < mugwumps.length; i++) {
            if (mugwumps[i].x == x && mugwumps[i].y == y) { 
                mugwumps[i].found = true;                
                appendMugwump(id, mugwumps[i].bodyColor, mugwumps[i].eyeColor, mugwumps[i].pupilColor, mugwumps[i].mouthColor);
                updateSelection();
            }
        }
    }
}

document.addEventListener('keydown', keyUpHandler, false);

var pos = {
    x: Math.floor(settings.GRID_W / 2)
    , y: Math.floor(settings.GRID_H /2)
};
buildGrid('grid', settings);
// appendMugwump('cell_2_1', VIOLET, ORANGE, TEAL, PINK);
newGame();
updateSelection();
