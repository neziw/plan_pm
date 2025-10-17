import os
import json
from dotenv import load_dotenv
from supabase import create_client
import datetime
import time

# Database structure:
# Building
# Classes
# Programs
# Rooms
# Teachers
# Teachersclasses

# Load environmental variables from .env
load_dotenv()

class json2db:
    db = ""
    data = ""
    
    def __init__(self, input):
        print("Json2DB loaded.")
        with open(input, encoding="utf8") as file:
            self.data = json.loads(file.read())
        
        
    def load_env(self):
        # Load environment variables and create a db connection
        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")
        
        print("Got url: ", url)
        print("Got key: ", key)
        
        self.db = create_client(url, key)
        
    def clear_db(self):
        self.db.table("teachersclasses").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()    
        self.db.table("classes").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        self.db.table("programs").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        self.db.table("rooms").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        self.db.table("teachers").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        self.db.table("building").delete().neq("id", "00000000-0000-0000-0000-000000000000").execute()
        
        
    def load_teachers(self):
        print("Loading teachers.")
        query = []
        for teacher in self.data["teachers"]:
            query.append({
                "fullName": teacher["fullName"],
                "title": teacher["title"]
            })
        
        _ = self.db.table("teachers").insert(query).execute()
        print("Done.")
    
    def load_buildings(self):
        print("Loading buildings.")
        query = []
        for building in self.data["building"]:
            query.append({
                "name": building
            })

        _ = self.db.table("building").insert(query).execute()
        print("Done")
    
    def load_rooms(self):
        print("Loading rooms")
        
        response = self.db.table("building").select("id, name").execute()
        buildings = {v['name']: v['id'] for v in response.data}
        
        query = []
        for room in self.data["rooms"]:
            if room["building"] != None:
                building_name = self.data["building"][room["building"]]
                id = buildings.get(building_name)
                
                query.append({
                    "name": room["room"],
                    "building": id
                    })
            else:
                query.append({
                    "name": room["room"],
                    "building": None
                    })
                
        _ = self.db.table("rooms").insert(query).execute()
                
        print("Done")
    
    def load_programs(self):
        print("Loading programs")
        
        current_year: int = datetime.datetime.now().year
        current_month: int = datetime.datetime.now().month
        
        is_winter_semester: bool = True if current_month >= 10 else False
         
        query: list = []
        for program in self.data["programs"]:
            # Calculate shitty academic year to current year
            programs_year: int = int(program["academic_year"].split(" ")[0].split("/")[0])
            
            programs_year = programs_year
            current_academic_start_year = current_year if is_winter_semester else current_year - 1
            
            if programs_year > current_academic_start_year:
                final_year = 0

            else:
                final_year = current_academic_start_year - programs_year + 1
            
            query.append({
                "name": program["name"],
                "programType": program["program_type"],
                "degreeLevel": program["degree_level"],
                "language": program["language"],
                "academicYear": program["academic_year"],
                "courseLength": float(program["course_length"]),
                "year": final_year
            })
        _ = self.db.table("programs").insert(query).execute()
        print("Done")
        
    
    def load_classes(self):
        print("Loading classes")
        
        query = []
        programs = self.db.table("programs").select("id, name, academicYear, language, programType, courseLength, degreeLevel").execute()
        programs_map = {v["id"] : [v["name"], v["academicYear"], v["language"], v["programType"], v["courseLength"], v["degreeLevel"]] for v in programs.data}
        
        rooms = self.db.table("rooms").select("id, name").execute()
        room_map = {v["name"]: v["id"] for v in rooms.data}
        for sclass in self.data["classes"]:
            found_program = self.data["programs"][sclass["program"]]
            program_name = found_program["name"]
            program_type = found_program["program_type"]
            degree_level = found_program["degree_level"]
            academic_year = found_program["academic_year"]
            course_length = float(found_program["course_length"])
            language = found_program["language"]
            # Get the id of the program
            
            found_program_id = None
            program = [program_name, academic_year, language, program_type, course_length, degree_level]
            for program_id, program_value in programs_map.items():
                if (program_value == program):
                    found_program_id = program_id
                   
            if (found_program_id == None):
                print("Nie znaleziono ID dla programu - niedobrze")
                continue
            

            # Get the id of the room
            room = sclass["room"]
            room_id = None
            if (room != None):
                room_name = self.data["rooms"][sclass["room"]]["room"]
                room_id = room_map.get(room_name)
            
            # Get the subject
            subject = sclass["subject"]
            subject_name = self.data["subjects"][subject]
            
            # Combine this shit into a whole query
            query.append({
                "startTime": datetime.datetime.fromtimestamp(int(sclass["startTime"])).strftime("%Y-%m-%d %H:%M:%S"),
                "endTime": datetime.datetime.fromtimestamp(int(sclass["endTime"])).strftime("%Y-%m-%d %H:%M:%S"),
                "program": found_program_id,
                "subject": subject_name,
                "group": sclass["group"],
                "room": room_id,
                "notes": sclass["notes"]
            })

        _ = self.db.table("classes").insert(query).execute()
        print("Done")
    
    def load_teachers_classes(self):
        print("Loading teachers/classes")
        classes = self.db.table("classes").select("id, subject, group, program(name), room(name), startTime, endTime, notes").execute()
        classes_map = {v["id"]: [v["subject"], v["group"], v["program"]["name"] if v["program"] else None, v["room"]["name"] if v["room"] else None, v["startTime"], v["endTime"], v["notes"]] for v in classes.data}
        
        teachers = self.db.table("teachers").select("id, fullName").execute()
        teachers_map = {v["fullName"]: v["id"] for v in teachers.data}
        # print(teachers_map)
        query = []
        for tc in self.data["teachersclasses"]:
            found_class = self.data["classes"][tc["class"]]
            start_time = datetime.datetime.fromtimestamp(int(found_class["startTime"])).strftime("%Y-%m-%d %H:%M:%S").replace(" ", "T")
            end_time = datetime.datetime.fromtimestamp(int(found_class["endTime"])).strftime("%Y-%m-%d %H:%M:%S").replace(" ", "T")
            subject = self.data["subjects"][found_class["subject"]]
            program_name = self.data["programs"][found_class["program"]]["name"]
            notes = found_class["notes"]
            group = found_class["group"]
            room_name = None
            if (found_class["room"] != None):
                room_name = self.data["rooms"][found_class["room"]]["room"]
            
            sclass = [
                subject, group, program_name, room_name, start_time, end_time, notes
            ]
            
            found_class_id = None
            
            for class_id, class_value in classes_map.items():
                if (class_value == sclass):
                    found_class_id = class_id
                    
            
            if (found_class_id == None):
                print(f"Nie znaleziono ID dla klasy - niedobrze.")
                continue
            
            for teacher in tc["teachers"]:
                teacher_fullname = self.data["teachers"][teacher]["fullName"]
                teacher_id = teachers_map.get(teacher_fullname)
                
                query.append({
                    "teachers": teacher_id,
                    "classes": found_class_id
                })
            
        _ = self.db.table("teachersclasses").insert(query).execute()
        print("Done")
            
    def run(self):
        print("Executing json2db.py")
        start_time = time.time()
        self.load_env()
        self.clear_db()
        self.load_teachers()
        self.load_buildings()
        self.load_rooms()
        self.load_programs()
        self.load_classes()
        self.load_teachers_classes()
        end_time = time.time()
        print(f"Done. Total execution time: {end_time - start_time:.2f} seconds")
            
        


if __name__ == "__main__":
    App = json2db(input="./output/parser.json")
    App.run()
    
    