from datetime import datetime
import json

PROGRAM_TYPE = ["S", "N"]
DEGREE_LEVEL = ["lic", "mgr", "inż."]
LANGUAGE = ["POL", "ANG"]
ACADEMIC_YEAR = ["zima", "lato"]

programs = []
classes = []
teachers = []

DEBUG = False

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


    teachers = []

    if prof != -1:
        teachers += parseTeachers(teacher[prof:])
        teacher = teacher[:prof]
    elif dr != -1:
        teachers += (parseTeachers(teacher[dr:]))
        teacher = teacher[:dr]
    elif mgr != -1:
        teachers += (parseTeachers(teacher[mgr:]))
        teacher = teacher[:mgr]

    teachers.append(teacher)

    return teachers

def getTokAndPlan(json):
    for i in json[:-2]:
        breakDownTok(i[:-1])
    breakDownTok(json[-2])

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

    return programs, classes, temp

def breakDownTok(tok):
    toknum = 0
    obj = eval(tok)
    if obj["Plan dla toku"] not in programs:
        programs.append(obj["Plan dla toku"])
        toknum += 1
    if obj["Prowadzący"] not in teachers:
        teachers.append(obj["Prowadzący"])
    obj["Plan dla toku"] = toknum
    obj["timestamp"] = convertDateToTimestamp(obj.pop("Data zajęć"), obj.pop("Czas od"), obj.pop("Czas do"))
    classes.append(obj)

def readJson():
    with open("plany.json", "r", encoding="utf-8") as file:
        json = file.read().splitlines()
        programs, classes, teachers = getTokAndPlan(json[1:])

        return programs, classes, teachers

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

programs, classes, teachers = readJson()
programs = [tokStringToDic(tok) for tok in programs]
classes = [{**c, "Prowadzący": " ".join(str(teachers.index(x)) for x in parseTeachers(c["Prowadzący"]))} for c in classes]
'''
with open("flows.json", "r", encoding="utf-8") as file:
    flows = file.read().splitlines()
    flows = [tokStringToDic(i[12:-2]) for i in flows[1:-1]]

for program in programs:
    if program not in flows:
        print("Flow does not exist in programs:", program)
for flow in flows:
    if flow not in programs:
        print("Program does not exist in flows:", flow)
'''

if DEBUG:
    print()
    print(programs[0])
    print(classes[535])
    print(teachers[0])

with open ("programs.json", "w", encoding="utf-8") as file:
    file.write(json.dumps({
        "programs": programs,
        "classes": classes,
        "teachers": teachers
    }, indent=4, ensure_ascii=False).replace("   ", "\t"))
    # file.write("{\n\t\"programs\": {\n")
    # for program in programs[:-1]:
    #     file.write("\t\t" + json.dumps(program))
    #     file.write(",\n")
    # file.write("\t\t" + json.dumps(programs[-1]))
    # file.write("\n\t},\n\t\"classes\": {\n")
    # for cls in classes[:-1]:
    #     file.write("\t\t" + json.dumps(cls))
    #     file.write(",\n")
    # file.write("\t\t" + json.dumps(classes[-1]))
    # file.write("\n\t},\n\t\"teachers\": {\n")
    # for teacher in teachers[:-1]:
    #     file.write("\t\t" + json.dumps(teacher))
    #     file.write(",\n")
    # file.write("\t\t" + json.dumps(teachers[-1]))
    # file.write("\n\t}\n}")