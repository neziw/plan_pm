from datetime import datetime
from json import loads as loadJSON, dumps as dumpJSON
from dataclasses import dataclass, field
import sys

PROGRAM_TYPE = ["S", "N"]
DEGREE_LEVEL = ["lic", "mgr", "inż."]
LANGUAGE = ["POL", "ANG"]
ACADEMIC_YEAR = ["zima", "lato"]

BUILDINGS = ["WChrobrego", "HPobożnego", "Willowa", "Szczerbcow", "Żołnierska"]

MAP = {"Plan dla toku" : "program", "Przedmiot" : "subject", "Grupy" : "group", "Sala" : "room", "Prowadzący" : "teacher"}

@dataclass
class ScheduleData:
    programs: list
    classes: list
    teachers: list
    subjects: list
    rooms: list
    buildings: list

    _programs_set: set = field(default_factory=set, init=False, repr=False)
    _teachers_set: set = field(default_factory=set, init=False, repr=False)
    _subjects_set: set = field(default_factory=set, init=False, repr=False)
    _rooms_set: set = field(default_factory=set, init=False, repr=False)


DEBUG = False

input = "./output/plany.json"
output = "./output"

if(len(sys.argv) > 1):
    output = sys.argv[1]
    DEBUG = True
    if(len(sys.argv) > 2):
        input = sys.argv[2]

# Important!!! This will only work correctly if your system's date locale is Polish.
def convertDateToTimestamp(date, start, end):
        
    date = date.split(".")
    date = datetime(int(date[0]), int(date[1]), int(date[2].split(" ")[0]))
    start = start.split(":")
    end = end.split(":")

    start = date.replace(hour=int(start[0]), minute=int(start[1]), second=0).timestamp()
    end = date.replace(hour=int(end[0]), minute=int(end[1]), second=0).timestamp()

    return start, end

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

def parseRooms(room):
    if not room:
        return []

    parsed_rooms = []
    for r in room.split(","):
        r = r.strip()
        if r not in parsed_rooms:
            parsed_rooms.append(r)
    return parsed_rooms

def breakDownRoom(room):
    b = None
    room = room.split(" ")
    if room[0] in BUILDINGS:
        if room[1][0] == 'B' and room[1][1].isdigit():
            b = " ".join(room[:2])
            room = room[2:]
        else:
            b = room[0]
            room = room[1:]
        room = " ".join(room)
    else:
        room = " ".join(room)
    return room, b

def breakDownTeachers(teachers):
    for i, t in enumerate(teachers):
        t = t.split(" ")
        teachers[i] = {"title": " ".join(t[:-2]), "fullName": " ".join(t[-2:])}
    return teachers

def breakDownBuildings(rooms):
    buildings = []
    for i, room in enumerate(rooms):
        r, b = breakDownRoom(room)
        t = {"building" : b, "room" : r}
        if not b:
            rooms[i] = t
            continue
        if b not in buildings:
            buildings.append(b)
        t["building"] = buildings.index(b)
        rooms[i] = t
    return rooms, buildings

def breakDownTok(tok, sched):
    if tok["Plan dla toku"] not in sched._programs_set:
        sched.programs.append(tok["Plan dla toku"])
        sched._programs_set.add(tok["Plan dla toku"])
    teachArray = parseTeachers(tok["Prowadzący"])
    for x in teachArray:
        if x and x not in sched._teachers_set:
            sched.teachers.append(x)
            sched._teachers_set.add(x)
    if tok["Sala"]:
        for s in parseRooms(tok["Sala"]):
            if s not in sched.rooms:
                sched.rooms.append(s)
                sched._rooms_set.add(s)
    if tok["Przedmiot"] not in sched._subjects_set:
        sched.subjects.append(tok["Przedmiot"])
        sched._subjects_set.add(tok["Przedmiot"])
    
    tok["Plan dla toku"] = sched.programs.index(tok["Plan dla toku"])
    tok["Przedmiot"] = sched.subjects.index(tok["Przedmiot"])
    tok["startTime"], tok["endTime"] = convertDateToTimestamp(tok.pop("Data zajęć"), tok.pop("Czas od"), tok.pop("Czas do"))

    sched.classes.append(tok)

def normalizeClasses(classes, teachers, rooms):
    teacher_to_idx = {teacher: i for i, teacher in enumerate(teachers)}
    room_to_idx = {room: i for i, room in enumerate(rooms)}
    
    return [{k: v for k, v in c.items() if k not in {"Liczba godzin", "Forma zajęć", "Forma zaliczenia", "Uwagi"}} | {"Prowadzący": [teacher_to_idx[x] for x in parseTeachers(c["Prowadzący"])], "Sala": (room_to_idx[c["Sala"]] if c["Sala"] in rooms else None)} for c in classes]

def getTokAndPlan(json):
    sched = ScheduleData([], [], [], [], [], [])
    for i in json:
        breakDownTok(i, sched)

    sched.programs = [tokStringToDic(tok) for tok in sched.programs]

    sched.classes = normalizeClasses(sched.classes, sched.teachers, sched.rooms)

    sched.teachers = breakDownTeachers(sched.teachers)

    sched.rooms, sched.buildings = breakDownBuildings(sched.rooms)

    return sched

def readJson():
    with open(input, "r", encoding="utf-8") as file:
        f = loadJSON(file.read())

        return getTokAndPlan(f)

sched = readJson()

for i, cl in enumerate(sched.classes):
    for old in MAP:
        sched.classes[i][MAP[old]] = sched.classes[i].pop(old)

teachersclasses = []

for i, cl in enumerate(sched.classes):
    teachersclasses.append({"class": i, "teachers": sched.classes[i].pop("teacher")})

if DEBUG:
    print()
    print(sched.programs[0])
    print(sched.classes[535])
    print(sched.teachers[0])

with open (output + "/programs.json", "w", encoding="utf-8") as file:
    file.write(dumpJSON({
        "programs": sched.programs,
        "classes": sched.classes,
        "teachers": sched.teachers,
        "teachersclasses": teachersclasses,
        "subjects": sched.subjects,
        "rooms": sched.rooms,
        "building": sched.buildings
    }, indent=4, ensure_ascii=False).replace("    ", "\t"))