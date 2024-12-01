import * as fs from "fs";

let input = fs.readFileSync("./input.txt");
let firstList = [];
let secondList = [];
for (let element of input.toString("utf8").split("\n")) {
    let splitted = element.split("   ");
    firstList.push(parseInt(splitted[0]));
    secondList.push(parseInt(splitted[1]));
}

firstList.sort();
secondList.sort();
let distance = 0;
for(let i in firstList) {
    if (firstList[i] < secondList[i]) 
        distance += secondList[i] - firstList[i];
    else distance += firstList[i] - secondList[i];
}
process.stdout.write(`Distance equals ${distance}\n`);


let similarityScore = 0;
for (let i in firstList) {
    let occ = 0;
    for (let e of secondList) {
        if (firstList[i] == e) {
            occ += 1;
        }
    }
    similarityScore += firstList[i] * occ;
}
process.stdout.write(`Similarity Score is: ${similarityScore}\n`)