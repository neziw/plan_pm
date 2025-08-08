import os
import json
from dotenv import load_dotenv
from supabase import create_client
import datetime

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
    
    def __init__(self, json_file):
        print("Json2DB loaded.")
        with open(json_file) as file:
            self.data = json.loads(file.read())
        
        
    def load_env(self):
        # Load environment variables and create a db connection
        url = os.environ.get("SUPABASE_URL")
        key = os.environ.get("SUPABASE_KEY")
        
        print("Got url: ", url)
        print("Got key: ", key)
        
        self.db = create_client(url, key)
        
    def clear_db(self):    
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
        
        buildings = self.db.table("building").select("id, name").execute()
        query = []
        for room in self.data["rooms"]:
            # Get the UUID of the building
            if room["building"] != None:
                building_name = self.data["building"][room["building"]]
                id = list(filter(lambda building: building["name"] == building_name, buildings.data))[0]["id"]
                
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
        programs = self.db.table("programs").select("id, name").execute()
        rooms = self.db.table("rooms").select("id, name").execute()
        for sclass in self.data["classes"]:
            # Get the id of the program
            program = sclass["program"]
            program_name = self.data["programs"][program]["name"]
            program_id = list(filter(lambda program: program["name"] == program_name, programs.data))[0]["id"]

            # Get the id of the room
            room = sclass["room"]
            room_id = None
            if (room != None):
                room_name = self.data["rooms"][room]["room"]
                room_id = list(filter(lambda room: room["name"] == room_name, rooms.data))[0]["id"]
            
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
                "room": room_id
            })
        result = self.db.table("classes").insert(query).execute()
        print("Done")
    
    def load_teachers_classes(self):
        # TODO: End this madness
        raise Exception("It's not implemented yet.")


if __name__ == "__main__":
    App = json2db(json_file="./output/programs.json")
    App.load_env()
    App.clear_db()
    App.load_teachers()
    App.load_buildings()
    App.load_rooms()
    App.load_programs()
    App.load_classes()
    # App.load_teachers_classes()