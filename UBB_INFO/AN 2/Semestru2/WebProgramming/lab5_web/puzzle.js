var rows = 4;
var columns = 4;

var currTile;
var otherTile; //blank tile

var turns = 0;

//var imgOrder = ["OIP.jpg", "R.jpg", "th.jpg", "p.jpg", "OIP.jpg", "R.jpg", "th.jpg", "p.jpg", "OIP.jpg", "R.jpg", "th.jpg", "p.jpg", "OIP.jpg", "R.jpg", "th.jpg", "p.jpg" ];

//var imgOrder = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "1", "2", "3", "4"];

var imgOrder = ["1", "2","3","4","5","6","7","8","9","10","11","12","1","2","3","4"];


window.onload = function (){
  for(let r=0; r<rows; r++){
    for(let c=0; c<columns; c++){
      //<img id="0-0">
      let tile = document.createElement("img");
      tile.id = r.toString() + "-" + c.toString();
      tile.src = imgOrder.shift() + ".jpg";

      // Drag fubctionality

      tile.addEventListener("dragtart", dragStart);
      tile.addEventListener("dragover", dragOver);
      tile.addEventListener("dragenter", dragEnter);
      tile.addEventListener("dragleave", dragLeave);
      tile.addEventListener("drop", dragDrop);
      tile.addEventListener("dragend", dragEnd);

      document.getElementById("board").append(tile);
    }
  }

}

function dragStart(){
  currTile = this; // this refers to the img tile being dragged

}

function dragOver(e){
  e.preventDefault();
}

function dragEnter(e){
  e.preventDefault();
}

function dragLeave(){

}

function dragDrop(){
  otherTile = this;  // this refers to the image tile being dropped
}


function swapTiles(tileId1, tileId2) {
    const tile1 = document.getElementById(tileId1);
    const tile2 = document.getElementById(tileId2);
    
    const parent = tile1.parentNode;
    const sibling = tile1.nextSibling === tile2 ? tile1 : tile2;
  
    parent.insertBefore(tile1, sibling);
    parent.insertBefore(tile2, sibling);
  }


function dragEnd(){

  let currCoords = currTile.id.split("-");
  let r = parseInt(currCoords[0]);
  let c = parseInt(currCoords[1]);
  
  let otherCoords = otherTile.id.split("-");
  let r2 = parseInt(currCoords[0]);
  let c2 = parseInt(currCoords[1]);
  
  let moveLeft = r == r2&&c2 == c-1;
  let moveRight = r == r2&&c2 == c+1;
  
  let moveUp = c == c2&&r2 == r-1;
  let moveDown = c == c2&&r2 == r+1;

  let isAdjacent = moveLeft || moveRight || moveUp || moveDown;

  swapTiles(currTile.id, otherTile.id);
    // let currImg = currTile.src;
    // let otherImg = otherTile.src;

    // currTile.src = otherImg;
    // otherTile.src = currImg;

  
}
