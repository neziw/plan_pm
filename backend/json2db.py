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
        
        result = self.db.table("teachers").insert(query).execute()
        print("Done.")
    
    def load_buildings(self):
        print("Loading buildings.")
        query = []
        for building in self.data["building"]:
            query.append({
                "name": building
            })

        result = self.db.table("building").insert(query).execute()
        print("Done")
    
    def load_rooms(self):
        print("Loading rooms")
        
        buildings = self.db.table("building").select("id").execute()
        query = []
        for room in self.data["rooms"]:
            # Get the UUID of the building
            if room["building"] != None:
                id = buildings.data[room["building"]]["id"]
                
                query.append({
                    "name": room["room"],
                    "building": id
                    })
            else:
                query.append({
                    "name": room["room"],
                    "building": None
                    })
                
        result = self.db.table("rooms").insert(query).execute()
                
        print("Done")
    
    def load_programs(self):
        print("Loading programs")
        query = []
        for program in self.data["programs"]:
            query.append({
                "name": program["name"],
                "programType": program["program_type"],
                "degreeLevel": program["degree_level"],
                "language": program["language"],
                "academicYear": program["academic_year"],
                "courseLength": float(program["course_length"])
            })
        result = self.db.table("programs").insert(query).execute()
        print("Done")
    
    def load_classes(self):
        print("Loading classes")
        
        query = []
        programs = self.db.table("programs").select("id").execute()
        rooms = self.db.table("rooms").select("id").execute()
        for sclass in self.data["classes"]:
            # Get the id of the program
            program_id = programs.data[sclass["program"]]["id"]

            # Get the id of the room
            room = sclass["room"]
            room_id = None
            if (room != None):
                room_id = rooms.data[sclass["room"]]["id"]
            
            # Get the subject
            subject = sclass["subject"]
            subject_name = self.data["subjects"][subject]
            
            # Combine this shit into a whole query
            query.append({
                "startTime": datetime.datetime.fromtimestamp(int(sclass["startTime"])).strftime("%Y-%m-%d %H:%M:%S"),
                "endTime": datetime.datetime.fromtimestamp(int(sclass["endTime"])).strftime("%Y-%m-%d %H:%M:%S"),
                "program": program_id,
                "subject": subject_name,
                "group": sclass["group"],
                "room": room_id,
                "notes": sclass["notes"]
            })
        result = self.db.table("classes").insert(query).execute()
        print("Done")
    
    def load_teachers_classes(self):
        print("Loading teachers/classes")
        classes = self.db.table("classes").select("id").execute()
        teachers = self.db.table("teachers").select("id").execute()
        query = []
        for tc in self.data["teachersclasses"]:
            class_id = classes.data[tc["class"]]["id"]
            
            for teacher in tc["teachers"]:
                teacher_id = teachers.data[teacher]["id"]
                query.append({
                    "teachers": teacher_id,
                    "classes": class_id
                })
            
        result = self.db.table("teachersclasses").insert(query).execute()
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
    