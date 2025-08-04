from datetime import datetime
from json import loads as loadJSON, dumps as dumpJSON
import sys

PROGRAM_TYPE = ["S", "N"]
DEGREE_LEVEL = ["lic", "mgr", "inż."]
LANGUAGE = ["POL", "ANG"]
ACADEMIC_YEAR = ["zima", "lato"]

programs = []
classes = []
teachers = []
rooms = []

DEBUG = False

input = "plany.json"
output = "./output"

if(len(sys.argv) > 1):
    output = sys.argv[1]
    DEBUG = True
    if(len(sys.argv) > 2):
        input = sys.argv[2]

# Important!!! This will only work correctly if your system's date locale is Polish.
def convertDateToTimestamp(date, start, end):
    timestamp = {
        "start": 0,
        "end": 0
    }
    
    date = date.split(".")
    date = datetime(int(date[0]), int(date[1]), int(date[2].split(" ")[0]))
    start = start.split(":")
    end = end.split(":")

    timestamp["start"] = date.replace(hour=int(start[0]), minute=int(start[1]), second=0).timestamp()
    timestamp["end"] = date.replace(hour=int(end[0]), minute=int(end[1]), second=0).timestamp()

    return timestamp

def parseTeachers(teacher):
    if teacher == "":
        return []
    prof = teacher.find("prof. ", 1)
    dr = teacher.find("dr ", 7)
    mgr = teacher.find("mgr ", 1)

    t = []

    if prof != -1:
        t += parseTeachers(teacher[prof:])
        teacher = teacher[:prof]
    elif dr != -1:
        t += (parseTeachers(teacher[dr:]))
        teacher = teacher[:dr]
    elif mgr != -1:
        t += (parseTeachers(teacher[mgr:]))
        teacher = teacher[:mgr]

    t.append(teacher.strip())

    return t

def getTokAndPlan(json):
    for i in json:
        breakDownTok(i)

    temp = []
    for i, teacher in enumerate(teachers):
        for i in parseTeachers(teacher):
            if i in temp:
                continue
            if "prof." in i:
                temp.append(i)
            elif "dr " in i:
                temp.append(i)
            elif "mgr " in i:
                temp.append(i)
            else:
                print(f"Unknown teacher format: {i}")

    return programs, classes, temp, rooms

def breakDownTok(tok):
    toknum = 0
    if tok["Plan dla toku"] not in programs:
        programs.append(tok["Plan dla toku"])
        toknum += 1
    if tok["Prowadzący"] not in teachers:
        teachers.append(tok["Prowadzący"])
    if tok["Sala"] not in rooms:
        if tok["Sala"]:
            rooms.append(tok["Sala"])

    tok["Plan dla toku"] = toknum
    tok["timestamp"] = convertDateToTimestamp(tok.pop("Data zajęć"), tok.pop("Czas od"), tok.pop("Czas do"))
    classes.append(tok)

def readJson():
    with open(input, "r", encoding="utf-8") as file:
        f = loadJSON(file.read())
        programs, classes, teachers, rooms = getTokAndPlan(f)

        return programs, classes, teachers, rooms

def tokStringToDic(tokString):
    tok = {
        "name": "",
        "program_type": "",
        "degree_level": "",
        "language": LANGUAGE[0],
        "academic_year": "",
        "course_length": 0
    }
    
    original = tokString
    
    for program_type in PROGRAM_TYPE:
        if f' {program_type} ' in original:
            tok["program_type"] = program_type
            break
    
    for language in LANGUAGE:
        if f' {language} ' in original:
            tok["language"] = language
            break
    
    for degree_level in DEGREE_LEVEL:
        if f'{degree_level} ' in original:
            tok["degree_level"] = degree_level
            break
    
    remaining = original
    
    try:
        remaining = remaining.replace(f' {tok["program_type"]} ', ' ')
        remaining = remaining.replace(f' {tok["language"]} ', ' ')
        parts = remaining.split(f'{tok["degree_level"]} ')
        tok["name"] = parts[0].strip()
        length_season = parts[1].strip().split(' ')
        tok["course_length"] = length_season[0]
        tok["academic_year"] = ' '.join(length_season[1:])
    except:
        print(f"Error processing course: {original}")

    return tok

programs, classes, teachers, rooms = readJson()
programs = [tokStringToDic(tok) for tok in programs]
teacher_to_idx = {teacher: str(i) for i, teacher in enumerate(teachers)}
room_to_idx = {room: str(i) for i, room in enumerate(rooms)}
classes = [{**c, "Prowadzący": " ".join(teacher_to_idx[x] for x in parseTeachers(c["Prowadzący"])), "Sala": (room_to_idx[c["Sala"]] if c["Sala"] in rooms else None)} for c in classes]

if DEBUG:
    print()
    print(programs[0])
    print(classes[535])
    print(teachers[0])

with open (output + "/programs.json", "w", encoding="utf-8") as file:
    file.write(dumpJSON({
        "programs": programs,
        "classes": classes,
        "teachers": teachers,
        "rooms": rooms
    }, indent=4, ensure_ascii=False).replace("   ", "\t"))