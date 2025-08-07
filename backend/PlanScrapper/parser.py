from datetime import datetime
from json import loads as loadJSON, dumps as dumpJSON
import sys

PROGRAM_TYPE = ["S", "N"]
DEGREE_LEVEL = ["lic", "mgr", "inż."]
LANGUAGE = ["POL", "ANG"]
ACADEMIC_YEAR = ["zima", "lato"]

BUILDINGS = ["WChrobrego", "HPobożnego", "Willowa", "Szczerbcow", "Żołnierska"]

MAP = {"Plan dla toku" : "program", "Przedmiot" : "subject", "Grupy" : "group", "Sala" : "room", "Prowadzący" : "teacher"}

programs = []
classes = []
teachers = []
rooms = []
buildings = []
sub = []
teachersclasses = []

toknum = 0

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
        
    date = date.split(".")
    date = datetime(int(date[0]), int(date[1]), int(date[2].split(" ")[0]))
    start = start.split(":")
    end = end.split(":")

    start = date.replace(hour=int(start[0]), minute=int(start[1]), second=0).timestamp()
    end = date.replace(hour=int(end[0]), minute=int(end[1]), second=0).timestamp()

    return start, end

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



def getTokAndPlan(json):
    for i in json:
        breakDownTok(i)

    global teachers
    temp = []
    for i, teacher in enumerate(teachers):
        for x in parseTeachers(teacher):
            if x in temp:
                continue
            if x:
                temp.append(x)

    teachers = temp

    teacher_to_idx = {teacher: i for i, teacher in enumerate(teachers)}
    room_to_idx = {room: i for i, room in enumerate(rooms)}
    
    cl = [{k: v for k, v in c.items() if k not in {"Liczba godzin", "Forma zajęć", "Forma zaliczenia", "Uwagi"}} | {"Prowadzący": [teacher_to_idx[x] for x in parseTeachers(c["Prowadzący"])], "Sala": (room_to_idx[c["Sala"]] if c["Sala"] in rooms else None)} for c in classes]
    
    for i, t in enumerate(teachers):
        t = t.split(" ")
        temp[i] = {"title": " ".join(t[:-2]), "fullName": " ".join(t[-2:])}

    build = []
    for i, room in enumerate(rooms):
        r, b = breakDownRoom(room)
        t = {"building" : b, "room" : r}
        if not b:
            rooms[i] = t
            continue
        if b not in build:
            build.append(b)
        t["building"] = build.index(b)
        rooms[i] = t

    return programs, cl, temp, rooms, build

def breakDownTok(tok):
    global toknum
    if tok["Plan dla toku"] not in programs:
        programs.append(tok["Plan dla toku"])
        toknum += 1
    if tok["Prowadzący"] not in teachers:
        teachers.append(tok["Prowadzący"])
    if tok["Sala"] not in rooms:
        if tok["Sala"]:
            for s in parseRooms(tok["Sala"]):
                if s not in rooms:
                    rooms.append(s)
    if tok["Przedmiot"] not in sub:
        sub.append(tok["Przedmiot"])
    
    tok["Plan dla toku"] = toknum
    tok["Przedmiot"] = sub.index(tok["Przedmiot"])
    tok["startTime"], tok["endTime"] = convertDateToTimestamp(tok.pop("Data zajęć"), tok.pop("Czas od"), tok.pop("Czas do"))
        
    classes.append(tok)

def readJson():
    with open(input, "r", encoding="utf-8") as file:
        f = loadJSON(file.read())

        return getTokAndPlan(f)

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

programs, classes, teachers, rooms, buildings = readJson()
programs = [tokStringToDic(tok) for tok in programs]

for i, cl in enumerate(classes):
    for old in MAP:
        classes[i][MAP[old]] = classes[i].pop(old)

for i, cl in enumerate(classes):
    teachersclasses.append({"class": i, "teachers": classes[i].pop("teacher")})

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
        "teachersclasses": teachersclasses,
        "rooms": rooms,
        "building": buildings,
        "subjects": sub
    }, indent=4, ensure_ascii=False).replace("    ", "\t"))